/// Fortal computed tokens and functional color utilities.
///
/// Resolves the roles a palette does not store, such as content and focus
/// colors, control borders, backgrounds and shadows, for the selected accent
/// and appearance. Built-in accents pin most roles ([UiColorRoles]); the
/// fitting functions here serve custom palettes and the theme's high contrast
/// switch, which moves the foundation's low-contrast boundaries to the
/// accessible values.
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

/// Fortal's margin over WCAG's 3:1 for marks and focus rings on a surface.
const _markMargin = 3.05;

/// WCAG 2 contrast ratio between two opaque colors.
double computeContrastRatio(Color first, Color second) {
  final a = first.computeLuminance();
  final b = second.computeLuminance();
  return (math.max(a, b) + .05) / (math.min(a, b) + .05);
}

/// Fits the source step-8 focus color to the surfaces it must identify.
Color computeFocus8(UiColorScale accent, {List<Color>? surfaces}) =>
    _fitForeground(
      accent.step(8),
      accent.step(12),
      surfaces ?? [accent.step(1), accent.step(2)],
      _markMargin,
    );

/// A chart series color from [scale] that keeps 3:1 on every one of
/// [surfaces]: [preferred] when it does, otherwise the first of source steps
/// 9 to 11 that does, otherwise step 12.
Color computeChartSeries(
  UiColorScale scale,
  List<Color> surfaces, {
  Color? preferred,
}) {
  for (final color in [
    ?preferred,
    for (var step = 9; step <= 11; step++) scale.step(step),
  ]) {
    if (_keepsContrast(color, surfaces, _markMargin)) return color;
  }
  return scale.step(12);
}

/// Computes translucent text selection color (accent alpha step 5).
Color computeFocusA5(UiColorScale accent) => accent.alphaStep(5);

/// Computes translucent focus ring color (accent alpha step 8).
Color computeFocusA8(UiColorScale accent) => accent.alphaStep(8);

UiFunctionalColors _functional({required bool isDark}) =>
    isDark ? uiFunctionalDark : uiFunctionalLight;

/// The page colour. The neutral's step 1 carries it; [gray] stays in the
/// signature for callers written against the fitted model.
Color computeColorBackground(UiColorScale gray, {required bool isDark}) =>
    _functional(isDark: isDark).background;

/// The solid panel colour: the raised surface, a step above the input
/// surface in dark.
Color computeColorPanelSolid(UiColorScale gray, {required bool isDark}) =>
    _functional(isDark: isDark).panelSolid;

/// The translucent panel colour: the raised surface at 88 percent.
Color computeColorPanelTranslucent(UiColorScale gray, {required bool isDark}) =>
    _functional(isDark: isDark).panelTranslucent;

/// The surface colour of input fields and controls: neutral step 2.
Color computeColorSurface(UiColorScale gray) => gray.step(2);

/// The modal backdrop, the same in both appearances.
Color computeColorOverlay({required bool isDark}) =>
    _functional(isDark: isDark).overlay;

/// Computes the neutral boundary of active empty controls under high
/// contrast.
///
/// Unchecked checkboxes and radios, the off switch's track and thumb, and
/// surface text inputs draw this line where it is the visual cue that a
/// control is there. It fits neutral step 8 toward the strong neutral text
/// tone until every one of [surfaces] keeps the 3:1 requirement.
Color computeControlBorder(
  UiColorScale gray, {
  required List<Color> surfaces,
}) => _fitForeground(gray.step(8), gray.step(12), [
  for (final surface in surfaces) ...[
    surface,
    Color.alphaBlend(gray.alphaStep(3), surface),
  ],
], _markMargin);

/// Moves a mark fill toward the accent's strong tone until it keeps 3:1 on
/// every one of [surfaces].
Color computeMarkFill(
  Color fill,
  UiColorScale accent, {
  required List<Color> surfaces,
}) => _fitForeground(fill, accent.step(10), surfaces, _markMargin);

/// The soft fills and neutral surfaces accent text has to read on.
List<Color> _contentSurfaces(UiColorScale accent, Color page, Color panel) => [
  for (var step = 1; step <= 5; step++) accent.step(step),
  for (final surface in [page, panel]) ...[
    surface,
    for (var step = 3; step <= 5; step++)
      Color.alphaBlend(accent.alphaStep(step), surface),
  ],
];

