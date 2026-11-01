import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/typography.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../helpers/heroui.dart';

const _text = 'Hi';

String _id(HeroUiTypographyType type) => switch (type) {
  .bodySm => 'body-sm',
  .bodyXs => 'body-xs',
  _ => type.name,
};

Future<void> _pump(
  WidgetTester tester, {
  HeroUiTypographyType type = .body,
  TextAlign align = TextAlign.start,
  HeroUiTypographyColor color = .defaultColor,
  HeroUiTypographyWeight? weight,
  bool truncate = false,
  String text = _text,
  double width = 160,
  String mode = 'light',
  TextStyler style = const TextStyler.create(),
}) async {
  await tester.pumpHeroUi(
    SizedBox(
      width: width,
      child: HeroUiTypography(
        text,
        type: type,
        align: align,
        color: color,
        weight: weight,
        truncate: truncate,
        style: style,
      ),
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
}

Text _label(WidgetTester tester, [String text = _text]) =>
    tester.widget<Text>(find.text(text));

void main() {
  test('types, colours, and weights follow HeroUI', () {
    expect(HeroUiTypographyType.values.map((t) => t.name), [
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'body',
      'bodySm',
      'bodyXs',
      'code',
    ]);
    expect(HeroUiTypographyColor.values.map((c) => c.name), [
      'defaultColor',
      'muted',
    ]);
    expect(HeroUiTypographyWeight.values.map((w) => w.name), [
      'normal',
      'medium',
      'semibold',
      'bold',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every type matches upstream in $mode', (tester) async {
      for (final type in HeroUiTypographyType.values) {
        await _pump(tester, type: type, mode: mode);
        final upstream = heroUiCase('typography-${_id(type)}', mode: mode);
        final text = _label(tester).style!;

        expect(
          tester.getSize(find.byType(HeroUiTypography)).height,
          upstream.size.height,
          reason: type.name,
        );
        expect(text.fontSize, upstream.px('fontSize'), reason: type.name);
        expect(
          text.fontSize! * text.height!,
          closeTo(upstream.px('lineHeight'), 1e-9),
          reason: type.name,
        );
        expect(
          text.fontWeight,
          FontWeight.values[upstream.px('fontWeight') ~/ 100 - 1],
          reason: type.name,
        );
        expect(
          text.letterSpacing ?? 0,
          closeTo(upstream.px('letterSpacing'), 1e-9),
          reason: type.name,
        );
        expectCssColor(
          text.color!,
          upstream.styles['color']!,
          reason: type.name,
        );
      }
    });
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('code is a filled, fixed-width chip in $mode', (tester) async {
      await _pump(tester, type: .code, mode: mode);
      final upstream = heroUiCase('typography-code', mode: mode);
      expect(_label(tester).style!.fontFamily, RemixFonts.geistMono);

      final box = tester
          .widgetList<Container>(
            find.descendant(
              of: find.byType(HeroUiTypography),
              matching: find.byType(Container),
            ),
          )
          .first;
      final decoration = box.decoration! as BoxDecoration;
      expectCssColor(decoration.color!, upstream.styles['backgroundColor']!);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );
      expect(
        box.padding,
        EdgeInsets.symmetric(
          horizontal: upstream.px('paddingLeft'),
          vertical: upstream.px('paddingTop'),
        ),
      );
      expect(
        tester.getSize(find.byType(HeroUiTypography)).height,
        upstream.size.height,
      );
    });

    testWidgets('muted uses the muted colour in $mode', (tester) async {
      await _pump(tester, color: .muted, mode: mode);
      final upstream = heroUiCase('typography-muted', mode: mode);
      expect(
        tester.getSize(find.byType(HeroUiTypography)).height,
        upstream.size.height,
      );
      expectCssColor(_label(tester).style!.color!, upstream.styles['color']!);
    });
  }

  testWidgets('weights follow the upstream cases', (tester) async {
    for (final weight in HeroUiTypographyWeight.values) {
      await _pump(tester, weight: weight);
      final upstream = heroUiCase('typography-weight-${weight.name}');
      expect(
        _label(tester).style!.fontWeight,
        FontWeight.values[upstream.px('fontWeight') ~/ 100 - 1],
        reason: weight.name,
      );
    }
  });

  testWidgets('alignment is the text align', (tester) async {
    for (final align in [
      TextAlign.start,
      TextAlign.center,
      TextAlign.end,
      TextAlign.justify,
    ]) {
      await _pump(tester, align: align);
      expect(
        tester.getSize(find.byType(HeroUiTypography)),
        heroUiCase('typography-align-${align.name}').size,
        reason: align.name,
      );
      expect(_label(tester).textAlign, align, reason: align.name);
    }
  });

  testWidgets('truncate keeps one ellipsized line', (tester) async {
    await _pump(
      tester,
      truncate: true,
      width: 80,
      text: 'A long line that cannot fit in eighty pixels',
    );
    final upstream = heroUiCase('typography-truncate');
    final label = _label(
      tester,
      'A long line that cannot fit in eighty pixels',
    );
    expect(label.maxLines, 1);
    expect(label.overflow, TextOverflow.ellipsis);
    expect(label.softWrap, isFalse);
    expect(tester.getSize(find.byType(HeroUiTypography)), upstream.size);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    await _pump(tester, style: TextStyler().fontSize(40));
    expect(_label(tester).style!.fontSize, 40);
  });
}
