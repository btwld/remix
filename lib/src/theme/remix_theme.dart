import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'remix_tokens.dart';

/// Provides pre-configured token definitions for light and dark themes.
///
/// These token definitions map [RemixTokens] to actual values, enabling
/// theme-aware styling across all Remix components.

// ============================================================================
// LIGHT/DARK TOKEN DEFINITIONS (minimal set per refactor plan)
// ============================================================================
final Set<TokenDefinition> remixLightTokens = {
  // Colors (light)
  RemixTokens.primary.defineValue(const Color(0xFF000000)), // Black
  RemixTokens.onPrimary.defineValue(const Color(0xFFFFFFFF)), // White
  RemixTokens.secondary.defineValue(const Color(0xFF6B7280)), // Gray-500
  RemixTokens.onSecondary.defineValue(const Color(0xFFFFFFFF)),

  // Spacing (static)
  RemixTokens.spaceXs.defineValue(4.0),
  RemixTokens.spaceSm.defineValue(8.0),
  RemixTokens.spaceMd.defineValue(12.0),
  RemixTokens.spaceLg.defineValue(16.0),

  // Radius (static)
  SpaceTokens.radius.defineValue(8.0),
};

final Set<TokenDefinition> remixDarkTokens = {
  // Colors (dark)
  RemixTokens.primary.defineValue(const Color(0xFFFFFFFF)), // White
  RemixTokens.onPrimary.defineValue(const Color(0xFF111827)), // Gray-900
  RemixTokens.secondary.defineValue(const Color(0xFF9CA3AF)), // Gray-400
  RemixTokens.onSecondary.defineValue(const Color(0xFF111827)),

  // Spacing (static)
  RemixTokens.spaceXs.defineValue(4.0),
  RemixTokens.spaceSm.defineValue(8.0),
  RemixTokens.spaceMd.defineValue(12.0),
  RemixTokens.spaceLg.defineValue(16.0),

  // Radius (static)
  SpaceTokens.radius.defineValue(8.0),
};

// ============================================================================
// THEME UTILITIES
// ============================================================================

/// Creates a MixScope with Remix tokens configured for the current theme.
///
/// Resolves the token set based on Theme brightness.
Widget createRemixScope({
  required Widget child,
  Set<TokenDefinition>? additionalTokens,
  List<Type>? orderOfModifiers,
  Key? key,
}) {
  return Builder(builder: (context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final baseTokens =
        brightness == Brightness.dark ? remixDarkTokens : remixLightTokens;
    final allTokens = {...baseTokens, ...?additionalTokens};

    return MixScope(
      key: key,
      tokens: allTokens,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  });
}
