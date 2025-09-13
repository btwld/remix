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
///  - Role colors (surface, indicator, track, contrast) come directly from
///    the generated RadixColor instances; we do not re-derive them here.
///  - Backgrounds and panels use the selected gray scale (step 1/2), and the
///    translucent panel uses the gray alpha scale (a2).
///  - Modal overlay follows Radix guidance: black alpha a6 (light) / a8 (dark).
///  - Focus colors are derived from the accent scale (8 / a8) for consistency.
///  - OKLab mixing is used only for the shadow stroke helper to match Radix CSS.

// Documentation for all public APIs is provided below

import 'dart:ui' show Color;

import 'package:flutter/painting.dart' show ColorSwatch;
import 'package:prism_flutter/prism_flutter.dart';

import 'colors/colors.dart';

// ============================================================================
// CONSTANTS
// ============================================================================

// Overlay comes from Radix black alpha swatch (a6 light / a8 dark).

// ============================================================================
// SWITCH HELPERS (prefer switches over partial Maps; analyzer-friendly)
// ============================================================================

/// Returns the optimal contrast color for text on solid accent backgrounds.
///
/// **Color Theory:**
/// Most Radix accent colors use white for maximum contrast, but the five
/// "bright" colors (sky, mint, lime, yellow, amber) use carefully chosen
/// near-black colors to ensure readability over their highly saturated
/// solid backgrounds (steps 9-10).
///
/// **Usage in Components:**
/// - Button text on solid accent buttons

// ============================================================================
// GENERIC COLOR MIXING (CSS parity)
// ============================================================================

