import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// Design tokens for the Remix component library.
///
/// Provides a centralized system for colors, spacing, typography, and other
/// design values that can be used across all Remix components. These tokens
/// integrate with the Mix framework's token system for theme-aware styling.
class RemixTokens {
  // ============================================================================
  // COLOR TOKENS
  // ============================================================================

  /// Primary brand color used for main actions and emphasis
  static const primary = MixToken<Color>('remix.color.primary');

  /// Secondary color for supporting actions and elements
  static const secondary = MixToken<Color>('remix.color.secondary');

  /// Success color for positive actions and states
  static const success = MixToken<Color>('remix.color.success');

  /// Warning color for cautionary actions and states
  static const warning = MixToken<Color>('remix.color.warning');

  /// Danger/error color for destructive actions and error states
  static const danger = MixToken<Color>('remix.color.danger');

  // Surface colors
  /// Main background color for the app
  static const background = MixToken<Color>('remix.color.background');

  /// Surface color for cards, sheets, and elevated elements
  static const surface = MixToken<Color>('remix.color.surface');

  /// Subtle surface color for secondary backgrounds
  static const surfaceVariant = MixToken<Color>('remix.color.surface.variant');

  // Border colors
  /// Primary border color for inputs and dividers
  static const border = MixToken<Color>('remix.color.border');

  /// Subtle border color for secondary divisions
  static const borderSubtle = MixToken<Color>('remix.color.border.subtle');

  // Text colors
  /// Primary text color for main content
  static const textPrimary = MixToken<Color>('remix.color.text.primary');

  /// Secondary text color for supporting content
  static const textSecondary = MixToken<Color>('remix.color.text.secondary');

  /// Tertiary text color for least prominent content
  static const textTertiary = MixToken<Color>('remix.color.text.tertiary');

  /// Disabled text color
  static const textDisabled = MixToken<Color>('remix.color.text.disabled');

  // ============================================================================
  // SPACING TOKENS
  // ============================================================================

  /// Extra small spacing: 4px
  static const spaceXs = MixToken<double>('remix.space.xs');

  /// Small spacing: 8px
  static const spaceSm = MixToken<double>('remix.space.sm');

  /// Medium spacing: 12px
  static const spaceMd = MixToken<double>('remix.space.md');

  /// Large spacing: 16px
  static const spaceLg = MixToken<double>('remix.space.lg');

  /// Extra large spacing: 24px
  static const spaceXl = MixToken<double>('remix.space.xl');

  /// Extra extra large spacing: 32px
  static const spaceXxl = MixToken<double>('remix.space.xxl');

  // ============================================================================
  // BORDER RADIUS TOKENS
  // ============================================================================

  /// Small border radius: 4px - for badges, chips
  static const radiusSm = MixToken<double>('remix.radius.sm');

  /// Medium border radius: 6px - for inputs, textfields
  static const radiusMd = MixToken<double>('remix.radius.md');

  /// Large border radius: 8px - for buttons, cards
  static const radiusLg = MixToken<double>('remix.radius.lg');

  /// Extra large border radius: 12px - for prominent elements
  static const radiusXl = MixToken<double>('remix.radius.xl');

  // ============================================================================
  // TYPOGRAPHY TOKENS
  // ============================================================================

  /// Font size for small text: 12px
  static const fontSizeSm = MixToken<double>('remix.font.size.sm');

  /// Font size for body text: 14px
  static const fontSizeMd = MixToken<double>('remix.font.size.md');

  /// Font size for large text: 16px
  static const fontSizeLg = MixToken<double>('remix.font.size.lg');

  /// Font size for extra large text: 18px
  static const fontSizeXl = MixToken<double>('remix.font.size.xl');

  // ============================================================================
  // ELEVATION TOKENS (for shadows)
  // ============================================================================

  /// Low elevation shadow
  static const elevationLow =
      MixToken<List<BoxShadowMix>>('remix.elevation.low');

  /// Medium elevation shadow
  static const elevationMd = MixToken<List<BoxShadowMix>>('remix.elevation.md');

  /// High elevation shadow
  static const elevationHigh =
      MixToken<List<BoxShadowMix>>('remix.elevation.high');

  // ============================================================================
  // ICON SIZE TOKENS
  // ============================================================================

  /// Small icon size: 14px
  static const iconSizeSm = MixToken<double>('remix.icon.size.sm');

  /// Medium icon size: 16px
  static const iconSizeMd = MixToken<double>('remix.icon.size.md');

  /// Large icon size: 18px
  static const iconSizeLg = MixToken<double>('remix.icon.size.lg');

  /// Extra large icon size: 20px
  static const iconSizeXl = MixToken<double>('remix.icon.size.xl');

  const RemixTokens._();
}
