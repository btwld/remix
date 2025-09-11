/// Radix computed tokens – Effective Dart doc comments
///
/// This module implements **functional** / **computed** Radix Themes tokens in
/// Flutter, mirroring Radix Themes behavior without inventing new semantics.
///
/// Why this exists
///  - Radix Themes ships role tokens like `--accent-contrast`, `--accent-track`,
///    `--accent-indicator`, `--accent-surface`, plus backgrounds/overlays.
///  - Those tokens are not just raw scale steps; some are **precomputed** per
///    color scale (e.g., `--{scale}-contrast`) or apply nuanced rules
///    (e.g., dark-mode track color mixes between steps).
///  - Components in your design system (e.g., Button, Slider, Progress, Switch)
///    should consume these **functional roles**, not re-derive logic.
///
/// Where it is used
///  - Used by the token resolver to build a `RadixThemeColors` object consumed
///    across component theming.
///
/// Implementation notes
///  - OKLab mixing is performed via `package:prism` to match CSS
///    `color-mix(in oklab, ...)` behavior used by Radix for some track colors.
///  - Neutral surface baselines match Radix "feel": ~80% white in light,
///    ~50% #212121 in dark. `--accent-surface` is approximated by compositing
///    `accent a3` over those baselines (close to Radix's per-scale constants).
///  - Helpers below use Dart 3 **switch expressions** per Effective Dart.

// ignore_for_file: public_member_api_docs

import 'dart:ui' show Color;

import 'package:prism_flutter/prism_flutter.dart';

import 'colors/colors.dart';
import 'types.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

/// Neutral surface baselines aligned to Radix feel (`--gray-surface`).
const Color _neutralSurfaceLight = Color(0xCCFFFFFF); // ≈80% white
const Color _neutralSurfaceDark = Color(0x80212121); // ≈50% #212121

// Overlay comes from Radix black alpha swatch (a6 light / a8 dark).

// ============================================================================
// SWITCH HELPERS (prefer switches over partial Maps; analyzer-friendly)
// ============================================================================

/// Returns the `--accent-contrast` foreground for the current accent.
///
/// Radix defines per-scale contrast colors: most scales use **white**, while the
/// bright five (**sky, mint, lime, yellow, amber**) use a **near-black** hex for
/// legibility over `--accent-9/10`.
///
/// Referenced by: resolver when computing `accentContrast`.
Color _accentContrastFor(RadixAccentColor accent) => switch (accent) {
      RadixAccentColor.sky => const Color(0xFF1C2024),
      RadixAccentColor.mint => const Color(0xFF1A211E),
      RadixAccentColor.lime => const Color(0xFF1D211C),
      RadixAccentColor.yellow => const Color(0xFF21201C),
      // ignore: no-equal-switch-expression-cases
      RadixAccentColor.amber => const Color(0xFF21201C),
      // ignore: avoid-wildcard-cases-with-enums
      _ => const Color(0xFFFFFFFF),
    };

/// Returns the dark-mode OKLab mix ratio for `--accent-track` if the current
/// accent is one of the "bright five"; otherwise `null` (use step 9 as-is).
///
/// Radix mixes **step8→step9** in dark mode to reduce glare on tracks:
/// - `sky, mint, lime, yellow` use **0.65** towards step 9
/// - `amber` uses **0.75** towards step 9
///
/// Referenced by: resolver when computing `accentTrack`.
double? _darkTrackMixTowards9For(RadixAccentColor accent) => switch (accent) {
      RadixAccentColor.sky ||
      RadixAccentColor.mint ||
      RadixAccentColor.lime ||
      RadixAccentColor.yellow =>
        0.65,
      RadixAccentColor.amber => 0.75,
      // ignore: avoid-wildcard-cases-with-enums
      _ => null,
    };

// ============================================================================
// FUNCTIONAL / COMPUTED IMPLEMENTATIONS
// ============================================================================

/// `--accent-contrast`: readable foreground for text/icons on solid accent
/// backgrounds. Use for Button solid text, Badge solid text, etc.
Color computeAccentContrast(RadixAccentColor accent) =>
    _accentContrastFor(accent);

/// `--accent-indicator`: solid fill for active parts (e.g., Progress indicator,
/// Slider range). Defaults to step **9** in both modes, except **yellow (light)**
/// uses step **10** per Radix tokens.
Color computeAccentIndicator({
  required RadixColorScale accent,
  required RadixAccentColor accentKind,
  required bool isDark,
}) {
  if (!isDark && accentKind == RadixAccentColor.yellow) return accent.step(10);

  return accent.step(9);
}

/// `--accent-track`: rail/track color for Slider/Progress/Switch.
/// - Light: accent **step 9**.
/// - Dark (bright five): OKLab mix of **step8→step9** using the ratio above.
Color computeAccentTrack({
  required RadixColorScale accent,
  required RadixAccentColor accentKind,
  required bool isDark,
}) {
  if (!isDark) return accent.step(9);
  final mix = _darkTrackMixTowards9For(accentKind);
  if (mix == null) return accent.step(9);

  final o8 = accent.step(8).toRayRgb8().toOklab();
  final o9 = accent.step(9).toRayRgb8().toOklab();

  return o8.lerp(o9, mix).toRgb8().toColor();
}

