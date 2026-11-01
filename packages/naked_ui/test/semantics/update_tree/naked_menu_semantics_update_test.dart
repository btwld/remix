import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../semantics_test_utils.dart';
import 'semantics_update_spy.dart';

void main() {
  final binding = SemanticsUpdateSpyBinding.instance;

  setUp(binding.resetSemanticsUpdates);

  final controls = <String, Widget Function(VoidCallback toggle)>{
    'a Material TextButton': (toggle) =>
        TextButton(onPressed: toggle, child: const Text('Actions')),
    'a NakedButton': (toggle) =>
        NakedButton(onPressed: toggle, child: const Text('Actions')),
  };

  for (final MapEntry(key: shape, value: control) in controls.entries) {
    testWidgets(
      'a NakedTooltip around $shape keeps its semantics attached to the tree',
      (tester) async {
        final handle = tester.ensureSemantics();
        final menu = MenuController();
        final tooltip = GlobalKey<RawTooltipState>();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: NakedMenu<String>(
                  controller: menu,
                  openOnTap: false,
                  child: NakedTooltip(
                    tooltipKey: tooltip,
                    overlayBuilder: (context, animation) => const Text('Tip'),
                    child: control(
                      () => menu.isOpen ? menu.close() : menu.open(),
                    ),
                  ),
                  overlayBuilder: (context, info) =>
                      const NakedMenuItem<String>(
                        value: 'item',
                        child: Text('Item'),
                      ),
                ),
              ),
            ),
          ),
        );

        Tristate expanded() {
          final buttons = collectSemanticsNodes(semanticsRootOf(tester), (
            node,
          ) {
            final data = node.getSemanticsData();
            return data.flagsCollection.isButton && data.label == 'Actions';
          });
          expect(buttons, hasLength(1));
          return buttons.single.getSemanticsData().flagsCollection.isExpanded;
        }

        expect(binding.detachedNodes, isEmpty, reason: 'after mount');
        expect(expanded(), Tristate.isFalse);

        tooltip.currentState!.ensureTooltipVisible();
        await tester.pumpAndSettle();
        expect(find.text('Tip'), findsOneWidget);
        expect(
          findSemanticsNode(
            semanticsRootOf(tester),
            (node) => node.getSemanticsData().label == 'Tip',
          ),
          isNotNull,
          reason: 'the tooltip text is reachable from the semantics root',
        );
        expect(binding.detachedNodes, isEmpty, reason: 'tooltip shown');

        menu.open();
        await tester.pumpAndSettle();
        expect(find.text('Item'), findsOneWidget);
        expect(binding.detachedNodes, isEmpty, reason: 'menu open');
        expect(expanded(), Tristate.isTrue);

        menu.close();
        await tester.pumpAndSettle();
        expect(binding.detachedNodes, isEmpty, reason: 'menu closed');
        expect(expanded(), Tristate.isFalse);

        handle.dispose();
      },
    );
  }

  testWidgets('loading announcements stay attached across trigger updates', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final menu = MenuController();
    final loading = ValueNotifier(true);
    addTearDown(loading.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NakedMenu<String>(
            controller: menu,
            openOnTap: false,
            child: ValueListenableBuilder<bool>(
              valueListenable: loading,
              builder: (context, isLoading, child) => Stack(
                children: [
                  NakedButton(
                    enabled: !isLoading,
                    onPressed: menu.open,
                    semanticLabel: 'Account actions',
                    child: const SizedBox(width: 160, height: 40),
                  ),
                  if (isLoading)
                    Semantics(
                      liveRegion: true,
                      label: 'Account actions, loading',
                      child: const SizedBox.square(dimension: 1),
                    ),
                ],
              ),
            ),
            overlayBuilder: (context, info) =>
                const NakedMenuItem<String>(value: 'item', child: Text('Item')),
          ),
        ),
      ),
    );

    for (final isLoading in [true, false, true]) {
      loading.value = isLoading;
      await tester.pump();
      final button = find.semantics
          .byLabel('Account actions')
          .evaluate()
          .single;
      expect(button.isMergedIntoParent, isFalse);
      expect(button.getSemanticsData().flagsCollection.isLiveRegion, isFalse);
      final announcements = find.semantics.byLabel('Account actions, loading');
      expect(announcements, isLoading ? findsOne : findsNothing);
      if (isLoading) {
        expect(announcements.evaluate().single.isMergedIntoParent, isFalse);
      }
      expect(binding.detachedNodes, isEmpty);
    }

    menu.open();
    await tester.pumpAndSettle();
    expect(
      find.semantics
          .byLabel('Account actions')
          .evaluate()
          .single
          .getSemanticsData()
          .flagsCollection
          .isExpanded,
      Tristate.isTrue,
    );
    expect(binding.detachedNodes, isEmpty);
    menu.close();
    await tester.pumpAndSettle();
    expect(
      find.semantics
          .byLabel('Account actions')
          .evaluate()
          .single
          .getSemanticsData()
          .flagsCollection
          .isExpanded,
      Tristate.isFalse,
    );
    expect(binding.detachedNodes, isEmpty);
    handle.dispose();
  });
}
