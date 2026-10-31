/// Ui computed tokens and functional color utilities.
///
/// Implements computed role tokens (accent-contrast, accent-track, etc.) and
/// background/overlay colors derived from Ui-owned palettes.
///
/// Components should use these functional roles rather than raw color steps.
library;

import 'dart:math' as math;
import 'dart:ui' show Color, Offset;

import 'package:flutter/painting.dart' show BoxShadow, ColorSwatch;
import 'package:remix/remix.dart' show MixToken, RemixBoxShadow;

import 'fortal_colors.dart';
import 'palette.dart';
import 'theme_data.dart';
import 'tokens.dart';

/// Computes solid focus ring color (accent step 8).
Color computeFocus8(UiColorScale accent) => accent.step(8);

/// Computes translucent text selection color (accent alpha step 5).
Color computeFocusA5(UiColorScale accent) => accent.alphaStep(5);

/// Computes translucent focus ring color (accent alpha step 8).
Color computeFocusA8(UiColorScale accent) => accent.alphaStep(8);

/// Computes primary page background color.
///
/// Both modes use Calçadão step 1, including the warm off-white light page.
Color computeColorBackground(UiColorScale gray, {required bool isDark}) =>
    gray.step(1);

/// Computes solid background for panels and input surfaces.
///
/// Solid panels use the neutral step 2 in both modes.
Color computeColorPanelSolid(UiColorScale gray, {required bool isDark}) =>
    gray.step(2);

/// Computes translucent background for floating panels.
///
/// Opt-in translucent panels composite neutral step 2 over the page.
Color computeColorPanelTranslucent(UiColorScale gray, {required bool isDark}) =>
    gray.alphaStep(2);

/// Computes the neutral control surface color.
///
/// Controls use the neutral step-2 surface in the active mode.
Color computeColorSurface({required bool isDark}) =>
    (isDark ? calcadao.dark : calcadao.light).scale.step(2);

/// Computes modal backdrop overlay color.
///
/// Uses black alpha step 6 (light mode) or step 8 (dark mode).
Color computeColorOverlay({required bool isDark}) =>
    isDark ? blackAlpha[8]! : blackAlpha[6]!;

/// Computes the mode-aware stroke used by elevation shadows.
Color computeShadowStroke(UiColorScale gray, {required bool isDark}) =>
    mixOklabPremultiplied(
      gray.alphaStep(isDark ? 6 : 3),
      gray.step(isDark ? 6 : 3),
      0.25,
    );

/// Mixes two sRGB colors in OKLab after premultiplying their channels by
/// alpha, matching CSS `color-mix(in oklab, ...)` for translucent colors.
Color mixOklabPremultiplied(Color first, Color second, double amount) {
  if (!amount.isFinite || amount < 0 || amount > 1) {
    throw ArgumentError.value(
      amount,
      'amount',
      'Expected a value from 0 to 1.',
    );
  }
  final firstWeight = 1 - amount;
  final alpha = first.a * firstWeight + second.a * amount;
  if (alpha == 0) return const Color(0x00000000);

  final firstLab = _srgbToOklab(first);
  final secondLab = _srgbToOklab(second);
  final mixedLab = (
    lightness:
        (firstLab.lightness * first.a * firstWeight +
            secondLab.lightness * second.a * amount) /
        alpha,
    a:
        (firstLab.a * first.a * firstWeight + secondLab.a * second.a * amount) /
        alpha,
    b:
        (firstLab.b * first.a * firstWeight + secondLab.b * second.a * amount) /
        alpha,
  );
  final rgb = _oklabToSrgb(mixedLab);

  return Color.from(
    alpha: alpha,
    red: rgb.red.clamp(0, 1),
    green: rgb.green.clamp(0, 1),
    blue: rgb.blue.clamp(0, 1),
  );
}

({double lightness, double a, double b}) _srgbToOklab(Color color) {
  final red = _linearizeSrgb(color.r);
  final green = _linearizeSrgb(color.g);
  final blue = _linearizeSrgb(color.b);
  final l = math
      .pow(
        0.4122214708 * red + 0.5363325363 * green + 0.0514459929 * blue,
        1 / 3,
      )
      .toDouble();
  final m = math
      .pow(
        0.2119034982 * red + 0.6806995451 * green + 0.1073969566 * blue,
        1 / 3,
      )
      .toDouble();
  final s = math
      .pow(
        0.0883024619 * red + 0.2817188376 * green + 0.6299787005 * blue,
        1 / 3,
      )
      .toDouble();

  return (
    lightness: 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
    a: 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
    b: 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
  );
}

({double red, double green, double blue}) _oklabToSrgb(
  ({double lightness, double a, double b}) color,
) {
  final l = math
      .pow(color.lightness + 0.3963377774 * color.a + 0.2158037573 * color.b, 3)
      .toDouble();
  final m = math
      .pow(color.lightness - 0.1055613458 * color.a - 0.0638541728 * color.b, 3)
      .toDouble();
  final s = math
      .pow(color.lightness - 0.0894841775 * color.a - 1.2914855480 * color.b, 3)
      .toDouble();

  return (
    red: _encodeSrgb(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s),
    green: _encodeSrgb(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s),
    blue: _encodeSrgb(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s),
  );
}

