import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/link.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'Docs';

/// `decoration-[1.5px]` (link.css).
const _underlineThickness = 1.5;

Future<LinkSpec> _pump(
  WidgetTester tester, {
  String mode = 'light',
  bool enabled = true,
  VoidCallback? onPressed,
  LinkStyler style = const LinkStyler.create(),
}) async {
  await tester.pumpHeroUi(
    HeroUiLink(
      label: _label,
      enabled: enabled,
      onPressed: onPressed ?? () {},
      style: style,
    ),
    mode: mode,
  );
  await tester.pumpAndSettle();
  return _spec(tester);
}

LinkSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<LinkSpec>(find.text(_label));

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('matches upstream at rest in $mode', (tester) async {
      final spec = await _pump(tester, mode: mode);
      final upstream = heroUiCase('link', mode: mode);

      expect(
        tester.getSize(find.byType(HeroUiLink)).height,
        upstream.size.height,
      );
      expect(
        (spec.container.spec.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(upstream.px('borderRadius')),
      );
      final text = spec.label.spec.style!;
      expect(
        text.fontWeight,
        FontWeight.values[upstream.px('fontWeight') ~/ 100 - 1],
      );
      expectCssColor(text.color!, upstream.styles['color']!);
      expect(text.decoration, TextDecoration.none);
      // The size comes from the surrounding text, as `.link` leaves it unset.
      expect(text.fontSize, isNull);
    });

    testWidgets('hover underlines the label in muted at half strength in '
        '$mode', (tester) async {
      await _pump(tester, mode: mode);
      await tester.hoverCenter(find.text(_label));

      final hover = heroUiCase('link-hover', mode: mode, state: true);
      expect(hover.styles['textDecorationLine'], 'underline');
      final text = _spec(tester).label.spec.style!;
      expect(text.decoration, TextDecoration.underline);
      expect(text.decorationThickness, _underlineThickness);
      // `decoration-muted/50`
      final muted = heroUiToken(HeroUiTokens.muted, mode);
      expect(text.decorationColor, muted.withValues(alpha: muted.a * .5));
      // Hover leaves the text colour alone.
      expectCssColor(text.color!, hover.styles['color']!);
    });

    testWidgets('a press underlines the label in the full muted colour in '
        '$mode', (tester) async {
      await _pump(tester, mode: mode);
      final mouse = await tester.hoverCenter(find.text(_label));
      await mouse.down(tester.getCenter(find.text(_label)));
      await tester.pumpAndSettle();

      final pressed = heroUiCase('link-pressed', mode: mode, state: true);
      expect(pressed.styles['textDecorationLine'], 'underline');
      final text = _spec(tester).label.spec.style!;
      expect(text.decoration, TextDecoration.underline);
      expect(text.decorationThickness, _underlineThickness);
      // `:active` is declared after `:hover`: `decoration-muted`.
      expect(text.decorationColor, heroUiToken(HeroUiTokens.muted, mode));
      expectCssColor(text.color!, pressed.styles['color']!);
      await mouse.up();
    });

    testWidgets('keyboard focus draws the measured ring in $mode', (
      tester,
    ) async {
      final rest = await _pump(tester, mode: mode);
      expect(rest.containerEffects?.isEmpty ?? true, isTrue);
      final before = tester.getSize(find.byType(HeroUiLink));

      await tester.focusWithTab();
      expectFocusRing(
        _spec(tester).containerEffects,
        heroUiCase('link-focus', mode: mode, state: true),
      );
      expect(tester.getSize(find.byType(HeroUiLink)), before);
    });

    testWidgets('disabled dims like upstream and ignores presses in $mode', (
      tester,
    ) async {
      var pressed = 0;
      await _pump(
        tester,
        enabled: false,
        mode: mode,
        onPressed: () => pressed++,
      );
      expect(
        tester.opacityAbove(find.text(_label)),
        double.parse(
          heroUiCase('link-disabled', mode: mode).styles['opacity']!,
        ),
      );
      await tester.tap(find.text(_label));
      expect(pressed, 0);

      // pointer-events: none, so hover does not underline it.
      await tester.hoverCenter(find.text(_label));
      expect(_spec(tester).label.spec.style!.decoration, TextDecoration.none);
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      style: LinkStyler().label(.color(override)),
    );
    expect(spec.label.spec.style!.color, override);
  });

  testWidgets('pressing runs the Remix callback', (tester) async {
    var pressed = 0;
    await _pump(tester, onPressed: () => pressed++);
    await tester.tap(find.text(_label));
    expect(pressed, 1);
  });
}
