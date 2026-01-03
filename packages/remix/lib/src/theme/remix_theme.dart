import 'package:flutter/material.dart';

import '../fortal/fortal.dart' as fortal;
import '../fortal/fortal_theme.dart';

/// Creates a MixScope with legacy Remix tokens, now powered by FortalTokens.
///
/// **DEPRECATED**: This function now uses createFortalScope internally for
/// better design system consistency. New applications should use createFortalScope
/// directly with FortalTokens.
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
  fortal.FortalAccentColor accent = fortal.FortalAccentColor.indigo,
  fortal.FortalGrayColor gray = fortal.FortalGrayColor.slate,
  Brightness? brightnessOverride,
}) {
  return Builder(builder: (context) {
    // Determine brightness, prioritizing explicit override and platform
    final brightness = resolveRemixBrightness(
      context,
      brightnessOverride: brightnessOverride,
    );

    // Use createFortalScope which provides all the token values
    return createFortalScope(
      accent: accent,
      gray: gray,
      brightness: brightness,
      orderOfModifiers: orderOfModifiers,
      child: child,
    );
  });
}

@visibleForTesting
Brightness resolveRemixBrightness(
  BuildContext context, {
  Brightness? brightnessOverride,
}) {
  final theme = Theme.of(context);
  final maybeMediaQuery = MediaQuery.maybeOf(context);

  return resolveRemixBrightnessValues(
    brightnessOverride: brightnessOverride,
    mediaQuery: maybeMediaQuery,
    themeBrightness: theme.brightness,
  );
}

@visibleForTesting
Brightness resolveRemixBrightnessValues({
  Brightness? brightnessOverride,
  MediaQueryData? mediaQuery,
  Brightness? themeBrightness,
}) {
  if (brightnessOverride != null) {
    return brightnessOverride;
  }

  if (mediaQuery != null) {
    return mediaQuery.platformBrightness;
  }

  if (themeBrightness != null) {
    return themeBrightness;
  }

  return Brightness.light;
}

/// Configuration data for a legacy Remix theme.
///
/// **DEPRECATED**: This class is maintained for backward compatibility.
/// New applications should use createFortalScope() directly.
@immutable
class RemixThemeConfig {
  final fortal.FortalAccentColor accent;
  final fortal.FortalGrayColor gray;

  const RemixThemeConfig({
    this.accent = fortal.FortalAccentColor.indigo,
    this.gray = fortal.FortalGrayColor.slate,
  });

  /// Creates a MixScope with this theme configuration
  Widget createScope({
    List<Type>? orderOfModifiers,
    Brightness? brightnessOverride,
    required Widget child,
  }) {
    return createRemixScope(
      orderOfModifiers: orderOfModifiers,
      accent: accent,
      gray: gray,
      brightnessOverride: brightnessOverride,
      child: child,
    );
  }

  /// Creates a copy of this config with the given fields replaced.
  RemixThemeConfig copyWith({
    fortal.FortalAccentColor? accent,
    fortal.FortalGrayColor? gray,
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
