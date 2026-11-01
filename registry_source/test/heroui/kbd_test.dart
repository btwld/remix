import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/kbd.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

Future<void> _pump(
  WidgetTester tester, {
  HeroUiKbdVariant variant = .defaultKbd,
  String mode = 'light',
  FlexBoxStyler style = const FlexBoxStyler.create(),
}) async {
  await tester.pumpHeroUi(
    HeroUiKbd(keys: const ['⌘', 'K'], variant: variant, style: style),
    mode: mode,
  );
  await tester.pumpAndSettle();
}

BoxDecoration _decoration(WidgetTester tester) =>
    tester
            .widgetList<DecoratedBox>(
              find.descendant(
                of: find.byType(HeroUiKbd),
                matching: find.byType(DecoratedBox),
              ),
            )
            .first
            .decoration
        as BoxDecoration;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiKbdVariant.values.map((v) => v.name), ['defaultKbd', 'light']);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('matches upstream in $mode', (tester) async {
      await _pump(tester, mode: mode);
      final upstream = heroUiCase('kbd-command', mode: mode);

      expect(
        tester.getSize(find.byType(HeroUiKbd)).height,
        upstream.size.height,
      );
      final decoration = _decoration(tester);
      expectCssColor(decoration.color!, upstream.styles['backgroundColor']!);
      expect(
        decoration.borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );

      // Two keys in Ahem's square glyphs: the padding plus both glyphs and the
      // gap between them.
      final first = tester.getRect(find.text('⌘'));
      final second = tester.getRect(find.text('K'));
      final kbd = tester.getRect(find.byType(HeroUiKbd));
      expect(first.left - kbd.left, upstream.px('paddingLeft'));
      expect(kbd.right - second.right, upstream.px('paddingRight'));
      expect(second.left - first.right, 2, reason: 'space-x-0.5');

      final text = tester.widget<Text>(find.text('K')).style!;
      expect(text.fontSize, upstream.px('fontSize'));
      expect(text.fontSize! * text.height!, upstream.px('lineHeight'));
      expect(text.fontWeight, FontWeight.w500);
      expectCssColor(text.color!, upstream.styles['color']!);
      expect(text.wordSpacing, -4);
    });
  }

  for (final mode in ['light', 'dark']) {
    testWidgets('light drops the fill and keeps the geometry in $mode', (
      tester,
    ) async {
      await _pump(tester, mode: mode);
      final filled = tester.getSize(find.byType(HeroUiKbd));

      await _pump(tester, variant: .light, mode: mode);
      final upstream = heroUiCase('kbd-light', mode: mode);
      expect(upstream.styles['backgroundColor'], isNull);
      expect(_decoration(tester).color, HeroUiTokens.transparent);
      expect(tester.getSize(find.byType(HeroUiKbd)), filled);
      expect(
        tester.getSize(find.byType(HeroUiKbd)).height,
        upstream.size.height,
      );
      expectCssColor(
        tester.widget<Text>(find.text('K')).style!.color!,
        upstream.styles['color']!,
      );
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await _pump(tester, style: FlexBoxStyler().color(override));
    expect(_decoration(tester).color, override);
  });
}
