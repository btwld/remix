import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'remix_tokens.dart';

/// Provides pre-configured token definitions for light and dark themes.
///
/// These token definitions map [RemixTokens] to actual values, enabling
/// theme-aware styling across all Remix components.

// ============================================================================
// LIGHT THEME DEFINITIONS
// ============================================================================

/// Light theme token definitions for the Remix design system.
///
/// Provides a clean, professional light theme with high contrast for readability
/// and accessibility.
final Set<TokenDefinition> remixLightTokens = {
  // Color tokens - Light theme
  RemixTokens.primary.defineValue(const Color(0xFF2563EB)), // Blue-600
  RemixTokens.secondary.defineValue(const Color(0xFF6B7280)), // Gray-500
  RemixTokens.success.defineValue(const Color(0xFF059669)), // Green-600
  RemixTokens.warning.defineValue(const Color(0xFFD97706)), // Amber-600
  RemixTokens.danger.defineValue(const Color(0xFFDC2626)), // Red-600

  // Surface colors - Light theme
  RemixTokens.background.defineValue(Colors.white),
  RemixTokens.surface.defineValue(const Color(0xFFF9FAFB)), // Gray-50
  RemixTokens.surfaceVariant.defineValue(const Color(0xFFF3F4F6)), // Gray-100

  // Border colors - Light theme
  RemixTokens.border.defineValue(const Color(0xFFE5E7EB)), // Gray-200
  RemixTokens.borderSubtle.defineValue(const Color(0xFFF3F4F6)), // Gray-100

  // Text colors - Light theme
  RemixTokens.textPrimary.defineValue(const Color(0xFF111827)), // Gray-900
  RemixTokens.textSecondary.defineValue(const Color(0xFF6B7280)), // Gray-500
  RemixTokens.textTertiary.defineValue(const Color(0xFF9CA3AF)), // Gray-400
  RemixTokens.textDisabled.defineValue(const Color(0xFFD1D5DB)), // Gray-300

  // Spacing tokens (same for both themes)
  RemixTokens.spaceXs.defineValue(4.0),
  RemixTokens.spaceSm.defineValue(8.0),
  RemixTokens.spaceMd.defineValue(12.0),
  RemixTokens.spaceLg.defineValue(16.0),
  RemixTokens.spaceXl.defineValue(24.0),
  RemixTokens.spaceXxl.defineValue(32.0),

  // Border radius tokens (same for both themes)
  RemixTokens.radiusSm.defineValue(4.0),
  RemixTokens.radiusMd.defineValue(6.0),
  RemixTokens.radiusLg.defineValue(8.0),
  RemixTokens.radiusXl.defineValue(12.0),

  // Typography tokens (same for both themes)
  RemixTokens.fontSizeSm.defineValue(12.0),
  RemixTokens.fontSizeMd.defineValue(14.0),
  RemixTokens.fontSizeLg.defineValue(16.0),
  RemixTokens.fontSizeXl.defineValue(18.0),

  // Icon size tokens (same for both themes)
  RemixTokens.iconSizeSm.defineValue(14.0),
  RemixTokens.iconSizeMd.defineValue(16.0),
  RemixTokens.iconSizeLg.defineValue(18.0),
  RemixTokens.iconSizeXl.defineValue(20.0),

  // Elevation tokens - Light theme
  RemixTokens.elevationLow.defineValue([
    BoxShadowMix(
      color: Colors.black.withValues(alpha: 0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ]),
  RemixTokens.elevationMd.defineValue([
    BoxShadowMix(
      color: Colors.black.withValues(alpha: 0.1),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ]),
  RemixTokens.elevationHigh.defineValue([
    BoxShadowMix(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ]),
};

// ============================================================================
// DARK THEME DEFINITIONS
// ============================================================================

/// Dark theme token definitions for the Remix design system.
///
/// Provides a modern dark theme with appropriate contrast and visual hierarchy
/// for comfortable viewing in low-light environments.
final Set<TokenDefinition> remixDarkTokens = {
  // Color tokens - Dark theme (adapted for dark backgrounds)
  RemixTokens.primary
      .defineValue(const Color(0xFF3B82F6)), // Blue-500 (slightly lighter)
  RemixTokens.secondary.defineValue(const Color(0xFF9CA3AF)), // Gray-400
  RemixTokens.success.defineValue(const Color(0xFF10B981)), // Green-500
  RemixTokens.warning.defineValue(const Color(0xFFF59E0B)), // Amber-500
  RemixTokens.danger.defineValue(const Color(0xFFEF4444)), // Red-500

  // Surface colors - Dark theme
  RemixTokens.background.defineValue(const Color(0xFF111827)), // Gray-900
  RemixTokens.surface.defineValue(const Color(0xFF1F2937)), // Gray-800
  RemixTokens.surfaceVariant.defineValue(const Color(0xFF374151)), // Gray-700

  // Border colors - Dark theme
  RemixTokens.border.defineValue(const Color(0xFF374151)), // Gray-700
  RemixTokens.borderSubtle.defineValue(const Color(0xFF4B5563)), // Gray-600

  // Text colors - Dark theme
  RemixTokens.textPrimary.defineValue(const Color(0xFFF9FAFB)), // Gray-50
  RemixTokens.textSecondary.defineValue(const Color(0xFFD1D5DB)), // Gray-300
  RemixTokens.textTertiary.defineValue(const Color(0xFF9CA3AF)), // Gray-400
  RemixTokens.textDisabled.defineValue(const Color(0xFF6B7280)), // Gray-500

  // Spacing tokens (same for both themes)
  RemixTokens.spaceXs.defineValue(4.0),
  RemixTokens.spaceSm.defineValue(8.0),
  RemixTokens.spaceMd.defineValue(12.0),
  RemixTokens.spaceLg.defineValue(16.0),
  RemixTokens.spaceXl.defineValue(24.0),
  RemixTokens.spaceXxl.defineValue(32.0),

  // Border radius tokens (same for both themes)
  RemixTokens.radiusSm.defineValue(4.0),
  RemixTokens.radiusMd.defineValue(6.0),
  RemixTokens.radiusLg.defineValue(8.0),
  RemixTokens.radiusXl.defineValue(12.0),

  // Typography tokens (same for both themes)
  RemixTokens.fontSizeSm.defineValue(12.0),
  RemixTokens.fontSizeMd.defineValue(14.0),
  RemixTokens.fontSizeLg.defineValue(16.0),
  RemixTokens.fontSizeXl.defineValue(18.0),

  // Icon size tokens (same for both themes)
  RemixTokens.iconSizeSm.defineValue(14.0),
  RemixTokens.iconSizeMd.defineValue(16.0),
  RemixTokens.iconSizeLg.defineValue(18.0),
  RemixTokens.iconSizeXl.defineValue(20.0),

  // Elevation tokens - Dark theme (more subtle shadows)
  RemixTokens.elevationLow.defineValue([
    BoxShadowMix(
      color: Colors.black.withValues(alpha: 0.3),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ]),
  RemixTokens.elevationMd.defineValue([
    BoxShadowMix(
      color: Colors.black.withValues(alpha: 0.4),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ]),
  RemixTokens.elevationHigh.defineValue([
    BoxShadowMix(
      color: Colors.black.withValues(alpha: 0.5),
      offset: const Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ]),
};

// ============================================================================
// THEME UTILITIES
// ============================================================================

/// Determines the appropriate token set based on the current brightness.
///
/// This utility function checks the platform brightness and returns the
/// corresponding token definitions.
Set<TokenDefinition> getRemixTokensForBrightness(Brightness brightness) {
  return brightness == Brightness.dark ? remixDarkTokens : remixLightTokens;
}

/// Creates a MixScope with Remix tokens configured for the current theme.
///
/// This is a convenience function that sets up a MixScope with the appropriate
/// Remix tokens based on the context's brightness.
Widget createRemixScope({
  required Widget child,
  Set<TokenDefinition>? additionalTokens,
  List<Type>? orderOfModifiers,
  Key? key,
}) {
  return Builder(
    builder: (context) {
      final brightness = MediaQuery.of(context).platformBrightness;
      final remixTokens = getRemixTokensForBrightness(brightness);
      final allTokens = {...remixTokens, ...?additionalTokens};

      return MixScope(
        key: key,
        tokens: allTokens,
        orderOfModifiers: orderOfModifiers,
        child: child,
      );
    },
  );
}
