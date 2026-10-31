import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

/// Labels and marks read separate roles. Solid buttons, badges and avatars
/// carry `contrast` on the labelled solid (`accentSolid`/`accentSolidHover`)
/// at 4.5:1 in every state. Checks and radio dots carry the mark ink derived
/// from the indicator at 3:1, and white switch thumbs stand out on the track
/// through their own face or their `accentThumbRing` outline.
void main() {
  const palettes = <String, FortalColorTheme>{
    'calcadao': calcadao,
    'mar': mar,
    'ceu': ceu,
    'serra': serra,
    'sol': sol,
    'duna': duna,
    'caju': caju,
    'fortalError': fortalError,
  };
  const white = Color(0xffffffff);

  Color box(StyleSpec<BoxSpec> spec) =>
      (spec.spec.decoration as BoxDecoration).color!;

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('$mode: labelled solids and marks read separate roles', (
      tester,
    ) async {
      for (final MapEntry(key: name, value: palette) in palettes.entries) {
        final colors = dark ? palette.dark : palette.light;
        for (final state in [null, WidgetState.hovered, WidgetState.pressed]) {
          final resolved = await resolveInFortalTheme(
            tester,
            (context) {
              expect(
                FortalTheme.of(context).brightness,
                dark ? Brightness.dark : Brightness.light,
              );
              return (
                button: fortalButtonStyle().build(context).spec,
                badge: fortalBadgeStyle(variant: .solid).build(context).spec,
                toggle: fortalSwitchStyle().build(context).spec,
                checkbox: fortalCheckboxStyle().build(context).spec,
                radio: fortalRadioStyle().build(context).spec,
                markInk: FortalTokens.accentIndicatorContrast.resolve(context),
                thumbRing: FortalTokens.accentThumbRing.resolve(context),
              );
            },
            accentPalette: palette,
            mode: dark ? .dark : .light,
            states: {WidgetState.selected, ?state},
          );
          final reason = '$name/$mode/${state?.name ?? 'idle'}';

          final fill = box(resolved.button.container.spec.box!);
          if (state == null) expect(fill, colors.solid, reason: reason);
          if (state == WidgetState.hovered) {
            expect(fill, colors.solidHover, reason: reason);
          }
          expect(resolved.button.label.spec.style?.color, colors.contrast);
          expect(
            contrastRatio(colors.contrast, fill),
            greaterThanOrEqualTo(4.5),
            reason: '$reason label on the resolved fill',
          );
          expect(box(resolved.badge.container), colors.solid, reason: reason);

          final checkboxFill =
              (resolved.checkbox.container.spec.decoration as BoxDecoration)
                  .color!;
          final radioFill =
              (resolved.radio.container.spec.decoration as BoxDecoration)
                  .color!;
          expect(checkboxFill, colors.indicator, reason: reason);
          expect(radioFill, colors.indicator, reason: reason);
          expect(resolved.checkbox.indicator.spec.color, resolved.markInk);
          expect(box(resolved.radio.indicator), resolved.markInk);
          expect(
            contrastRatio(resolved.markInk, checkboxFill),
            greaterThanOrEqualTo(3),
            reason: '$reason check on its fill',
          );

          final track = box(resolved.toggle.container);
          final thumb = box(resolved.toggle.thumb);
          final ring =
              ((resolved.toggle.thumb.spec.decoration as BoxDecoration).border!
                      as Border)
                  .top;
          expect(thumb, white, reason: '$reason thumb');
          expect(ring.color, resolved.thumbRing, reason: '$reason ring');
          expect(ring.width, 2, reason: '$reason ring width');
          expect(
            [
              contrastRatio(thumb, track),
              contrastRatio(ring.color, track),
            ].reduce((a, b) => a > b ? a : b),
            greaterThanOrEqualTo(3),
            reason: '$reason thumb on its track',
          );
        }
      }
    });
  }

  test('non-luminous palettes carry white labels and white marks', () {
    for (final MapEntry(key: name, value: palette) in palettes.entries) {
      if (name == 'calcadao' || name == 'sol' || name == 'duna') continue;
      for (final colors in [palette.light, palette.dark]) {
        expect(colors.contrast, white, reason: name);
        expect(
          contrastRatio(white, colors.indicator),
          greaterThanOrEqualTo(3),
          reason: '$name mark',
        );
      }
    }
  });
}
