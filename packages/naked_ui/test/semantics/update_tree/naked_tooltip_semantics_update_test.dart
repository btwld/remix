import 'dart:ui' show SemanticsAction, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import 'semantics_update_spy.dart';

void main() {
  final binding = SemanticsUpdateSpyBinding.instance;
  setUp(binding.resetSemanticsUpdates);

  final triggers = <String, Widget Function(FocusNode)>{
    'menu': (focusNode) => NakedMenu<String>(
      controller: MenuController(),
      triggerFocusNode: focusNode,
      overlayBuilder: (context, info) => const NakedMenuItem<String>(
        value: 'item',
        child: Text('Overlay item'),
      ),
      child: const Text('Actions'),
    ),
    'popover': (focusNode) => NakedPopover(
      triggerFocusNode: focusNode,
      popoverBuilder: (context, info) => const Text('Overlay item'),
      child: const Text('Actions'),
    ),
    'popover with child-owned focus': (focusNode) => NakedPopover(
      popoverBuilder: (context, info) => const Text('Overlay item'),
      child: Focus(focusNode: focusNode, child: const Text('Actions')),
    ),
  };

  for (final MapEntry(key: name, value: buildTrigger) in triggers.entries) {
    testWidgets('tooltip preserves the $name trigger and both overlay trees', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final tooltip = GlobalKey<RawTooltipState>();
      final trigger = find.semantics.byLabel('Actions');
      final overlay = find.semantics.byLabel('Overlay item');
      const description = 'Manage workspace actions';
      final announcements = <String>[];
      binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
        SystemChannels.accessibility,
        (message) async {
          if (message case {
            'type': 'tooltip',
            'data': {'message': String text},
          } when text.isNotEmpty) {
            announcements.add(text);
          }
          return null;
        },
      );
      addTearDown(() {
        binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
          SystemChannels.accessibility,
          null,
        );
      });

      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Semantics(
                  container: true,
                  label: 'Workspace',
                  child: NakedTooltip(
                    tooltipKey: tooltip,
                    isFocusVisible: () => false,
                    semanticLabel: description,
                    excludeOverlaySemantics: false,
                    overlayBuilder: (context, animation) =>
                        const Text('Tooltip content'),
                    child: buildTrigger(focusNode),
                  ),
                ),
              ),
            ),
          ),
        );

        int expectTrigger(Tristate expanded) {
          expect(trigger, findsOne);
          final node = trigger.evaluate().single;
          final data = node.getSemanticsData();
          expect(data.tooltip, description);
          expect(data.flagsCollection.isButton, isTrue);
          expect(data.flagsCollection.isExpanded, expanded);
          expect(data.hasAction(SemanticsAction.tap), isTrue);
          expect(data.hasAction(SemanticsAction.focus), isTrue);
          expect(
            find.semantics
                .byPredicate(
                  (node) => node.getSemanticsData().tooltip == description,
                )
                .evaluate(),
            [node],
          );
          expect(binding.detachedNodes, isEmpty);
          return node.id;
        }

        final triggerId = expectTrigger(Tristate.isFalse);
        expect(find.semantics.byLabel('Workspace'), findsOne);

        tester.semantics.performAction(trigger, SemanticsAction.focus);
        await tester.pumpAndSettle();
        expect(focusNode.hasPrimaryFocus, isTrue);

        tester.semantics.tap(trigger);
        await tester.pumpAndSettle();
        expect(expectTrigger(Tristate.isTrue), triggerId);
        expect(overlay, findsOne);

        tester.semantics.tap(trigger);
        await tester.pumpAndSettle();
        expect(expectTrigger(Tristate.isFalse), triggerId);
        expect(overlay, findsNothing);
        expect(announcements, isEmpty);

        tooltip.currentState!.ensureTooltipVisible();
        await tester.pumpAndSettle();
        expect(find.semantics.byLabel('Tooltip content'), findsOne);
        expect(expectTrigger(Tristate.isFalse), triggerId);
        expect(announcements, [description]);
      } finally {
        handle.dispose();
      }
    });
  }
}