/// `--accent-surface`: tinted accent surface for surface/soft button variants,
/// chips, subtle states. Radix ships per-scale constants; here we approximate by
/// compositing **accent a3** over neutral surface baselines (see constants).
///
/// Referenced by: resolver when computing `accentSurface`.
Color computeAccentSurface({
  required RadixColorScale accent,
  required bool isDark,
}) {
  final base = isDark ? _neutralSurfaceDark : _neutralSurfaceLight;

  return Color.alphaBlend(accent.alphaStep(3), base);
}

/// `--focus-8` and `--focus-a8`: commonly used focus outline colors. In Radix
/// Themes, the focus hue follows the active accent. These helpers expose the
/// conventional step **8** (solid) and **a8** (alpha) for your focus rings.
Color computeFocus8(RadixColorScale accent) => accent.step(8);
Color computeFocusA8(RadixColorScale accent) => accent.alphaStep(8);

// ============================================================================
// BACKGROUND / PANEL / OVERLAY
// ============================================================================

/// `--color-background` = `--gray-1`: page background.
/// Referenced by: resolver when computing `colorBackground`.
Color computeColorBackground(RadixColorScale gray) => gray.step(1);

/// `--color-panel-solid` / `--color-surface` ≈ `--gray-2`: solid panels and
/// input surfaces.
/// Referenced by: resolver when computing `colorPanelSolid`.
Color computeColorPanelSolid(RadixColorScale gray) => gray.step(2);

/// `--color-panel-translucent` = `--gray-a2`: translucent panels.
/// Referenced by: resolver when computing `colorPanelTranslucent`.
Color computeColorPanelTranslucent(RadixColorScale gray) => gray.alphaStep(2);

/// `--color-overlay` = black alpha (a6 light / a8 dark): dialog scrims.
/// Referenced by: resolver when computing `colorOverlay`.
Color computeColorOverlay({required bool isDark}) => isDark
    ? RadixColors.blackAlpha.alphaSwatch[8]!
    : RadixColors.blackAlpha.alphaSwatch[6]!;

/// Neutral control surface baseline used by components (not a direct Radix var,
/// but matches Radix feel for input surfaces and thumb backgrounds).
Color computeNeutralSurface({required bool isDark}) =>
    isDark ? _neutralSurfaceDark : _neutralSurfaceLight;

// ============================================================================
// RESOLVER (merged from resolver.dart)
// ============================================================================

class RadixThemeColors {
  final RadixColorScale accent;
  final RadixColorScale gray;
  final Color colorBackground;
  final Color colorSurface;
  final Color colorPanelSolid;
  final Color colorPanelTranslucent;
  final Color colorOverlay;
  final Color accentContrast;
  final Color accentSurface;
  final Color accentIndicator;
  final Color accentTrack;
  final Color focus8;
  final Color focusA8;

  const RadixThemeColors({
    required this.accent,
    required this.gray,
    required this.colorBackground,
    required this.colorSurface,
    required this.colorPanelSolid,
    required this.colorPanelTranslucent,
    required this.colorOverlay,
    required this.accentContrast,
    required this.accentSurface,
    required this.accentIndicator,
    required this.accentTrack,
    required this.focus8,
    required this.focusA8,
  });
}

typedef _ScalePair = (RadixColors, RadixColors);

