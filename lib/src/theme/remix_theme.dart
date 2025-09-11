// ABOUTME: Legacy Remix theme system that now uses RadixTokens internally
// ABOUTME: Provides backward compatibility while leveraging the comprehensive Radix design system

import 'package:flutter/material.dart';

import '../radix/radix.dart' as resolver;
import '../radix/radix_theme.dart';

/// Creates a MixScope with legacy Remix tokens, now powered by RadixTokens.
///
/// **DEPRECATED**: This function now uses createRadixScope internally for
/// better design system consistency. New applications should use createRadixScope
/// directly with RadixTokens.
///
/// This function automatically adapts to the current theme brightness and provides
/// sensible defaults for accent and gray colors.
///
/// Example usage:
/// ```dart
/// createRemixScope(
///   child: MyApp(),
/// )
/// ```
Widget createRemixScope({
  required Widget child,
  List<Type>? orderOfModifiers,
  resolver.RadixAccentColor accent = resolver.RadixAccentColor.indigo,
  resolver.RadixGrayColor gray = resolver.RadixGrayColor.slate,
}) {
  return Builder(builder: (context) {
    // Determine theme brightness
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    // Use createRadixScope which provides all the token values
    // RemixTokens now just references RadixTokens, so this provides everything
    return createRadixScope(
      accent: accent,
      gray: gray,
      brightness: brightness,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  });
}

/// Configuration data for a legacy Remix theme.
///
/// **DEPRECATED**: This class is maintained for backward compatibility.
/// New applications should use createRadixScope() directly.
@immutable
class RemixThemeConfig {
  final resolver.RadixAccentColor accent;
  final resolver.RadixGrayColor gray;

  const RemixThemeConfig({
    this.accent = resolver.RadixAccentColor.indigo,
    this.gray = resolver.RadixGrayColor.slate,
  });

  /// Creates a MixScope with this theme configuration
  Widget createScope({List<Type>? orderOfModifiers, required Widget child}) {
    return createRemixScope(
      orderOfModifiers: orderOfModifiers,
      accent: accent,
      gray: gray,
      child: child,
    );
  }

  /// Creates a copy of this config with the given fields replaced.
  RemixThemeConfig copyWith({
    resolver.RadixAccentColor? accent,
    resolver.RadixGrayColor? gray,
  }) {
    return RemixThemeConfig(
      accent: accent ?? this.accent,
      gray: gray ?? this.gray,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is RemixThemeConfig &&
        other.accent == accent &&
        other.gray == gray;
  }

  @override
  int get hashCode => Object.hash(accent, gray);
}
