/// Fortal computed tokens and functional color utilities.
///
/// Implements computed role tokens (accent-contrast, accent-track, etc.) and
/// background/overlay colors derived from the selected paired theme.
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

/// Fits the source step-8 focus color to the surfaces it must identify.
Color computeFocus8(FortalColorScale accent, {List<Color>? surfaces}) =>
    _fitForeground(
      accent.step(8),
      accent.step(12),
      surfaces ?? [accent.step(1), accent.step(2)],
      3.05,
    );

/// Computes translucent text selection color (accent alpha step 5).
Color computeFocusA5(FortalColorScale accent) => accent.alphaStep(5);

/// Computes translucent focus ring color (accent alpha step 8).
Color computeFocusA8(FortalColorScale accent) => accent.alphaStep(8);

/// Computes primary page background color.
///
/// Uses step 1 of the neutral paired with the selected theme.
Color computeColorBackground(FortalColorScale gray, {required bool isDark}) =>
    gray.step(1);

/// Computes solid background for panels and input surfaces.
///
/// Solid panels use the neutral step 2 in both modes.
Color computeColorPanelSolid(FortalColorScale gray, {required bool isDark}) =>
    gray.step(2);

/// Computes translucent background for floating panels.
///
/// Opt-in translucent panels composite neutral step 2 over the page.
Color computeColorPanelTranslucent(
  FortalColorScale gray, {
  required bool isDark,
}) {
  final page = gray.step(1), panel = gray.step(2);
  final backgrounds = [page.r, page.g, page.b];
  final channels = [panel.r, panel.g, panel.b];
  var opacity = 0.0;
  for (var i = 0; i < 3; i++) {
    final background = backgrounds[i], channel = channels[i];
    final needed = channel < background
        ? (background - channel) / background
        : channel > background
        ? (channel - background) / (1 - background)
        : 0.0;
    opacity = math.max(opacity, needed);
  }
  if (opacity == 0) return const Color(0x00000000);
  final alpha = (opacity * 255).ceil();
  final a = alpha / 255;
  int foreground(int i) => ((channels[i] - backgrounds[i] * (1 - a)) / a * 255)
      .round()
      .clamp(0, 255);
  return Color.fromARGB(alpha, foreground(0), foreground(1), foreground(2));
}

/// Computes the neutral control surface color.
///
/// Controls use step 2 of the selected theme's paired neutral.
Color computeColorSurface(FortalColorScale gray) => gray.step(2);

/// Computes the neutral boundary of active empty controls.
///
/// Unchecked checkboxes and radios, the off switch's track and thumb, and
/// surface text inputs draw this line where it is the visual cue that a
/// control is there. It fits source step 8 toward the strong neutral text tone
/// until page, panel and off-track cues retain their 3:1 contrast requirement.
/// The [isDark] argument remains for source compatibility; the scale carries
/// its own appearance values.
Color computeControlBorder(FortalColorScale gray, {required bool isDark}) =>
    _fitForeground(gray.step(8), gray.step(12), [
      for (final surface in [gray.step(1), gray.step(2)]) ...[
        surface,
        Color.alphaBlend(gray.alphaStep(3), surface),
      ],
    ], 3.05);

/// Least movement toward the strong source text tone that meets the role.
/// Raw upstream scale and alpha steps remain untouched.
Color _fitForeground(
  Color start,
  Color end,
  List<Color> surfaces,
  double floor,
) {
  bool passes(Color color) => surfaces.every((surface) {
    final ink = Color.alphaBlend(color, surface).computeLuminance();
    final background = surface.computeLuminance();
    return (math.max(ink, background) + .05) /
            (math.min(ink, background) + .05) >=
        floor;
  });
  if (passes(start)) return start;
  var low = 0.0, high = 1.0;
  for (var i = 0; i < 12; i++) {
    final middle = (low + high) / 2;
    if (passes(mixOklabPremultiplied(start, end, middle))) {
      high = middle;
    } else {
      low = middle;
    }
  }
  return mixOklabPremultiplied(start, end, high);
}

/// Computes the ink of checks and radio dots on the accent's indicator.
///
/// Marks need 3:1 on the fill they sit on, which is the indicator, not the
/// labelled solid. White wherever it keeps 3:1 on the indicator; otherwise the
/// palette's [FortalColor.contrast] when that keeps 3:1 there; otherwise
/// a deep neutral fallback for hand-authored palettes.
Color computeAccentIndicatorContrast(FortalColor accent) =>
    accent.markContrast != null &&
        _keepsMarkContrast(accent.markContrast!, accent.indicator)
    ? accent.markContrast!
    : _markInk(accent.indicator, accent.contrast);

/// Computes the outline of track-coloured shapes: light switch and slider
/// thumbs, and the filled extent of a surface progress bar.
///
/// Where white keeps 3:1 on the accent's track, a white thumb already stands
/// out there and the outline only separates the shape from the page and
/// panels around it: the track colour itself where it keeps 3:1 against every
/// one of [surfaces], otherwise [controlBorder]. Without [surfaces] that
/// cannot be judged, so the conservative [controlBorder] is used. On a bright
/// track the outline carries the contrast instead, with the same ink rule as
/// [computeAccentIndicatorContrast].
Color computeAccentThumbRing(
  FortalColor accent,
  Color controlBorder, {
  List<Color>? surfaces,
}) {
  final track = accent.track;
  if (!_keepsMarkContrast(_white, track) ||
      (accent.markContrast != null &&
          !_keepsMarkContrast(_white, accent.markHover))) {
    final ink = computeAccentIndicatorContrast(accent);
    // Hand-authored palettes can give the indicator and track different fills.
    return _keepsMarkContrast(ink, track)
        ? ink
        : _markInk(track, accent.contrast);
  }
  final clear =
      surfaces != null &&
      surfaces.every((surface) => _keepsMarkContrast(track, surface));
  return clear ? track : controlBorder;
}

