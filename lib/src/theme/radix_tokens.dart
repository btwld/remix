// ABOUTME: Defines MixToken constants for all Radix UI semantic design tokens
// ABOUTME: Provides type-safe token references that resolve through Mix theme system

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// Radix UI design tokens using Mix token system.
///
/// These tokens provide semantic color references that automatically adapt
/// to the current RadixTheme configuration (accent color, gray scale, light/dark mode).
/// All tokens resolve to actual color values through the Mix theme system.
class RadixTokens {
  // =============================================================================
  // CORE BACKGROUND TOKENS
  // =============================================================================
  
  /// Page background color
  static const colorBackground = ColorToken('radix.color.background');
  
  /// Input and form control surface color
  static const colorSurface = ColorToken('radix.color.surface');
  
  /// Cards, tables, menus (solid panels)
  static const colorPanelSolid = ColorToken('radix.color.panel.solid');
  
  /// Translucent panels when panelBackground='translucent'
  static const colorPanelTranslucent = ColorToken('radix.color.panel.translucent');
  
  /// Dialog scrims/overlays
  static const colorOverlay = ColorToken('radix.color.overlay');

  // =============================================================================
  // ACCENT FUNCTIONAL TOKENS
  // =============================================================================
  
  /// Toned accent surface for surface variants
  static const accentSurface = ColorToken('radix.accent.surface');
  
  /// Filled parts like progress indicators (step 9)
  static const accentIndicator = ColorToken('radix.accent.indicator');
  
  /// Tracks/rails for sliders, progress, switches
  static const accentTrack = ColorToken('radix.accent.track');
  
  /// Legible text on accent solid backgrounds
  static const accentContrast = ColorToken('radix.accent.contrast');

  // =============================================================================
  // FOCUS TOKENS
  // =============================================================================
  
  /// Visible outline color for focus states
  static const focus8 = ColorToken('radix.focus.8');
  
  /// Focus ring color with alpha for layering
  static const focusA8 = ColorToken('radix.focus.a8');

  // =============================================================================
  // ACCENT COLOR SCALE TOKENS (12-step scale)
  // =============================================================================
  
  /// Accent step 1: App background
  static const accent1 = ColorToken('radix.accent.1');
  
  /// Accent step 2: Subtle background
  static const accent2 = ColorToken('radix.accent.2');
  
  /// Accent step 3: UI element background
  static const accent3 = ColorToken('radix.accent.3');
  
  /// Accent step 4: Hovered UI element background
  static const accent4 = ColorToken('radix.accent.4');
  
  /// Accent step 5: Active / Selected UI element background
  static const accent5 = ColorToken('radix.accent.5');
  
  /// Accent step 6: Subtle borders and separators
  static const accent6 = ColorToken('radix.accent.6');
  
  /// Accent step 7: UI element border and focus rings
  static const accent7 = ColorToken('radix.accent.7');
  
  /// Accent step 8: Hovered UI element border
  static const accent8 = ColorToken('radix.accent.8');
  
  /// Accent step 9: Solid backgrounds
  static const accent9 = ColorToken('radix.accent.9');
  
  /// Accent step 10: Hovered solid backgrounds
  static const accent10 = ColorToken('radix.accent.10');
  
  /// Accent step 11: Low-contrast text
  static const accent11 = ColorToken('radix.accent.11');
  
  /// Accent step 12: High-contrast text
  static const accent12 = ColorToken('radix.accent.12');

  // =============================================================================
  // GRAY COLOR SCALE TOKENS (12-step scale)
  // =============================================================================
  
  /// Gray step 1: App background
  static const gray1 = ColorToken('radix.gray.1');
  
  /// Gray step 2: Subtle background
  static const gray2 = ColorToken('radix.gray.2');
  
  /// Gray step 3: UI element background
  static const gray3 = ColorToken('radix.gray.3');
  
  /// Gray step 4: Hovered UI element background
  static const gray4 = ColorToken('radix.gray.4');
  
