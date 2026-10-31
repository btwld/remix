/// Fortal's deterministic, dependency-free OKLCH palette generator.
///
/// The color science is OKLab (Björn Ottosson, 2020) and WCAG 2 relative
/// luminance; there is no third-party palette data. All colors are gamut-mapped
/// by reducing chroma, never by clipping hue-changing RGB channels.
library;

import 'dart:math' as math;

const basalt = 0xff13181d;
const limestone = 0xfffaf9f6;

/// Selectable accent seeds. Calçadão, Mar, Sol and Duna keep the refresh brief
/// (2026-10-29) values; the 2026-10-31 palette review set Céu, Serra and Caju.
const fortalSeeds = <String, int>{
  'calcadao': basalt,
  'mar': 0xff036f6b,
  'ceu': 0xff1a95d8,
  'serra': 0xff6f7845,
  'sol': 0xffffcf50,
  'duna': 0xffe5c79a,
  'caju': 0xffe76a32,
};

/// Dedicated error red. It is generated with the accents but is not one of
/// them: error roles read it regardless of the accent or a custom palette.
const fortalErrorSeed = 0xffc92e3b;

/// Curated placement of [fortalErrorSeed]. Its dark mark fill starts at
/// [darkMarkLightness] instead of the accent band, and its labelled solid sits
/// at [solidLightness] in both modes, so destructive marks and actions read as
/// red rather than coral and stay apart from Caju's orange.
const fortalErrorPlacement = (darkMarkLightness: .61, solidLightness: .53);

/// Generation margins over the WCAG 2 thresholds (4.5:1 for labels, 3:1 for
/// marks), so rounding to 8-bit sRGB cannot pull a pair under its threshold.
const contrastMargin = (text: 4.6, mark: 3.05);

/// Dark mark fills start at the seed's OKLCH lightness clamped to this band,
/// then deepen as needed. Unlike a lifted pastel, the band leaves room for
/// white marks and labels.
const darkMarkLightnessRange = (min: .58, max: .72);

/// A seed is luminous when a white label would need its fill darkened by more
/// than this OKLCH lightness to reach [contrastMargin]. Luminous palettes
/// (Sol, Duna and near-white custom seeds) keep their bright fill for labels
/// and marks and take a same-hue dark ink ([onSolidInk]).
const luminousShift = .12;

/// Dark luminous fills keep the seed's OKLCH lightness within these bounds.
const luminousDarkLightnessRange = (min: .70, max: .84);

/// Tint chroma (steps 1–8, 11 and 12) for chromatic seeds: the step weight
/// times the seed's chroma, but at least [floor], so low-chroma seeds such as
/// Mar, Serra and Duna read as their hue instead of gray. Seeds below
/// [achromatic] chroma, and the neutral, keep [baseChromaWeight] on their own
/// chroma.
const tintChroma = (floor: .09, achromatic: .02);
const lightTintWeight = <double>[
  .04,
  .12,
  .22,
  .30,
  .38,
  .48,
  .62,
  .80,
  1,
  1,
  .95,
  .55,
];
const darkTintWeight = <double>[
  .08,
  .22,
  .40,
  .48,
  .55,
  .62,
  .72,
  .85,
  1,
  1,
  .85,
  .45,
];
const baseChromaWeight = <double>[
  .02,
  .04,
  .08,
  .12,
  .16,
  .23,
  .4,
  .7,
  1,
  1,
  .75,
  .35,
];

/// Step 11 (secondary text) of a chromatic seed starts at this OKLCH
/// lightness and moves toward contrast until it keeps [contrastMargin] text
/// contrast on the step-5 tint over the solid panel: the lightest same-hue
/// label that soft, surface, outline and ghost treatments can carry.
const secondaryTextLightness = (light: .52, dark: .82);

/// On-solid ink of luminous palettes. Their label and marks use a tone of the
/// palette's own hue instead of generic basalt: the lightest such tone up to
/// [maxLightness] that keeps the [contrastMargin] text contrast on both the
/// fill and its hover, so Sol and Duna get a visibly coloured brown rather
/// than a near-black. Chroma is [chromaScale] × the seed's, at most
/// [maxChroma], gamut-mapped by chroma reduction. Yellow and sand hues rotate
/// up to [warmHueShift] degrees toward orange so their tone reads warm brown
/// rather than olive. Basalt remains the fallback and the neutral palette's
/// dark ink.
const onSolidInk = (
  maxLightness: .70,
  chromaScale: 1.0,
  maxChroma: .14,
  warmHueShift: 18.0,
);

typedef Oklch = ({double l, double c, double h});