/// Accessible normal text across soft, surface and outline treatments: step
/// 11 fitted toward step 12 for 4.5:1 on steps 1 to 5 and on the alpha fills
/// 3 to 5 over the page and panel.
Color computeAccentContent(
  UiColorScale accent, {
  required Color page,
  required Color panel,
}) => _fitForeground(
  accent.step(11),
  accent.step(12),
  _contentSurfaces(accent, page, panel),
  4.6,
);

/// Retains alpha step 11 where it meets the same content contract, otherwise
/// moves toward [content].
Color computeAccentContentAlpha(
  UiColorScale accent, {
  required Color content,
  required Color page,
  required Color panel,
}) => _fitForeground(
  accent.alphaStep(11),
  content,
  _contentSurfaces(accent, page, panel),
  4.6,
);

/// Least movement toward the strong source text tone that meets the role.
/// Raw upstream scale and alpha steps remain untouched.
Color _fitForeground(
  Color start,
  Color end,
  List<Color> surfaces,
  double floor,
) {
  bool passes(Color color) => _keepsContrast(color, surfaces, floor);
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

/// Whether [color], composited over each of [surfaces], keeps [floor] there.
bool _keepsContrast(Color color, List<Color> surfaces, double floor) =>
    surfaces.every(
      (surface) =>
          computeContrastRatio(Color.alphaBlend(color, surface), surface) >=
          floor,
    );

/// Computes the ink of checks and radio dots on the accent's indicator.
///
/// Marks need 3:1 on the fill they sit on, which is the indicator, not the
/// labelled solid. White wherever it keeps 3:1 on the indicator; otherwise the
/// palette's [UiColor.contrast] when that keeps 3:1 there; otherwise
/// a deep neutral fallback for hand-authored palettes.
Color computeAccentIndicatorContrast(UiColor accent) =>
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
  UiColor accent,
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
bool _keepsMarkContrast(Color first, Color second) =>
    computeContrastRatio(first, second) >= 3;

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

/// The Flutter blur radius whose Gaussian matches a CSS shadow blur.
///
/// CSS blurs a shadow with sigma `blur / 2`; Flutter's
/// `Shadow.convertRadiusToSigma` is `0.57735 × radius + 0.5` for a positive
/// radius and 0 otherwise. Writing the CSS number into `blurRadius` would
/// paint a shadow about a fifth wider and softer than designed.
double uiBlurRadius(double cssBlur) =>
    cssBlur <= 1 ? 0 : (cssBlur / 2 - 0.5) / 0.57735;

/// One shadow layer in the foundation's CSS terms.
typedef _Layer = ({double y, double blur, double spread, double alpha});

BoxShadow _boxShadow(_Layer layer) => BoxShadow(
  color: Color.fromRGBO(0, 0, 0, layer.alpha),
  offset: Offset(0, layer.y),
  blurRadius: uiBlurRadius(layer.blur),
  spreadRadius: layer.spread,
);

/// Fortal's elevation scale and the thumb shadow.
///
/// Levels 1, 3 and 5 are the foundation's resting, raised and floating
/// shadows; 2 and 4 sit midway between their neighbours and 6 extends level 5
/// by a quarter. Light shadows carry two layers, dark ones a single denser
/// layer.
Map<MixToken<Object?>, Object> buildUiShadows({required bool isDark}) {
  final levels = isDark
      ? const <List<_Layer>>[
          [(y: 1, blur: 2, spread: 0, alpha: .18)],
          [(y: 4.5, blur: 12, spread: 0, alpha: .20)],
          [(y: 8, blur: 22, spread: 0, alpha: .22)],
          [(y: 15, blur: 38.5, spread: 0, alpha: .28)],
          [(y: 22, blur: 55, spread: 0, alpha: .34)],
          [(y: 27.5, blur: 68.75, spread: 0, alpha: .34)],
        ]
      : const <List<_Layer>>[
          [(y: 1, blur: 2, spread: 0, alpha: .035)],
          [
            (y: 3.5, blur: 10, spread: 0, alpha: .05),
            (y: 1, blur: 3, spread: 0, alpha: .035),
          ],
          [
            (y: 6, blur: 18, spread: 0, alpha: .065),
            (y: 1, blur: 3, spread: 0, alpha: .035),
          ],
          [
            (y: 13, blur: 33, spread: 0, alpha: .085),
            (y: 2, blur: 6.5, spread: 0, alpha: .04),
          ],
          [
            (y: 20, blur: 48, spread: 0, alpha: .105),
            (y: 3, blur: 10, spread: 0, alpha: .045),
          ],
          [
            (y: 25, blur: 60, spread: 0, alpha: .105),
            (y: 3.75, blur: 12.5, spread: 0, alpha: .045),
          ],
        ];
  final thumb = isDark
      ? const <_Layer>[
          (y: 0, blur: 0, spread: .5, alpha: .30),
          (y: 1, blur: 2, spread: 0, alpha: .35),
          (y: 2, blur: 6, spread: 0, alpha: .20),
        ]
      : const <_Layer>[
          (y: 0, blur: 0, spread: .5, alpha: .07),
          (y: 1, blur: 2, spread: 0, alpha: .14),
          (y: 2, blur: 6, spread: 0, alpha: .06),
        ];
  const tokens = [
    UiTokens.shadow1,
    UiTokens.shadow2,
    UiTokens.shadow3,
    UiTokens.shadow4,
    UiTokens.shadow5,
    UiTokens.shadow6,
  ];
  final resting = levels[0].single;
  return {
    for (var i = 0; i < levels.length; i++)
      tokens[i]: [for (final layer in levels[i]) _boxShadow(layer)],
    UiTokens.shadowThumb: [for (final layer in thumb) _boxShadow(layer)],
    UiTokens.shadow1Layers: [
      RemixBoxShadow(
        color: Color.fromRGBO(0, 0, 0, resting.alpha),
        offset: Offset(0, resting.y),
        blurRadius: uiBlurRadius(resting.blur),
      ),
    ],
  };
}

/// Container for all computed Fortal theme colors and scales.
///
/// Holds the resolved color system for one theme configuration, as returned
/// by [resolveUiTokens].
class UiThemeColors {
  /// The accent, with its mark fills already fitted under high contrast.
  final UiColor accent;
  final UiColor gray;
  final UiFunctionalColors functional;
  final ColorSwatch<int> blackAlpha;
  final ColorSwatch<int> whiteAlpha;
  final bool highContrast;

  // Functional colors
  final Color colorBackground;
  final Color colorSurface;
  final Color colorPanelSolid;
  final Color colorPanelTranslucent;
  final Color colorOverlay;
  final Color shadowStroke;

  // Control boundaries
  final Color controlBorder;
  final Color controlTrack;
  final Color accentThumbRing;

  // Accent roles
  final Color accentIndicatorContrast;
  final Color accentContent;
  final Color accentContentAlpha;
  final Color accentRange;
  final Color accentThumb;
  final Color accentSwatchContrast;

  // Focus
  final Color focus8;
  final Color focusA5;
  final Color focusA8;

  /// The page and the solid and translucent panels marks must show on.
  List<Color> get markSurfaces =>
      _markSurfaces(colorBackground, colorPanelSolid, colorPanelTranslucent);

  const UiThemeColors({
    required this.accent,
    required this.gray,
    required this.functional,
    required this.blackAlpha,
    required this.whiteAlpha,
    required this.highContrast,
    required this.colorBackground,
    required this.colorSurface,
    required this.colorPanelSolid,
    required this.colorPanelTranslucent,
    required this.colorOverlay,
    required this.shadowStroke,
    required this.controlBorder,
    required this.controlTrack,
    required this.accentThumbRing,
    required this.accentIndicatorContrast,
    required this.accentContent,
    required this.accentContentAlpha,
    required this.accentRange,
    required this.accentThumb,
    required this.accentSwatchContrast,
    required this.focus8,
    required this.focusA5,
    required this.focusA8,
  });
}

List<Color> _markSurfaces(Color page, Color panel, Color translucentPanel) => [
  page,
  panel,
  Color.alphaBlend(translucentPanel, page),
];

// Named palettes share the same fixed-role model.
const Map<String, UiColorTheme> _accentThemesByName = {
  'orla': orla,
  'mar': mar,
  'ceu': ceu,
  'serra': serra,
  'sol': sol,
  'duna': duna,
  'caju': caju,
  'jambo': jambo,
};

/// Resolves all computed tokens for a theme configuration.
///
/// In the default mode a built-in accent's pinned [UiColorRoles] are used
/// as they are. A custom palette without roles has them fitted. Under
/// `highContrast` every palette takes the fitted path, and the neutral
/// control boundaries and the accent's mark fills are fitted as well.
UiThemeColors resolveUiTokens(UiThemeConfig theme) {
  final accentColor = theme.accent ?? UiAccentColor.orla;
  final accentTheme =
      theme.accentPalette ?? _accentThemesByName[accentColor.name]!;
  final isDark = theme.isDark;
  final highContrast = theme.highContrast ?? false;
  final functional = _functional(isDark: isDark);
  final UiColor grayRC = isDark ? uiNeutral.dark : uiNeutral.light;
  var accentRC = isDark ? accentTheme.dark : accentTheme.light;
  final gray = grayRC.scale;
  var accent = accentRC.scale;

  final colorBackground = computeColorBackground(gray, isDark: isDark);
  final colorPanelSolid = computeColorPanelSolid(gray, isDark: isDark);
  final colorPanelTranslucent = computeColorPanelTranslucent(
    gray,
    isDark: isDark,
  );
  final markSurfaces = _markSurfaces(
    colorBackground,
    colorPanelSolid,
    colorPanelTranslucent,
  );

  final controlTrack = highContrast
      ? _fitForeground(
          functional.controlTrack,
          gray.step(12),
          markSurfaces,
          _markMargin,
        )
      : functional.controlTrack;
  final controlBorder = highContrast
      ? computeControlBorder(gray, surfaces: [...markSurfaces, controlTrack])
      : gray.step(8);

  if (highContrast) {
    // Strong text keeps 7:1 on steps 1 to 5; only dark amber falls short.
    final strong = _fitForeground(accent.step(12), gray.step(12), [
      for (var step = 1; step <= 5; step++) accent.step(step),
    ], 7);
    accent = UiColorScale(
      ColorSwatch(accent.step(9).toARGB32(), {
        for (var step = 1; step <= 12; step++)
          step: step == 12 ? strong : accent.step(step),
      }),
      ColorSwatch(accent.alphaStep(9).toARGB32(), {
        for (var step = 1; step <= 12; step++)
          step: step == 12 ? strong : accent.alphaStep(step),
      }),
    );
    Color fit(Color fill) =>
        computeMarkFill(fill, accent, surfaces: markSurfaces);
    accentRC = UiColor(
      accent,
      accentRC.surface,
      fit(accentRC.indicator),
      fit(accentRC.track),
      accentRC.contrast,
      solid: accentRC.solid,
      solidHover: accentRC.solidHover,
      markContrast: accentRC.markContrast,
      markHover: fit(accentRC.markHover),
    );
  }
  final roles = accentRC.roles;

  final accentContent =
      roles?.content ??
      computeAccentContent(
        accent,
        page: colorBackground,
        panel: colorPanelSolid,
      );

  return UiThemeColors(
    accent: accentRC,
    gray: grayRC,
    functional: functional,
    blackAlpha: blackAlpha,
    whiteAlpha: whiteAlpha,
    highContrast: highContrast,
    colorBackground: colorBackground,
    colorSurface: computeColorSurface(gray),
    colorPanelSolid: colorPanelSolid,
    colorPanelTranslucent: colorPanelTranslucent,
    colorOverlay: computeColorOverlay(isDark: isDark),
    shadowStroke: computeShadowStroke(gray, isDark: isDark),
    controlBorder: controlBorder,
    controlTrack: controlTrack,
    accentThumbRing:
        roles?.thumbRing ??
        computeAccentThumbRing(accentRC, controlBorder, surfaces: markSurfaces),
    accentIndicatorContrast: roles != null
        ? accentRC.markContrast ?? computeAccentIndicatorContrast(accentRC)
        : computeAccentIndicatorContrast(accentRC),
    accentContent: accentContent,
    accentContentAlpha:
        roles?.contentAlpha ??
        computeAccentContentAlpha(
          accent,
          content: accentContent,
          page: colorBackground,
          panel: colorPanelSolid,
        ),
    accentRange: roles?.range ?? accentRC.track,
    accentThumb: roles?.thumb ?? _white,
    accentSwatchContrast: roles?.swatchContrast ?? accentRC.contrast,
    focus8:
        roles?.focus ??
        computeFocus8(accent, surfaces: [colorBackground, colorPanelSolid]),
    focusA5: computeFocusA5(accent),
    focusA8: roles?.focus ?? computeFocusA8(accent),
  );
}