const Map<RadixAccentColor, _ScalePair> _accentPairs = {
  RadixAccentColor.amber: (RadixColors.amber, RadixColors.amberDark),
  RadixAccentColor.blue: (RadixColors.blue, RadixColors.blueDark),
  RadixAccentColor.bronze: (RadixColors.bronze, RadixColors.bronzeDark),
  RadixAccentColor.brown: (RadixColors.brown, RadixColors.brownDark),
  RadixAccentColor.crimson: (RadixColors.crimson, RadixColors.crimsonDark),
  RadixAccentColor.cyan: (RadixColors.cyan, RadixColors.cyanDark),
  RadixAccentColor.gold: (RadixColors.gold, RadixColors.goldDark),
  RadixAccentColor.grass: (RadixColors.grass, RadixColors.grassDark),
  RadixAccentColor.green: (RadixColors.green, RadixColors.greenDark),
  RadixAccentColor.indigo: (RadixColors.indigo, RadixColors.indigoDark),
  RadixAccentColor.iris: (RadixColors.iris, RadixColors.irisDark),
  RadixAccentColor.jade: (RadixColors.jade, RadixColors.jadeDark),
  RadixAccentColor.lime: (RadixColors.lime, RadixColors.limeDark),
  RadixAccentColor.mint: (RadixColors.mint, RadixColors.mintDark),
  RadixAccentColor.orange: (RadixColors.orange, RadixColors.orangeDark),
  RadixAccentColor.pink: (RadixColors.pink, RadixColors.pinkDark),
  RadixAccentColor.plum: (RadixColors.plum, RadixColors.plumDark),
  RadixAccentColor.purple: (RadixColors.purple, RadixColors.purpleDark),
  RadixAccentColor.red: (RadixColors.red, RadixColors.redDark),
  RadixAccentColor.ruby: (RadixColors.ruby, RadixColors.rubyDark),
  RadixAccentColor.sky: (RadixColors.sky, RadixColors.skyDark),
  RadixAccentColor.teal: (RadixColors.teal, RadixColors.tealDark),
  RadixAccentColor.tomato: (RadixColors.tomato, RadixColors.tomatoDark),
  RadixAccentColor.violet: (RadixColors.violet, RadixColors.violetDark),
  RadixAccentColor.yellow: (RadixColors.yellow, RadixColors.yellowDark),
  RadixAccentColor.gray: (RadixColors.gray, RadixColors.grayDark),
  RadixAccentColor.mauve: (RadixColors.mauve, RadixColors.mauveDark),
  RadixAccentColor.slate: (RadixColors.slate, RadixColors.slateDark),
  RadixAccentColor.sage: (RadixColors.sage, RadixColors.sageDark),
  RadixAccentColor.olive: (RadixColors.olive, RadixColors.oliveDark),
  RadixAccentColor.sand: (RadixColors.sand, RadixColors.sandDark),
};

const Map<RadixGrayColor, _ScalePair> _grayPairs = {
  RadixGrayColor.gray: (RadixColors.gray, RadixColors.grayDark),
  RadixGrayColor.mauve: (RadixColors.mauve, RadixColors.mauveDark),
  RadixGrayColor.slate: (RadixColors.slate, RadixColors.slateDark),
  RadixGrayColor.sage: (RadixColors.sage, RadixColors.sageDark),
  RadixGrayColor.olive: (RadixColors.olive, RadixColors.oliveDark),
  RadixGrayColor.sand: (RadixColors.sand, RadixColors.sandDark),
};

RadixColorScale _scaleFromPair(_ScalePair pair, bool isDark) {
  final colors = isDark ? pair.$2 : pair.$1;

  return RadixColorScale(colors.swatch, colors.alphaSwatch);
}

RadixColorScale _getAccentScale(RadixAccentColor color, bool isDark) {
  final pair = _accentPairs[color];
  assert(pair != null, 'Unsupported accent color: $color');

  return _scaleFromPair(pair!, isDark);
}

RadixColorScale _getGrayScale(RadixGrayColor color, bool isDark) {
  final pair = _grayPairs[color];
  assert(pair != null, 'Unsupported gray color: $color');

  return _scaleFromPair(pair!, isDark);
}

final Map<String, RadixThemeColors> _resolvedCache = {};

RadixThemeColors resolveRadixTokens(RadixTheme theme) {
  final key =
      '${theme.accent.index}-${theme.gray.index}-${theme.isDark ? 1 : 0}';
  final cached = _resolvedCache[key];
  if (cached != null) return cached;
  final resolved = _buildResolvedColors(theme);
  _resolvedCache[key] = resolved;

  return resolved;
}

RadixThemeColors _buildResolvedColors(RadixTheme theme) {
  final accent = _getAccentScale(theme.accent, theme.isDark);
  final gray = _getGrayScale(theme.gray, theme.isDark);

  final colorBackground = computeColorBackground(gray);
  final colorPanelSolid = computeColorPanelSolid(gray);
  final colorPanelTranslucent = computeColorPanelTranslucent(gray);
  final colorSurface = computeNeutralSurface(isDark: theme.isDark);
  final colorOverlay = computeColorOverlay(isDark: theme.isDark);

  final accentIndicator = computeAccentIndicator(
    accent: accent,
    accentKind: theme.accent,
    isDark: theme.isDark,
  );

  final accentTrack = computeAccentTrack(
    accent: accent,
    accentKind: theme.accent,
    isDark: theme.isDark,
  );

  final accentContrast = computeAccentContrast(theme.accent);
  final accentSurface = computeAccentSurface(
    accent: accent,
    isDark: theme.isDark,
  );

  final Color focus8 = computeFocus8(accent);
  final Color focusA8 = computeFocusA8(accent);

  return RadixThemeColors(
    accent: accent,
    gray: gray,
    colorBackground: colorBackground,
    colorSurface: colorSurface,
    colorPanelSolid: colorPanelSolid,
    colorPanelTranslucent: colorPanelTranslucent,
    colorOverlay: colorOverlay,
    accentContrast: accentContrast,
    accentSurface: accentSurface,
    accentIndicator: accentIndicator,
    accentTrack: accentTrack,
    focus8: focus8,
    focusA8: focusA8,
  );
}