double _linearizeSrgb(double channel) => channel <= 0.04045
    ? channel / 12.92
    : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();

double _encodeSrgb(double channel) => channel <= 0.0031308
    ? 12.92 * channel
    : 1.055 * math.pow(channel, 1 / 2.4).toDouble() - 0.055;

/// Ui's floating-layer elevation scale (no inset or control shadows).
Map<MixToken<Object?>, Object> buildUiShadows({
  required bool isDark,
  required UiThemeColors colors,
}) {
  final color = Color.fromRGBO(0, 0, 0, isDark ? .36 : .14);
  const geometry = [
    (1.0, 2.0, 0.0),
    (2.0, 6.0, -1.0),
    (4.0, 12.0, -2.0),
    (8.0, 20.0, -4.0),
    (12.0, 32.0, -6.0),
    (16.0, 48.0, -8.0),
  ];
  const tokens = [
    UiTokens.shadow1,
    UiTokens.shadow2,
    UiTokens.shadow3,
    UiTokens.shadow4,
    UiTokens.shadow5,
    UiTokens.shadow6,
  ];
  return {
    for (var i = 0; i < geometry.length; i++)
      tokens[i]: [
        BoxShadow(
          color: color,
          offset: Offset(0, geometry[i].$1),
          blurRadius: geometry[i].$2,
          spreadRadius: geometry[i].$3,
        ),
      ],
    UiTokens.shadow1Layers: [
      RemixBoxShadow(color: color, offset: const Offset(0, 1), blurRadius: 2),
    ],
  };
}

/// Container for all computed Ui theme colors and scales.
///
/// Holds resolved color system for a specific theme configuration.
/// Created by [resolveUiTokens] for internal use by the token system.
class UiThemeColors {
  final UiColor accent;
  final UiColor gray;
  final ColorSwatch<int> blackAlpha;
  final ColorSwatch<int> whiteAlpha;

  // Functional colors
  final Color colorBackground;
  final Color colorSurface;
  final Color colorPanelSolid;
  final Color colorPanelTranslucent;
  final Color colorOverlay;
  final Color shadowStroke;

  // Focus
  final Color focus8;
  final Color focusA5;
  final Color focusA8;

  const UiThemeColors({
    required this.accent,
    required this.gray,
    required this.blackAlpha,
    required this.whiteAlpha,
    required this.colorBackground,
    required this.colorSurface,
    required this.colorPanelSolid,
    required this.colorPanelTranslucent,
    required this.colorOverlay,
    required this.shadowStroke,
    required this.focus8,
    required this.focusA5,
    required this.focusA8,
  });
}

// Named palettes share the same fixed-role model.
const Map<String, UiColorTheme> _accentThemesByName = {
  'calcadao': calcadao,
  'mar': mar,
  'ceu': ceu,
  'serra': serra,
  'sol': sol,
  'duna': duna,
  'caju': caju,
};

/// Resolves all computed tokens for a theme configuration.
UiThemeColors resolveUiTokens(UiThemeConfig theme) {
  final accentColor = theme.accent ?? UiAccentColor.calcadao;
  const grayTheme = calcadao;
  final accentTheme =
      theme.accentPalette ?? _accentThemesByName[accentColor.name]!;
  final UiColor accentRC = theme.isDark ? accentTheme.dark : accentTheme.light;
  final UiColor grayRC = theme.isDark ? grayTheme.dark : grayTheme.light;

  // Extract scales
  final UiColorScale accent = accentRC.scale;
  final UiColorScale gray = grayRC.scale;

  // Neutral alpha swatches
  const ColorSwatch<int> blackA = blackAlpha;
  const ColorSwatch<int> whiteA = whiteAlpha;

  // Backgrounds/panels/overlay
  final Color colorBackground = computeColorBackground(
    gray,
    isDark: theme.isDark,
  );
  final Color colorPanelSolid = computeColorPanelSolid(
    gray,
    isDark: theme.isDark,
  );
  final Color colorPanelTranslucent = computeColorPanelTranslucent(
    gray,
    isDark: theme.isDark,
  );
  final Color colorSurface = computeColorSurface(isDark: theme.isDark);
  final Color colorOverlay = computeColorOverlay(isDark: theme.isDark);
  final Color shadowStroke = computeShadowStroke(gray, isDark: theme.isDark);

  // Focus
  final Color focus8 = computeFocus8(accent);
  final Color focusA5 = computeFocusA5(accent);
  final Color focusA8 = computeFocusA8(accent);

  return UiThemeColors(
    accent: accentRC,
    gray: grayRC,
    blackAlpha: blackA,
    whiteAlpha: whiteA,
    colorBackground: colorBackground,
    colorSurface: colorSurface,
    colorPanelSolid: colorPanelSolid,
    colorPanelTranslucent: colorPanelTranslucent,
    colorOverlay: colorOverlay,
    shadowStroke: shadowStroke,
    focus8: focus8,
    focusA5: focusA5,
    focusA8: focusA8,
  );
}
