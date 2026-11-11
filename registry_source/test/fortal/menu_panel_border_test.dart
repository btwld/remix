import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../helpers/test_helpers.dart';

void main() {
  // Anchored panels share one edge: Fortal's elevation shadows carry no ring,
  // so menus take the same 1px gray-7 edge as select, popover and combobox.
  // The menu paints it as a foreground decoration, so it takes no layout space.
  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    for (final size in FortalMenuSize.values) {
      testWidgets('Menu panel has its gray-7 edge in ${mode.name} $size', (
        tester,
      ) async {
        await tester.pumpWidget(
          FortalTheme(
            mode: mode,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Builder(
                builder: (context) {
                  final spec = fortalMenuStyle(size: size).build(context).spec;
                  final overlay = spec.overlay.spec.box!.spec;
                  // No layout border: the edge is painted in the foreground.
                  expect((overlay.decoration as BoxDecoration).border, isNull);
                  final edge = overlay.foregroundDecoration as BoxDecoration;
                  expect(
                    edge.border,
                    Border.all(color: FortalTokens.gray7.resolve(context)),
                  );
                  // It follows the panel's own corner radius.
                  expect(
                    edge.borderRadius,
                    (overlay.decoration as BoxDecoration).borderRadius,
                  );
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );
      });
    }
  }

  testWidgets('Menu edge keeps the panel width callers size items to', (
    tester,
  ) async {
    // The dashboard sizes items as panel width minus the content inset.
    await tester.pumpRemixApp(
      FortalMenu<String>(
        size: .size1,
        trigger: const RemixMenuTrigger(label: 'Open'),
        items: [
          RemixMenuItem(
            value: 'a',
            label: 'Alpha',
            style: MenuItemStyler().width(172),
          ),
        ],
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    // The first box wider than the item is the panel: item plus padding,
    // with no extra width for the edge.
    final panelWidth = find
        .ancestor(
          of: find.text('Alpha'),
          matching: find.byWidgetPredicate((_) => true),
        )
        .evaluate()
        .map((e) => e.renderObject)
        .whereType<RenderBox>()
        .map((box) => box.size.width)
        .firstWhere((width) => width > 172);
    final inset = FortalTokens.space1.resolve(
      tester.element(find.text('Alpha')),
    );
    expect(panelWidth, 172 + inset * 2);
  });
}