/// One generated appearance. [solid] step 9 and 10 are the mark fill and its
/// pressed step (selected checkbox, radio, switch track, slider range);
/// [fill] and [fillHover] are the labelled solid that carries [contrast].
/// They are equal to steps 9 and 10 wherever one fill serves both.
class GeneratedMode {
  const GeneratedMode(
    this.solid,
    this.alpha,
    this.contrast, {
    required this.fill,
    required this.fillHover,
  });

  final List<int> solid;
  final List<int> alpha;
  final int contrast;
  final int fill;
  final int fillHover;
  int get surface => alpha[2];
  int get indicator => solid[8];
  int get track => solid[8];
}

class GeneratedPalette {
  const GeneratedPalette(this.light, this.dark);

  final GeneratedMode light;
  final GeneratedMode dark;
}

/// Generates both appearances of [seed].
///
/// Non-luminous palettes split their solid roles. The mark fill keeps the seed
/// where white marks and the page keep 3:1, and otherwise deepens just enough.
/// The labelled solid deepens further only as far as a white label needs on it
/// and on its hover. Luminous palettes keep one bright fill for both with a
/// same-hue ink, and [neutral] inverts basalt and limestone. Fill-to-page
/// contrast is guaranteed for non-luminous mark fills only; use high-contrast
/// recipes or an explicit step-8 border when a very light seed needs a visible
/// boundary.
///
/// [darkMarkLightness] and [solidLightness] replace the default placement for
/// a curated semantic palette.
GeneratedPalette generatePalette(
  int seed, {
  bool neutral = false,
  double? darkMarkLightness,
  double? solidLightness,
}) {
  final luminous = !neutral && _isLuminous(seed);
  GeneratedMode mode({required bool dark}) => _generateMode(
    seed,
    dark: dark,
    neutral: neutral,
    luminous: luminous,
    darkMarkLightness: darkMarkLightness,
    solidLightness: solidLightness,
  );
  return GeneratedPalette(mode(dark: false), mode(dark: true));
}

/// Generates [fortalErrorSeed] with its curated placement.
GeneratedPalette generateErrorPalette() => generatePalette(
  fortalErrorSeed,
  darkMarkLightness: fortalErrorPlacement.darkMarkLightness,
  solidLightness: fortalErrorPlacement.solidLightness,
);

const _white = 0xffffffff;

/// Whether a white label would need more than [luminousShift] of darkening.
bool _isLuminous(int seed) {
  final brand = toOklch(seed);
  final chroma = brand.c.clamp(.035, .22).toDouble();
  var l = brand.l;
  int at(double lightness) =>
      fromOklch((l: lightness.clamp(0, 1), c: chroma, h: brand.h));
  while (l > 0 &&
      (_ratio(_white, at(l)) < contrastMargin.text ||
          _ratio(_white, at(l - .035)) < contrastMargin.text)) {
    l -= .002;
  }
  return brand.l - l > luminousShift;
}

/// The neutral page (step 1) or solid panel (step 2) of either appearance.
int neutralSurface(int step, {required bool dark}) {
  final lightness = dark ? [.19, .225] : [.985, .97];
  return fromOklch((
    l: lightness[step - 1],
    c: dark ? .012 * baseChromaWeight[step - 1] : .004,
    h: dark ? toOklch(basalt).h : 90,
  ));
}

