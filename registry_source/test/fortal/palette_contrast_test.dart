import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../../tool/fortal_palettes/generate.dart' as cli;
import '../../tool/fortal_palettes/palette_generator.dart' as generator;
import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

const palettes = <String, FortalColorTheme>{
  'calcadao': calcadao,
  'mar': mar,
  'ceu': ceu,
  'serra': serra,
  'sol': sol,
  'duna': duna,
  'caju': caju,
};

/// Every shipped scale: the selectable accents plus the dedicated error red.
const shipped = <String, FortalColorTheme>{
  ...palettes,
  'fortalError': fortalError,
};

/// OKLab distance, used for Fortal's own comparative separation checks.
double oklabDistance(Color first, Color second) {
  final a = generator.toOklch(first.toARGB32());
  final b = generator.toOklch(second.toARGB32());
  final da = a.c * math.cos(a.h) - b.c * math.cos(b.h);
  final db = a.c * math.sin(a.h) - b.c * math.sin(b.h);
  return math.sqrt(math.pow(a.l - b.l, 2) + da * da + db * db);
}

double hueDegrees(Color color) =>
    generator.toOklch(color.toARGB32()).h * 180 / math.pi % 360;

void main() {
  for (final entry in shipped.entries) {
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

  test('on-solid inks are tones of their own family', () {
    // Calçadão stays the neutral reference: white on basalt, basalt on
    // limestone.
    expect(calcadao.light.contrast, const Color(0xffffffff));
    expect(calcadao.dark.contrast, const Color(generator.basalt));
    // White remains where the fill needs it.
    const whiteSide = {'mar/light', 'serra/light', 'fortalError/light'};
    final basaltL = generator.toOklch(generator.basalt).l;
    for (final entry in shipped.entries) {
      if (entry.key == 'calcadao') continue;
      for (final dark in [false, true]) {
        final name = '${entry.key}/${dark ? 'dark' : 'light'}';
        final mode = dark ? entry.value.dark : entry.value.light;
        final ink = mode.contrast;
        if (whiteSide.contains(name)) {
          expect(ink, const Color(0xffffffff), reason: name);
          continue;
        }
        final tone = generator.toOklch(ink.toARGB32());
        final seed = generator.toOklch(
          generator.fortalSeeds[entry.key] ?? generator.fortalErrorSeed,
        );
        // Neither generic basalt nor a light midtone.
        expect(
          oklabDistance(ink, const Color(generator.basalt)),
          greaterThan(.03),
          reason: '$name is basalt',
        );
        expect(
          tone.l,
          inInclusiveRange(
            basaltL - .005,
            generator.onSolidInk.maxLightness + .005,
          ),
          reason: name,
        );
        expect(tone.c, greaterThan(.03), reason: '$name chroma');
        // The family hue, warmed by at most the documented rotation.
        final hueShift =
            (hueDegrees(
                      Color(
                        generator.fortalSeeds[entry.key] ??
                            generator.fortalErrorSeed,
                      ),
                    ) -
                    hueDegrees(ink) +
                    540) %
                360 -
            180;
        expect(
          hueShift,
          inInclusiveRange(-4, generator.onSolidInk.warmHueShift + 4),
          reason: '$name hue',
        );
        // Deeper than its seed and never more saturated than it.
        expect(tone.l, lessThan(seed.l), reason: '$name stays deeper');
        expect(
          tone.c,
          lessThanOrEqualTo(seed.c + .002),
          reason: '$name chroma',
        );
        // The 4.6:1 generation margin holds on the fill and on its hover, and
        // the ink spends the remaining headroom: it is the lightest tone that
        // keeps that margin, not a near-black with contrast to spare.
        final ratios = [
          for (final step in [9, 10]) contrastRatio(ink, mode.scale.step(step)),
        ];
        for (final ratio in ratios) {
          expect(ratio, greaterThanOrEqualTo(4.6), reason: name);
        }
        expect(ratios.reduce(math.min), lessThan(4.75), reason: '$name fit');
      }
    }
    // Sol and Duna read as a visibly coloured warm brown: not olive, and not
    // the near-black a lower lightness cap produced.
    for (final theme in [sol, duna]) {
      for (final mode in [theme.light, theme.dark]) {
        expect(hueDegrees(mode.contrast), inInclusiveRange(55, 72));
        final tone = generator.toOklch(mode.contrast.toARGB32());
        expect(tone.l, greaterThanOrEqualTo(.40));
        expect(tone.c, greaterThanOrEqualTo(.06));
      }
    }
  });

  test('control border keeps 3:1 against page, panels and the off track', () {
    for (final dark in [false, true]) {
      final colors = resolveFortalTokens(
        FortalThemeConfig(brightness: dark ? .dark : .light),
      );
      final surfaces = {
        'page': colors.colorBackground,
        'panel': colors.colorPanelSolid,
        'translucent panel': Color.alphaBlend(
          colors.colorPanelTranslucent,
          colors.colorBackground,
        ),
      };
      for (final MapEntry(key: name, value: surface) in surfaces.entries) {
        final track = Color.alphaBlend(colors.gray.scale.alphaStep(3), surface);
        final reason = '${dark ? 'dark' : 'light'} $name';
        expect(
          contrastRatio(colors.controlBorder, surface),
          greaterThanOrEqualTo(3),
          reason: reason,
        );
        expect(
          contrastRatio(colors.controlBorder, track),
          greaterThanOrEqualTo(3),
          reason: '$reason off track',
        );
      }
    }
  });

  test('thumb ring follows the ink only where the ink is darker', () {
    for (final MapEntry(key: name, value: palette) in shipped.entries) {
      for (final dark in [false, true]) {
        final colors = resolveFortalTokens(
          FortalThemeConfig(
            accentPalette: palette,
            brightness: dark ? .dark : .light,
          ),
        );
        final ink = colors.accent.contrast;
        final fill = colors.accent.scale.step(9);
        final reason = '$name/${dark ? 'dark' : 'light'}';
        final inkIsDarker = ink.computeLuminance() < fill.computeLuminance();
        expect(
          colors.accentThumbRing,
          inkIsDarker ? ink : colors.controlBorder,
          reason: reason,
        );
        // A white thumb with that ring stands out on the fill and the hover.
        for (final step in [9, 10]) {
          final track = colors.accent.scale.step(step);
          expect(
            math.max(
              contrastRatio(const Color(0xffffffff), track),
              contrastRatio(colors.accentThumbRing, track),
            ),
            greaterThanOrEqualTo(3),
            reason: '$reason step $step',
          );
        }
      }
    }
  });

  test('custom and extreme seeds follow the same ink policy', () {
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
      final achromatic = generator.toOklch(seed).c < .02;
      for (final mode in [palette.light, palette.dark]) {
        final reason = '#${seed.toRadixString(16)}';
        if (mode.contrast == 0xffffffff) continue;
        final tone = generator.toOklch(mode.contrast);
        expect(
          tone.l,
          lessThanOrEqualTo(generator.onSolidInk.maxLightness + .005),
          reason: reason,
        );
        for (final step in [9, 10]) {
          expect(
            contrastRatio(Color(mode.contrast), Color(mode.solid[step - 1])),
            greaterThanOrEqualTo(4.6),
            reason: '$reason step $step',
          );
        }
        // Gray and near-white seeds get a deep neutral, not an invented hue.
        if (achromatic) expect(tone.c, lessThan(.02), reason: reason);
      }
    }
    // The neutral generator keeps basalt on limestone.
    final neutral = generator.generatePalette(generator.basalt, neutral: true);
    expect(neutral.dark.contrast, generator.basalt);
    expect(neutral.light.contrast, 0xffffffff);
  });

  test('every shipped solid keeps a visibly distinct hover', () {
    // Contrast fitting once collapsed hover onto the solid (OKLab 0.0003).
    // Calçadão's dark limestone-to-white hover (0.018) is the stable minimum;
    // palettes changed in the 2026-10-31 review keep a full hover step.
    const reviewed = {'ceu', 'serra', 'sol', 'duna', 'caju', 'fortalError'};
    for (final entry in shipped.entries) {
      for (final dark in [false, true]) {
        final scale = (dark ? entry.value.dark : entry.value.light).scale;
        expect(
          oklabDistance(scale.step(9), scale.step(10)),
          greaterThanOrEqualTo(reviewed.contains(entry.key) ? .025 : .015),
          reason: '${entry.key}/${dark ? 'dark' : 'light'}',
        );
      }
    }
  });

  test('dark solids follow seed lightness within the dark range', () {
    final range = generator.darkSolidLightnessRange;
    for (final seed in [
      0xff000000,
      0xff036f6b,
      0xffe76a32,
      0xffe5c79a,
      0xffffcf50,
      0xfff4f4f0,
      0xffffffff,
    ]) {
      final expected = generator
          .toOklch(seed)
          .l
          .clamp(range.min, range.max)
          .toDouble();
      final actual = generator
          .toOklch(generator.generatePalette(seed).dark.solid[8])
          .l;
      // Contrast fitting may nudge lightness; stay within one fitting band.
      expect(
        actual,
        closeTo(expected, .02),
        reason: '#${seed.toRadixString(16)}',
      );
    }
    // Sol keeps a sunny gold instead of the former L .70 mustard (#C49800).
    expect(sol.dark.scale.step(9), const Color(0xfff3c442));
    expect(sol.dark.scale.step(10), const Color(0xffffcf51));
    // Duna keeps its sand seed in dark mode.
    expect(
      oklabDistance(duna.dark.scale.step(9), const Color(0xffe5c79a)),
      lessThan(.01),
    );
  });

  test('named accents and the error red stay mutually distinct', () {
    // Fortal's own comparative floor for chart series and status badges, not
    // an external standard. The former Serra/Duna dark pair measured 0.047.
    final names = shipped.keys.toList();
    for (final dark in [false, true]) {
      for (var i = 0; i < names.length; i++) {
        for (var j = i + 1; j < names.length; j++) {
          Color fill(String name) =>
              (dark ? shipped[name]!.dark : shipped[name]!.light).scale.step(9);
          expect(
            oklabDistance(fill(names[i]), fill(names[j])),
            greaterThanOrEqualTo(.08),
            reason: '${names[i]}/${names[j]} ${dark ? 'dark' : 'light'}',
          );
        }
      }
    }
  });

  test('the dedicated error palette stays red and apart from Caju', () {
    for (final dark in [false, true]) {
      final error = dark ? fortalError.dark : fortalError.light;
      for (final step in [3, 7, 8, 9, 11]) {
        final hue = hueDegrees(error.scale.step(step));
        expect(hue, inInclusiveRange(10, 32), reason: 'error$step hue');
      }
      final orange = dark ? caju.dark : caju.light;
      expect(hueDegrees(orange.scale.step(9)), greaterThan(38));
      expect(
        oklabDistance(error.scale.step(9), orange.scale.step(9)),
        greaterThanOrEqualTo(.08),
      );
    }
    // Light errors keep white labels; the dark solid is curated deeper.
    expect(fortalError.light.contrast, const Color(0xffffffff));
    expect(
      generator.toOklch(fortalError.dark.scale.step(9).toARGB32()).l,
      closeTo(generator.fortalErrorDarkSolidLightness, .02),
    );
  });

  test('custom generation never borrows built-in identities by name', () {
    final reserved = cli.reservedPaletteNames('Acme');
    expect(reserved, containsAll(['calcadao', 'serra', 'caju', 'acmeError']));
    expect(reserved, isNot(contains('mangue')));
    final custom = cli.renderPalettes({
      'calcadao': generator.basalt,
    }, paletteImport: 'palette.dart');
    final builtIn = cli.renderPalettes(
      {'calcadao': generator.basalt},
      paletteImport: 'palette.dart',
      builtIns: true,
    );
    // Only the shipped file renders Calçadão as the neutral (limestone dark
    // solid) and appends the error palette and alpha swatches.
    expect(custom, isNot(contains('0xfffaf9f6')));
    expect(custom, isNot(contains('fortalError')));
    expect(custom, isNot(contains('blackAlpha')));
    expect(builtIn, contains('0xfffaf9f6'));
    expect(builtIn, contains('const fortalError'));
  });

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
