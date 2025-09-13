// Radix theme: tokens + MixScope builder in one place.

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'computed.dart';

// OKLab mixing lives in computed.dart; no direct dependency here.

/// Design tokens for the Radix UI system, providing access to all colors, spacing, typography, and other design primitives.
///
/// This class contains all the design tokens that power the Radix theming system.
/// Tokens are organized into semantic categories following Radix UI conventions:
///
/// **Color System:**
/// - Background and surface colors for layouts
/// - 12-step accent color scales for branding
/// - 12-step gray scales for neutral elements
/// - Functional colors (focus, contrast, indicators)
/// - Alpha variants for translucent effects
///
/// **Layout System:**
/// - 9-step spacing scale (4px to 36px)
/// - 6-step radius scale plus full radius
/// - 6-step shadow elevation system
/// - Border widths and focus ring sizing
///
/// **Typography:**
/// - 9-step text size scale (12px to 60px)
/// - Font weight tokens (regular, medium, bold)
/// - Carefully tuned letter spacing and line heights
///
/// Example usage:
/// ```dart
/// // Use in Mix styles
/// Style(
///   $box.color.ref(RadixTokens.accent9),
///   $text.style.ref(RadixTokens.text3),
///   $box.padding.ref(RadixTokens.space4),
///   $box.borderRadius.ref(RadixTokens.radius3),
/// )
///
/// // Access colors directly (after scope setup)
/// final accentColor = context.mix.tokens.colorValue(RadixTokens.accent9);
/// ```
///
/// All tokens must be used within a [createRadixScope] to provide actual values.
/// The scope resolves tokens based on the selected accent color, gray scale,
/// and brightness (light/dark mode).
class RadixTokens {
  // ============================================================================
  // BACKGROUND AND SURFACE COLORS
  // ============================================================================

  /// Page background color (gray step 1).
  ///
  /// The primary background for app screens and layouts.
  /// Provides subtle contrast from pure white/black.
  static const colorBackground = ColorToken('radix.color.background');

  /// Neutral surface color for input fields and controls.
  ///
  /// Used for form inputs, card surfaces, and interactive elements
  /// that need a subtle background different from the page background.
  static const colorSurface = ColorToken('radix.color.surface');

  /// Solid panel background (gray step 2).
  ///
  /// For cards, modals, and other contained content areas.
  /// Provides clear separation from the page background.
  static const colorPanelSolid = ColorToken('radix.color.panel.solid');

  /// Translucent panel background with alpha transparency.
  ///
  /// Used for overlays, tooltips, and floating panels that need
  /// to show content underneath while providing visual separation.
  static const colorPanelTranslucent =
      ColorToken('radix.color.panel.translucent');

  /// Dark overlay for modals and dialogs.
  ///
  /// Provides a semi-transparent black background that dims
  /// the content behind modal dialogs and drawers.
  static const colorOverlay = ColorToken('radix.color.overlay');

  // ============================================================================
  // FUNCTIONAL ACCENT COLORS
  // ============================================================================

  /// Subtle accent surface for soft button variants and chips.
  ///
  /// A lightly tinted surface that provides accent color context
  /// without being too prominent. Created by compositing accent alpha
  /// over neutral surface.
  static const accentSurface = ColorToken('radix.accent.surface');

  /// Active indicator color for progress bars and sliders.
  ///
  /// The solid accent color used to show progress, selected ranges,
  /// and other active states. Typically accent step 9, but may vary
  /// by color (yellow uses step 10 in light mode for better contrast).
  static const accentIndicator = ColorToken('radix.accent.indicator');

  /// Track/rail background color for sliders and progress bars.
  ///
  /// The background behind indicators in range controls.
  /// In dark mode for bright colors, uses OKLab color mixing
  /// to reduce visual glare.
  static const accentTrack = ColorToken('radix.accent.track');

  /// High contrast foreground for solid accent backgrounds.
  ///
  /// Text and icon color for buttons and badges with solid accent
  /// backgrounds. White for most colors, near-black for bright colors
  /// (sky, mint, lime, yellow, amber) to ensure readability.
  static const accentContrast = ColorToken('radix.accent.contrast');

  // ============================================================================
  // FOCUS AND INTERACTION STATES
  // ============================================================================

  /// Solid focus ring color (accent step 8).
  ///
  /// Used for focus outlines and keyboard navigation indicators.
  /// Provides clear visual feedback for interactive elements.
  static const focus8 = ColorToken('radix.focus.8');

