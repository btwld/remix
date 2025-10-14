// Fortal theme: tokens + MixScope builder in one place.

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'computed.dart';

// OKLab mixing lives in computed.dart; no direct dependency here.

/// Design tokens for the Fortal UI system (powered by Radix Colors).
///
/// Provides color scales (12-step accent/gray), spacing (9-step), radius (6-step),
/// shadows (6-level), typography (9-size), and functional colors.
///
/// Example:
/// ```dart
/// Style(
///   $box.color.ref(FortalTokens.accent9),
///   $text.style.ref(FortalTokens.text3),
///   $box.padding.ref(FortalTokens.space4),
/// )
/// ```
///
/// Must be used within [createFortalScope] to resolve actual values.
class FortalTokens {
  // ============================================================================
  // BACKGROUND AND SURFACE COLORS
  // ============================================================================

  /// Page background color (gray step 1).
  static const colorBackground = ColorToken('fortal.color.background');

  /// Neutral surface color for input fields and controls.
  static const colorSurface = ColorToken('fortal.color.surface');

  /// Solid panel background (gray step 2).
  static const colorPanelSolid = ColorToken('fortal.color.panel.solid');

  /// Translucent panel background with alpha transparency.
  static const colorPanelTranslucent = ColorToken(
    'fortal.color.panel.translucent',
  );

  /// Dark overlay for modals and dialogs.
  static const colorOverlay = ColorToken('fortal.color.overlay');

  // ============================================================================
  // FUNCTIONAL ACCENT COLORS
  // ============================================================================

  /// Subtle accent surface for soft button variants and chips.
  static const accentSurface = ColorToken('fortal.accent.surface');

  /// Active indicator color for progress bars and sliders.
  static const accentIndicator = ColorToken('fortal.accent.indicator');

  /// Track/rail background color for sliders and progress bars.
  static const accentTrack = ColorToken('fortal.accent.track');

  /// High contrast foreground for solid accent backgrounds.
  static const accentContrast = ColorToken('fortal.accent.contrast');

  // ============================================================================
  // FOCUS AND INTERACTION STATES
  // ============================================================================

  /// Solid focus ring color (accent step 8).
  static const focus8 = ColorToken('fortal.focus.8');

  /// Translucent focus ring color with alpha transparency.
  static const focusA8 = ColorToken('fortal.focus.a8');

  // ============================================================================
  // ACCENT COLOR SCALE (12 STEPS)
  // ============================================================================
  //
  // Fortal uses a 12-step color scale (inherited from Radix Themes) that provides semantic meaning:
  //
  // Steps 1-2:  App backgrounds (subtle → more visible)
  // Steps 3-5:  Component backgrounds (rest → hover → active)
  // Steps 6-8:  Borders (subtle → component → hover)
  // Steps 9-10: Solid backgrounds (default → hover)
  // Steps 11-12: Text (low contrast → high contrast)
  //

  /// Accent step 1 - App background, most subtle.
  static const accent1 = ColorToken('fortal.accent.1');

  /// Accent step 2 - Subtle background.
  static const accent2 = ColorToken('fortal.accent.2');

  /// Accent step 3 - Component background at rest.
  static const accent3 = ColorToken('fortal.accent.3');

  /// Accent step 4 - Component background on hover.
  static const accent4 = ColorToken('fortal.accent.4');

  /// Accent step 5 - Component background when active/pressed.
  static const accent5 = ColorToken('fortal.accent.5');

  /// Accent step 6 - Subtle borders and separators.
  static const accent6 = ColorToken('fortal.accent.6');

  /// Accent step 7 - Component borders at rest.
  static const accent7 = ColorToken('fortal.accent.7');

  /// Accent step 8 - Component borders on hover and focus.
  static const accent8 = ColorToken('fortal.accent.8');

  /// Accent step 9 - Primary solid background.
  static const accent9 = ColorToken('fortal.accent.9');

  /// Accent step 10 - Solid background on hover.
  static const accent10 = ColorToken('fortal.accent.10');

  /// Accent step 11 - Low contrast text.
  static const accent11 = ColorToken('fortal.accent.11');

  /// Accent step 12 - High contrast text.
  static const accent12 = ColorToken('fortal.accent.12');

  // ============================================================================
  // GRAY COLOR SCALE (12 STEPS)
  // ============================================================================
  //
  // The gray scale follows the same 12-step semantic structure as accent colors,
  // but provides neutral colors for text, borders, and backgrounds.
  // The specific gray variant (slate, mauve, sage, etc.) is chosen in the theme.
  //