/// Mixes two colors in OKLab like CSS `color-mix(in oklab, A, B p%)`.
///
/// - [a]: first color (equivalent to CSS A)
/// - [b]: second color (equivalent to CSS B)
/// - [bPercent]: percentage towards [b] (0..100)
Color computeColorMixOklab({
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

/// Computes the optimal contrast foreground color for solid accent backgrounds.
///
/// This is the primary function for determining what color text and icons
/// should be when placed on solid accent backgrounds (typically step 9-10).
///
/// **Use Cases:**
/// - Primary button text color
/// - Badge and chip text color
/// - Icon colors on accent backgrounds
/// - Any content that needs high contrast on accent colors
///

/// Computes solid focus ring color from the accent scale.
///
/// **Accessibility Purpose:**
/// Provides a clear, high-contrast outline for keyboard navigation
/// that follows the app's accent color for brand consistency.
///
/// **Why Step 8:**
/// Step 8 provides optimal contrast for focus rings - prominent enough
/// to be clearly visible but not so intense as to be distracting.
/// It works well against both light and dark backgrounds.
///
/// **Usage:**
/// Apply to focus ring outlines, keyboard navigation indicators,
/// and any UI that needs to show focused state.
///
/// Example:
/// ```dart
/// final focusColor = computeFocus8(accentScale);
/// // Use in focus ring: Style($box.border.color(focusColor))
/// ```
Color computeFocus8(RadixColorScale accent) => accent.step(8);

/// Computes translucent focus ring color from the accent scale.
///
/// **Alternative to Solid Focus:**
/// Provides the same visual weight as [computeFocus8] but with alpha
/// transparency, making it suitable for focus rings that need to work
/// over varying background colors or complex content.
///
/// **Benefits of Alpha Version:**
/// - Works over gradients and images
/// - Doesn't completely obscure background content
/// - Maintains consistent visual weight across different contexts
///
/// Example:
/// ```dart
/// final focusAlpha = computeFocusA8(accentScale);
/// // Use over complex backgrounds: Style($box.border.color(focusAlpha))
/// ```
Color computeFocusA8(RadixColorScale accent) => accent.alphaStep(8);

// ============================================================================
// BACKGROUND / PANEL / OVERLAY
// ============================================================================

/// Computes the primary page background color.
///
/// **Purpose:**
/// The foundational background color for app screens, pages, and large
/// layout areas. Uses gray step 1 to provide subtle warmth and character
/// compared to pure white or black.
///
/// **Color Selection:**
/// Always uses the first step of the chosen gray scale, which provides
/// the most subtle possible gray tint while maintaining excellent
/// readability for content layered on top.
///
/// Example:
/// ```dart
/// final background = computeColorBackground(grayScale);
/// // Use for main app background
/// ```
Color computeColorBackground(RadixColorScale gray) => gray.step(1);

/// Computes solid background color for panels and input surfaces.
///
/// **Purpose:**
/// Provides a distinct background for contained content like cards,
/// modal dialogs, form panels, and input fields. Uses gray step 2
/// to create clear visual separation from the main page background.
///
/// **Usage Guidelines:**
/// - Card and modal backgrounds
/// - Form input field backgrounds
/// - Sidebar and navigation panel backgrounds
/// - Any contained content area
///
/// **Visual Hierarchy:**
/// Step 2 is subtle enough to not compete with content while being
/// distinct enough to clearly separate different interface regions.
///
/// Example:
/// ```dart
/// final panelBg = computeColorPanelSolid(grayScale);
/// // Use for card backgrounds: Style($box.color(panelBg))
/// ```
Color computeColorPanelSolid(RadixColorScale gray) => gray.step(2);

/// Computes translucent background for floating panels and overlays.
///
/// **Purpose:**
/// Creates see-through backgrounds for tooltips, dropdowns, and floating
/// panels that need to show underlying content while still providing
/// visual separation and readability.
///
/// **Alpha Benefits:**
/// - Maintains visual connection to background content
/// - Reduces visual weight compared to solid panels
/// - Works over varying background colors and images
/// - Creates depth and layering effects
///
/// **Use Cases:**
/// - Tooltip backgrounds
/// - Dropdown menu backgrounds
/// - Floating action sheet backgrounds
/// - Contextual overlay panels
///
/// Example:
/// ```dart
/// final translucent = computeColorPanelTranslucent(grayScale);
/// // Use for floating panels: Style($box.color(translucent))
/// ```
Color computeColorPanelTranslucent(RadixColorScale gray) => gray.alphaStep(2);

/// Computes modal backdrop overlay color for dialogs and sheets.
///
/// **Purpose:**
/// Creates the dark, semi-transparent backdrop behind modal dialogs,
/// bottom sheets, and other blocking overlays. This dims the background
/// content and focuses attention on the modal content.
///
/// **Color Selection:**
/// Uses different intensities of black alpha for optimal readability:
/// - Light mode: Black alpha step 6 (lighter dimming)
/// - Dark mode: Black alpha step 8 (stronger dimming)
///
/// **Why Different Steps:**
/// Light backgrounds need less dimming to create focus, while dark
/// backgrounds need stronger dimming to ensure modal content stands out
/// clearly against the backdrop.
///
/// **Accessibility:**
/// Provides sufficient contrast reduction to focus attention while
/// maintaining enough visibility of background content for context.
///
/// Example:
/// ```dart
/// final overlay = computeColorOverlay(isDark: false);
/// // Use for modal backdrop: Style($box.color(overlay))
/// ```
Color computeColorOverlay({required bool isDark}) =>
    isDark ? blackAlpha[8]! : blackAlpha[6]!;

// ============================================================================
// SHADOWS
// ============================================================================

/// Computes the OKLab-mixed shadow stroke color used in Radix shadows.
///
/// Matches: color-mix(in oklab, var(--gray-a6), var(--gray-6) 25%)
Color computeShadowStroke(RadixColorScale gray) =>
    computeColorMixOklab(a: gray.alphaStep(6), b: gray.step(6), bPercent: 25);

// ============================================================================
// RESOLVER (merged from resolver.dart)
// ============================================================================

/// Container for all computed Radix theme colors and scales.
///
/// This class holds the complete resolved color system for a specific
/// theme configuration (accent color + gray + light/dark mode). It contains
/// both the raw color scales and all computed functional colors.
///
/// **Contents:**
/// - **Raw Scales**: accent and gray color scales with all 12 steps
/// - **Background Colors**: page, surface, panel, and overlay colors
/// - **Functional Colors**: computed accent roles (surface, contrast, etc.)
/// - **Focus Colors**: solid and alpha focus ring colors
///
/// **Usage:**
/// This class is created by [resolveRadixTokens] and used internally
/// by the token system. App developers typically don't interact with
/// this directly - instead use [RadixTokens] within a [createRadixScope].
///
/// **Performance:**
/// Results are cached by theme configuration to avoid recomputation.
///
/// Example:
/// ```dart
/// final theme = RadixTheme(accent: RadixAccentColor.blue, isDark: false);
/// final colors = resolveRadixTokens(theme);
///
/// // Access computed colors
/// final buttonColor = colors.accent.solidBackground;
/// final textColor = colors.accentContrast;
/// ```
class RadixThemeColors {
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

  const RadixThemeColors({
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

/// Resolve all computed tokens for a given theme configuration.
RadixThemeColors resolveRadixTokens(dynamic theme) {
  // Pick light/dark RadixColor for accent and neutral using enum .name keys
  final RadixColorTheme accentTheme = _accentThemesByName[theme.accent.name]!;
  final RadixColorTheme grayTheme = _grayThemesByName[theme.gray.name]!;
  final RadixColor accentRC =
      theme.isDark ? accentTheme.dark : accentTheme.light;
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

  return RadixThemeColors(
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