  /// Translucent focus ring color with alpha transparency.
  ///
  /// Alternative to solid focus ring, useful when focus outline
  /// needs to blend with varying background colors.
  static const focusA8 = ColorToken('radix.focus.a8');

  // ============================================================================
  // ACCENT COLOR SCALE (12 STEPS)
  // ============================================================================
  //
  // Radix uses a 12-step color scale that provides semantic meaning:
  //
  // Steps 1-2:  App backgrounds (subtle → more visible)
  // Steps 3-5:  Component backgrounds (rest → hover → active)
  // Steps 6-8:  Borders (subtle → component → hover)
  // Steps 9-10: Solid backgrounds (default → hover)
  // Steps 11-12: Text (low contrast → high contrast)
  //

  /// Accent step 1 - App background, most subtle.
  ///
  /// Very subtle accent tint for page backgrounds.
  /// Provides barely perceptible brand color presence.
  static const accent1 = ColorToken('radix.accent.1');

  /// Accent step 2 - Subtle background.
  ///
  /// For hover states over step 1, or card backgrounds
  /// that need slightly more accent presence.
  static const accent2 = ColorToken('radix.accent.2');

  /// Accent step 3 - Component background at rest.
  ///
  /// Default background for buttons, input fields, and other
  /// interactive components in their resting state.
  static const accent3 = ColorToken('radix.accent.3');

  /// Accent step 4 - Component background on hover.
  ///
  /// Hover state background for components, providing
  /// clear feedback for interactive elements.
  static const accent4 = ColorToken('radix.accent.4');

  /// Accent step 5 - Component background when active/pressed.
  ///
  /// Active state background, used when components are pressed
  /// or selected. Provides clear feedback for user actions.
  static const accent5 = ColorToken('radix.accent.5');

  /// Accent step 6 - Subtle borders and separators.
  ///
  /// For borders that need to be visible but not prominent.
  /// Provides gentle visual separation between elements.
  static const accent6 = ColorToken('radix.accent.6');

  /// Accent step 7 - Component borders at rest.
  ///
  /// Standard border color for form inputs, cards, and other
  /// components in their default state.
  static const accent7 = ColorToken('radix.accent.7');

  /// Accent step 8 - Component borders on hover and focus.
  ///
  /// Border color for interactive states, also used for
  /// focus rings to provide clear keyboard navigation feedback.
  static const accent8 = ColorToken('radix.accent.8');

  /// Accent step 9 - Primary solid background.
  ///
  /// The main accent color for buttons, badges, and other prominent
  /// elements. This is typically what users think of as "the brand color".
  static const accent9 = ColorToken('radix.accent.9');

  /// Accent step 10 - Solid background on hover.
  ///
  /// Hover state for solid accent backgrounds, slightly darker/lighter
  /// than step 9 to provide clear interactive feedback.
  static const accent10 = ColorToken('radix.accent.10');

  /// Accent step 11 - Low contrast text.
  ///
  /// Accent-colored text that works well on light backgrounds.
  /// Used for links, secondary text, and less prominent content.
  static const accent11 = ColorToken('radix.accent.11');

  /// Accent step 12 - High contrast text.
  ///
  /// The highest contrast accent text color, used for headings,
  /// important content, and when maximum readability is needed.
  static const accent12 = ColorToken('radix.accent.12');

  // ============================================================================
  // GRAY COLOR SCALE (12 STEPS)
  // ============================================================================
  //
  // The gray scale follows the same 12-step semantic structure as accent colors,
  // but provides neutral colors for text, borders, and backgrounds.
  // The specific gray variant (slate, mauve, sage, etc.) is chosen in the theme.
  //

  /// Gray step 1 - Page background.
  ///
  /// Primary background color for app layouts and screens.
  /// Provides subtle warmth compared to pure white/black.
  static const gray1 = ColorToken('radix.gray.1');

  /// Gray step 2 - Panel and card backgrounds.
  ///
  /// Background for contained content areas like cards,
  /// modals, and form panels.
  static const gray2 = ColorToken('radix.gray.2');

  /// Gray step 3 - Input backgrounds and pressed states.
  ///
  /// Default background for form inputs and active states
  /// of interactive elements.
  static const gray3 = ColorToken('radix.gray.3');

  /// Gray step 4 - Input backgrounds on hover.
  ///
  /// Hover state background for form elements,
  /// providing clear interactive feedback.
  static const gray4 = ColorToken('radix.gray.4');

  /// Gray step 5 - Active states and disabled backgrounds.
  ///
  /// For pressed states and backgrounds of disabled elements
  /// that still need to be distinguishable.
  static const gray5 = ColorToken('radix.gray.5');

