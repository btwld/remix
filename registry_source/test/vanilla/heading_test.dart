import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

void main() {
  const sizes = <VanillaHeadingVariant, (double, double, FontWeight)>{
    .h1: (36, 40, FontWeight.w800),
    .h2: (30, 36, FontWeight.w600),
    .h3: (24, 32, FontWeight.w600),
    .h4: (20, 28, FontWeight.w600),
  };

  for (final theme in vanillaThemes) {
    for (final variant in VanillaHeadingVariant.values) {
      testWidgets('${variant.name} (${theme.name})', (tester) async {
        final (size, line, weight) = sizes[variant]!;
        await tester.pumpWidget(
          VanillaTheme(
            theme: theme.data,
            child: hostOf(
              Center(
                child: VanillaHeading('Taxing Laughter', variant: variant),
              ),
            ),
          ),
        );

        final text = tester.widget<Text>(find.text('Taxing Laughter'));
        expect(text.style?.fontSize, size);
        expect(size * text.style!.height!, closeTo(line, 1e-9));
        expect(text.style?.fontWeight, weight);
        expect(text.style?.letterSpacing, closeTo(-0.025 * size, 1e-9));
        expect(text.style?.color, theme.data.foreground);
        expect(text.textAlign, variant == .h1 ? TextAlign.center : null);
        final heading = tester.getSemantics(
          find.bySemanticsLabel('Taxing Laughter'),
        );
        expect(
          heading,
          matchesSemantics(label: 'Taxing Laughter', isHeader: true),
        );
        expect(heading.getSemanticsData().headingLevel, variant.index + 1);
      });
    }
  }

  testWidgets('h2 puts the rule below the line at 2× text scale', (
    tester,
  ) async {
    const theme = VanillaThemeData.dark();
    await tester.pumpWidget(
      VanillaTheme(
        theme: theme,
        child: hostOf(
          const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Center(child: VanillaHeading.h2('Laughter')),
          ),
        ),
      ),
    );

    final text = find.text('Laughter');
    final rule = find.ancestor(of: text, matching: find.byType(Box)).first;
    final decoration = tester.widget<Box>(rule).styleSpec!.spec.decoration!;
    expect(
      (decoration as BoxDecoration).border,
      Border(bottom: BorderSide(color: theme.border)),
    );
    expect(tester.getSize(text).height, 72);
    expect(tester.getRect(rule).bottom - tester.getRect(text).bottom, 9);
    expect(tester.takeException(), isNull);
  });

  testWidgets('outline level and caller style are independent', (tester) async {
    await tester.pumpWidget(
      VanillaTheme(
        child: hostOf(
          Center(
            child: VanillaHeading.h3(
              'Taxing Laughter',
              headingLevel: 1,
              style: TextStyler().maxLines(1).overflow(.ellipsis),
            ),
          ),
        ),
      ),
    );

    final heading = tester.getSemantics(
      find.bySemanticsLabel('Taxing Laughter'),
    );
    expect(heading.getSemanticsData().headingLevel, 1);
    final text = tester.widget<Text>(find.text('Taxing Laughter'));
    expect(text.style?.fontSize, 24);
    expect(text.maxLines, 1);
    expect(text.overflow, TextOverflow.ellipsis);
  });
}