GeneratedMode _generateMode(
  int seed, {
  required bool dark,
  required bool neutral,
  required bool luminous,
  double? darkMarkLightness,
  double? solidLightness,
}) {
  final brand = toOklch(seed);
  final page = neutralSurface(1, dark: dark);
  final panel = neutralSurface(2, dark: dark);
  final chromatic = !neutral && brand.c >= tintChroma.achromatic;
  final chroma = neutral ? .012 : brand.c.clamp(.035, .22).toDouble();
  final tint = chromatic ? math.max(chroma, tintChroma.floor) : chroma;
  final weights = !chromatic
      ? baseChromaWeight
      : dark
      ? darkTintWeight
      : lightTintWeight;
  // Common lightness by role. Steps 9 and 10 are placed below; step 11 of a
  // chromatic seed is fitted.
  final lightness = dark
      ? <double>[.19, .225, .27, .305, .34, .39, .46, .64, .70, .74, .84, .97]
      : <double>[.985, .97, .94, .915, .89, .84, .76, .62, .5, .5, .40, .22];
  Oklch tone(double l, int index) => (
    l: l,
    c: neutral && !dark && index < 8 ? .004 : tint * weights[index],
    h: neutral && !dark && index < 8 ? 90 : brand.h,
  );
  final solid = <int>[
    for (var i = 0; i < 12; i++) fromOklch(tone(lightness[i], i)),
  ];

  late int fill, fillHover, contrast;
  if (neutral || luminous) {
    // One bright (or inverted neutral) fill for labels and marks, fitted to
    // its ink like the seed-led solids it has always been.
    final start = dark
        ? brand.l
              .clamp(
                luminousDarkLightnessRange.min,
                luminousDarkLightnessRange.max,
              )
              .toDouble()
        : brand.l;
    solid[8] = neutral && dark
        ? limestone
        : dark
        ? fromOklch((l: start, c: chroma, h: brand.h))
        : seed;
    final onSolid = _ratio(_white, solid[8]) >= _ratio(basalt, solid[8])
        ? _white
        : basalt;
    final seedLightness = toOklch(solid[8]).l;
    for (final index in [8, 9]) {
      var l = seedLightness + (index == 9 ? (dark ? .035 : -.035) : 0);
      if (!(index == 8 && (!dark || neutral))) {
        solid[index] = fromOklch((l: l.clamp(0, 1), c: chroma, h: brand.h));
      }
      // Basalt rather than pure black leaves a small luminance interval in
      // which neither foreground passes. Move out of it deterministically.
      for (
        var attempt = 0;
        _ratio(onSolid, solid[index]) < contrastMargin.text;
        attempt++
      ) {
        if (attempt > 1000) throw StateError('Cannot fit solid contrast');
        l += onSolid == _white ? -.002 : .002;
        solid[index] = fromOklch((l: l.clamp(0, 1), c: chroma, h: brand.h));
      }
    }
    fill = solid[8];
    fillHover = solid[9];
    contrast = onSolid == _white || neutral
        ? onSolid
        : deepInk(seed, fill: fill, hover: fillHover);
  } else {
    // Mark fill: the exact seed in light mode when it qualifies; otherwise the
    // seed's hue and chroma, deepened until white marks, the page and the
    // solid panel all keep the mark margin. Its pressed step is deeper still.
    int at(double l) => !dark && l == brand.l
        ? seed
        : fromOklch((l: l.clamp(0, 1), c: chroma, h: brand.h));
    bool marks(int fill) => [
      _white,
      page,
      panel,
    ].every((other) => _ratio(fill, other) >= contrastMargin.mark);
    var markLightness = dark
        ? (darkMarkLightness ??
              brand.l
                  .clamp(darkMarkLightnessRange.min, darkMarkLightnessRange.max)
                  .toDouble())
        : brand.l;
    for (var attempt = 0; !marks(at(markLightness)); attempt++) {
      if (attempt > 1000) throw StateError('Cannot fit mark fill');
      markLightness -= .002;
    }
    solid[8] = at(markLightness);
    solid[9] = at(markLightness - .035);
    // Labelled solid: from the mark (or a curated placement), deepened until
    // white keeps the text margin on the fill and on its hover.
    var l = math.min(markLightness, solidLightness ?? markLightness);
    for (
      var attempt = 0;
      _ratio(_white, at(l)) < contrastMargin.text ||
          _ratio(_white, at(l - .035)) < contrastMargin.text;
      attempt++
    ) {
      if (attempt > 1000) throw StateError('Cannot fit labelled solid');
      l -= .002;
    }
    fill = at(l);
    fillHover = at(l - .035);
    contrast = _white;
  }

  if (chromatic) {
    // The lightest step 11 that keeps the text margin on the panel and on the
    // pressed soft tint composited over it.
    final tintOverPanel = _over(transparentOver(solid[4], page), panel);
    var l = dark ? secondaryTextLightness.dark : secondaryTextLightness.light;
    for (var attempt = 0; ; attempt++) {
      if (attempt > 1000) throw StateError('Cannot fit secondary text');
      final candidate = fromOklch(tone(l, 10));
      if (_ratio(candidate, tintOverPanel) >= contrastMargin.text &&
          _ratio(candidate, panel) >= contrastMargin.text) {
        solid[10] = candidate;
        break;
      }
      l += dark ? .002 : -.002;
    }
  }

  return GeneratedMode(
    List.unmodifiable(solid),
    List.unmodifiable([
      for (final color in solid) transparentOver(color, page),
    ]),
    contrast,
    fill: fill,
    fillHover: fillHover,
  );
}

/// The [onSolidInk] for a luminous palette whose fitted fill and hover take a
/// dark label. Deterministic: lightness descends in 0.002 steps from the cap
/// to basalt's lightness; basalt is returned if no family tone qualifies.
int deepInk(int seed, {required int fill, required int hover}) {
  final brand = toOklch(seed);
  final hue = brand.h * 180 / math.pi % 360;
  // Full rotation at yellow (85°), tapering to none at 55° and 115°.
  final warmth = (1 - ((hue - 85).abs() / 30)).clamp(0, 1);
  final inkHue = (hue - onSolidInk.warmHueShift * warmth) * math.pi / 180;
  final chroma = math.min(
    brand.c * onSolidInk.chromaScale,
    onSolidInk.maxChroma,
  );
  final floor = toOklch(basalt).l;
  for (var step = 0; ; step++) {
    final l = onSolidInk.maxLightness - step * .002;
    if (l < floor) return basalt;
    final ink = fromOklch((l: l, c: chroma, h: inkHue));
    if (_ratio(ink, fill) >= contrastMargin.text &&
        _ratio(ink, hover) >= contrastMargin.text) {
      return ink;
    }
  }
}