  /// Gray step 6 - Subtle borders and dividers.
  ///
  /// For separators and borders that should be present
  /// but not draw attention.
  static const gray6 = ColorToken('radix.gray.6');

  /// Gray step 7 - Standard borders and outlines.
  ///
  /// Primary border color for form inputs, cards,
  /// and component boundaries.
  static const gray7 = ColorToken('radix.gray.7');

  /// Gray step 8 - Borders on hover and focus.
  ///
  /// Interactive border states and stronger separators
  /// that need more visual weight.
  static const gray8 = ColorToken('radix.gray.8');

  /// Gray step 9 - Solid neutral backgrounds.
  ///
  /// For neutral buttons, badges, and other elements
  /// that need a solid background without accent color.
  static const gray9 = ColorToken('radix.gray.9');

  /// Gray step 10 - Solid neutral backgrounds on hover.
  ///
  /// Hover state for neutral solid backgrounds,
  /// providing interactive feedback.
  static const gray10 = ColorToken('radix.gray.10');

  /// Gray step 11 - Low contrast text and secondary content.
  ///
  /// For secondary text, placeholders, and content that should
  /// be readable but not prominent.
  static const gray11 = ColorToken('radix.gray.11');

  /// Gray step 12 - High contrast text and primary content.
  ///
  /// Primary text color for body content, headings, and any text
  /// that needs maximum readability and prominence.
  static const gray12 = ColorToken('radix.gray.12');

  // ============================================================================
  // GRAY ROLE TOKENS (parity with generated JSON roles)
  // ============================================================================
  /// Neutral surface baseline for the selected gray scale (matches JSON surface)
  static const graySurface = ColorToken('radix.gray.surface');

  /// Neutral indicator color (typically gray step 9)
  static const grayIndicator = ColorToken('radix.gray.indicator');

  /// Neutral track color (typically gray step 9)
  static const grayTrack = ColorToken('radix.gray.track');

  /// Contrast color for content over neutral solid backgrounds (white)
  static const grayContrast = ColorToken('radix.gray.contrast');

  // ============================================================================
  // COMMONLY USED ALPHA VARIANTS
  // ============================================================================

  /// Accent step 3 with alpha transparency.
  ///
  /// Translucent version of accent3, useful for overlays
  /// and effects that need to show background content.
  static const accentA3 = ColorToken('radix.accent.a3');

  /// Accent step 4 with alpha transparency.
  ///
  /// Translucent hover state that works over varying backgrounds
  /// while maintaining consistent visual weight.
  static const accentA4 = ColorToken('radix.accent.a4');

  /// Accent step 8 with alpha transparency.
  ///
  /// Translucent version of the focus color, useful for
  /// focus indicators that need to work over different backgrounds.
  static const accentA8 = ColorToken('radix.accent.a8');

  // ============================================================================
  // NEUTRALS FOR SHADOWS (HELPER TOKENS)
  // ============================================================================
  /// Gray alpha step used in Radix shadow border mixes.
  static const grayA6 = ColorToken('radix.gray.a6');

  /// Black alpha steps used in layered shadows.
  static const blackA3 = ColorToken('radix.black.a3');
  static const blackA4 = ColorToken('radix.black.a4');
  static const blackA5 = ColorToken('radix.black.a5');
  static const blackA6 = ColorToken('radix.black.a6');
  static const blackA7 = ColorToken('radix.black.a7');
  static const blackA11 = ColorToken('radix.black.a11');

  /// OKLab-mixed shadow stroke: color-mix(in oklab, gray-a6, gray-6 25%).
  static const shadowStroke = ColorToken('radix.shadow.stroke');

  // ============================================================================
  // SPACING SCALE (9 STEPS)
  // ============================================================================
  //
  // A consistent spacing scale based on 4px increments.
  // Provides visual rhythm and consistency across layouts.
  //

  /// Space step 1 - 4px.
  ///
  /// Smallest spacing for tight layouts, borders,
  /// and fine-grained adjustments.
  static const space1 = SpaceToken('radix.space.1');

  /// Space step 2 - 8px.
  ///
  /// Small spacing for component padding and margins.
  /// Good for button padding and form element spacing.
  static const space2 = SpaceToken('radix.space.2');

  /// Space step 3 - 12px.
  ///
  /// Medium-small spacing for comfortable padding
  /// and moderate element separation.
  static const space3 = SpaceToken('radix.space.3');

  /// Space step 4 - 16px.
  ///
  /// Standard spacing for most layouts. Good default
  /// for card padding and section margins.
  static const space4 = SpaceToken('radix.space.4');

