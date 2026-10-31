import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

void main() {
  for (final accent in FortalAccentColor.values) {
    for (final dark in [false, true]) {
      testWidgets(
        '${accent.name}/${dark ? 'dark' : 'light'} switch thumb roles',
        (tester) async {
          for (final variant in FortalSwitchVariant.values) {
            for (final highContrast in [false, true]) {
              for (final pressed in [false, true]) {
                final states = {
                  WidgetState.selected,
                  if (pressed) WidgetState.pressed,
                };
                final resolved = await resolveInFortalTheme(
                  tester,
                  (context) {
                    final theme = FortalTheme.of(context);
                    expect(
                      theme.brightness,
                      dark ? Brightness.dark : Brightness.light,
                    );
                    return (
                      style: fortalSwitchStyle(
                        variant: variant,
                        highContrast: highContrast,
                      ).build(context).spec,
                      tokens: resolveFortalTokens(theme),
                    );
                  },
                  accent: accent,
                  mode: dark ? .dark : .light,
                  states: states,
                );
                final tokens = resolved.tokens;
                final expected = variant == .surface
                    ? (highContrast
                          ? tokens.accent.scale.step(1)
                          : tokens.accent.contrast)
                    : (highContrast
                          ? tokens.accent.scale.step(12)
                          : tokens.accent.scale.step(11));
                final thumb = _color(resolved.style.thumb);
                final track = Color.alphaBlend(
                  _color(resolved.style.container),
                  tokens.colorBackground,
                );
                final reason = '$accent/$dark/$variant/$highContrast/$pressed';
                expect(thumb, expected, reason: reason);
                expect(
                  contrastRatio(thumb, track),
                  greaterThanOrEqualTo(3),
                  reason: reason,
                );

                final disabled = await resolveInFortalTheme(
                  tester,
                  (context) {
                    expect(
                      FortalTheme.of(context).brightness,
                      dark ? Brightness.dark : Brightness.light,
                    );
                    return fortalSwitchStyle(
                      variant: variant,
                      highContrast: highContrast,
                    ).build(context).spec;
                  },
                  accent: accent,
                  mode: dark ? .dark : .light,
                  states: {...states, WidgetState.disabled},
                );
                expect(_color(disabled.thumb), tokens.gray.scale.step(2));
                final decoration =
                    disabled.thumb.spec.decoration as BoxDecoration;
                expect(
                  (decoration.border as Border).top.color,
                  tokens.gray.scale.step(6),
                );
              }
            }
          }
        },
      );
    }
  }

  testWidgets('default neutral dark selected thumb contrasts with limestone', (
    tester,
  ) async {
    for (final pressed in [false, true]) {
      final spec = await resolveInFortalTheme(
        tester,
        (context) {
          expect(FortalTheme.of(context).brightness, Brightness.dark);
          return fortalSwitchStyle().build(context).spec;
        },
        mode: .dark,
        states: {WidgetState.selected, if (pressed) WidgetState.pressed},
      );
      expect(_color(spec.thumb), const Color(0xff13181d));
      expect(
        _color(spec.container),
        pressed ? const Color(0xffffffff) : const Color(0xfffaf9f6),
      );
    }
  });

  testWidgets(
    'base and state-specific thumb overrides follow variant precedence',
    (tester) async {
      const custom = Color(0xff8038cc);
      for (final variant in FortalSwitchVariant.values) {
        final base = SwitchStyler().thumbColor(custom);
        final idle = await resolveInFortalTheme(
          tester,
          (context) => fortalSwitchStyle(
            variant: variant,
            style: base,
          ).build(context).spec,
        );
        expect(_color(idle.thumb), custom);
        final selected = await resolveInFortalTheme(
          tester,
          (context) => (
            spec: fortalSwitchStyle(
              variant: variant,
              style: base,
            ).build(context).spec,
            tokens: resolveFortalTokens(FortalTheme.of(context)),
          ),
          accent: .mar,
          mode: .dark,
          states: {WidgetState.selected},
        );
        expect(
          _color(selected.spec.thumb),
          variant == .surface
              ? selected.tokens.accent.contrast
              : selected.tokens.accent.scale.step(11),
        );
        for (final disabled in [false, true]) {
          final explicit = await resolveInFortalTheme(
            tester,
            (context) => fortalSwitchStyle(
              variant: variant,
              style: base
                  .onSelected(SwitchStyler().thumbColor(custom))
                  .onDisabled(SwitchStyler().thumbColor(custom)),
            ).build(context).spec,
            mode: .dark,
            states: {WidgetState.selected, if (disabled) WidgetState.disabled},
          );
          expect(_color(explicit.thumb), custom);
        }
      }
    },
  );

  testWidgets('off thumb and explicit selected overrides remain supported', (
    tester,
  ) async {
    for (final dark in [false, true]) {
      final off = await resolveInFortalTheme(
        tester,
        (context) => fortalSwitchStyle().build(context).spec,
        mode: dark ? .dark : .light,
      );
      expect(_color(off.thumb), const Color(0xffffffff));
      const override = Color(0xff8038cc);
      final selected = await resolveInFortalTheme(
        tester,
        (context) => fortalSwitchStyle(
          style: SwitchStyler().onSelected(SwitchStyler().thumbColor(override)),
        ).build(context).spec,
        mode: dark ? .dark : .light,
        states: {WidgetState.selected},
      );
      expect(_color(selected.thumb), override);
    }
  });
}

Color _color(StyleSpec<BoxSpec> box) =>
    (box.spec.decoration as BoxDecoration).color!;
