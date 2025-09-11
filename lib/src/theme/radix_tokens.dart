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
  static const colorBackground = MixToken<Color>('radix.color.background');
  
  /// Input and form control surface color
  static const colorSurface = MixToken<Color>('radix.color.surface');
  
  /// Cards, tables, menus (solid panels)
  static const colorPanelSolid = MixToken<Color>('radix.color.panel.solid');
  
  /// Translucent panels when panelBackground='translucent'
  static const colorPanelTranslucent = MixToken<Color>('radix.color.panel.translucent');
  
  /// Dialog scrims/overlays
  static const colorOverlay = MixToken<Color>('radix.color.overlay');

  // =============================================================================
  // ACCENT FUNCTIONAL TOKENS
  // =============================================================================
  
  /// Toned accent surface for surface variants
  static const accentSurface = MixToken<Color>('radix.accent.surface');
  
  /// Filled parts like progress indicators (step 9)
  static const accentIndicator = MixToken<Color>('radix.accent.indicator');
  
  /// Tracks/rails for sliders, progress, switches
  static const accentTrack = MixToken<Color>('radix.accent.track');
  
  /// Legible text on accent solid backgrounds
  static const accentContrast = MixToken<Color>('radix.accent.contrast');

  // =============================================================================
  // FOCUS TOKENS
  // =============================================================================
  
  /// Visible outline color for focus states
  static const focus8 = MixToken<Color>('radix.focus.8');
  
  /// Focus ring color with alpha for layering
  static const focusA8 = MixToken<Color>('radix.focus.a8');

  // =============================================================================
  // SOLID VARIANT TOKENS
  // =============================================================================
  
  /// Solid variant base background
  static const solidBackground = MixToken<Color>('radix.solid.background');
  
  /// Solid variant hover background
  static const solidBackgroundHover = MixToken<Color>('radix.solid.background.hover');
  
  /// Solid variant text color
  static const solidText = MixToken<Color>('radix.solid.text');
  
  /// Solid variant focus ring
  static const solidFocusRing = MixToken<Color>('radix.solid.focus.ring');

  // =============================================================================
  // SOFT VARIANT TOKENS
  // =============================================================================
  
  /// Soft variant base background
  static const softBackground = MixToken<Color>('radix.soft.background');
  
  /// Soft variant hover background
  static const softBackgroundHover = MixToken<Color>('radix.soft.background.hover');
  
  /// Soft variant active background
  static const softBackgroundActive = MixToken<Color>('radix.soft.background.active');
  
  /// Soft variant border color
  static const softBorder = MixToken<Color>('radix.soft.border');
  
  /// Soft variant border hover color
  static const softBorderHover = MixToken<Color>('radix.soft.border.hover');
  
  /// Soft variant text color
  static const softText = MixToken<Color>('radix.soft.text');
  
  /// Soft variant focus ring
  static const softFocusRing = MixToken<Color>('radix.soft.focus.ring');

  // =============================================================================
  // SURFACE VARIANT TOKENS
  // =============================================================================
  
  /// Surface variant base background
  static const surfaceBackground = MixToken<Color>('radix.surface.background');
  
  /// Surface variant hover background
  static const surfaceBackgroundHover = MixToken<Color>('radix.surface.background.hover');
  
  /// Surface variant border color
  static const surfaceBorder = MixToken<Color>('radix.surface.border');
  
  /// Surface variant border hover color
  static const surfaceBorderHover = MixToken<Color>('radix.surface.border.hover');
  
  /// Surface variant text color
  static const surfaceText = MixToken<Color>('radix.surface.text');
  
  /// Surface variant focus ring
  static const surfaceFocusRing = MixToken<Color>('radix.surface.focus.ring');

  // =============================================================================
  // OUTLINE VARIANT TOKENS
  // =============================================================================
  
  /// Outline variant base background (transparent)
  static const outlineBackground = MixToken<Color>('radix.outline.background');
  
  /// Outline variant hover background
  static const outlineBackgroundHover = MixToken<Color>('radix.outline.background.hover');
  
  /// Outline variant border color
  static const outlineBorder = MixToken<Color>('radix.outline.border');
  
  /// Outline variant border hover color
  static const outlineBorderHover = MixToken<Color>('radix.outline.border.hover');
  
  /// Outline variant text color
  static const outlineText = MixToken<Color>('radix.outline.text');
  
  /// Outline variant focus ring
  static const outlineFocusRing = MixToken<Color>('radix.outline.focus.ring');

  // =============================================================================
  // GHOST VARIANT TOKENS
  // =============================================================================
  
  /// Ghost variant base background (transparent)
  static const ghostBackground = MixToken<Color>('radix.ghost.background');
  
  /// Ghost variant hover background
  static const ghostBackgroundHover = MixToken<Color>('radix.ghost.background.hover');
  
  /// Ghost variant active background
  static const ghostBackgroundActive = MixToken<Color>('radix.ghost.background.active');
  
  /// Ghost variant text color
  static const ghostText = MixToken<Color>('radix.ghost.text');
  
  /// Ghost variant focus ring
  static const ghostFocusRing = MixToken<Color>('radix.ghost.focus.ring');

  // =============================================================================
  // CLASSIC VARIANT TOKENS
  // =============================================================================
  
  /// Classic variant base background
  static const classicBackground = MixToken<Color>('radix.classic.background');
  
  /// Classic variant hover background
  static const classicBackgroundHover = MixToken<Color>('radix.classic.background.hover');
  
  /// Classic variant border color
  static const classicBorder = MixToken<Color>('radix.classic.border');
  
  /// Classic variant border hover color
  static const classicBorderHover = MixToken<Color>('radix.classic.border.hover');
  
  /// Classic variant text color (neutral gray)
  static const classicText = MixToken<Color>('radix.classic.text');
  
  /// Classic variant focus ring
  static const classicFocusRing = MixToken<Color>('radix.classic.focus.ring');

  // =============================================================================
  // SIZE TOKENS
  // =============================================================================
  
  /// Size 1: Small button dimensions
  static const size1FontSize = MixToken<double>('radix.size.1.font.size');
  static const size1PaddingX = MixToken<double>('radix.size.1.padding.x');
  static const size1PaddingY = MixToken<double>('radix.size.1.padding.y');
  static const size1IconSize = MixToken<double>('radix.size.1.icon.size');
  
  /// Size 2: Medium button dimensions
  static const size2FontSize = MixToken<double>('radix.size.2.font.size');
  static const size2PaddingX = MixToken<double>('radix.size.2.padding.x');
  static const size2PaddingY = MixToken<double>('radix.size.2.padding.y');
  static const size2IconSize = MixToken<double>('radix.size.2.icon.size');
  
  /// Size 3: Large button dimensions
  static const size3FontSize = MixToken<double>('radix.size.3.font.size');
  static const size3PaddingX = MixToken<double>('radix.size.3.padding.x');
  static const size3PaddingY = MixToken<double>('radix.size.3.padding.y');
  static const size3IconSize = MixToken<double>('radix.size.3.icon.size');
  
  /// Size 4: Extra large button dimensions
  static const size4FontSize = MixToken<double>('radix.size.4.font.size');
  static const size4PaddingX = MixToken<double>('radix.size.4.padding.x');
  static const size4PaddingY = MixToken<double>('radix.size.4.padding.y');
  static const size4IconSize = MixToken<double>('radix.size.4.icon.size');

  const RadixTokens._();
}