  /// Gray step 1 - Page background.
  static const gray1 = ColorToken('fortal.gray.1');

  /// Gray step 2 - Panel and card backgrounds.
  static const gray2 = ColorToken('fortal.gray.2');

  /// Gray step 3 - Input backgrounds and pressed states.
  static const gray3 = ColorToken('fortal.gray.3');

  /// Gray step 4 - Input backgrounds on hover.
  static const gray4 = ColorToken('fortal.gray.4');

  /// Gray step 5 - Active states and disabled backgrounds.
  static const gray5 = ColorToken('fortal.gray.5');

  /// Gray step 6 - Subtle borders and dividers.
  static const gray6 = ColorToken('fortal.gray.6');

  /// Gray step 7 - Standard borders and outlines.
  ///
  /// Primary border color for form inputs, cards,
  /// and component boundaries.
  static const gray7 = ColorToken('fortal.gray.7');

  /// Gray step 8 - Borders on hover and focus.
  ///
  /// Interactive border states and stronger separators
  /// that need more visual weight.
  static const gray8 = ColorToken('fortal.gray.8');

  /// Gray step 9 - Solid neutral backgrounds.
  ///
  /// For neutral buttons, badges, and other elements
  /// that need a solid background without accent color.
  static const gray9 = ColorToken('fortal.gray.9');

  /// Gray step 10 - Solid neutral backgrounds on hover.
  ///
  /// Hover state for neutral solid backgrounds,
  /// providing interactive feedback.
  static const gray10 = ColorToken('fortal.gray.10');

  /// Gray step 11 - Low contrast text and secondary content.
  ///
  /// For secondary text, placeholders, and content that should
  /// be readable but not prominent.
  static const gray11 = ColorToken('fortal.gray.11');

  /// Gray step 12 - High contrast text and primary content.
  ///
  /// Primary text color for body content, headings, and any text
  /// that needs maximum readability and prominence.
  static const gray12 = ColorToken('fortal.gray.12');

  // ============================================================================
  // GRAY ROLE TOKENS (parity with generated JSON roles)
  // ============================================================================
  /// Neutral surface baseline for the selected gray scale (matches JSON surface)
  static const graySurface = ColorToken('fortal.gray.surface');

  /// Neutral indicator color (typically gray step 9)
  static const grayIndicator = ColorToken('fortal.gray.indicator');

  /// Neutral track color (typically gray step 9)
  static const grayTrack = ColorToken('fortal.gray.track');

  /// Contrast color for content over neutral solid backgrounds (white)
  static const grayContrast = ColorToken('fortal.gray.contrast');

  // ============================================================================
  // ALPHA VARIANTS (FULL 12-STEP FOR ACCENT AND GRAY)
  // ============================================================================

  // Accent alpha steps a1..a12
  static const accentA1 = ColorToken('fortal.accent.a1');
  static const accentA2 = ColorToken('fortal.accent.a2');
  static const accentA3 = ColorToken('fortal.accent.a3');
  static const accentA4 = ColorToken('fortal.accent.a4');
  static const accentA5 = ColorToken('fortal.accent.a5');
  static const accentA6 = ColorToken('fortal.accent.a6');
  static const accentA7 = ColorToken('fortal.accent.a7');
  static const accentA8 = ColorToken('fortal.accent.a8');
  static const accentA9 = ColorToken('fortal.accent.a9');
  static const accentA10 = ColorToken('fortal.accent.a10');
  static const accentA11 = ColorToken('fortal.accent.a11');
  static const accentA12 = ColorToken('fortal.accent.a12');

  // Gray alpha steps a1..a12
  static const grayA1 = ColorToken('fortal.gray.a1');
  static const grayA2 = ColorToken('fortal.gray.a2');
  static const grayA3 = ColorToken('fortal.gray.a3');
  static const grayA4 = ColorToken('fortal.gray.a4');
  static const grayA5 = ColorToken('fortal.gray.a5');
  static const grayA6 = ColorToken('fortal.gray.a6');
  static const grayA7 = ColorToken('fortal.gray.a7');
  static const grayA8 = ColorToken('fortal.gray.a8');
  static const grayA9 = ColorToken('fortal.gray.a9');
  static const grayA10 = ColorToken('fortal.gray.a10');
  static const grayA11 = ColorToken('fortal.gray.a11');
  static const grayA12 = ColorToken('fortal.gray.a12');

  // ============================================================================
  // NEUTRALS FOR SHADOWS (HELPER TOKENS)
  // ============================================================================
  /// Gray alpha steps are declared above (grayA1..grayA12).