  /// Space step 5 - 20px.
  ///
  /// Medium spacing for generous padding and
  /// comfortable separation between sections.
  static const space5 = SpaceToken('radix.space.5');

  /// Space step 6 - 24px.
  ///
  /// Large spacing for significant visual separation
  /// and generous component padding.
  static const space6 = SpaceToken('radix.space.6');

  /// Space step 7 - 28px.
  ///
  /// Extra large spacing for major layout sections
  /// and prominent visual separation.
  static const space7 = SpaceToken('radix.space.7');

  /// Space step 8 - 32px.
  ///
  /// Very large spacing for significant page sections
  /// and major layout boundaries.
  static const space8 = SpaceToken('radix.space.8');

  /// Space step 9 - 36px.
  ///
  /// Maximum spacing for major page sections
  /// and substantial layout separation.
  static const space9 = SpaceToken('radix.space.9');

  // ============================================================================
  // BORDER RADIUS SCALE (6 STEPS + FULL)
  // ============================================================================

  /// Radius step 1 - 3px.
  ///
  /// Subtle rounding for small elements like buttons
  /// and form inputs. Provides gentle softening of corners.
  static const radius1 = RadiusToken('radix.radius.1');

  /// Radius step 2 - 4px.
  ///
  /// Small radius for compact components and minor rounding.
  /// Good for small badges and tight layouts.
  static const radius2 = RadiusToken('radix.radius.2');

  /// Radius step 3 - 6px.
  ///
  /// Medium radius for standard components like buttons
  /// and cards. Balances modern look with usability.
  static const radius3 = RadiusToken('radix.radius.3');

  /// Radius step 4 - 8px.
  ///
  /// Large radius for prominent components and generous rounding.
  /// Good for larger buttons and feature cards.
  static const radius4 = RadiusToken('radix.radius.4');

  /// Radius step 5 - 12px.
  ///
  /// Extra large radius for major components and modern aesthetics.
  /// Suitable for large cards and prominent interface elements.
  static const radius5 = RadiusToken('radix.radius.5');

  /// Radius step 6 - 16px.
  ///
  /// Very large radius for distinctive styling and major components.
  /// Creates a soft, friendly appearance for large interface elements.
  static const radius6 = RadiusToken('radix.radius.6');

  /// Full radius (9999px) for circular shapes.
  ///
  /// Creates perfect circles and pills. Use for avatars,
  /// badges, and elements that should appear completely rounded.
  static const radiusFull = RadiusToken('radix.radius.full');

  // ============================================================================
  // ELEVATION SHADOWS (6 LEVELS)
  // ============================================================================

  /// Shadow level 1 - Subtle elevation.
  ///
  /// Minimal shadow for slight elevation effects.
  /// Good for cards and buttons in their resting state.
  static const shadow1 = BoxShadowToken('radix.shadow.1');

  /// Shadow level 2 - Low elevation.
  ///
  /// Light shadow for gentle elevation and hover states.
  /// Suitable for interactive elements and small modals.
  static const shadow2 = BoxShadowToken('radix.shadow.2');

  /// Shadow level 3 - Medium elevation.
  ///
  /// Moderate shadow for clear visual separation.
  /// Good for dropdowns, tooltips, and floating elements.
  static const shadow3 = BoxShadowToken('radix.shadow.3');

  /// Shadow level 4 - High elevation.
  ///
  /// Prominent shadow for important floating content.
  /// Suitable for modal dialogs and important overlays.
  static const shadow4 = BoxShadowToken('radix.shadow.4');

  /// Shadow level 5 - Very high elevation.
  ///
  /// Strong shadow for primary modals and major overlays.
  /// Creates clear hierarchy and focus on important content.
  static const shadow5 = BoxShadowToken('radix.shadow.5');

  /// Shadow level 6 - Maximum elevation.
  ///
  /// Maximum shadow depth for critical dialogs and notifications.
  /// Ensures content appears above all other interface elements.
  static const shadow6 = BoxShadowToken('radix.shadow.6');

  // ============================================================================
  // BORDER AND STROKE WIDTHS
  // ============================================================================

  /// Standard border width (1px).
  ///
  /// Default border thickness for most components like inputs,
  /// cards, and dividers. Provides clear boundaries without visual weight.
  static const borderWidth1 = SpaceToken('radix.border.width.1');

  /// Thick border width (2px).
  ///
  /// Heavier border for emphasis, selected states, and components
  /// that need stronger visual definition.
  static const borderWidth2 = SpaceToken('radix.border.width.2');

