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
        '${accent.name}/${dark ? 'dark' : 'light'} switch track and thumb roles',
        (tester) async {
          for (final variant in FortalSwitchVariant.values) {
            for (final selected in [false, true]) {
              final resolved = await resolveInFortalTheme(
                tester,
                (context) => (
                  spec: fortalSwitchStyle(variant: variant).build(context).spec,
                  tokens: resolveFortalTokens(FortalTheme.of(context)),
                  offThumb: FortalTokens.controlThumb.resolve(context),
                ),
                accent: accent,
                mode: dark ? .dark : .light,
                states: {if (selected) WidgetState.selected},
              );
              final tokens = resolved.tokens;
              final spec = resolved.spec;
              final reason = '$accent/$dark/$variant/$selected';
              if (!selected) {
                expect(_color(spec.container), tokens.controlTrack);
                expect(_color(spec.thumb), resolved.offThumb, reason: reason);
                continue;
              }
              expect(
                _color(spec.container),
                variant == .surface
                    ? tokens.accent.track
                    : tokens.accent.track.withValues(alpha: 0.1),
                reason: reason,
              );
              expect(
                _color(spec.thumb),
                variant == .surface ? tokens.accentThumb : tokens.accent.track,
                reason: reason,
              );
              // The ring is drawn only where the theme asks for one.
              expect(_border(spec.thumb).color, tokens.accentThumbRing);
              expect(_border(spec.thumb).width, 2);
            }
          }
        },
      );
    }
  }

  testWidgets('every thumb carries the three-layer thumb shadow', (
    tester,
  ) async {
    for (final dark in [false, true]) {
      final resolved = await resolveInFortalTheme(
        tester,
        (context) => (
          spec: fortalSwitchStyle().build(context).spec,
          shadow: FortalTokens.shadowThumb.resolve(context),
        ),
        mode: dark ? .dark : .light,
      );
      final decoration = resolved.spec.thumb.spec.decoration as BoxDecoration;
      expect(decoration.boxShadow, resolved.shadow);
      expect(decoration.boxShadow, hasLength(3));
    }
  });

  testWidgets(
    'under the theme high contrast the on thumb or its ring reaches 3:1',
    (tester) async {
      for (final accent in FortalAccentColor.values) {
        for (final dark in [false, true]) {
          for (final variant in FortalSwitchVariant.values) {
            final resolved = await resolveInFortalTheme(
              tester,
              (context) => (
                spec: fortalSwitchStyle(variant: variant).build(context).spec,
                tokens: resolveFortalTokens(FortalTheme.of(context)),
              ),
              accent: accent,
              mode: dark ? .dark : .light,
              highContrast: true,
              states: {WidgetState.selected},
            );
            final track = Color.alphaBlend(
              _color(resolved.spec.container),
              resolved.tokens.colorBackground,
            );
            final thumb = _color(resolved.spec.thumb);
            final ring = _border(resolved.spec.thumb).color;
            expect(
              [
                contrastRatio(thumb, track),
                if (ring.a > 0) contrastRatio(ring, track),
              ].reduce((a, b) => a > b ? a : b),
              greaterThanOrEqualTo(3),
              reason: '$accent/$dark/$variant',
            );
          }
        }
      }
    },
  );

  testWidgets('base and state-specific thumb overrides win', (tester) async {
    const custom = Color(0xff8038cc);
    for (final variant in FortalSwitchVariant.values) {
      final base = SwitchStyler().thumbColor(custom);
      final idle = await resolveInFortalTheme(
        tester,
        (context) =>
            fortalSwitchStyle(variant: variant, style: base).build(context).spec,
      );
      expect(_color(idle.thumb), custom);
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
}

Color _color(StyleSpec<BoxSpec> box) =>
    (box.spec.decoration as BoxDecoration).color!;

BorderSide _border(StyleSpec<BoxSpec> box) =>
    ((box.spec.decoration as BoxDecoration).border! as Border).top;