  /// Black alpha steps used in layered shadows.
  static const blackA3 = ColorToken('fortal.black.a3');
  static const blackA4 = ColorToken('fortal.black.a4');
  static const blackA5 = ColorToken('fortal.black.a5');
  static const blackA6 = ColorToken('fortal.black.a6');
  static const blackA7 = ColorToken('fortal.black.a7');
  static const blackA11 = ColorToken('fortal.black.a11');

  /// OKLab-mixed shadow stroke: color-mix(in oklab, gray-a6, gray-6 25%).
  static const shadowStroke = ColorToken('fortal.shadow.stroke');

  // ============================================================================
  // SPACING SCALE (9 STEPS)
  // ============================================================================
  //
  // A consistent spacing scale based on 4px increments.
  //

  /// Space step 1 - 4px.
  ///
  /// Smallest spacing for tight layouts, borders,
  /// and fine-grained adjustments.
  static const space1 = SpaceToken('fortal.space.1');

  /// Space step 2 - 8px.
  ///
  /// Small spacing for component padding and margins.
  /// Good for button padding and form element spacing.
  static const space2 = SpaceToken('fortal.space.2');

  /// Space step 3 - 12px.
  ///
  /// Medium-small spacing for comfortable padding
  /// and moderate element separation.
  static const space3 = SpaceToken('fortal.space.3');

  /// Space step 4 - 16px.
  ///
  /// Standard spacing for most layouts. Good default
  /// for card padding and section margins.
  static const space4 = SpaceToken('fortal.space.4');

  /// Space step 5 - 20px.
  ///
  /// Medium spacing for generous padding and
  /// comfortable separation between sections.
  static const space5 = SpaceToken('fortal.space.5');

  /// Space step 6 - 24px.
  ///
  /// Large spacing for significant visual separation
  /// and generous component padding.
  static const space6 = SpaceToken('fortal.space.6');

  /// Space step 7 - 28px.
  ///
  /// Extra large spacing for major layout sections
  /// and prominent visual separation.
  static const space7 = SpaceToken('fortal.space.7');

  /// Space step 8 - 32px.
  ///
  /// Very large spacing for significant page sections
  /// and major layout boundaries.
  static const space8 = SpaceToken('fortal.space.8');

  /// Space step 9 - 36px.
  ///
  /// Maximum spacing for major page sections
  /// and substantial layout separation.
  static const space9 = SpaceToken('fortal.space.9');

  // ============================================================================
  // BORDER RADIUS SCALE (6 STEPS + FULL)
  // ============================================================================

  /// Radius step 1 - 3px.
  ///
  /// Subtle rounding for small elements like buttons
  /// and form inputs. Provides gentle softening of corners.
  static const radius1 = RadiusToken('fortal.radius.1');

  /// Radius step 2 - 4px.
  ///
  /// Small radius for compact components and minor rounding.
  /// Good for small badges and tight layouts.
  static const radius2 = RadiusToken('fortal.radius.2');

  /// Radius step 3 - 6px.
  ///
  /// Medium radius for standard components like buttons
  /// and cards. Balances modern look with usability.
  static const radius3 = RadiusToken('fortal.radius.3');

  /// Radius step 4 - 8px.
  ///
  /// Large radius for prominent components and generous rounding.
  /// Good for larger buttons and feature cards.
  static const radius4 = RadiusToken('fortal.radius.4');

  /// Radius step 5 - 12px.
  ///
  /// Extra large radius for major components and modern aesthetics.
  /// Suitable for large cards and prominent interface elements.
  static const radius5 = RadiusToken('fortal.radius.5');

  /// Radius step 6 - 16px.
  ///
  /// Very large radius for distinctive styling and major components.
  /// Creates a soft, friendly appearance for large interface elements.
  static const radius6 = RadiusToken('fortal.radius.6');

  /// Full radius (9999px) for circular shapes.
  ///
  /// Creates perfect circles and pills. Use for avatars,
  /// badges, and elements that should appear completely rounded.
  static const radiusFull = RadiusToken('fortal.radius.full');

  // ============================================================================
  // ELEVATION SHADOWS (6 LEVELS)
  // ============================================================================

  /// Shadow level 1 - Subtle elevation.
  ///
  /// Minimal shadow for slight elevation effects.
  /// Good for cards and buttons in their resting state.
  static const shadow1 = BoxShadowToken('fortal.shadow.1');

