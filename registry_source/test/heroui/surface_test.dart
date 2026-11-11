import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/surface.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _text = 'Surface content';

String _id(HeroUiSurfaceVariant variant) =>
    variant == .defaultSurface ? 'default' : variant.name;

Future<void> _pump(
  WidgetTester tester,
  HeroUiSurfaceVariant variant, {
  String mode = 'light',
  BoxStyler style = const BoxStyler.create(),
}) async {
  await tester.pumpHeroUi(
    SizedBox(
      width: 160,
      height: 48,
      child: HeroUiSurface(
        variant: variant,
        style: style,
        child: const Text(_text),
      ),
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
}

BoxDecoration? _decoration(WidgetTester tester) =>
    tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(HeroUiSurface),
                matching: find.byType(Container),
              ),
            )
            .first
            .decoration
        as BoxDecoration?;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiSurfaceVariant.values.map((v) => v.name), [
      'transparent',
      'defaultSurface',
      'secondary',
      'tertiary',
    ]);
  });

  for (final mode in ['light', 'dark']) {
    testWidgets('every variant matches upstream in $mode', (tester) async {
      for (final variant in HeroUiSurfaceVariant.values) {
        await _pump(tester, variant, mode: mode);
        final upstream = heroUiCase('surface-${_id(variant)}', mode: mode);
        final text = heroUiCase('surface-text-${_id(variant)}', mode: mode);

        expect(
          tester.getSize(find.byType(HeroUiSurface)),
          upstream.size,
          reason: variant.name,
        );
        final fill = upstream.styles['backgroundColor'];
        if (fill == null) {
          expect(_decoration(tester)?.color, isNull, reason: variant.name);
        } else {
          expectCssColor(
            _decoration(tester)!.color!,
            fill,
            reason: variant.name,
          );
        }
        // The text colour reaches content that sets none of its own.
        expectCssColor(
          DefaultTextStyle.of(tester.element(find.text(_text))).style.color!,
          text.styles['color']!,
          reason: variant.name,
        );
      }
    });
  }

  // `text-surface-*-foreground` is the CSS `color`, which `currentColor` icons
  // inherit as text does; an override shows it.
  testWidgets('every variant colours icons as it colours text', (tester) async {
    const recolor = Color(0xFF8000FF);
    // The theme scope already colours icons `foreground`; the filled
    // variants must replace it with their own foreground.
    final theme = const HeroUiThemeData.light().copyWith(
      colors: {
        HeroUiTokens.surfaceForeground: recolor,
        HeroUiTokens.surfaceSecondaryForeground: recolor,
        HeroUiTokens.surfaceTertiaryForeground: recolor,
      },
    );
    for (final variant in HeroUiSurfaceVariant.values) {
      await tester.pumpHeroUi(
        HeroUiSurface(
          variant: variant,
          child: const Icon(IconData(0xe000), key: Key('icon')),
        ),
        theme: theme,
      );
      await tester.pumpAndSettle();
      expect(
        IconTheme.of(tester.element(find.byKey(const Key('icon')))).color,
        variant == .transparent
            ? heroUiToken(HeroUiTokens.foreground)
            : recolor,
        reason: variant.name,
      );
    }
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await _pump(tester, .defaultSurface, style: BoxStyler().color(override));
    expect(_decoration(tester)!.color, override);
  });
}