  /// Focus ring border width (2px).
  ///
  /// Standard width for focus outlines to ensure accessibility
  /// compliance and clear keyboard navigation feedback.
  static const focusRingWidth = SpaceToken('radix.focus.ring.width');

  /// Focus ring offset distance from element edge.
  ///
  /// Space between the component border and focus ring,
  /// ensuring the focus indicator doesn't interfere with the element.
  static const focusRingOffset = SpaceToken('radix.focus.ring.offset');

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
  static const text1 = TextStyleToken('radix.text.1');

  /// Text size 2 - 14px (Standard UI text).
  ///
  /// Default size for most interface text including buttons,
  /// form labels, and secondary content.
  static const text2 = TextStyleToken('radix.text.2');

  /// Text size 3 - 16px (Body text and primary content).
  ///
  /// Ideal for body text and primary content. Provides excellent
  /// readability for extended reading on all device types.
  static const text3 = TextStyleToken('radix.text.3');

  /// Text size 4 - 18px (Prominent body text).
  ///
  /// For important content that needs more visual weight than
  /// standard body text but isn't quite a heading.
  static const text4 = TextStyleToken('radix.text.4');

  /// Text size 5 - 20px (Small headings).
  ///
  /// For minor headings, subheadings, and content that needs
  /// to stand out from body text.
  static const text5 = TextStyleToken('radix.text.5');

  /// Text size 6 - 24px (Medium headings).
  ///
  /// Standard heading size for section titles and important content.
  /// Good balance between prominence and page economy.
  static const text6 = TextStyleToken('radix.text.6');

  /// Text size 7 - 28px (Large headings).
  ///
  /// For major page headings and important announcements.
  /// Creates strong visual hierarchy and draws attention.
  static const text7 = TextStyleToken('radix.text.7');

  /// Text size 8 - 35px (Extra large headings).
  ///
  /// For hero text, page titles, and major content sections.
  /// Strong negative letter spacing improves appearance at large sizes.
  static const text8 = TextStyleToken('radix.text.8');

  /// Text size 9 - 60px (Display text).
  ///
  /// Maximum text size for hero sections and display typography.
  /// Includes significant negative letter spacing and tight line height.
  static const text9 = TextStyleToken('radix.text.9');

  // ============================================================================
  // FONT WEIGHT TOKENS
  // ============================================================================

  /// Light font weight (300).
  ///
  /// Optional lighter weight occasionally used in display typography or
  /// subdued text. Provided for parity with Radix token set.
  static const fontWeightLight = FontWeightToken('radix.font.weight.light');

  /// Regular font weight (400).
  ///
  /// Standard weight for body text and most interface elements.
  /// Provides good readability without visual strain.
  static const fontWeightRegular = FontWeightToken('radix.font.weight.regular');

  /// Medium font weight (500).
  ///
  /// Slightly heavier than regular for UI elements that need
  /// more visual weight, like active states and button text.
  static const fontWeightMedium = FontWeightToken('radix.font.weight.medium');

  /// Bold font weight (600).
  ///
  /// For headings and content that needs strong emphasis.
  /// Provides clear hierarchy without being too heavy.
  static const fontWeightBold = FontWeightToken('radix.font.weight.bold');

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================

  /// Fast animation duration (100ms).
  ///
  /// For quick micro-interactions like hover states and button presses.
  /// Provides immediate feedback without feeling sluggish.
  static const transitionFast = DurationToken('radix.transition.fast');

  /// Slow animation duration (300ms).
  ///
  /// For more substantial transitions like modal appearances,
  /// page transitions, and complex state changes.
  static const transitionSlow = DurationToken('radix.transition.slow');
}