  /// Shadow level 2 - Low elevation.
  ///
  /// Light shadow for gentle elevation and hover states.
  /// Suitable for interactive elements and small modals.
  static const shadow2 = BoxShadowToken('fortal.shadow.2');

  /// Shadow level 3 - Medium elevation.
  ///
  /// Moderate shadow for clear visual separation.
  /// Good for dropdowns, tooltips, and floating elements.
  static const shadow3 = BoxShadowToken('fortal.shadow.3');

  /// Shadow level 4 - High elevation.
  ///
  /// Prominent shadow for important floating content.
  /// Suitable for modal dialogs and important overlays.
  static const shadow4 = BoxShadowToken('fortal.shadow.4');

  /// Shadow level 5 - Very high elevation.
  ///
  /// Strong shadow for primary modals and major overlays.
  /// Creates clear hierarchy and focus on important content.
  static const shadow5 = BoxShadowToken('fortal.shadow.5');

  /// Shadow level 6 - Maximum elevation.
  ///
  /// Maximum shadow depth for critical dialogs and notifications.
  /// Ensures content appears above all other interface elements.
  static const shadow6 = BoxShadowToken('fortal.shadow.6');

  // ============================================================================
  // BORDER AND STROKE WIDTHS
  // ============================================================================

  /// Standard border width (1px).
  ///
  /// Default border thickness for most components like inputs,
  /// cards, and dividers. Provides clear boundaries without visual weight.
  static const borderWidth1 = SpaceToken('fortal.border.width.1');

  /// Thick border width (2px).
  ///
  /// Heavier border for emphasis, selected states, and components
  /// that need stronger visual definition.
  static const borderWidth2 = SpaceToken('fortal.border.width.2');

  /// Focus ring border width (2px).
  ///
  /// Standard width for focus outlines to ensure accessibility
  /// compliance and clear keyboard navigation feedback.
  static const focusRingWidth = SpaceToken('fortal.focus.ring.width');

  /// Focus ring offset distance from element edge.
  ///
  /// Space between the component border and focus ring,
  /// ensuring the focus indicator doesn't interfere with the element.
  static const focusRingOffset = SpaceToken('fortal.focus.ring.offset');

  // ============================================================================
  // TYPOGRAPHY SCALE (9 LEVELS)
  // ============================================================================
  //
  // Text sizes with carefully tuned line heights and letter spacing
  // for optimal readability across all scales.
  //

  /// Text size 1 - 12px (Small labels and metadata).
  ///
  /// Smallest readable text for labels, captions, and secondary metadata.
  /// Includes tight letter spacing for improved legibility at small sizes.
  static const text1 = TextStyleToken('fortal.text.1');

  /// Text size 2 - 14px (Standard UI text).
  ///
  /// Default size for most interface text including buttons,
  /// form labels, and secondary content.
  static const text2 = TextStyleToken('fortal.text.2');

  /// Text size 3 - 16px (Body text and primary content).
  ///
  /// Ideal for body text and primary content. Provides excellent
  /// readability for extended reading on all device types.
  static const text3 = TextStyleToken('fortal.text.3');

  /// Text size 4 - 18px (Prominent body text).
  ///
  /// For important content that needs more visual weight than
  /// standard body text but isn't quite a heading.
  static const text4 = TextStyleToken('fortal.text.4');

  /// Text size 5 - 20px (Small headings).
  ///
  /// For minor headings, subheadings, and content that needs
  /// to stand out from body text.
  static const text5 = TextStyleToken('fortal.text.5');

  /// Text size 6 - 24px (Medium headings).
  ///
  /// Standard heading size for section titles and important content.
  /// Good balance between prominence and page economy.
  static const text6 = TextStyleToken('fortal.text.6');

  /// Text size 7 - 28px (Large headings).
  ///
  /// For major page headings and important announcements.
  /// Creates strong visual hierarchy and draws attention.
  static const text7 = TextStyleToken('fortal.text.7');

  /// Text size 8 - 35px (Extra large headings).
  ///
  /// For hero text, page titles, and major content sections.
  /// Strong negative letter spacing improves appearance at large sizes.
  static const text8 = TextStyleToken('fortal.text.8');

  /// Text size 9 - 60px (Display text).
  ///
  /// Maximum text size for hero sections and display typography.
  /// Includes significant negative letter spacing and tight line height.
  static const text9 = TextStyleToken('fortal.text.9');

  // ============================================================================
  // FONT WEIGHT TOKENS
  // ============================================================================

  /// Light font weight (300).
  ///
  /// Optional lighter weight occasionally used in display typography or
  /// subdued text. Provided for parity with Radix token set.
  static const fontWeightLight = FontWeightToken('fortal.font.weight.light');

