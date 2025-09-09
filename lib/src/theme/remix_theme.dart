import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'remix_tokens.dart';

/// Provides token definitions using adaptive tokens for theme-aware styling.
///
/// Adaptive tokens automatically resolve values based on the current theme
/// brightness, so a single token set can be used for both light and dark.

// ============================================================================
// ADAPTIVE + STATIC TOKEN DEFINITIONS (minimal set)
// ============================================================================
final Set<TokenDefinition> remixTokens = {
  // Colors (adaptive)
  RemixTokens.primary.defineAdaptive(
    light: MixColors.black,
    dark: MixColors.white,
  ),
  RemixTokens.onPrimary.defineAdaptive(
    light: MixColors.white,
    dark: MixColors.greySwatch[900]!,
  ),
  RemixTokens.secondary.defineAdaptive(
    light: MixColors.greySwatch[500]!,
    dark: MixColors.greySwatch[400]!,
  ),
  RemixTokens.onSecondary.defineAdaptive(
    light: MixColors.white,
    dark: MixColors.greySwatch[900]!,
  ),

  // Spacing (static)
  RemixTokens.spaceXs.defineValue(4.0),
  RemixTokens.spaceSm.defineValue(8.0),
  RemixTokens.spaceMd.defineValue(12.0),
  RemixTokens.spaceLg.defineValue(16.0),

  // Radius (static)
  RemixTokens.radius.defineValue(Radius.circular(8.0)),
};

// ============================================================================
// THEME UTILITIES
// ============================================================================

/// Creates a MixScope with Remix tokens configured for the current theme.
Widget createRemixScope({
  required Widget child,
  Set<TokenDefinition>? additionalTokens,
  List<Type>? orderOfModifiers,
}) {
  return Builder(builder: (context) {
    final allTokens = {...remixTokens, ...?additionalTokens};

    final scope = MixScope(
      tokens: allTokens,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );

    // Ensure MediaQuery.platformBrightness matches Theme brightness for token resolution

    return scope;
  });
}
