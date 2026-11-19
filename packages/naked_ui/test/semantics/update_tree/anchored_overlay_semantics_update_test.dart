import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import 'semantics_update_spy.dart';

void main() {
  final binding = SemanticsUpdateSpyBinding.instance;
  setUp(binding.resetSemanticsUpdates);

  const triggerLabel = 'Actions';
  const parentLabel = 'Open parent menu';
  const fieldLabel = 'Search customers';
  const buttonLabel = 'Clear search';
  final overlays = <String, Widget Function(Widget, Widget Function(Widget))>{
    'popover': (panel, wrap) => wrap(
      NakedPopover(
        popoverBuilder: (context, info) => panel,
        child: const Text(triggerLabel),
      ),
    ),
    'menu': (panel, wrap) => wrap(
      NakedMenu<String>(
        controller: MenuController(),
        overlayBuilder: (context, info) => panel,
        child: const Text(triggerLabel),
      ),
    ),
    'submenu': (panel, wrap) => NakedMenu<String>(
      controller: MenuController(),
      overlayBuilder: (context, info) => wrap(
        NakedMenuSubmenu<String>(
          overlayBuilder: (context, info) => panel,
          child: const Text(triggerLabel),
        ),
      ),
      child: const Text(parentLabel),
    ),
    'select': (panel, wrap) => wrap(
      NakedSelect<String>(
        onChanged: (_) {},
        overlayBuilder: (context, info) => panel,
        child: const Text(triggerLabel),
      ),
    ),
  };

  for (final MapEntry(key: name, value: buildOverlay) in overlays.entries) {
    testWidgets('$name panel keeps its clear button separate with a tooltip', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();

      Future<void> openPanel({required bool withTooltip}) async {
        final panel = Semantics(
          container: true,
          textField: true,
          label: fieldLabel,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 200, height: 40),
              NakedButton(
                semanticLabel: buttonLabel,
                onPressed: () {},
                child: const SizedBox.square(dimension: 24),
              ),
            ],
          ),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: buildOverlay(
                  panel,
                  (trigger) => withTooltip
                      ? NakedTooltip(
                          semanticLabel: 'Manage workspace actions',
                          isFocusVisible: () => false,
                          overlayBuilder: (context, animation) =>
                              const Text('Workspace help'),
                          child: trigger,
                        )
                      : trigger,
                ),
              ),
            ),
          ),
        );
        if (name == 'submenu') {
          await tester.tap(find.text(parentLabel));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.text(triggerLabel));
        await tester.pumpAndSettle();
        expect(binding.detachedNodes, isEmpty);
      }

      List<({String label, bool textField, bool button, bool tap, bool focus})>
      panelNodes() => binding.nodes
          .where(
            (node) =>
                node.label.contains(fieldLabel) ||
                node.label.contains(buttonLabel),
          )
          .map(
            (node) => (
              label: node.label,
              textField: node.flags.isTextField,
              button: node.flags.isButton,
              tap: node.hasAction(SemanticsAction.tap),
              focus: node.hasAction(SemanticsAction.focus),
            ),
          )
          .toList();

      try {
        await openPanel(withTooltip: false);
        final baseline = panelNodes();
        expect(
          baseline,
          unorderedEquals([
            (
              label: fieldLabel,
              textField: true,
              button: false,
              tap: false,
              focus: false,
            ),
            (
              label: buttonLabel,
              textField: false,
              button: true,
              tap: true,
              focus: true,
            ),
          ]),
        );

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
        await openPanel(withTooltip: true);
        expect(panelNodes(), unorderedEquals(baseline));
      } finally {
        handle.dispose();
      }
    });
  }
}