  /// Regular font weight (400).
  ///
  /// Standard weight for body text and most interface elements.
  /// Provides good readability without visual strain.
  static const fontWeightRegular = FontWeightToken(
    'fortal.font.weight.regular',
  );

  /// Medium font weight (500).
  ///
  /// Slightly heavier than regular for UI elements that need
  /// more visual weight, like active states and button text.
  static const fontWeightMedium = FontWeightToken('fortal.font.weight.medium');

  /// Bold font weight (600).
  ///
  /// For headings and content that needs strong emphasis.
  /// Provides clear hierarchy without being too heavy.
  static const fontWeightBold = FontWeightToken('fortal.font.weight.bold');

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================

  /// Fast animation duration (100ms).
  ///
  /// For quick micro-interactions like hover states and button presses.
  /// Provides immediate feedback without feeling sluggish.
  static const transitionFast = DurationToken('fortal.transition.fast');

  /// Slow animation duration (300ms).
  ///
  /// For more substantial transitions like modal appearances,
  /// page transitions, and complex state changes.
  static const transitionSlow = DurationToken('fortal.transition.slow');
}

/// Creates a MixScope with Fortal design tokens configured for the specified theme.
///
/// This function sets up the complete Fortal token system with resolved color values
/// (sourced from Radix Colors) based on the chosen accent color, gray scale, and
/// brightness settings. All [FortalTokens] must be used within this scope to have
/// actual values.
///
/// **Theme Configuration:**
/// - [accent]: The accent color scale (indigo, blue, red, etc.)
/// - [gray]: The neutral gray scale with different undertones
/// - [brightness]: Light or dark mode
///
/// **Color Theory:**
/// The Fortal color system builds on Radix color science for perceptual
/// uniformity and accessibility:
/// - Each color scale has 12 steps with semantic meaning
/// - Colors are designed to work together harmoniously
/// - Alpha variants provide translucency without losing saturation
/// - Dark mode uses different algorithms to maintain contrast ratios
///
/// Example:
/// ```dart
/// createFortalScope(
///   accent: FortalAccentColor.blue,
///   gray: FortalGrayColor.slate,
///   brightness: Brightness.light,
///   child: MyApp(),
/// )
/// ```
///
/// The scope provides access to all design tokens through Mix styles:
/// ```dart
/// Style(
///   $box.color.ref(FortalTokens.accent9),     // Solid accent
///   $text.color.ref(FortalTokens.gray12),      // High contrast text
///   $box.padding.ref(FortalTokens.space4),     // 16px padding
///   $box.shadow.ref(FortalTokens.shadow2),     // Subtle elevation
/// )
/// ```
Widget createFortalScope({
  FortalAccentColor accent = FortalAccentColor.indigo,
  FortalGrayColor gray = FortalGrayColor.slate,
  Brightness brightness = Brightness.light,
  List<Type>? orderOfModifiers,
  required Widget child,
}) {
  final theme = FortalThemeConfig(
    accent: accent,
    gray: gray,
    brightness: brightness,
  );

  final tokens = resolveFortalTokens(theme);

  final colorTokens = {
    // Role and functional tokens
    FortalTokens.colorBackground: tokens.colorBackground,
    FortalTokens.colorSurface: tokens.colorSurface,
    FortalTokens.colorPanelSolid: tokens.colorPanelSolid,
    FortalTokens.colorPanelTranslucent: tokens.colorPanelTranslucent,
    FortalTokens.colorOverlay: tokens.colorOverlay,
    FortalTokens.accentSurface: tokens.accent.surface,
    FortalTokens.accentIndicator: tokens.accent.indicator,
    FortalTokens.accentTrack: tokens.accent.track,
    FortalTokens.accentContrast: tokens.accent.contrast,
    FortalTokens.focus8: tokens.focus8,
    FortalTokens.focusA8: tokens.focusA8,
    // Accent steps (explicit for clarity)
    FortalTokens.accent1: tokens.accent.scale.step(1),
    FortalTokens.accent2: tokens.accent.scale.step(2),
    FortalTokens.accent3: tokens.accent.scale.step(3),
    FortalTokens.accent4: tokens.accent.scale.step(4),
    FortalTokens.accent5: tokens.accent.scale.step(5),
    FortalTokens.accent6: tokens.accent.scale.step(6),
    FortalTokens.accent7: tokens.accent.scale.step(7),
    FortalTokens.accent8: tokens.accent.scale.step(8),
    FortalTokens.accent9: tokens.accent.scale.step(9),
    FortalTokens.accent10: tokens.accent.scale.step(10),
    FortalTokens.accent11: tokens.accent.scale.step(11),
    FortalTokens.accent12: tokens.accent.scale.step(12),
    // Gray steps
    FortalTokens.gray1: tokens.gray.scale.step(1),
    FortalTokens.gray2: tokens.gray.scale.step(2),
    FortalTokens.gray3: tokens.gray.scale.step(3),
    FortalTokens.gray4: tokens.gray.scale.step(4),
    FortalTokens.gray5: tokens.gray.scale.step(5),
    FortalTokens.gray6: tokens.gray.scale.step(6),
    FortalTokens.gray7: tokens.gray.scale.step(7),
    FortalTokens.gray8: tokens.gray.scale.step(8),
    FortalTokens.gray9: tokens.gray.scale.step(9),
    FortalTokens.gray10: tokens.gray.scale.step(10),
    FortalTokens.gray11: tokens.gray.scale.step(11),
    FortalTokens.gray12: tokens.gray.scale.step(12),
    // Gray role tokens (from resolved colors)
    FortalTokens.graySurface: tokens.gray.surface,
    FortalTokens.grayIndicator: tokens.gray.indicator,
    FortalTokens.grayTrack: tokens.gray.track,
    FortalTokens.grayContrast: tokens.gray.contrast,
    // Accent alpha a1..a12
    FortalTokens.accentA1: tokens.accent.scale.alphaStep(1),
    FortalTokens.accentA2: tokens.accent.scale.alphaStep(2),
    FortalTokens.accentA3: tokens.accent.scale.alphaStep(3),
    FortalTokens.accentA4: tokens.accent.scale.alphaStep(4),
    FortalTokens.accentA5: tokens.accent.scale.alphaStep(5),
    FortalTokens.accentA6: tokens.accent.scale.alphaStep(6),
    FortalTokens.accentA7: tokens.accent.scale.alphaStep(7),
    FortalTokens.accentA8: tokens.accent.scale.alphaStep(8),
    FortalTokens.accentA9: tokens.accent.scale.alphaStep(9),
    FortalTokens.accentA10: tokens.accent.scale.alphaStep(10),
    FortalTokens.accentA11: tokens.accent.scale.alphaStep(11),
    FortalTokens.accentA12: tokens.accent.scale.alphaStep(12),

    // Gray alpha a1..a12
    FortalTokens.grayA1: tokens.gray.scale.alphaStep(1),
    FortalTokens.grayA2: tokens.gray.scale.alphaStep(2),
    FortalTokens.grayA3: tokens.gray.scale.alphaStep(3),
    FortalTokens.grayA4: tokens.gray.scale.alphaStep(4),
    FortalTokens.grayA5: tokens.gray.scale.alphaStep(5),
    FortalTokens.grayA6: tokens.gray.scale.alphaStep(6),
    FortalTokens.grayA7: tokens.gray.scale.alphaStep(7),
    FortalTokens.grayA8: tokens.gray.scale.alphaStep(8),
    FortalTokens.grayA9: tokens.gray.scale.alphaStep(9),
    FortalTokens.grayA10: tokens.gray.scale.alphaStep(10),
    FortalTokens.grayA11: tokens.gray.scale.alphaStep(11),
    FortalTokens.grayA12: tokens.gray.scale.alphaStep(12),
    // Neutral helpers derived from primitives
    FortalTokens.blackA3: tokens.blackAlpha[3]!,
    FortalTokens.blackA4: tokens.blackAlpha[4]!,
    FortalTokens.blackA5: tokens.blackAlpha[5]!,
    FortalTokens.blackA6: tokens.blackAlpha[6]!,
    FortalTokens.blackA7: tokens.blackAlpha[7]!,
    FortalTokens.blackA11: tokens.blackAlpha[11]!,
    // Shadow stroke (OKLab mix)
    FortalTokens.shadowStroke: computeShadowStroke(tokens.gray.scale),
  };

  // Build base tokens map
  final allTokens = <MixToken, Object>{
    ...colorTokens,
    // Defaults (may be overridden by JSON tokens below)
    FortalTokens.space1: 4.0,
    FortalTokens.space2: 8.0,
    FortalTokens.space3: 12.0,
    FortalTokens.space4: 16.0,
    FortalTokens.space5: 24.0,
    FortalTokens.space6: 32.0,
    FortalTokens.space7: 40.0,
    FortalTokens.space8: 48.0,
    FortalTokens.space9: 64.0,
    FortalTokens.radius1: const Radius.circular(3.0),
    FortalTokens.radius2: const Radius.circular(4.0),
    FortalTokens.radius3: const Radius.circular(6.0),
    FortalTokens.radius4: const Radius.circular(8.0),
    FortalTokens.radius5: const Radius.circular(12.0),
    FortalTokens.radius6: const Radius.circular(16.0),
    FortalTokens.radiusFull: const Radius.circular(9999.0),

    // Shadow lists
    // Layered shadows approximating Radix Themes CSS tokens
    // shadow-1: Radix uses inset layers; Flutter lacks inset. Approximate with subtle stroke + small ambient.
    FortalTokens.shadow1: [
      BoxShadow(
        color: FortalTokens.grayA6(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: FortalTokens.blackA5(),
        offset: const Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ],
    // shadow-2
    FortalTokens.shadow2: [
      // 0 0 0 1px color-mix(in oklab, gray-a6, gray-6 25%)
      BoxShadow(
        color: FortalTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 0 0 0.5px black-a3 -> approximate with small blur instead of half-px spread
      BoxShadow(
        color: FortalTokens.blackA3(),
        offset: const Offset(0, 0),
        blurRadius: 0.5,
        spreadRadius: 0,
      ),
      // 0 1px 1px 0 black-a6
      BoxShadow(
        color: FortalTokens.blackA6(),
        offset: const Offset(0, 1),
        blurRadius: 1,
        spreadRadius: 0,
      ),
      // 0 2px 1px -1px black-a6
      BoxShadow(
        color: FortalTokens.blackA6(),
        offset: const Offset(0, 2),
        blurRadius: 1,
        spreadRadius: -1,
      ),
      // 0 1px 3px 0 black-a5
      BoxShadow(
        color: FortalTokens.blackA5(),
        offset: const Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
    ],
    // shadow-3
    FortalTokens.shadow3: [
      BoxShadow(
        color: FortalTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 2px 3px -2px black-a3
      BoxShadow(
        color: FortalTokens.blackA3(),
        offset: const Offset(0, 2),
        blurRadius: 3,
        spreadRadius: -2,
      ),
      // 0 3px 8px -2px black-a6
      BoxShadow(
        color: FortalTokens.blackA6(),
        offset: const Offset(0, 3),
        blurRadius: 8,
        spreadRadius: -2,
      ),
      // 0 4px 12px -4px black-a7
      BoxShadow(
        color: FortalTokens.blackA7(),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: -4,
      ),
    ],
    // shadow-4
    FortalTokens.shadow4: [
      BoxShadow(
        color: FortalTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 8px 40px black-a3
      BoxShadow(
        color: FortalTokens.blackA3(),
        offset: const Offset(0, 8),
        blurRadius: 40,
        spreadRadius: 0,
      ),
      // 0 12px 32px -16px black-a5
      BoxShadow(
        color: FortalTokens.blackA5(),
        offset: const Offset(0, 12),
        blurRadius: 32,
        spreadRadius: -16,
      ),
    ],
    // shadow-5
    FortalTokens.shadow5: [
      BoxShadow(
        color: FortalTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 12px 60px black-a5
      BoxShadow(
        color: FortalTokens.blackA5(),
        offset: const Offset(0, 12),
        blurRadius: 60,
        spreadRadius: 0,
      ),
      // 0 12px 32px -16px black-a7
      BoxShadow(
        color: FortalTokens.blackA7(),
        offset: const Offset(0, 12),
        blurRadius: 32,
        spreadRadius: -16,
      ),
    ],
    // shadow-6
    FortalTokens.shadow6: [
      BoxShadow(
        color: FortalTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 12px 60px black-a4
      BoxShadow(
        color: FortalTokens.blackA4(),
        offset: const Offset(0, 12),
        blurRadius: 60,
        spreadRadius: 0,
      ),
      // 0 16px 64px black-a6
      BoxShadow(
        color: FortalTokens.blackA6(),
        offset: const Offset(0, 16),
        blurRadius: 64,
        spreadRadius: 0,
      ),
      // 0 16px 36px -20px black-a11
      BoxShadow(
        color: FortalTokens.blackA11(),
        offset: const Offset(0, 16),
        blurRadius: 36,
        spreadRadius: -20,
      ),
    ],
    FortalTokens.borderWidth1: 1.0,
    FortalTokens.borderWidth2: 2.0,
    FortalTokens.focusRingWidth: 2.0,
    FortalTokens.focusRingOffset: 2.0,
    FortalTokens.text1: TextStyle(
      fontSize: 12.0,
      letterSpacing: 0.0025 * 12.0,
      height: 16.0 / 12.0,
    ),
    FortalTokens.text2: TextStyle(
      fontSize: 14.0,
      letterSpacing: 0.0,
      height: 20.0 / 14.0,
    ),
    FortalTokens.text3: TextStyle(
      fontSize: 16.0,
      letterSpacing: 0.0,
      height: 24.0 / 16.0,
    ),
    FortalTokens.text4: TextStyle(
      fontSize: 18.0,
      letterSpacing: -0.0025 * 18.0,
      height: 26.0 / 18.0,
    ),
    FortalTokens.text5: TextStyle(
      fontSize: 20.0,
      letterSpacing: -0.005 * 20.0,
      height: 28.0 / 20.0,
    ),
    FortalTokens.text6: TextStyle(
      fontSize: 24.0,
      letterSpacing: -0.00625 * 24.0,
      height: 30.0 / 24.0,
    ),
    FortalTokens.text7: TextStyle(
      fontSize: 28.0,
      letterSpacing: -0.0075 * 28.0,
      height: 36.0 / 28.0,
    ),
    FortalTokens.text8: TextStyle(
      fontSize: 35.0,
      letterSpacing: -0.01 * 35.0,
      height: 40.0 / 35.0,
    ),
    FortalTokens.text9: TextStyle(
      fontSize: 60.0,
      letterSpacing: -0.025 * 60.0,
      height: 1.0,
    ),

    // Font weights (token values)
    FortalTokens.fontWeightLight: FontWeight.w300,
    FortalTokens.fontWeightRegular: FontWeight.w400,
    FortalTokens.fontWeightMedium: FontWeight.w500,
    // Match Radix Themes font weights (bold = 700)
    FortalTokens.fontWeightBold: FontWeight.w700,

    // Durations (token values)
    FortalTokens.transitionFast: Duration(milliseconds: 100),
    FortalTokens.transitionSlow: Duration(milliseconds: 300),
  };

  return MixScope(
    tokens: allTokens,
    orderOfModifiers: orderOfModifiers,
    child: child,
  );
}

// OKLab mixing implemented in computed.dart; no helper here.

// (No internal helpers needed; explicit step mapping kept for clarity.)

/// Available accent colors matching Radix Themes names.
enum FortalAccentColor {
  amber,
  blue,
  bronze,
  brown,
  crimson,
  cyan,
  gold,
  grass,
  green,
  indigo,
  iris,
  jade,
  lime,
  mint,
  orange,
  pink,
  plum,
  purple,
  red,
  ruby,
  sky,
  teal,
  tomato,
  violet,
  yellow,
  // neutrals also allowed as accent for convenience
  gray,
  mauve,
  slate,
  sage,
  olive,
  sand,
}

/// Available neutral gray families matching Radix Themes names.
enum FortalGrayColor { gray, mauve, slate, sage, olive, sand }

/// Immutable configuration object for Fortal theme settings.
///
/// Provides a convenient way to store and pass around theme configuration,
/// including methods to create variants and apply the theme to widgets.
/// This is useful when you need to switch themes dynamically or pass
/// theme configuration through your app.
///
/// Example:
/// ```dart
/// const theme = FortalThemeConfig(
///   accent: FortalAccentColor.green,
///   gray: FortalGrayColor.sage,
///   brightness: Brightness.dark,
/// );
///
/// // Create variants
/// final lightTheme = theme.copyWith(brightness: Brightness.light);
///
/// // Apply to widgets
/// theme.createScope(child: MyApp())
/// ```
@immutable
class FortalThemeConfig {
  final FortalAccentColor accent;
  final FortalGrayColor gray;
  final Brightness brightness;

  const FortalThemeConfig({
    this.accent = FortalAccentColor.indigo,
    this.gray = FortalGrayColor.slate,
    this.brightness = Brightness.light,
  });

  bool get isDark => brightness == Brightness.dark;

  FortalThemeConfig copyWith({
    FortalAccentColor? accent,
    FortalGrayColor? gray,
    Brightness? brightness,
  }) => FortalThemeConfig(
    accent: accent ?? this.accent,
    gray: gray ?? this.gray,
    brightness: brightness ?? this.brightness,
  );

  Widget createScope({List<Type>? orderOfModifiers, required Widget child}) =>
      createFortalScope(
        accent: accent,
        gray: gray,
        brightness: brightness,
        orderOfModifiers: orderOfModifiers,
        child: child,
      );
}
