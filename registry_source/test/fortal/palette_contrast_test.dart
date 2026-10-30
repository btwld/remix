import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../../tool/fortal_palettes/palette_generator.dart' as generator;
import '../helpers/contrast.dart';

const palettes = <String, FortalColorTheme>{
  'calcadao': calcadao,
  'mar': mar,
  'ceu': ceu,
  'mangue': mangue,
  'sol': sol,
  'duna': duna,
  'caju': caju,
};

void main() {
  for (final entry in palettes.entries) {
    for (final dark in [false, true]) {
      final name = '${entry.key}/${dark ? 'dark' : 'light'}';
      final color = dark ? entry.value.dark : entry.value.light;
      final page = (dark ? calcadao.dark : calcadao.light).scale.step(1);
      final panel = (dark ? calcadao.dark : calcadao.light).scale.step(2);

      test('$name: solid and hover labels meet 4.5:1', () {
        for (final step in [9, 10]) {
          expect(
            contrastRatio(color.contrast, color.scale.step(step)),
            greaterThanOrEqualTo(4.5),
            reason: '$name step $step',
          );
        }
      });
      test('$name: secondary text meets 4.5:1 on steps 1–3', () {
        for (var step = 1; step <= 3; step++) {
          expect(
            contrastRatio(color.scale.step(11), color.scale.step(step)),
            greaterThanOrEqualTo(4.5),
            reason: '$name step $step',
          );
        }
        // Recipes actually use alpha text over alpha fills, on page and card.
        for (final background in [page, panel]) {
          for (final step in [3, 4, 5]) {
            expect(
              compositedContrast(
                foreground: color.scale.alphaStep(11),
                fill: color.scale.alphaStep(step),
                panel: background,
              ),
              greaterThanOrEqualTo(4.5),
              reason: '$name soft step $step',
            );
          }
        }
      });
      test('$name: primary text meets 7:1 on steps 1–5', () {
        for (var step = 1; step <= 5; step++) {
          expect(
            contrastRatio(color.scale.step(12), color.scale.step(step)),
            greaterThanOrEqualTo(7),
            reason: '$name step $step',
          );
        }
      });
      test('$name: focus/border meets 3:1 on steps 1–2 and page', () {
        for (final background in [
          color.scale.step(1),
          color.scale.step(2),
          page,
          panel,
        ]) {
          expect(
            contrastRatio(color.scale.step(8), background),
            greaterThanOrEqualTo(3),
            reason: name,
          );
        }
      });
      test('$name: all alpha steps reconstruct their solid on the page', () {
        for (var step = 1; step <= 12; step++) {
          final actual = Color.alphaBlend(color.scale.alphaStep(step), page);
          final expected = color.scale.step(step);
          for (final (a, b) in [
            (actual.r, expected.r),
            (actual.g, expected.g),
            (actual.b, expected.b),
          ]) {
            expect(a, closeTo(b, 1 / 255 + 1e-6), reason: '$name step $step');
          }
        }
      });
    }
  }

  test(
    'generator also meets the contrast contract for arbitrary brand seeds',
    () {
      // Extremes, highly saturated and gray seeds exercise gamut and foreground
      // fitting rather than only the seven curated inputs.
      for (final seed in [
        0xff000000,
        0xffffffff,
        0xff777777,
        0xffff0000,
        0xff00ff00,
        0xff0000ff,
        0xff8038cc,
        0xff00ffff,
      ]) {
        final palette = generator.generatePalette(seed);
        for (final mode in [palette.light, palette.dark]) {
          for (final step in [9, 10]) {
            expect(
              contrastRatio(Color(mode.contrast), Color(mode.solid[step - 1])),
              greaterThanOrEqualTo(4.5),
            );
          }
          for (var step = 1; step <= 5; step++) {
            expect(
              contrastRatio(Color(mode.solid[11]), Color(mode.solid[step - 1])),
              greaterThanOrEqualTo(7),
            );
          }
          for (var step = 1; step <= 3; step++) {
            expect(
              contrastRatio(Color(mode.solid[10]), Color(mode.solid[step - 1])),
              greaterThanOrEqualTo(4.5),
            );
          }
          for (var step = 1; step <= 2; step++) {
            expect(
              contrastRatio(Color(mode.solid[7]), Color(mode.solid[step - 1])),
              greaterThanOrEqualTo(3),
            );
          }
        }
      }
    },
  );

  test('out-of-range steps fail in release builds as well as debug', () {
    expect(() => calcadao.light.scale.step(0), throwsRangeError);
    expect(() => calcadao.light.scale.alphaStep(13), throwsRangeError);
  });
}
