import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

/// Solid controls read one role for their foreground: the palette's on-solid
/// ink. Labels, thumbs and marks therefore share the family's deep tone (or
/// white) instead of generic basalt, and keep 4.5:1 on fill and hover.
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

  Color box(StyleSpec<BoxSpec> spec) =>
      (spec.spec.decoration as BoxDecoration).color!;

  for (final dark in [false, true]) {
    final mode = dark ? 'dark' : 'light';
    testWidgets('$mode: solid controls share the on-solid ink', (tester) async {
      for (final MapEntry(key: name, value: palette) in palettes.entries) {
        final colors = dark ? palette.dark : palette.light;
        final ink = colors.contrast;
        for (final hovered in [false, true]) {
          final resolved = await resolveInFortalTheme(
            tester,
            (context) {
              expect(
                FortalTheme.of(context).brightness,
                dark ? Brightness.dark : Brightness.light,
              );
              return (
                button: fortalButtonStyle().build(context).spec,
                toggle: fortalSwitchStyle().build(context).spec,
                checkbox: fortalCheckboxStyle().build(context).spec,
                radio: fortalRadioStyle().build(context).spec,
              );
            },
            accentPalette: palette,
            mode: dark ? .dark : .light,
            states: {WidgetState.selected, if (hovered) WidgetState.hovered},
          );
          final reason = '$name/$mode${hovered ? '/hovered' : ''}';
          final fill = box(resolved.button.container.spec.box!);
          expect(
            fill,
            colors.scale.step(hovered ? 10 : 9),
            reason: '$reason fill',
          );
          expect(
            resolved.button.label.spec.style?.color,
            ink,
            reason: '$reason label',
          );
          expect(
            contrastRatio(ink, fill),
            greaterThanOrEqualTo(4.5),
            reason: '$reason label contrast',
          );
          expect(box(resolved.toggle.thumb), ink, reason: '$reason thumb');
          expect(
            resolved.checkbox.indicator.spec.color,
            ink,
            reason: '$reason checkbox mark',
          );
          expect(box(resolved.radio.indicator), ink, reason: '$reason radio');
        }
      }
    });
  }
}
