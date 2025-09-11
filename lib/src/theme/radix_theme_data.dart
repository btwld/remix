// ABOUTME: Simplified Radix theme system that creates MixScope directly with typed maps
// ABOUTME: Eliminates unnecessary abstraction layers and follows Mix 2.0 patterns

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../utilities/radix_token_resolver.dart' as resolver;
import 'radix_tokens.dart';

/// Creates a MixScope with Radix design tokens configured for the specified theme.
///
/// This function directly creates typed token maps and passes them to MixScope,
/// following Mix 2.0 patterns and eliminating unnecessary abstraction layers.
///
/// Example usage:
/// ```dart
/// createRadixScope(
///   accent: RadixAccentColor.indigo,
///   gray: RadixGrayColor.slate,
///   brightness: Brightness.light,
///   child: MyApp(),
/// )
/// ```
Widget createRadixScope({
  resolver.RadixAccentColor accent = resolver.RadixAccentColor.indigo,
  resolver.RadixGrayColor gray = resolver.RadixGrayColor.slate,
  Brightness brightness = Brightness.light,
  resolver.TrackVariant trackVariant = resolver.TrackVariant.neutral,
  List<Type>? orderOfModifiers,
  required Widget child,
}) {
  // Create theme configuration
  final theme = resolver.RadixTheme(
    accent: accent,
    gray: gray,
    isDark: brightness == Brightness.dark,
    trackVariant: trackVariant,
  );

  // Compute color tokens
  final tokens = resolver.RadixTokenBuilder.build(theme);

  // Create typed token maps for MixScope
  final colorTokens = {
    // Core background tokens
    RadixTokens.colorBackground: tokens.colorBackground,
    RadixTokens.colorSurface: tokens.colorSurface,
    RadixTokens.colorPanelSolid: tokens.colorPanelSolid,
    RadixTokens.colorPanelTranslucent: tokens.colorPanelTranslucent,
    RadixTokens.colorOverlay: tokens.colorOverlay,

    // Accent functional tokens
    RadixTokens.accentSurface: tokens.accentSurface,
    RadixTokens.accentIndicator: tokens.accentIndicator,
    RadixTokens.accentTrack: tokens.accentTrack,
    RadixTokens.accentContrast: tokens.accentContrast,

    // Focus tokens
    RadixTokens.focus8: tokens.focus.step(8),
    RadixTokens.focusA8: tokens.focus.alphaStep(8),

    // Accent scale tokens (direct access to color scales)
    RadixTokens.accent1: tokens.accent.step(1),
    RadixTokens.accent2: tokens.accent.step(2),
    RadixTokens.accent3: tokens.accent.step(3),
    RadixTokens.accent4: tokens.accent.step(4),
    RadixTokens.accent5: tokens.accent.step(5),
    RadixTokens.accent6: tokens.accent.step(6),
    RadixTokens.accent7: tokens.accent.step(7),
    RadixTokens.accent8: tokens.accent.step(8),
    RadixTokens.accent9: tokens.accent.step(9),
    RadixTokens.accent10: tokens.accent.step(10),
    RadixTokens.accent11: tokens.accent.step(11),
    RadixTokens.accent12: tokens.accent.step(12),

    // Gray scale tokens (direct access to color scales)
    RadixTokens.gray1: tokens.gray.step(1),
    RadixTokens.gray2: tokens.gray.step(2),
    RadixTokens.gray3: tokens.gray.step(3),
    RadixTokens.gray4: tokens.gray.step(4),
    RadixTokens.gray5: tokens.gray.step(5),
    RadixTokens.gray6: tokens.gray.step(6),
    RadixTokens.gray7: tokens.gray.step(7),
    RadixTokens.gray8: tokens.gray.step(8),
    RadixTokens.gray9: tokens.gray.step(9),
    RadixTokens.gray10: tokens.gray.step(10),
    RadixTokens.gray11: tokens.gray.step(11),
    RadixTokens.gray12: tokens.gray.step(12),

    // Alpha scale tokens (commonly used alpha steps)
    RadixTokens.accentA3: tokens.accent.alphaStep(3),
    RadixTokens.accentA4: tokens.accent.alphaStep(4),
    RadixTokens.accentA8: tokens.accent.alphaStep(8),

  };

  // Combine all tokens into single Map<MixToken, Object>
  final allTokens = <MixToken, Object>{
    // Color tokens
    ...colorTokens.map((key, value) => MapEntry(key, value)),

    // Space tokens
    RadixTokens.space1: 4.0,
    RadixTokens.space2: 8.0,
    RadixTokens.space3: 12.0,
    RadixTokens.space4: 16.0,
    RadixTokens.space5: 20.0,
    RadixTokens.space6: 24.0,
    RadixTokens.space7: 28.0,
    RadixTokens.space8: 32.0,
    RadixTokens.space9: 36.0,

    // Radius tokens
    RadixTokens.radius1: const Radius.circular(3.0),
    RadixTokens.radius2: const Radius.circular(4.0),
    RadixTokens.radius3: const Radius.circular(6.0),
    RadixTokens.radius4: const Radius.circular(8.0),
    RadixTokens.radius5: const Radius.circular(12.0),
    RadixTokens.radius6: const Radius.circular(16.0),
    RadixTokens.radiusFull: const Radius.circular(9999.0),

    // Border widths
    RadixTokens.borderWidth1: 1.0,
    RadixTokens.borderWidth2: 2.0,

    // Note: Font weights are now direct constants, not tokens

    // Focus ring width
    RadixTokens.focusRingWidth: 2.0,

    // Note: Transitions are now direct constants, not tokens
  };

  // Create MixScope with single tokens map (simpler approach)
  return MixScope(
    tokens: allTokens,
    orderOfModifiers: orderOfModifiers,
    child: child,
  );
}

/// Configuration data for a Radix theme.
///
/// This is kept as a simple data class for cases where you need to pass
/// theme configuration around, but the main API is now `createRadixScope()`.
@immutable
class RadixThemeConfig {
  final resolver.RadixAccentColor accent;
  final resolver.RadixGrayColor gray;
  final Brightness brightness;
  final resolver.TrackVariant trackVariant;

  const RadixThemeConfig({
    this.accent = resolver.RadixAccentColor.indigo,
    this.gray = resolver.RadixGrayColor.slate,
    this.brightness = Brightness.light,
    this.trackVariant = resolver.TrackVariant.neutral,
  });

  /// Whether this theme is in dark mode
  bool get isDark => brightness == Brightness.dark;

  /// Creates a copy of this config with the given fields replaced.
  RadixThemeConfig copyWith({
    resolver.RadixAccentColor? accent,
    resolver.RadixGrayColor? gray,
    Brightness? brightness,
    resolver.TrackVariant? trackVariant,
  }) {
    return RadixThemeConfig(
      accent: accent ?? this.accent,
      gray: gray ?? this.gray,
      brightness: brightness ?? this.brightness,
      trackVariant: trackVariant ?? this.trackVariant,
    );
  }

  /// Creates a MixScope with this theme configuration
  Widget createScope({List<Type>? orderOfModifiers, required Widget child}) {
    return createRadixScope(
      accent: accent,
      gray: gray,
      brightness: brightness,
      trackVariant: trackVariant,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is RadixThemeConfig &&
        other.accent == accent &&
        other.gray == gray &&
        other.brightness == brightness &&
        other.trackVariant == trackVariant;
  }

  @override
  int get hashCode => Object.hash(accent, gray, brightness, trackVariant);
}
