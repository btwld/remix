import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

import '../helpers/test_helpers.dart';

void main() {
  for (final mode in [FortalThemeMode.light, FortalThemeMode.dark]) {
    testWidgets('Menu panel has its token edge in ${mode.name}', (
      tester,
    ) async {
      await tester.pumpWidget(
        FortalTheme(
          mode: mode,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Builder(
              builder: (context) {
                final panel = fortalMenuStyle().build(context).spec.overlay;
                final edge =
                    panel.spec.box!.spec.foregroundDecoration as BoxDecoration;
                expect(
                  edge.border,
                  Border.all(color: FortalTokens.gray7.resolve(context)),
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  }

  testWidgets('Menu edge keeps the panel width items are sized to', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      FortalMenu<String>(
        size: .size1,
        trigger: const RemixMenuTrigger(label: 'Open'),
        items: [
          RemixMenuItem(
            value: 'a',
            label: 'Alpha',
            style: MenuItemStyler().width(200),
          ),
        ],
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final panel = find
        .ancestor(
          of: find
              .ancestor(
                of: find.text('Alpha'),
                matching: find.byType(ColumnBox),
              )
              .first,
          matching: find.byType(Box),
        )
        .first;
    // 5px of padding inside the 1px edge on each side; wider than the
    // panel's 192px minimum, so the items set the width.
    expect(tester.getSize(panel).width, 200 + 6 * 2);
  });
}
