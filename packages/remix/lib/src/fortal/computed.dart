/// Fortal computed tokens and functional color utilities.
///
/// Implements computed role tokens (accent-contrast, accent-track, etc.) and
/// background/overlay colors that mirror Radix Themes behavior while keeping the
/// original Radix Colors data.
///
/// Components should use these functional roles rather than raw color steps.

// Documentation for all public APIs is provided below

import 'dart:ui' show Color;

import 'package:flutter/painting.dart' show ColorSwatch;
import 'package:prism_flutter/prism_flutter.dart';

import '../radix/colors/colors.dart';
import 'fortal_theme.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

// Overlay comes from Radix black alpha swatch (a6 light / a8 dark).

// ============================================================================
// SWITCH HELPERS (prefer switches over partial Maps; analyzer-friendly)
// ============================================================================

/// Returns optimal contrast color for text on solid accent backgrounds.
///
/// Most colors use white; bright colors (sky, mint, lime, yellow, amber)
/// use near-black for better readability.

// ============================================================================
// GENERIC COLOR MIXING (CSS parity)
// ============================================================================

/// Mixes two colors in OKLab like CSS `color-mix(in oklab, A, B p%)`.
Color _computeColorMixOklab({
  required Color a,
  required Color b,
  required double bPercent,
}) {
  final t = (bPercent.isNaN ? 0.0 : bPercent).clamp(0.0, 100.0) / 100.0;
  final oa = a.toRayRgb8().toOklab();
  final ob = b.toRayRgb8().toOklab();

  return oa.lerp(ob, t).toRgb8().toColor();
}

// ============================================================================
// FUNCTIONAL / COMPUTED IMPLEMENTATIONS
// ============================================================================

/// Computes contrast foreground color for solid accent backgrounds.
///

/// Computes solid focus ring color (accent step 8).
Color computeFocus8(RadixColorScale accent) => accent.step(8);

/// Computes translucent focus ring color (accent alpha step 8).
Color computeFocusA8(RadixColorScale accent) => accent.alphaStep(8);

// ============================================================================
// BACKGROUND / PANEL / OVERLAY
// ============================================================================

/// Computes primary page background color (gray step 1).
Color computeColorBackground(RadixColorScale gray) => gray.step(1);

/// Computes solid background for panels and input surfaces (gray step 2).
Color computeColorPanelSolid(RadixColorScale gray) => gray.step(2);

/// Computes translucent background for floating panels (gray alpha step 2).
Color computeColorPanelTranslucent(RadixColorScale gray) => gray.alphaStep(2);

/// Computes modal backdrop overlay color.
///
/// Uses black alpha step 6 (light mode) or step 8 (dark mode).
Color computeColorOverlay({required bool isDark}) =>
    isDark ? blackAlpha[8]! : blackAlpha[6]!;

// ============================================================================
// SHADOWS
// ============================================================================

/// Computes the OKLab-mixed shadow stroke color used in Fortal shadows.
///
/// Matches: color-mix(in oklab, var(--gray-a6), var(--gray-6) 25%)
Color computeShadowStroke(RadixColorScale gray) =>
    _computeColorMixOklab(a: gray.alphaStep(6), b: gray.step(6), bPercent: 25);

// ============================================================================
// RESOLVER (merged from resolver.dart)
// ============================================================================

/// Container for all computed Fortal theme colors and scales.
///
/// Holds resolved color system for a specific theme configuration.
/// Created by [resolveFortalTokens] for internal use by the token system.
class FortalThemeColors {
  final RadixColor accent;
  final RadixColor gray;
  final ColorSwatch<int> blackAlpha;
  final ColorSwatch<int> whiteAlpha;

  // Functional colors
  final Color colorBackground;
  final Color colorSurface;
  final Color colorPanelSolid;
  final Color colorPanelTranslucent;
  final Color colorOverlay;

  // Focus
  final Color focus8;
  final Color focusA8;

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
    required this.focus8,
    required this.focusA8,
  });
}

// Map by enum .name to generated RadixColorTheme instances (light/dark contained).
const Map<String, RadixColorTheme> _accentThemesByName = {
  'amber': amber,
  'blue': blue,
  'bronze': bronze,
  'brown': brown,
  'crimson': crimson,
  'cyan': cyan,
  'gold': gold,
  'grass': grass,
  'green': green,
  'indigo': indigo,
  'iris': iris,
  'jade': jade,
  'lime': lime,
  'mint': mint,
  'orange': orange,
  'pink': pink,
  'plum': plum,
  'purple': purple,
  'red': red,
  'ruby': ruby,
  'sky': sky,
  'teal': teal,
  'tomato': tomato,
  'violet': violet,
  'yellow': yellow,
  // neutrals also exist as accent enums for convenience
  'gray': gray,
  'mauve': mauve,
  'slate': slate,
  'sage': sage,
  'olive': olive,
  'sand': sand,
};

const Map<String, RadixColorTheme> _grayThemesByName = {
  'gray': gray,
  'mauve': mauve,
  'slate': slate,
  'sage': sage,
  'olive': olive,
  'sand': sand,
};

/// Resolves all computed tokens for a theme configuration.
FortalThemeColors resolveFortalTokens(FortalThemeConfig theme) {
  // Pick light/dark RadixColor for accent and neutral using enum .name keys
  final String accentName = theme.accent.name;
  final String grayName = theme.gray.name;
  final RadixColorTheme accentTheme = _accentThemesByName[accentName]!;
  final RadixColorTheme grayTheme = _grayThemesByName[grayName]!;
  final RadixColor accentRC = theme.isDark
      ? accentTheme.dark
      : accentTheme.light;
  final RadixColor grayRC = theme.isDark ? grayTheme.dark : grayTheme.light;

  // Extract scales
  final RadixColorScale accent = accentRC.scale;
  final RadixColorScale gray = grayRC.scale;

  // Neutral alpha swatches
  final ColorSwatch<int> blackA = blackAlpha;
  final ColorSwatch<int> whiteA = whiteAlpha;

  // Backgrounds/panels/overlay
  final Color colorBackground = computeColorBackground(gray);
  final Color colorPanelSolid = computeColorPanelSolid(gray);
  final Color colorPanelTranslucent = computeColorPanelTranslucent(gray);
  final Color colorSurface = grayRC.surface;
  final Color colorOverlay = computeColorOverlay(isDark: theme.isDark);

  // Focus
  final Color focus8 = computeFocus8(accent);
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
    focus8: focus8,
    focusA8: focusA8,
  );
}