  /// Gray step 5: Active / Selected UI element background
  static const gray5 = ColorToken('radix.gray.5');
  
  /// Gray step 6: Subtle borders and separators
  static const gray6 = ColorToken('radix.gray.6');
  
  /// Gray step 7: UI element border and focus rings
  static const gray7 = ColorToken('radix.gray.7');
  
  /// Gray step 8: Hovered UI element border
  static const gray8 = ColorToken('radix.gray.8');
  
  /// Gray step 9: Solid backgrounds
  static const gray9 = ColorToken('radix.gray.9');
  
  /// Gray step 10: Hovered solid backgrounds
  static const gray10 = ColorToken('radix.gray.10');
  
  /// Gray step 11: Low-contrast text
  static const gray11 = ColorToken('radix.gray.11');
  
  /// Gray step 12: High-contrast text
  static const gray12 = ColorToken('radix.gray.12');

  // =============================================================================
  // ALPHA COLOR SCALE TOKENS (commonly used alpha steps)
  // =============================================================================
  
  /// Accent alpha step 3: Subtle transparent backgrounds
  static const accentA3 = ColorToken('radix.accent.a3');
  
  /// Accent alpha step 4: UI element transparent backgrounds
  static const accentA4 = ColorToken('radix.accent.a4');
  
  /// Accent alpha step 8: Focus rings and borders
  static const accentA8 = ColorToken('radix.accent.a8');

  // =============================================================================
  // SPACE SCALE TOKENS (9-step scale: 4px to 64px)
  // =============================================================================
  
  /// Space step 1: 4px
  static const space1 = SpaceToken('radix.space.1');
  
  /// Space step 2: 8px
  static const space2 = SpaceToken('radix.space.2');
  
  /// Space step 3: 12px
  static const space3 = SpaceToken('radix.space.3');
  
  /// Space step 4: 16px
  static const space4 = SpaceToken('radix.space.4');
  
  /// Space step 5: 24px
  static const space5 = SpaceToken('radix.space.5');
  
  /// Space step 6: 32px
  static const space6 = SpaceToken('radix.space.6');
  
  /// Space step 7: 40px
  static const space7 = SpaceToken('radix.space.7');
  
  /// Space step 8: 48px
  static const space8 = SpaceToken('radix.space.8');
  
  /// Space step 9: 64px
  static const space9 = SpaceToken('radix.space.9');

  // =============================================================================
  // RADIUS SCALE TOKENS (6 steps + full)
  // =============================================================================
  
  /// Radius step 1: 3px
  static const radius1 = RadiusToken('radix.radius.1');
  
  /// Radius step 2: 4px
  static const radius2 = RadiusToken('radix.radius.2');
  
  /// Radius step 3: 6px
  static const radius3 = RadiusToken('radix.radius.3');
  
  /// Radius step 4: 8px
  static const radius4 = RadiusToken('radix.radius.4');
  
  /// Radius step 5: 12px
  static const radius5 = RadiusToken('radix.radius.5');
  
  /// Radius step 6: 16px
  static const radius6 = RadiusToken('radix.radius.6');
  
  /// Full radius: 9999px (pill shape)
  static const radiusFull = RadiusToken('radix.radius.full');

  // COMMENTED OUT: Typography tokens - not used in current codebase
  // /// Text style step 1: 12px/16px/0.0025em
  // static const text1 = TextStyleToken('radix.text.1');
  // /// Text style step 2: 14px/20px/0em
  // static const text2 = TextStyleToken('radix.text.2');
  // /// Text style step 3: 16px/24px/0em
  // static const text3 = TextStyleToken('radix.text.3');
  // /// Text style step 4: 18px/26px/-0.0025em
  // static const text4 = TextStyleToken('radix.text.4');
  // /// Text style step 5: 20px/28px/-0.005em
  // static const text5 = TextStyleToken('radix.text.5');
  // /// Text style step 6: 24px/30px/-0.00625em
  // static const text6 = TextStyleToken('radix.text.6');
  // /// Text style step 7: 28px/36px/-0.0075em
  // static const text7 = TextStyleToken('radix.text.7');
  // /// Text style step 8: 35px/40px/-0.01em
  // static const text8 = TextStyleToken('radix.text.8');
  // /// Text style step 9: 60px/60px/-0.025em
  // static const text9 = TextStyleToken('radix.text.9');
  