/// Creates a MixScope with Radix design tokens configured for the specified theme.
///
/// This function sets up the complete Radix token system with resolved color values
/// based on the chosen accent color, gray scale, and brightness settings.
/// All [RadixTokens] must be used within this scope to have actual values.
///
/// **Theme Configuration:**
/// - [accent]: The accent color scale (indigo, blue, red, etc.)
/// - [gray]: The neutral gray scale with different undertones
/// - [brightness]: Light or dark mode
///
/// **Color Theory:**
/// The Radix color system is based on perceptual uniformity and accessibility:
/// - Each color scale has 12 steps with semantic meaning
/// - Colors are designed to work together harmoniously
/// - Alpha variants provide translucency without losing saturation
/// - Dark mode uses different algorithms to maintain contrast ratios
///
/// Example:
/// ```dart
/// createRadixScope(
///   accent: RadixAccentColor.blue,
///   gray: RadixGrayColor.slate,
///   brightness: Brightness.light,
///   child: MyApp(),
/// )
/// ```
///
/// The scope provides access to all design tokens through Mix styles:
/// ```dart
/// Style(
///   $box.color.ref(RadixTokens.accent9),     // Solid accent
///   $text.color.ref(RadixTokens.gray12),      // High contrast text
///   $box.padding.ref(RadixTokens.space4),     // 16px padding
///   $box.shadow.ref(RadixTokens.shadow2),     // Subtle elevation
/// )
/// ```
Widget createRadixScope({
  RadixAccentColor accent = RadixAccentColor.indigo,
  RadixGrayColor gray = RadixGrayColor.slate,
  Brightness brightness = Brightness.light,
  List<Type>? orderOfModifiers,
  required Widget child,
}) {
  final theme = RadixThemeConfig(
    accent: accent,
    gray: gray,
    brightness: brightness,
  );

  final tokens = resolveRadixTokens(theme);

  final colorTokens = {
    RadixTokens.colorBackground: tokens.colorBackground,
    RadixTokens.colorSurface: tokens.colorSurface,
    RadixTokens.colorPanelSolid: tokens.colorPanelSolid,
    RadixTokens.colorPanelTranslucent: tokens.colorPanelTranslucent,
    RadixTokens.colorOverlay: tokens.colorOverlay,
    RadixTokens.accentSurface: tokens.accent.surface,
    RadixTokens.accentIndicator: tokens.accent.indicator,
    RadixTokens.accentTrack: tokens.accent.track,
    RadixTokens.accentContrast: tokens.accent.contrast,
    RadixTokens.focus8: tokens.focus8,
    RadixTokens.focusA8: tokens.focusA8,
    RadixTokens.accent1: tokens.accent.scale.step(1),
    RadixTokens.accent2: tokens.accent.scale.step(2),
    RadixTokens.accent3: tokens.accent.scale.step(3),
    RadixTokens.accent4: tokens.accent.scale.step(4),
    RadixTokens.accent5: tokens.accent.scale.step(5),
    RadixTokens.accent6: tokens.accent.scale.step(6),
    RadixTokens.accent7: tokens.accent.scale.step(7),
    RadixTokens.accent8: tokens.accent.scale.step(8),
    RadixTokens.accent9: tokens.accent.scale.step(9),
    RadixTokens.accent10: tokens.accent.scale.step(10),
    RadixTokens.accent11: tokens.accent.scale.step(11),
    RadixTokens.accent12: tokens.accent.scale.step(12),
    RadixTokens.gray1: tokens.gray.scale.step(1),
    RadixTokens.gray2: tokens.gray.scale.step(2),
    RadixTokens.gray3: tokens.gray.scale.step(3),
    RadixTokens.gray4: tokens.gray.scale.step(4),
    RadixTokens.gray5: tokens.gray.scale.step(5),
    RadixTokens.gray6: tokens.gray.scale.step(6),
    RadixTokens.gray7: tokens.gray.scale.step(7),
    RadixTokens.gray8: tokens.gray.scale.step(8),
    RadixTokens.gray9: tokens.gray.scale.step(9),
    RadixTokens.gray10: tokens.gray.scale.step(10),
    RadixTokens.gray11: tokens.gray.scale.step(11),
    RadixTokens.gray12: tokens.gray.scale.step(12),
    // Gray role tokens (from resolved colors)
    RadixTokens.graySurface: tokens.gray.surface,
    RadixTokens.grayIndicator: tokens.gray.indicator,
    RadixTokens.grayTrack: tokens.gray.track,
    RadixTokens.grayContrast: tokens.gray.contrast,
    RadixTokens.accentA3: tokens.accent.scale.alphaStep(3),
    RadixTokens.accentA4: tokens.accent.scale.alphaStep(4),
    RadixTokens.accentA8: tokens.accent.scale.alphaStep(8),
    // Neutral helpers derived from primitives (not stored in RadixThemeColors)
    RadixTokens.grayA6: tokens.gray.scale.alphaStep(6),
    RadixTokens.blackA3: tokens.blackAlpha[3]!,
    RadixTokens.blackA4: tokens.blackAlpha[4]!,
    RadixTokens.blackA5: tokens.blackAlpha[5]!,
    RadixTokens.blackA6: tokens.blackAlpha[6]!,
    RadixTokens.blackA7: tokens.blackAlpha[7]!,
    RadixTokens.blackA11: tokens.blackAlpha[11]!,
    // Shadow stroke (OKLab mix)
    RadixTokens.shadowStroke: computeShadowStroke(tokens.gray.scale),
  };

  // Build base tokens map
  final allTokens = <MixToken, Object>{
    ...colorTokens,
    // Defaults (may be overridden by JSON tokens below)
    RadixTokens.space1: 4.0,
    RadixTokens.space2: 8.0,
    RadixTokens.space3: 12.0,
    RadixTokens.space4: 16.0,
    RadixTokens.space5: 24.0,
    RadixTokens.space6: 32.0,
    RadixTokens.space7: 40.0,
    RadixTokens.space8: 48.0,
    RadixTokens.space9: 64.0,
    RadixTokens.radius1: const Radius.circular(3.0),
    RadixTokens.radius2: const Radius.circular(4.0),
    RadixTokens.radius3: const Radius.circular(6.0),
    RadixTokens.radius4: const Radius.circular(8.0),
    RadixTokens.radius5: const Radius.circular(12.0),
    RadixTokens.radius6: const Radius.circular(16.0),
    RadixTokens.radiusFull: const Radius.circular(9999.0),

    // Shadow lists
    // Layered shadows approximating Radix Themes CSS tokens
    // shadow-1: Radix uses inset layers; Flutter lacks inset. Approximate with subtle stroke + small ambient.
    RadixTokens.shadow1: [
      BoxShadow(
        color: RadixTokens.grayA6(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: RadixTokens.blackA5(),
        offset: const Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ],
    // shadow-2
    RadixTokens.shadow2: [
      // 0 0 0 1px color-mix(in oklab, gray-a6, gray-6 25%)
      BoxShadow(
        color: RadixTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 0 0 0.5px black-a3 -> approximate with small blur instead of half-px spread
      BoxShadow(
        color: RadixTokens.blackA3(),
        offset: const Offset(0, 0),
        blurRadius: 0.5,
        spreadRadius: 0,
      ),
      // 0 1px 1px 0 black-a6
      BoxShadow(
        color: RadixTokens.blackA6(),
        offset: const Offset(0, 1),
        blurRadius: 1,
        spreadRadius: 0,
      ),
      // 0 2px 1px -1px black-a6
      BoxShadow(
        color: RadixTokens.blackA6(),
        offset: const Offset(0, 2),
        blurRadius: 1,
        spreadRadius: -1,
      ),
      // 0 1px 3px 0 black-a5
      BoxShadow(
        color: RadixTokens.blackA5(),
        offset: const Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
    ],
    // shadow-3
    RadixTokens.shadow3: [
      BoxShadow(
        color: RadixTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 2px 3px -2px black-a3
      BoxShadow(
        color: RadixTokens.blackA3(),
        offset: const Offset(0, 2),
        blurRadius: 3,
        spreadRadius: -2,
      ),
      // 0 3px 8px -2px black-a6
      BoxShadow(
        color: RadixTokens.blackA6(),
        offset: const Offset(0, 3),
        blurRadius: 8,
        spreadRadius: -2,
      ),
      // 0 4px 12px -4px black-a7
      BoxShadow(
        color: RadixTokens.blackA7(),
        offset: const Offset(0, 4),
        blurRadius: 12,
        spreadRadius: -4,
      ),
    ],
    // shadow-4
    RadixTokens.shadow4: [
      BoxShadow(
        color: RadixTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 8px 40px black-a3
      BoxShadow(
        color: RadixTokens.blackA3(),
        offset: const Offset(0, 8),
        blurRadius: 40,
        spreadRadius: 0,
      ),
      // 0 12px 32px -16px black-a5
      BoxShadow(
        color: RadixTokens.blackA5(),
        offset: const Offset(0, 12),
        blurRadius: 32,
        spreadRadius: -16,
      ),
    ],
    // shadow-5
    RadixTokens.shadow5: [
      BoxShadow(
        color: RadixTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 12px 60px black-a5
      BoxShadow(
        color: RadixTokens.blackA5(),
        offset: const Offset(0, 12),
        blurRadius: 60,
        spreadRadius: 0,
      ),
      // 0 12px 32px -16px black-a7
      BoxShadow(
        color: RadixTokens.blackA7(),
        offset: const Offset(0, 12),
        blurRadius: 32,
        spreadRadius: -16,
      ),
    ],
    // shadow-6
    RadixTokens.shadow6: [
      BoxShadow(
        color: RadixTokens.shadowStroke(),
        offset: const Offset(0, 0),
        blurRadius: 0,
        spreadRadius: 1,
      ),
      // 0 12px 60px black-a4
      BoxShadow(
        color: RadixTokens.blackA4(),
        offset: const Offset(0, 12),
        blurRadius: 60,
        spreadRadius: 0,
      ),
      // 0 16px 64px black-a6
      BoxShadow(
        color: RadixTokens.blackA6(),
        offset: const Offset(0, 16),
        blurRadius: 64,
        spreadRadius: 0,
      ),
      // 0 16px 36px -20px black-a11
      BoxShadow(
        color: RadixTokens.blackA11(),
        offset: const Offset(0, 16),
        blurRadius: 36,
        spreadRadius: -20,
      ),
    ],
    RadixTokens.borderWidth1: 1.0,
    RadixTokens.borderWidth2: 2.0,
    RadixTokens.focusRingWidth: 2.0,
    RadixTokens.text1: TextStyleMix(
      fontSize: 12.0,
      letterSpacing: 0.0025 * 12.0,
      height: 16.0 / 12.0,
    ),
    RadixTokens.text2:
        TextStyleMix(fontSize: 14.0, letterSpacing: 0.0, height: 20.0 / 14.0),
    RadixTokens.text3:
        TextStyleMix(fontSize: 16.0, letterSpacing: 0.0, height: 24.0 / 16.0),
    RadixTokens.text4: TextStyleMix(
      fontSize: 18.0,
      letterSpacing: -0.0025 * 18.0,
      height: 26.0 / 18.0,
    ),
    RadixTokens.text5: TextStyleMix(
      fontSize: 20.0,
      letterSpacing: -0.005 * 20.0,
      height: 28.0 / 20.0,
    ),
    RadixTokens.text6: TextStyleMix(
      fontSize: 24.0,
      letterSpacing: -0.00625 * 24.0,
      height: 30.0 / 24.0,
    ),
    RadixTokens.text7: TextStyleMix(
      fontSize: 28.0,
      letterSpacing: -0.0075 * 28.0,
      height: 36.0 / 28.0,
    ),
    RadixTokens.text8: TextStyleMix(
      fontSize: 35.0,
      letterSpacing: -0.01 * 35.0,
      height: 40.0 / 35.0,
    ),
    RadixTokens.text9:
        TextStyleMix(fontSize: 60.0, letterSpacing: -0.025 * 60.0, height: 1.0),

    // Font weights (token values)
    RadixTokens.fontWeightLight: FontWeight.w300,
    RadixTokens.fontWeightRegular: FontWeight.w400,
    RadixTokens.fontWeightMedium: FontWeight.w500,
    // Match Radix Themes font weights (bold = 700)
    RadixTokens.fontWeightBold: FontWeight.w700,

    // Durations (token values)
    RadixTokens.transitionFast: Duration(milliseconds: 100),
    RadixTokens.transitionSlow: Duration(milliseconds: 300),
  };

  return MixScope(
    tokens: allTokens,
    orderOfModifiers: orderOfModifiers,
    child: child,
  );
}

// OKLab mixing implemented in computed.dart; no helper here.

/// Available accent colors matching Radix Themes names.
enum RadixAccentColor {
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
enum RadixGrayColor {
  gray,
  mauve,
  slate,
  sage,
  olive,
  sand,
}

/// Immutable configuration object for Radix theme settings.
///
/// Provides a convenient way to store and pass around theme configuration,
/// including methods to create variants and apply the theme to widgets.
/// This is useful when you need to switch themes dynamically or pass
/// theme configuration through your app.
///
/// Example:
/// ```dart
/// const theme = RadixThemeConfig(
///   accent: RadixAccentColor.green,
///   gray: RadixGrayColor.sage,
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
class RadixThemeConfig {
  final RadixAccentColor accent;
  final RadixGrayColor gray;
  final Brightness brightness;

  const RadixThemeConfig({
    this.accent = RadixAccentColor.indigo,
    this.gray = RadixGrayColor.slate,
    this.brightness = Brightness.light,
  });

  bool get isDark => brightness == Brightness.dark;

  RadixThemeConfig copyWith({
    RadixAccentColor? accent,
    RadixGrayColor? gray,
    Brightness? brightness,
  }) =>
      RadixThemeConfig(
        accent: accent ?? this.accent,
        gray: gray ?? this.gray,
        brightness: brightness ?? this.brightness,
      );

  Widget createScope({List<Type>? orderOfModifiers, required Widget child}) =>
      createRadixScope(
        accent: accent,
        gray: gray,
        brightness: brightness,
        orderOfModifiers: orderOfModifiers,
        child: child,
      );
}
