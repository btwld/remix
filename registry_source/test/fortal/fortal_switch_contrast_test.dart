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
                // The ordinary surface thumb is a light surface with a 2px
                // palette-toned ring; soft and high contrast keep their
                // content-role fills.
                final ringed = variant == .surface && !highContrast;
                final expected = variant == .surface
                    ? (highContrast
                          ? tokens.accent.scale.step(1)
                          : const Color(0xFFFFFFFF))
                    : (highContrast
                          ? tokens.accent.scale.step(12)
                          : tokens.accent.scale.step(11));
                final thumb = _color(resolved.style.thumb);
                final ring = _border(resolved.style.thumb);
                final track = Color.alphaBlend(
                  _color(resolved.style.container),
                  tokens.colorBackground,
                );
                final reason = '$accent/$dark/$variant/$highContrast/$pressed';
                expect(thumb, expected, reason: reason);
                if (ringed) {
                  expect(ring.color, tokens.accentThumbRing, reason: reason);
                  expect(ring.width, 2, reason: reason);
                }
                // The thumb's fill or its ring identifies it on the track.
                expect(
                  [
                    contrastRatio(thumb, track),
                    if (ringed) contrastRatio(ring.color, track),
                  ].reduce((a, b) => a > b ? a : b),
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
      expect(_color(spec.thumb), const Color(0xffffffff));
      expect(_border(spec.thumb).color, const Color(0xff13181d));
      expect(_border(spec.thumb).width, 2);
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
              ? const Color(0xffffffff)
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

  testWidgets('track boundaries: active off ring, muted when disabled', (
    tester,
  ) async {
    for (final dark in [false, true]) {
      for (final variant in FortalSwitchVariant.values) {
        for (final selected in [false, true]) {
          for (final extra in <Set<WidgetState>>[
            {},
            {WidgetState.pressed},
            {WidgetState.focused},
            {WidgetState.disabled},
            {WidgetState.disabled, WidgetState.focused},
            {WidgetState.disabled, WidgetState.pressed},
            {WidgetState.disabled, WidgetState.focused, WidgetState.pressed},
          ]) {
            final states = {if (selected) WidgetState.selected, ...extra};
            final resolved = await resolveInFortalTheme(
              tester,
              (context) {
                expect(
                  FortalTheme.of(context).brightness,
                  dark ? Brightness.dark : Brightness.light,
                );
                return (
                  spec: fortalSwitchStyle(variant: variant).build(context).spec,
                  tokens: resolveFortalTokens(FortalTheme.of(context)),
                  grayA5: FortalTokens.grayA5.resolve(context),
                );
              },
              accent: .sol,
              mode: dark ? .dark : .light,
              states: states,
            );
            final reason = '${dark ? 'dark' : 'light'}/$variant/$states';
            final tokens = resolved.tokens;
            final disabled = states.contains(WidgetState.disabled);
            final quiet = variant == .surface
                ? [resolved.grayA5]
                : const <Color>[];
            expect(
              _trackRing(resolved.spec),
              disabled || selected ? quiet : [tokens.controlBorder],
              reason: reason,
            );
            if (disabled) {
              expect(_color(resolved.spec.thumb), tokens.gray.scale.step(2));
              expect(
                _border(resolved.spec.thumb).color,
                tokens.gray.scale.step(6),
                reason: reason,
              );
              expect(
                resolved.spec.trackEffects?.outline.style,
                BorderStyle.none,
                reason: reason,
              );
            } else if (!selected) {
              // The off thumb stays light; its neutral ring carries it.
              expect(_color(resolved.spec.thumb), const Color(0xffffffff));
              expect(
                _border(resolved.spec.thumb).color,
                tokens.controlBorder,
                reason: reason,
              );
            }
          }
        }
      }
    }
  });

  testWidgets('selected thumb ring overrides stay explicit', (tester) async {
    const custom = Color(0xff8038cc);
    final spec = await resolveInFortalTheme(
      tester,
      (context) => fortalSwitchStyle(
        style: SwitchStyler().onSelected(
          SwitchStyler().thumb(
            BoxStyler().border(.all(.color(custom).width(3))),
          ),
        ),
      ).build(context).spec,
      accent: .ceu,
      states: {WidgetState.selected},
    );
    expect(_color(spec.thumb), const Color(0xffffffff));
    expect(_border(spec.thumb).color, custom);
    expect(_border(spec.thumb).width, 3);
  });

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

BorderSide _border(StyleSpec<BoxSpec> box) =>
    ((box.spec.decoration as BoxDecoration).border! as Border).top;

List<Color> _trackRing(SwitchSpec spec) => [
  for (final shadow in spec.trackEffects?.overContent?.shadows ?? const [])
    shadow.color,
];
