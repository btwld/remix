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

// Documentation for all public APIs is provided below

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
/// - Badge text on solid accent badges
/// - Any foreground content over solid accent backgrounds
///
/// Example:
/// ```dart
/// // White for most colors
/// _accentContrastFor(RadixAccentColor.blue)  // → #FFFFFF
///
/// // Near-black for bright colors
/// _accentContrastFor(RadixAccentColor.lime)  // → #1D211C
/// ```
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

/// Returns the OKLab color mixing ratio for dark mode track colors.
///
/// **Visual Problem Solved:**
/// Bright accent colors (sky, mint, lime, yellow, amber) can cause visual
/// glare in dark mode when used at full intensity for slider tracks and
/// progress bar backgrounds. This function provides mixing ratios to
/// tone down these colors.
///
/// **Color Science:**
/// Uses OKLab color space for perceptually uniform color mixing,
/// blending between step 8 (less intense) and step 9 (full intensity)
/// to create more comfortable viewing experiences.
///
/// **Mix Ratios:**
/// - sky, mint, lime, yellow: 65% towards step 9 (more conservative)
/// - amber: 75% towards step 9 (slightly more intense)
/// - all other colors: null (use step 9 unchanged)
///
/// Returns null for non-bright colors, indicating no mixing is needed.
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
/// **Accessibility:**
/// All returned colors meet or exceed WCAG contrast requirements
/// for normal text on their respective accent backgrounds.
///
/// Example:
/// ```dart
/// final contrast = computeAccentContrast(RadixAccentColor.blue);
/// // Use for button text: Style($text.color(contrast))
/// ```
Color computeAccentContrast(RadixAccentColor accent) =>
    _accentContrastFor(accent);

/// Computes the solid color for active indicators and progress elements.
///
/// **Purpose:**
/// This color represents "progress" or "active state" in range controls
/// like sliders, progress bars, and toggle switches. It's typically the
/// most prominent accent color in these components.
///
/// **Color Selection Logic:**
/// - Most colors: Use step 9 (primary solid accent)
/// - Yellow in light mode: Use step 10 for better contrast
/// - All dark mode: Use step 9 consistently
///
/// **Special Case - Yellow:**
/// Yellow step 9 can be difficult to see against light backgrounds,
/// so light mode uses the slightly darker step 10 for better visibility.
///
/// Example usage:
/// ```dart
/// // Progress bar fill
/// final indicatorColor = computeAccentIndicator(
///   accent: accentScale,
///   accentKind: RadixAccentColor.blue,
///   isDark: false,
/// );
/// ```
Color computeAccentIndicator({
  required RadixColorScale accent,
  required RadixAccentColor accentKind,
  required bool isDark,
}) {
  if (!isDark && accentKind == RadixAccentColor.yellow) return accent.step(10);

  return accent.step(9);
}

/// Computes the background track color for range controls.
///
/// **Purpose:**
/// This color serves as the background "rail" or "track" behind indicators
/// in sliders, progress bars, and similar range controls. It should be
/// visible but not competing with the indicator for attention.
///
/// **Algorithm:**
/// - **Light mode**: Always uses step 9 (solid accent)
/// - **Dark mode (normal colors)**: Uses step 9
/// - **Dark mode (bright colors)**: Mixes step 8 and 9 using OKLab color space
///
/// **Why OKLab Mixing:**
/// Bright colors can cause eye strain in dark environments. By mixing
/// step 8 (less intense) with step 9 (full intensity), we create more
/// comfortable viewing while maintaining brand recognition.
///
/// The mixing ratios are carefully chosen based on each color's perceptual
/// intensity and user testing feedback from the Radix team.
///
/// Example:
/// ```dart
/// // Slider track background
/// final trackColor = computeAccentTrack(
///   accent: accentScale,
///   accentKind: RadixAccentColor.lime,  // Bright color
///   isDark: true,  // Will use OKLab mixing
/// );
/// ```
Color computeAccentTrack({
  required RadixColorScale accent,
  required RadixAccentColor accentKind,
  required bool isDark,
}) {
  if (!isDark) return accent.step(9);
  final mix = _darkTrackMixTowards9For(accentKind);
  if (mix == null) return accent.step(9);

  return computeColorMixOklab(
    a: accent.step(8),
    b: accent.step(9),
    bPercent: mix * 100.0,
  );
}

