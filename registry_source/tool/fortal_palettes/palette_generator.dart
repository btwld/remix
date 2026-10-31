/// Fortal's deterministic, dependency-free OKLCH palette generator.
///
/// The color science is OKLab (Björn Ottosson, 2020) and WCAG 2 relative
/// luminance; there is no third-party palette data. All colors are gamut-mapped
/// by reducing chroma, never by clipping hue-changing RGB channels.
library;

import 'dart:math' as math;

const basalt = 0xff13181d;
const limestone = 0xfffaf9f6;

/// Original design seeds from the Fortal refresh brief, 2026-10-29.
const fortalSeeds = <String, int>{
  'calcadao': basalt,
  'mar': 0xff036f6b,
  'ceu': 0xff006ebe,
  'mangue': 0xff1d7d3e,
  'sol': 0xffffcf50,
  'duna': 0xffe5c79a,
  'caju': 0xffcb4333,
};

typedef Oklch = ({double l, double c, double h});

class GeneratedMode {
  const GeneratedMode(this.solid, this.alpha, this.contrast);

  final List<int> solid;
  final List<int> alpha;
  final int contrast;
  int get surface => alpha[2];
  int get indicator => solid[8];
  int get track => solid[8];
}

class GeneratedPalette {
  const GeneratedPalette(this.light, this.dark);

  final GeneratedMode light;
  final GeneratedMode dark;
}

/// Preserves seed-led light fills when their label passes contrast.
/// Fill-to-page contrast is not guaranteed; use high-contrast recipes or an
/// explicit step-8 border when very light seeds need a visible boundary.
GeneratedPalette generatePalette(int seed, {bool neutral = false}) =>
    GeneratedPalette(
      _generateMode(seed, dark: false, neutral: neutral),
      _generateMode(seed, dark: true, neutral: neutral),
    );

GeneratedMode _generateMode(
  int seed, {
  required bool dark,
  required bool neutral,
}) {
  final brand = toOklch(seed);
  // Common lightness by role, except the seed-led solid/hover pair. Keeping
  // Sol yellow and Calçadão basalt is intentional: equal solid lightness would
  // turn both into midtones. Text/border contrast is checked after quantizing.
  final lightness = dark
      ? <double>[.19, .225, .27, .305, .34, .39, .46, .64, .70, .74, .84, .97]
      : <double>[
          .985,
          .97,
          .94,
          .915,
          .89,
          .84,
          .76,
          .62,
          brand.l,
          brand.l,
          .40,
          .22,
        ];
  const chromaWeight = <double>[
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
  final chroma = neutral ? .012 : brand.c.clamp(.035, .22).toDouble();
  final solid = <int>[
    for (var i = 0; i < 12; i++)
      fromOklch((
        l: lightness[i],
        c: neutral && !dark && i < 8 ? .004 : chroma * chromaWeight[i],
        h: neutral && !dark && i < 8 ? 90 : brand.h,
      )),
  ];
  // Retain the exact seed for light solid fills whenever it passes contrast.
  solid[8] = neutral && dark
      ? limestone
      : dark
      ? solid[8]
      : seed;
  final white = 0xffffffff;
  final onSolid = _ratio(white, solid[8]) >= _ratio(basalt, solid[8])
      ? white
      : basalt;
  final seedLightness = toOklch(solid[8]).l;
  for (final index in [8, 9]) {
    var l = seedLightness + (index == 9 ? (dark ? .035 : -.035) : 0);
    if (!(index == 8 && (!dark || neutral))) {
      solid[index] = fromOklch((l: l.clamp(0, 1), c: chroma, h: brand.h));
    }
    // Basalt rather than pure black leaves a small luminance interval in
    // which neither foreground passes. Move out of it deterministically.
    for (var attempt = 0; _ratio(onSolid, solid[index]) < 4.6; attempt++) {
      if (attempt > 1000) throw StateError('Cannot fit solid contrast');
      l += onSolid == white ? -.002 : .002;
      solid[index] = fromOklch((l: l.clamp(0, 1), c: chroma, h: brand.h));
    }
  }
  final page = fromOklch((
    l: dark ? .19 : .985,
    c: dark ? .00024 : .004,
    h: dark ? toOklch(basalt).h : 90,
  ));
  return GeneratedMode(
    List.unmodifiable(solid),
    List.unmodifiable([
      for (final color in solid) transparentOver(color, page),
    ]),
    onSolid,
  );
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
