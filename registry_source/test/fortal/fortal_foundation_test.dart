import 'dart:math' as math;

import 'package:flutter/animation.dart' show Cubic;
import 'package:flutter/painting.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/theme/computed.dart'
    show FortalThemeColors;
import 'package:registry_source/src/fortal/theme/theme_data.dart'
    show buildFortalScopeTokens;
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../helpers/contrast.dart';
import 'foundation_values.dart';

/// Fortal's foundation values: every colour token resolves to its foundation
/// literal under every accent in both appearances, and the theme's high
/// contrast switch moves the low-contrast boundaries to values that meet the
/// contrast gates.
void main() {
  const grayTokens = [
    FortalTokens.gray1,
    FortalTokens.gray2,
    FortalTokens.gray3,
    FortalTokens.gray4,
    FortalTokens.gray5,
    FortalTokens.gray6,
    FortalTokens.gray7,
    FortalTokens.gray8,
    FortalTokens.gray9,
    FortalTokens.gray10,
    FortalTokens.gray11,
    FortalTokens.gray12,
    FortalTokens.grayA1,
    FortalTokens.grayA2,
    FortalTokens.grayA3,
    FortalTokens.grayA4,
    FortalTokens.grayA5,
    FortalTokens.grayA6,
    FortalTokens.grayA7,
    FortalTokens.grayA8,
    FortalTokens.grayA9,
    FortalTokens.grayA10,
    FortalTokens.grayA11,
    FortalTokens.grayA12,
  ];
  const accentTokens = [
    FortalTokens.accent1,
    FortalTokens.accent2,
    FortalTokens.accent3,
    FortalTokens.accent4,
    FortalTokens.accent5,
    FortalTokens.accent6,
    FortalTokens.accent7,
    FortalTokens.accent8,
    FortalTokens.accent9,
    FortalTokens.accent10,
    FortalTokens.accent11,
    FortalTokens.accent12,
    FortalTokens.accentA1,
    FortalTokens.accentA2,
    FortalTokens.accentA3,
    FortalTokens.accentA4,
    FortalTokens.accentA5,
    FortalTokens.accentA6,
    FortalTokens.accentA7,
    FortalTokens.accentA8,
    FortalTokens.accentA9,
    FortalTokens.accentA10,
    FortalTokens.accentA11,
    FortalTokens.accentA12,
  ];
  const roleTokens = <String, ColorToken>{
    'accentSurface': FortalTokens.accentSurface,
    'accentSolid': FortalTokens.accentSolid,
    'accentSolidHover': FortalTokens.accentSolidHover,
    'accentContrast': FortalTokens.accentContrast,
    'accentIndicator': FortalTokens.accentIndicator,
    'accentTrack': FortalTokens.accentTrack,
    'accentMarkHover': FortalTokens.accentMarkHover,
    'accentIndicatorContrast': FortalTokens.accentIndicatorContrast,
    'accentContent': FortalTokens.accentContent,
    'accentThumbRing': FortalTokens.accentThumbRing,
    'focus8': FortalTokens.focus8,
    'accentRange': FortalTokens.accentRange,
    'accentThumb': FortalTokens.accentThumb,
    'accentSwatchContrast': FortalTokens.accentSwatchContrast,
  };
  const functionalTokens = <String, ColorToken>{
    'colorBackground': FortalTokens.colorBackground,
    'colorSurface': FortalTokens.colorSurface,
    'colorPanelSolid': FortalTokens.colorPanelSolid,
    'colorPanelTranslucent': FortalTokens.colorPanelTranslucent,
    'colorOverlay': FortalTokens.colorOverlay,
    'controlBorder': FortalTokens.controlBorder,
    'error3': FortalTokens.error3,
    'error7': FortalTokens.error7,
    'error8': FortalTokens.error8,
    'error9': FortalTokens.error9,
    'error11': FortalTokens.error11,
    'error12': FortalTokens.error12,
    'errorA7': FortalTokens.errorA7,
    'controlTrack': FortalTokens.controlTrack,
    'controlTrackHover': FortalTokens.controlTrackHover,
    'controlThumb': FortalTokens.controlThumb,
    'success': FortalTokens.success,
    'warning': FortalTokens.warning,
    'info': FortalTokens.info,
    'toneTeal': FortalTokens.toneTeal,
    'toneSky': FortalTokens.toneSky,
    'toneOrchid': FortalTokens.toneOrchid,
    'toneViolet': FortalTokens.toneViolet,
    'toneRose': FortalTokens.toneRose,
    'toneAmber': FortalTokens.toneAmber,
    'toneGreen': FortalTokens.toneGreen,
  };

  int argb(Map<MixToken<Object?>, Object> tokens, MixToken<Object?> token) =>
      (tokens[token]! as Color).toARGB32();

  test('the accent enum names the eight foundation accents', () {
    expect(FortalAccentColor.values.map((value) => value.name), [
      ...foundationAccents,
    ]);
  });

  for (final name in foundationAccents) {
    final accent = FortalAccentColor.values.byName(name);
    for (final mode in ['light', 'dark']) {
      final theme = mode == 'dark'
          ? FortalThemeData.dark(accent: accent)
          : FortalThemeData.light(accent: accent);
      final tokens = buildFortalScopeTokens(theme);

      test('$name/$mode: the shared neutral scale', () {
        final expected = foundationScales['gray']![mode]!;
        for (var i = 0; i < 24; i++) {
          expect(
            argb(tokens, grayTokens[i]),
            expected[i],
            reason: grayTokens[i].name,
          );
        }
      });

      test('$name/$mode: the accent scale', () {
        final expected = foundationScales[name]![mode]!;
        for (var i = 0; i < 24; i++) {
          expect(
            argb(tokens, accentTokens[i]),
            expected[i],
            reason: accentTokens[i].name,
          );
        }
      });

      test('$name/$mode: the accent roles', () {
        final expected = foundationAccentRoles[mode]![name]!;
        for (final MapEntry(key: role, value: token) in roleTokens.entries) {
          expect(argb(tokens, token), expected[role]!, reason: role);
        }
        // focusA8 and accentContentAlpha carry the same value as their
        // opaque roles; the gray roles are the neutral accent's.
        expect(argb(tokens, FortalTokens.focusA8), expected['focus8']);
        expect(
          argb(tokens, FortalTokens.accentContentAlpha),
          expected['accentContent'],
        );
        expect(
          argb(tokens, FortalTokens.focusA5),
          argb(tokens, FortalTokens.accentA5),
        );
      });

      test('$name/$mode: functional and status colours', () {
        final expected = foundationFunctional[mode]!;
        for (final MapEntry(key: role, value: token)
            in functionalTokens.entries) {
          expect(argb(tokens, token), expected[role]!, reason: role);
        }
        final neutral = foundationAccentRoles[mode]!['orla']!;
        expect(
          argb(tokens, FortalTokens.grayIndicator),
          neutral['accentIndicator'],
        );
        expect(argb(tokens, FortalTokens.grayTrack), neutral['accentTrack']);
        expect(
          argb(tokens, FortalTokens.grayContrast),
          neutral['accentIndicatorContrast'],
        );
        expect(
          argb(tokens, FortalTokens.graySurface),
          argb(tokens, FortalTokens.grayA3),
        );
      });
    }
  }

  group('high contrast', () {
    for (final accent in FortalAccentColor.values) {
      for (final dark in [false, true]) {
        final name = '${accent.name}/${dark ? 'dark' : 'light'}';
        final plain = resolveFortalTokens(
          dark
              ? FortalThemeData.dark(accent: accent)
              : FortalThemeData.light(accent: accent),
        );
        final fitted = resolveFortalTokens(
          dark
              ? FortalThemeData.dark(accent: accent, highContrast: true)
              : FortalThemeData.light(accent: accent, highContrast: true),
        );

        test('$name: boundaries and marks meet the gates', () {
          final page = fitted.colorBackground;
          final panel = fitted.colorPanelSolid;
          final surfaces = [...fitted.markSurfaces, fitted.controlTrack];
          for (final surface in surfaces) {
            expect(
              contrastRatio(fitted.controlBorder, surface),
              greaterThanOrEqualTo(3),
              reason: 'control border on $surface',
            );
          }
          for (final surface in fitted.markSurfaces) {
            expect(
              contrastRatio(fitted.controlTrack, surface),
              greaterThanOrEqualTo(3),
              reason: 'off track',
            );
            expect(
              contrastRatio(fitted.accent.indicator, surface),
              greaterThanOrEqualTo(3),
              reason: 'indicator',
            );
            expect(
              contrastRatio(Color.alphaBlend(fitted.focus8, surface), surface),
              greaterThanOrEqualTo(3),
              reason: 'focus',
            );
          }
          expect(
            contrastRatio(
              fitted.accentIndicatorContrast,
              fitted.accent.indicator,
            ),
            greaterThanOrEqualTo(3),
            reason: 'mark ink',
          );
          for (final track in [fitted.accent.track, fitted.controlTrack]) {
            expect(
              math.max(
                contrastRatio(fitted.accentThumb, track),
                contrastRatio(fitted.accentThumbRing, track),
              ),
              greaterThanOrEqualTo(3),
              reason: 'thumb or ring on $track',
            );
          }
          for (var step = 1; step <= 3; step++) {
            expect(
              contrastRatio(
                fitted.accentContent,
                fitted.accent.scale.step(step),
              ),
              greaterThanOrEqualTo(4.5),
              reason: 'content on step $step',
            );
          }
          for (var step = 1; step <= 5; step++) {
            expect(
              contrastRatio(
                fitted.accent.scale.step(12),
                fitted.accent.scale.step(step),
              ),
              greaterThanOrEqualTo(7),
              reason: 'strong text on step $step',
            );
          }
          for (final fill in [fitted.accent.solid, fitted.accent.solidHover]) {
            expect(
              contrastRatio(fitted.accent.contrast, fill),
              greaterThanOrEqualTo(4.5),
              reason: 'label on $fill',
            );
          }
          expect(page, plain.colorBackground);
          expect(panel, plain.colorPanelSolid);
        });

        test('$name: the switch changes the failing boundaries only', () {
          // The default look keeps the foundation's quiet border and track.
          expect(
            contrastRatio(plain.controlBorder, plain.colorBackground),
            lessThan(3),
          );
          expect(
            contrastRatio(plain.controlTrack, plain.colorBackground),
            lessThan(3),
          );
          expect(fitted.controlBorder, isNot(plain.controlBorder));
          expect(fitted.controlTrack, isNot(plain.controlTrack));
          expect(fitted.accent.solid, plain.accent.solid);
          expect(fitted.accent.contrast, plain.accent.contrast);
          expect(fitted.accent.surface, plain.accent.surface);
          for (var step = 1; step <= 11; step++) {
            expect(
              fitted.accent.scale.step(step),
              plain.accent.scale.step(step),
            );
          }
        });
      }
    }

    test('custom palettes without pinned roles are fitted in both modes', () {
      final stripped = FortalColorTheme(
        FortalColor(
          sol.light.scale,
          sol.light.surface,
          sol.light.indicator,
          sol.light.track,
          sol.light.contrast,
        ),
        sol.dark,
      );
      final FortalThemeColors colors = resolveFortalTokens(
        FortalThemeData.light(accentPalette: stripped),
      );
      // Amber's light indicator fails 3:1 on white, so the fitted ink and
      // ring take over where the pinned roles would have kept the look.
      expect(colors.accentThumbRing, isNot(const Color(0x00000000)));
      expect(
        contrastRatio(colors.accentIndicatorContrast, colors.accent.indicator),
        greaterThanOrEqualTo(3),
      );
      expect(
        contrastRatio(colors.accentContent, colors.accent.scale.step(3)),
        greaterThanOrEqualTo(4.5),
      );
    });
  });

  group('type', () {
    final tokens = buildFortalScopeTokens(const FortalThemeData.light());
    TextStyle text(TextStyleToken token) => tokens[token]! as TextStyle;

    test('the ramp is 12, 13, 15, 17, 20, 22, 28, 34 and 40 pixels', () {
      final expected = <TextStyleToken, (double, double, double, String)>{
        FortalTokens.text1: (12, 1.4, -0.01, RemixFonts.inter),
        FortalTokens.text2: (13, 1.4, -0.01, RemixFonts.inter),
        FortalTokens.text3: (15, 1.4, -0.01, RemixFonts.inter),
        FortalTokens.text4: (17, 1.4, -0.01, RemixFonts.inter),
        FortalTokens.text5: (20, 1.2, -0.01, RemixFonts.inter),
        FortalTokens.text6: (22, 1.15, -0.02, RemixFonts.inter),
        FortalTokens.text7: (28, 1.1, -0.03, RemixFonts.geist),
        FortalTokens.text8: (34, 1.1, -0.03, RemixFonts.geist),
        FortalTokens.text9: (40, 1.1, -0.03, RemixFonts.geist),
        FortalTokens.textField: (14, 1.4, -0.01, RemixFonts.inter),
      };
      for (final MapEntry(key: token, value: (size, leading, tracking, family))
          in expected.entries) {
        final style = text(token);
        expect(style.fontSize, size, reason: token.name);
        expect(style.height, closeTo(leading, 1e-9), reason: token.name);
        expect(
          style.letterSpacing,
          closeTo(tracking * size, 1e-9),
          reason: token.name,
        );
        expect(style.fontFamily, family, reason: token.name);
        expect(
          style.leadingDistribution,
          TextLeadingDistribution.even,
          reason: token.name,
        );
      }
      expect(text(FortalTokens.avatarFallback5).fontFamily, RemixFonts.inter);
    });

    test('families follow the theme and null leaves them to the app', () {
      const theme = FortalThemeData.light(
        fontFamily: 'Body',
        displayFontFamily: 'Display',
      );
      final custom = buildFortalScopeTokens(theme);
      expect((custom[FortalTokens.text3]! as TextStyle).fontFamily, 'Body');
      expect((custom[FortalTokens.text8]! as TextStyle).fontFamily, 'Display');
      final bare = buildFortalScopeTokens(
        const FortalThemeData(
          accent: FortalAccentColor.orla,
          brightness: .light,
          panelBackground: FortalPanelBackground.solid,
          radius: FortalRadius.medium,
          scaling: FortalScaling.percent100,
          hasBackground: true,
        ),
      );
      expect((bare[FortalTokens.text3]! as TextStyle).fontFamily, isNull);
      expect((bare[FortalTokens.text8]! as TextStyle).fontFamily, isNull);
      expect(
        const FortalThemeData.light().monoFontFamily,
        RemixFonts.geistMono,
      );
    });
  });

  test('the radius ladder is the control radius with its offsets', () {
    final tokens = buildFortalScopeTokens(const FortalThemeData.light());
    final expected = <RadiusToken, double>{
      FortalTokens.radius1: 6,
      FortalTokens.radius2: 10,
      FortalTokens.radius3: 12,
      FortalTokens.radius4: 14,
      FortalTokens.radius5: 16,
      FortalTokens.radius6: 20,
      FortalTokens.radius7: 24,
    };
    for (final MapEntry(key: token, value: value) in expected.entries) {
      expect(tokens[token], Radius.circular(value), reason: token.name);
    }
    expect(tokens[FortalTokens.controlHeight1], 32);
    expect(tokens[FortalTokens.controlHeight2], 40);
    expect(tokens[FortalTokens.controlHeight3], 44);
    expect(tokens[FortalTokens.controlHeight4], 48);
    expect(tokens[FortalTokens.space18], 18);
    expect(tokens[FortalTokens.space20], 20);
    expect(tokens[FortalTokens.space56], 56);
  });

  group('shadows', () {
    test('blur radii reproduce the CSS sigma', () {
      for (final blur in [2.0, 3.0, 6.0, 10.0, 18.0, 22.0, 48.0, 55.0]) {
        expect(
          Shadow.convertRadiusToSigma(fortalBlurRadius(blur)),
          closeTo(blur / 2, 1e-9),
          reason: '$blur',
        );
      }
      expect(fortalBlurRadius(0), 0);
    });

    test('light shadows carry two layers and dark shadows one', () {
      final light = buildFortalScopeTokens(const FortalThemeData.light());
      final dark = buildFortalScopeTokens(const FortalThemeData.dark());
      final raised = light[FortalTokens.shadow3]! as List<BoxShadow>;
      expect(raised.map((layer) => layer.offset), [
        const Offset(0, 6),
        const Offset(0, 1),
      ]);
      expect(raised.map((layer) => layer.blurRadius), [
        closeTo(fortalBlurRadius(18), 1e-9),
        closeTo(fortalBlurRadius(3), 1e-9),
      ]);
      expect(raised.map((layer) => layer.color.a), [
        closeTo(.065, .002),
        closeTo(.035, .002),
      ]);
      final darkRaised = dark[FortalTokens.shadow3]! as List<BoxShadow>;
      expect(darkRaised.single.offset, const Offset(0, 8));
      expect(darkRaised.single.color.a, closeTo(.22, .002));
      final thumb = light[FortalTokens.shadowThumb]! as List<BoxShadow>;
      expect(thumb, hasLength(3));
      expect(thumb.first.spreadRadius, .5);
      expect(thumb.first.blurRadius, 0);
      expect(thumb.map((layer) => layer.offset.dy), [0, 1, 2]);
    });
  });

  group('motion', () {
    test('duration springs equal the explicit descriptions', () {
      for (final (spring, milliseconds) in [
        (FortalMotion.springSnappy, 240),
        (FortalMotion.springSmooth, 360),
      ]) {
        final byDuration = SpringDescription.withDurationAndBounce(
          duration: Duration(milliseconds: milliseconds),
        );
        expect(spring.mass, 1);
        expect(spring.stiffness, closeTo(byDuration.stiffness, .1));
        expect(spring.damping, closeTo(byDuration.damping, .01));
      }
      expect(FortalMotion.springMorph, same(FortalMotion.springSmooth));
    });

    test('the transform spring settles at its duration', () {
      final simulation = SpringSimulation(FortalMotion.springCss, 0, 1, 0);
      expect(simulation.x(.44), closeTo(.997, .002));
      expect(simulation.x(.22), closeTo(.908, .005));
    });

    test('durations and eases', () {
      expect(FortalMotion.instant, const Duration(milliseconds: 100));
      expect(FortalMotion.fast, const Duration(milliseconds: 150));
      expect(FortalMotion.exit, const Duration(milliseconds: 140));
      expect(FortalMotion.standard, const Duration(milliseconds: 200));
      expect(FortalMotion.considered, const Duration(milliseconds: 360));
      expect(FortalMotion.easeStandard, const Cubic(0.22, 1, 0.36, 1));
      expect(FortalMotion.easeExit.transform(.5), lessThan(.5));
      expect(FortalMotion.easeEnter.transform(.5), greaterThan(.5));
    });
  });
}