  // COMMENTED OUT: Individual typography tokens consolidated into text1-9 above
  // /// Line height step 1: 16px
  // static const lineHeight1 = MixToken<double>('radix.line.height.1');
  // /// Line height step 2: 20px
  // static const lineHeight2 = MixToken<double>('radix.line.height.2');
  // ... (all lineHeight tokens commented out)
  
  // /// Letter spacing step 1: 0.0025em
  // static const letterSpacing1 = MixToken<double>('radix.letter.spacing.1');
  // ... (all letterSpacing tokens commented out)
  
  // =============================================================================
  // FONT WEIGHT CONSTANTS (regular Flutter types)
  // =============================================================================
  
  /// Font weight: Regular (400)
  static const fontWeightRegular = FontWeight.w400;
  
  /// Font weight: Medium (500)
  static const fontWeightMedium = FontWeight.w500;
  
  /// Font weight: Bold (600)
  static const fontWeightBold = FontWeight.w600;

  // =============================================================================
  // VISUAL EFFECT TOKENS
  // =============================================================================
  
  // COMMENTED OUT: Shadow tokens - not used in current codebase
  // /// Shadow level 1: Subtle elevation
  // static const shadow1 = BoxShadowToken('radix.shadow.1');
  // /// Shadow level 2: Low elevation
  // static const shadow2 = BoxShadowToken('radix.shadow.2');
  // /// Shadow level 3: Medium elevation
  // static const shadow3 = BoxShadowToken('radix.shadow.3');
  // /// Shadow level 4: High elevation
  // static const shadow4 = BoxShadowToken('radix.shadow.4');
  // /// Shadow level 5: Very high elevation
  // static const shadow5 = BoxShadowToken('radix.shadow.5');
  // /// Shadow level 6: Maximum elevation
  // static const shadow6 = BoxShadowToken('radix.shadow.6');
  
  /// Border width: 1px
  static const borderWidth1 = SpaceToken('radix.border.width.1');
  
  /// Border width: 2px
  static const borderWidth2 = SpaceToken('radix.border.width.2');
  
  // =============================================================================
  // DURATION CONSTANTS (regular Flutter types)
  // =============================================================================
  
  /// Transition: Fast (100ms)
  static const transitionFast = Duration(milliseconds: 100);
  
  /// Transition: Slow (300ms)
  static const transitionSlow = Duration(milliseconds: 300);
  
  /// Focus ring width: 2px
  static const focusRingWidth = SpaceToken('radix.focus.ring.width');
  
  /// Focus ring offset: 2px
  static const focusRingOffset = SpaceToken('radix.focus.ring.offset');

  // COMMENTED OUT: Size tokens - not used in current codebase
  // /// Size 1: Small component dimensions
  // static const size1Height = SpaceToken('radix.size.1.height');
  // static const size1PaddingX = SpaceToken('radix.size.1.padding.x');
  // static const size1PaddingY = SpaceToken('radix.size.1.padding.y');
  // static const size1Gap = SpaceToken('radix.size.1.gap');
  // static const size1FontSize = SpaceToken('radix.size.1.font.size');
  // static const size1LineHeight = SpaceToken('radix.size.1.line.height');
  // static const size1LetterSpacing = SpaceToken('radix.size.1.letter.spacing');
  // static const size1Radius = RadiusToken('radix.size.1.radius');
  // static const size1IconSize = SpaceToken('radix.size.1.icon.size');
  // (Similar for size2, size3, size4 - all commented out)

  const RadixTokens._();
}