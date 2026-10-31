import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

/// Hand-authored palettes supply `indicator`, `track`, `contrast` and the
/// labelled `solid` pair independently. Marks and thumbs must derive their ink
/// from the fill they actually sit on, not from the label ink.
void main() {
  const white = Color(0xffffffff);
  const yellow = Color(0xffffcf50);
  const basalt = Color(0xff13181d);

  Color box(StyleSpec<BoxSpec> spec) =>
      (spec.spec.decoration as BoxDecoration).color!;

  Future<
    ({
      Color buttonFill,
      Color buttonLabel,
      Color checkFill,
      Color check,
      Color radioDot,
      Color track,
      Color ring,
    })
  >
  resolve(
    WidgetTester tester,
    FortalColor colors, {
    WidgetState? state,
    bool dark = false,
  }) => resolveInFortalTheme(
    tester,
    (context) {
      final button = fortalButtonStyle().build(context).spec;
      final checkbox = fortalCheckboxStyle().build(context).spec;
      final radio = fortalRadioStyle().build(context).spec;
      final toggle = fortalSwitchStyle().build(context).spec;
      return (
        buttonFill: box(button.container.spec.box!),
        buttonLabel: button.label.spec.style!.color!,
        checkFill: (checkbox.container.spec.decoration as BoxDecoration).color!,
        check: checkbox.indicator.spec.color!,
        radioDot: box(radio.indicator),
        track: box(toggle.container),
        ring:
            ((toggle.thumb.spec.decoration as BoxDecoration).border! as Border)
                .top
                .color,
      );
    },
    accentPalette: FortalColorTheme(colors, colors),
    mode: dark ? .dark : .light,
    states: {WidgetState.selected, ?state},
  );

  testWidgets('a split palette keeps white labels and gets dark marks on a '
      'bright indicator', (tester) async {
    // Valid label pair (white on deep blue) beside a bright yellow mark fill.
    final colors = FortalColor(
      ceu.light.scale,
      ceu.light.surface,
      yellow,
      yellow,
      white,
      solid: const Color(0xff005783),
      solidHover: const Color(0xff00486c),
    );
    for (final state in [null, WidgetState.hovered, WidgetState.pressed]) {
      final r = await resolve(tester, colors, state: state);
      expect(r.buttonLabel, white);
      expect(contrastRatio(r.buttonLabel, r.buttonFill), greaterThan(4.5));
      expect(r.checkFill, yellow);
      // White would be 1.47:1 on yellow; the supplied label ink is white too,
      // so the mark falls back to the dark neutral.
      expect(r.check, basalt, reason: '${state?.name}');
      expect(r.radioDot, basalt);
      expect(contrastRatio(r.check, r.checkFill), greaterThanOrEqualTo(3));
      expect(r.ring, basalt);
      expect(contrastRatio(r.ring, yellow), greaterThanOrEqualTo(3));
      // The white thumb or its ring stands out on the resolved track, which
      // is the scale's step 10 while pressed.
      expect(
        [
          contrastRatio(white, r.track),
          contrastRatio(r.ring, r.track),
        ].reduce((a, b) => a > b ? a : b),
        greaterThanOrEqualTo(3),
        reason: '${state?.name}',
      );
    }
  });

  testWidgets('supplied contrast is reused for marks only where it keeps 3:1 '
      'on the indicator', (tester) async {
    const brown = Color(0xff5a3a00);
    final reused = await resolve(
      tester,
      FortalColor(ceu.light.scale, ceu.light.surface, yellow, yellow, brown),
    );
    expect(reused.check, brown);
    expect(reused.ring, brown);
    // A light label ink fails on yellow, so marks do not borrow it.
    const cream = Color(0xfffff4cc);
    final fallback = await resolve(
      tester,
      FortalColor(
        ceu.light.scale,
        ceu.light.surface,
        yellow,
        yellow,
        cream,
        solid: const Color(0xff6b4300),
      ),
    );
    expect(fallback.check, basalt);
    expect(fallback.ring, basalt);
    expect(contrastRatio(cream, fallback.buttonFill), greaterThan(4.5));
  });

  testWidgets('five-argument palettes keep their labels on steps 9 and 10', (
    tester,
  ) async {
    // The constructor form used before the labelled solid existed.
    final legacy = FortalColor(
      ceu.light.scale,
      ceu.light.surface,
      ceu.light.scale.step(9),
      ceu.light.scale.step(9),
      white,
    );
    expect(legacy.solid, ceu.light.scale.step(9));
    expect(legacy.solidHover, ceu.light.scale.step(10));
    final idle = await resolve(tester, legacy);
    final hovered = await resolve(tester, legacy, state: WidgetState.hovered);
    expect(idle.buttonFill, ceu.light.scale.step(9));
    expect(hovered.buttonFill, ceu.light.scale.step(10));
    expect(idle.check, white);
  });

  test('computeAccentThumbRing keeps its two-argument call shape', () {
    const controlBorder = Color(0xff7c7c7b);
    // White fits Céu's track, but without the surfaces the track cannot be
    // judged against the page, so the outline stays the neutral border.
    expect(computeAccentThumbRing(ceu.light, controlBorder), controlBorder);
    // A bright track takes the dark ink either way.
    final bright = FortalColor(
      ceu.light.scale,
      ceu.light.surface,
      yellow,
      yellow,
      white,
    );
    expect(computeAccentThumbRing(bright, controlBorder), basalt);
    // With the page and panels the outline can follow the track.
    expect(
      computeAccentThumbRing(
        ceu.light,
        controlBorder,
        surfaces: [calcadao.light.scale.step(1), calcadao.light.scale.step(2)],
      ),
      ceu.light.track,
    );
  });

  test('a solid without a hover serves as its own hover', () {
    final colors = FortalColor(
      ceu.light.scale,
      ceu.light.surface,
      ceu.light.indicator,
      ceu.light.track,
      white,
      solid: const Color(0xff005783),
    );
    expect(colors.solid, const Color(0xff005783));
    expect(colors.solidHover, const Color(0xff005783));
  });

  testWidgets('a deep track keeps its ring visible against a dark page', (
    tester,
  ) async {
    // White stands out on this deep teal, but the track itself is under 3:1
    // on the dark page, so the overhanging slider thumb uses controlBorder.
    const deep = Color(0xff1f5e5a);
    final colors = FortalColor(
      mar.dark.scale,
      mar.dark.surface,
      deep,
      deep,
      white,
    );
    late FortalThemeColors tokens;
    await resolveInFortalTheme(
      tester,
      (context) => tokens = resolveFortalTokens(FortalTheme.of(context)),
      accentPalette: FortalColorTheme(colors, colors),
      mode: .dark,
    );
    expect(contrastRatio(deep, tokens.colorBackground), lessThan(3));
    expect(tokens.accentThumbRing, tokens.controlBorder);
    final r = await resolve(tester, colors, dark: true);
    expect(r.ring, tokens.controlBorder);
    expect(r.check, white);
  });
}
