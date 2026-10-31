import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../../tool/fortal_palettes/palette_generator.dart' as generator;
import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

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
        0xfff4f4f0,
        0xff777777,
        0xffff0000,
        0xff00ff00,
        0xff0000ff,
        0xff8038cc,
        0xff00ffff,
      ]) {
        final palette = generator.generatePalette(seed);
        for (final dark in [false, true]) {
          final mode = dark ? palette.dark : palette.light;
          final gray = dark ? calcadao.dark : calcadao.light;
          final page = gray.scale.step(1);
          final panel = gray.scale.step(2);
          for (final background in [page, panel]) {
            expect(
              contrastRatio(Color(mode.solid[7]), background),
              greaterThanOrEqualTo(3),
            );
            for (final step in [3, 4, 5]) {
              expect(
                compositedContrast(
                  foreground: Color(mode.alpha[10]),
                  fill: Color(mode.alpha[step - 1]),
                  panel: background,
                ),
                greaterThanOrEqualTo(4.5),
                reason: '$seed/$dark/soft $step',
              );
            }
          }
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

  test('near-white seeds retain identity and their contrast roles', () {
    for (final seed in [0xfff4f4f0, 0xffffffff]) {
      final palette = generator.generatePalette(seed);
      expect(palette.light.solid[8], seed);
      expect(generator.generatePalette(seed).light.solid, palette.light.solid);
      for (final dark in [false, true]) {
        final mode = dark ? palette.dark : palette.light;
        final neutral = dark ? calcadao.dark : calcadao.light;
        final page = neutral.scale.step(1);
        expect(
          contrastRatio(Color(mode.solid[11]), page),
          greaterThanOrEqualTo(7),
        );
        expect(
          contrastRatio(Color(mode.solid[7]), page),
          greaterThanOrEqualTo(3),
        );
        for (var i = 0; i < 12; i++) {
          final composed = Color.alphaBlend(Color(mode.alpha[i]), page);
          final solid = Color(mode.solid[i]);
          for (final pair in [
            (composed.r, solid.r),
            (composed.g, solid.g),
            (composed.b, solid.b),
          ]) {
            expect(pair.$1, closeTo(pair.$2, 1 / 255 + 1e-6));
          }
        }
      }
    }
  });

  testWidgets(
    'near-white custom buttons use a visible high-contrast fill in both modes',
    (tester) async {
      final generated = generator.generatePalette(0xfff4f4f0);
      final brand = FortalColorTheme(
        _mode(generated.light),
        _mode(generated.dark),
      );
      for (final dark in [false, true]) {
        final resolved = await resolveInFortalTheme(
          tester,
          (context) {
            expect(
              FortalTheme.of(context).brightness,
              dark ? Brightness.dark : Brightness.light,
            );
            return (
              spec: fortalButtonStyle(highContrast: true).build(context).spec,
              colors: resolveFortalTokens(FortalTheme.of(context)),
            );
          },
          accentPalette: brand,
          mode: dark ? .dark : .light,
        );
        final fill =
            (resolved.spec.container.spec.box!.spec.decoration as BoxDecoration)
                .color!;
        expect(
          fill,
          Color((dark ? generated.dark : generated.light).solid[11]),
        );
        expect(
          contrastRatio(fill, resolved.colors.colorBackground),
          greaterThanOrEqualTo(3),
        );
        expect(
          contrastRatio(fill, resolved.spec.label.spec.style!.color!),
          greaterThanOrEqualTo(4.5),
        );
      }
    },
  );

  test('out-of-range steps fail in release builds as well as debug', () {
    expect(() => calcadao.light.scale.step(0), throwsRangeError);
    expect(() => calcadao.light.scale.alphaStep(13), throwsRangeError);
  });
}

FortalColor _mode(generator.GeneratedMode mode) => FortalColor(
  FortalColorScale(
    ColorSwatch(mode.solid[8], {
      for (var i = 0; i < 12; i++) i + 1: Color(mode.solid[i]),
    }),
    ColorSwatch(mode.alpha[8], {
      for (var i = 0; i < 12; i++) i + 1: Color(mode.alpha[i]),
    }),
  ),
  Color(mode.surface),
  Color(mode.indicator),
  Color(mode.track),
  Color(mode.contrast),
);
