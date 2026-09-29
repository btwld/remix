import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../semantics_test_utils.dart';
import 'semantics_update_spy.dart';

void main() {
  final binding = SemanticsUpdateSpyBinding.instance;

  setUp(binding.resetSemanticsUpdates);

  testWidgets(
    'select semantics updates stay attached to the tree through open, select, and close',
    (tester) async {
      final handle = tester.ensureSemantics();
      var value = 'apple';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) => NakedSelect<String>(
                  value: value,
                  onChanged: (next) => setState(() => value = next!),
                  semanticLabel: 'Fruit',
                  builder: (context, state, child) => Text('Fruit: $value'),
                  overlayBuilder: (context, info) => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NakedSelectOption(value: 'apple', child: Text('Apple')),
                      NakedSelectOption(value: 'banana', child: Text('Banana')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      SemanticsData trigger() {
        final root = tester.getSemantics(find.byType(Scaffold));
        final triggers = collectSemanticsNodes(
          root,
          (node) => node.getSemanticsData().flagsCollection.isButton,
        );
        final data = triggers
            .map((node) => node.getSemanticsData())
            .where((data) => data.label == 'Fruit');

        return data.single;
      }

      void expectMergedTrigger({required String value, required bool open}) {
        final data = trigger();
        expect(data.value, value);
        expect(data.flagsCollection.isButton, isTrue);
        expect(
          data.flagsCollection.isExpanded,
          open ? Tristate.isTrue : Tristate.isFalse,
        );
        expect(data.hasAction(SemanticsAction.tap), isTrue);
      }

      expect(binding.detachedNodes, isEmpty, reason: 'after mount');
      expectMergedTrigger(value: 'apple', open: false);

      await tester.tap(find.text('Fruit: apple'));
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsOneWidget);
      expect(binding.detachedNodes, isEmpty, reason: 'after open');
      expectMergedTrigger(value: 'apple', open: true);

      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsNothing);
      expect(binding.detachedNodes, isEmpty, reason: 'after select');
      expectMergedTrigger(value: 'banana', open: false);

      await tester.tap(find.text('Fruit: banana'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('Banana'), findsNothing);
      expect(binding.detachedNodes, isEmpty, reason: 'after close');
      expectMergedTrigger(value: 'banana', open: false);

      handle.dispose();
    },
  );
}
