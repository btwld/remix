import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

/// Design tokens for the Remix component library.
///
/// Provides a centralized system for colors, spacing, typography, and other
/// design values that can be used across all Remix components. These tokens
/// integrate with the Mix framework's token system for theme-aware styling.
class RemixTokens {
  // ============================================================================
  // MINIMAL COLOR TOKENS (ADAPTIVE)
  // ============================================================================

  /// Primary color for main emphasis and solid surfaces
  static const primary = MixToken<Color>('remix.color.primary');

  /// Foreground that sits on top of [primary]
  static const onPrimary = MixToken<Color>('remix.color.onPrimary');

  /// Secondary neutral/supporting color (outlines, subtle UI)
  static const secondary = MixToken<Color>('remix.color.secondary');


  /// Foreground that sits on top of [secondary]
  static const onSecondary = MixToken<Color>('remix.color.onSecondary');

  // ============================================================================
  // MINIMAL SPACING TOKENS
  // ============================================================================
  static const spaceXs = MixToken<double>('remix.space.xs');
  static const spaceSm = MixToken<double>('remix.space.sm');
  static const spaceMd = MixToken<double>('remix.space.md');
  static const spaceLg = MixToken<double>('remix.space.lg');

  // ============================================================================
  // SHAPE TOKENS
  // ============================================================================
  /// Shared border radius value as a concrete Radius.
  /// Use with BorderRadiusMix.all(RemixTokens.radius())
  static const radius = MixToken<Radius>('remix.radius');

  const RemixTokens._();
}

/// Opacity/alpha tokens to normalize UI overlays and subtle elements
// Opacity tokens removed; keep only muted color tokens above.