/// Composites [color] (with alpha) over an opaque [background].
int _over(int color, int background) {
  final a = (color >> 24 & 255) / 255;
  final fg = _channels(color);
  final bg = _channels(background);
  return 0xff000000 |
      _byte(fg[0] * a + bg[0] * (1 - a)) << 16 |
      _byte(fg[1] * a + bg[1] * (1 - a)) << 8 |
      _byte(fg[2] * a + bg[2] * (1 - a));
}

/// Minimal-alpha sRGB source that reconstructs [solid] over [background].
int transparentOver(int solid, int background) {
  final target = _channels(solid);
  final base = _channels(background);
  var opacity = 0.0;
  for (var i = 0; i < 3; i++) {
    final delta = target[i] - base[i];
    final available = delta < 0 ? base[i] : 1 - base[i];
    if (available > 0) opacity = math.max(opacity, delta.abs() / available);
  }
  final alpha = (opacity * 255).ceil().clamp(0, 255);
  if (alpha == 0) return 0;
  final a = alpha / 255;
  return alpha << 24 |
      _byte((target[0] - base[0] * (1 - a)) / a) << 16 |
      _byte((target[1] - base[1] * (1 - a)) / a) << 8 |
      _byte((target[2] - base[2] * (1 - a)) / a);
}

Oklch toOklch(int color) {
  final rgb = _channels(color).map(_linear).toList();
  final l = _cbrt(
    .4122214708 * rgb[0] + .5363325363 * rgb[1] + .0514459929 * rgb[2],
  );
  final m = _cbrt(
    .2119034982 * rgb[0] + .6806995451 * rgb[1] + .1073969566 * rgb[2],
  );
  final s = _cbrt(
    .0883024619 * rgb[0] + .2817188376 * rgb[1] + .6299787005 * rgb[2],
  );
  final a = 1.9779984951 * l - 2.4285922050 * m + .4505937099 * s;
  final b = .0259040371 * l + .7827717662 * m - .8086757660 * s;
  return (
    l: .2104542553 * l + .7936177850 * m - .0040720468 * s,
    c: math.sqrt(a * a + b * b),
    h: math.atan2(b, a),
  );
}

int fromOklch(Oklch color) {
  var low = 0.0;
  var high = color.c;
  var rgb = _rgb(color);
  if (!_inGamut(rgb)) {
    for (var iteration = 0; iteration < 28; iteration++) {
      final c = (low + high) / 2;
      final candidate = _rgb((l: color.l, c: c, h: color.h));
      if (_inGamut(candidate)) {
        low = c;
        rgb = candidate;
      } else {
        high = c;
      }
    }
  }
  return 0xff000000 |
      _byte(_encoded(rgb[0])) << 16 |
      _byte(_encoded(rgb[1])) << 8 |
      _byte(_encoded(rgb[2]));
}

List<double> _rgb(Oklch color) {
  final a = color.c * math.cos(color.h);
  final b = color.c * math.sin(color.h);
  final l = _cube(color.l + .3963377774 * a + .2158037573 * b);
  final m = _cube(color.l - .1055613458 * a - .0638541728 * b);
  final s = _cube(color.l - .0894841775 * a - 1.2914855480 * b);
  return [
    4.0767416621 * l - 3.3077115913 * m + .2309699292 * s,
    -1.2684380046 * l + 2.6097574011 * m - .3413193965 * s,
    -.0041960863 * l - .7034186147 * m + 1.7076147010 * s,
  ];
}

bool _inGamut(List<double> rgb) =>
    rgb.every((v) => v >= -1e-8 && v <= 1.00000001);
List<double> _channels(int rgb) => [
  for (final shift in [16, 8, 0]) ((rgb >> shift) & 255) / 255,
];
double _linear(double c) =>
    c <= .04045 ? c / 12.92 : math.pow((c + .055) / 1.055, 2.4).toDouble();
double _encoded(double c) =>
    c <= .0031308 ? 12.92 * c : 1.055 * math.pow(c, 1 / 2.4) - .055;
double _cbrt(double v) => math.pow(v, 1 / 3).toDouble();
double _cube(double v) => v * v * v;
int _byte(num v) => (v * 255).round().clamp(0, 255);
double _luminance(int rgb) {
  final c = _channels(rgb).map(_linear).toList();
  return .2126 * c[0] + .7152 * c[1] + .0722 * c[2];
}

double _ratio(int first, int second) {
  final a = _luminance(first);
  final b = _luminance(second);
  return (math.max(a, b) + .05) / (math.min(a, b) + .05);
}