/// Computes a subtle accent-tinted surface for soft interactive elements.
///
/// **Purpose:**
/// Creates lightly branded backgrounds for "soft" or "ghost" button variants,
/// chips, hover states, and other elements that need accent color context
/// without being too prominent or attention-grabbing.
///
/// **Algorithm:**
/// Uses alpha blending to composite accent alpha step 3 over carefully
/// chosen neutral surface baselines. This maintains the accent color's
/// character while keeping it subtle enough for comfortable viewing.
///
/// **Surface Baselines:**
/// - Light mode: ~80% white (Color(0xCCFFFFFF))
/// - Dark mode: ~50% of #212121 (Color(0x80212121))
///
/// These baselines are chosen to match Radix's neutral surface feeling
/// while providing good contrast for text and other content.
///
/// **Use Cases:**
/// - Ghost button backgrounds
/// - Chip and tag backgrounds
/// - Hover states for subtle interactions
/// - Table row highlights
///
/// Example:
/// ```dart
/// final surface = computeAccentSurface(
///   accent: accentScale,
///   isDark: false,
/// );
/// // Use for: Style($box.color(surface))
/// ```
Color computeAccentSurface({
  required RadixColorScale accent,
  required bool isDark,
}) {
  final base = isDark ? _neutralSurfaceDark : _neutralSurfaceLight;

  return Color.alphaBlend(accent.alphaStep(3), base);
}

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
Color computeColorOverlay({required bool isDark}) => isDark
    ? RadixColors.blackAlpha.alphaSwatch[8]!
    : RadixColors.blackAlpha.alphaSwatch[6]!;

/// Computes the neutral control surface color for component internals.
///
/// **Purpose:**
/// Provides the baseline surface color for component elements like
/// slider thumbs, switch toggles, input field backgrounds, and other
/// interactive control surfaces that need to feel neutral and tactile.
///
/// **Color Values:**
/// - Light mode: ~80% white opacity (creates soft, lifted feeling)
/// - Dark mode: ~50% of #212121 (provides subtle contrast in dark themes)
///
/// **Design Intent:**
/// These colors are specifically chosen to feel like physical, touchable
/// surfaces that users can interact with. They provide enough contrast
/// to be clearly interactive while remaining neutral enough to work
/// with any accent color.
///
/// **Usage:**
/// Internal component styling - not typically used directly in app code.
///
/// Example:
/// ```dart
/// final surface = computeNeutralSurface(isDark: true);
/// // Used internally by slider thumb styling
/// ```
Color computeNeutralSurface({required bool isDark}) =>
    isDark ? _neutralSurfaceDark : _neutralSurfaceLight;

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
  final RadixColorScale accent;
  final RadixColorScale gray;
  final RadixColorScale blackAlpha;
  final RadixColorScale whiteAlpha;
  // Gray (neutral) role colors to mirror generated JSON roles
  final Color graySurface; // neutral surface baseline
  final Color grayIndicator; // usually gray.step(9)
  final Color grayTrack; // usually gray.step(9)
  final Color grayContrast; // usually white
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
  // Neutral helpers for shadows
  final Color grayA6;
  final Color blackA3;
  final Color blackA4;
  final Color blackA5;
  final Color blackA6;
  final Color blackA7;
  final Color blackA11;
  final Color shadowStroke;

  const RadixThemeColors({
    required this.accent,
    required this.gray,
    required this.blackAlpha,
    required this.whiteAlpha,
    required this.graySurface,
    required this.grayIndicator,
    required this.grayTrack,
    required this.grayContrast,
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
    required this.grayA6,
    required this.blackA3,
    required this.blackA4,
    required this.blackA5,
    required this.blackA6,
    required this.blackA7,
    required this.blackA11,
    required this.shadowStroke,
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

  // Neutral helpers for shadows
  final Color grayA6 = gray.alphaStep(6);
  final Color blackA3 = RadixColors.blackAlpha.alphaSwatch[3]!;
  final Color blackA4 = RadixColors.blackAlpha.alphaSwatch[4]!;
  final Color blackA5 = RadixColors.blackAlpha.alphaSwatch[5]!;
  final Color blackA6 = RadixColors.blackAlpha.alphaSwatch[6]!;
  final Color blackA7 = RadixColors.blackAlpha.alphaSwatch[7]!;
  final Color blackA11 = RadixColors.blackAlpha.alphaSwatch[11]!;
  final Color shadowStroke = computeShadowStroke(gray);

  // Gray role colors (mirroring JSON roles for gray scale)
  final Color roleGraySurface = computeNeutralSurface(isDark: theme.isDark);
  final Color roleGrayIndicator = gray.step(9);
  final Color roleGrayTrack = gray.step(9);
  final Color roleGrayContrast = const Color(0xFFFFFFFF);

  return RadixThemeColors(
    accent = accent,
    gray = gray,
    blackAlpha = blackA,
    whiteAlpha = whiteA,
    graySurface = roleGraySurface,
    grayIndicator = roleGrayIndicator,
    grayTrack = roleGrayTrack,
    grayContrast = roleGrayContrast,
    colorBackground = colorBackground,
    colorSurface = colorSurface,
    colorPanelSolid = colorPanelSolid,
    colorPanelTranslucent = colorPanelTranslucent,
    colorOverlay = colorOverlay,
    accentContrast = accentContrast,
    accentSurface = accentSurface,
    accentIndicator = accentIndicator,
    accentTrack = accentTrack,
    focus8 = focus8,
    focusA8 = focusA8,
    // Shadow helpers
    grayA6 = grayA6,
    blackA3 = blackA3,
    blackA4 = blackA4,
    blackA5 = blackA5,
    blackA6 = blackA6,
    blackA7 = blackA7,
    blackA11 = blackA11,
    shadowStroke = shadowStroke,
  );
}