const _white = Color(0xFFFFFFFF);

Color _markInk(Color fill, Color supplied) {
  if (_keepsMarkContrast(_white, fill)) return _white;
  if (_keepsMarkContrast(supplied, fill)) return supplied;
  return const Color(0xff13181d);
}

/// WCAG 2 contrast of at least 3:1, the non-text threshold.
bool _keepsMarkContrast(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (math.max(a, b) + .05) / (math.min(a, b) + .05) >= 3;
}

/// Computes modal backdrop overlay color.
///
/// Uses black alpha step 6 (light mode) or step 8 (dark mode).
Color computeColorOverlay({required bool isDark}) =>
    isDark ? blackAlpha[8]! : blackAlpha[6]!;

/// Computes the mode-aware stroke used by elevation shadows.
Color computeShadowStroke(FortalColorScale gray, {required bool isDark}) =>
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

/// Fortal's floating-layer elevation scale (no inset or control shadows).
Map<MixToken<Object?>, Object> buildFortalShadows({
  required bool isDark,
  required FortalThemeColors colors,
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
    FortalTokens.shadow1,
    FortalTokens.shadow2,
    FortalTokens.shadow3,
    FortalTokens.shadow4,
    FortalTokens.shadow5,
    FortalTokens.shadow6,
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
    FortalTokens.shadow1Layers: [
      RemixBoxShadow(color: color, offset: const Offset(0, 1), blurRadius: 2),
    ],
  };
}

/// Container for all computed Fortal theme colors and scales.
///
/// Holds resolved color system for a specific theme configuration.
/// Created by [resolveFortalTokens] for internal use by the token system.
class FortalThemeColors {
  final FortalColor accent;
  final FortalColor gray;
  final ColorSwatch<int> blackAlpha;
  final ColorSwatch<int> whiteAlpha;

  // Functional colors
  final Color colorBackground;
  final Color colorSurface;
  final Color colorPanelSolid;
  final Color colorPanelTranslucent;
  final Color colorOverlay;
  final Color shadowStroke;

  // Control boundaries
  final Color controlBorder;
  final Color accentThumbRing;

  // Focus
  final Color focus8;
  final Color focusA5;
  final Color focusA8;

  /// Ink of checks and radio dots on the accent's indicator.
  Color get accentIndicatorContrast => computeAccentIndicatorContrast(accent);

  List<Color> get _contentSurfaces => [
    for (var step = 1; step <= 5; step++) accent.scale.step(step),
    for (final surface in [colorBackground, colorPanelSolid]) ...[
      surface,
      for (var step = 3; step <= 5; step++)
        Color.alphaBlend(accent.scale.alphaStep(step), surface),
    ],
  ];

  /// Accessible normal text across soft, surface and outline treatments.
  Color get accentContent => _fitForeground(
    accent.scale.step(11),
    accent.scale.step(12),
    _contentSurfaces,
    4.6,
  );

  /// Retains upstream alpha text where it meets the same content contract.
  Color get accentContentAlpha => _fitForeground(
    accent.scale.alphaStep(11),
    accentContent,
    _contentSurfaces,
    4.6,
  );

  const FortalThemeColors({
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
    required this.controlBorder,
    required this.accentThumbRing,
    required this.focus8,
    required this.focusA5,
    required this.focusA8,
  });
}

// Named palettes share the same fixed-role model.
const Map<String, FortalColorTheme> _accentThemesByName = {
  'orla': orla,
  'mar': mar,
  'ceu': ceu,
  'serra': serra,
  'sol': sol,
  'duna': duna,
  'caju': caju,
};

/// Resolves all computed tokens for a theme configuration.
FortalThemeColors resolveFortalTokens(FortalThemeConfig theme) {
  final accentColor = theme.accent ?? FortalAccentColor.orla;
  final grayTheme = fortalNeutralPalettes[accentColor.name]!;
  final accentTheme =
      theme.accentPalette ?? _accentThemesByName[accentColor.name]!;
  final FortalColor accentRC = theme.isDark
      ? accentTheme.dark
      : accentTheme.light;
  final FortalColor grayRC = theme.isDark ? grayTheme.dark : grayTheme.light;

  // Extract scales
  final FortalColorScale accent = accentRC.scale;
  final FortalColorScale gray = grayRC.scale;

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
  final Color colorSurface = computeColorSurface(gray);
  final Color colorOverlay = computeColorOverlay(isDark: theme.isDark);
  final Color shadowStroke = computeShadowStroke(gray, isDark: theme.isDark);
  final Color controlBorder = computeControlBorder(gray, isDark: theme.isDark);

  // Focus
  final Color focus8 = computeFocus8(
    accent,
    surfaces: [colorBackground, colorPanelSolid],
  );
  final Color focusA5 = computeFocusA5(accent);
  final Color focusA8 = computeFocusA8(accent);

  return FortalThemeColors(
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
    controlBorder: controlBorder,
    accentThumbRing: computeAccentThumbRing(
      accentRC,
      controlBorder,
      surfaces: [
        colorBackground,
        colorPanelSolid,
        Color.alphaBlend(colorPanelTranslucent, colorBackground),
      ],
    ),
    focus8: focus8,
    focusA5: focusA5,
    focusA8: focusA8,
  );
}
