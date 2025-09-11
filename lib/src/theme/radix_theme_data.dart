// ABOUTME: RadixThemeData class for managing Radix theme configuration and state
// ABOUTME: Provides centralized theme management with automatic tokens resolution

import 'package:flutter/material.dart';

import '../utilities/radix_token_resolver.dart' as resolver;

/// Configuration data for a Radix theme.
///
/// Contains the theme settings (accent color, gray scale, brightness) and
/// provides access to computed token values through the RadixTokenBuilder.
@immutable
class RadixThemeData {
  final resolver.RadixAccentColor accent;
  final resolver.RadixGrayColor gray;
  final Brightness brightness;
  final resolver.TrackVariant trackVariant;

  // Computed token values (cached for performance)
  final resolver.RadixTokens _tokens;
  final resolver.RadixComponentTokens _componentTokens;

  const RadixThemeData._({
    required this.accent,
    required this.gray,
    required this.brightness,
    required this.trackVariant,
    required resolver.RadixTokens tokens,
    required resolver.RadixComponentTokens componentTokens,
  })  : _tokens = tokens,
        _componentTokens = componentTokens;

  /// Creates a new RadixThemeData with the specified configuration.
  factory RadixThemeData({
    resolver.RadixAccentColor accent = resolver.RadixAccentColor.indigo,
    resolver.RadixGrayColor gray = resolver.RadixGrayColor.slate,
    Brightness brightness = Brightness.light,
    resolver.TrackVariant trackVariant = resolver.TrackVariant.neutral,
  }) {
    final theme = resolver.RadixTheme(
      accent: accent,
      gray: gray,
      isDark: brightness == Brightness.dark,
      trackVariant: trackVariant,
    );

    final tokens = resolver.RadixTokenBuilder.build(theme);
    final componentTokens =
        resolver.RadixTokenBuilder.buildComponentTokens(tokens);

    return RadixThemeData._(
      accent: accent,
      gray: gray,
      brightness: brightness,
      trackVariant: trackVariant,
      tokens: tokens,
      componentTokens: componentTokens,
    );
  }

  /// Whether this theme is in dark mode
  bool get isDark => brightness == Brightness.dark;

  /// Access to computed token values
  resolver.RadixTokens get tokens => _tokens;

  /// Access to computed component variant tokens
  resolver.RadixComponentTokens get componentTokens => _componentTokens;

  /// Creates a copy of this theme data with the given fields replaced.
  RadixThemeData copyWith({
    resolver.RadixAccentColor? accent,
    resolver.RadixGrayColor? gray,
    Brightness? brightness,
    resolver.TrackVariant? trackVariant,
  }) {
    return RadixThemeData(
      accent: accent ?? this.accent,
      gray: gray ?? this.gray,
      brightness: brightness ?? this.brightness,
      trackVariant: trackVariant ?? this.trackVariant,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;

    return other is RadixThemeData &&
        other.accent == accent &&
        other.gray == gray &&
        other.brightness == brightness &&
        other.trackVariant == trackVariant;
  }

  @override
  int get hashCode => Object.hash(accent, gray, brightness, trackVariant);
}

/// Provider widget for RadixThemeData.
///
/// Supplies RadixThemeData to descendant widgets through InheritedWidget.
/// Also sets up the Mix token definitions for the theme.
class RadixTheme extends InheritedWidget {
  const RadixTheme({
    super.key,
    required this.themeData,
    required super.child,
  });

  /// Creates a RadixTheme with default configuration.
  RadixTheme.light({
    super.key,
    resolver.RadixAccentColor accent = resolver.RadixAccentColor.indigo,
    resolver.RadixGrayColor gray = resolver.RadixGrayColor.slate,
    resolver.TrackVariant trackVariant = resolver.TrackVariant.neutral,
    required super.child,
  }) : themeData = RadixThemeData(
          accent: accent,
          gray: gray,
          brightness: Brightness.light,
          trackVariant: trackVariant,
        );

  /// Creates a RadixTheme with dark mode configuration.
  RadixTheme.dark({
    super.key,
    resolver.RadixAccentColor accent = resolver.RadixAccentColor.indigo,
    resolver.RadixGrayColor gray = resolver.RadixGrayColor.slate,
    resolver.TrackVariant trackVariant = resolver.TrackVariant.neutral,
    required super.child,
  }) : themeData = RadixThemeData(
          accent: accent,
          gray: gray,
          brightness: Brightness.dark,
          trackVariant: trackVariant,
        );

  /// Get the closest RadixTheme in the widget tree.
  static RadixThemeData of(BuildContext context) {
    final theme = context.dependOnInheritedWidgetOfExactType<RadixTheme>();
    if (theme == null) {
      throw FlutterError(
        'RadixTheme.of() was called with a context that does not contain a RadixTheme.\n'
        'Make sure to wrap your app with a RadixTheme widget.',
      );
    }

    return theme.themeData;
  }

  /// Get the closest RadixTheme in the widget tree, or null if not found.
  static RadixThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RadixTheme>()?.themeData;
  }

  final RadixThemeData themeData;

  @override
  bool updateShouldNotify(RadixTheme oldWidget) {
    return themeData != oldWidget.themeData;
  }
}

/// Extension to easily access RadixThemeData from BuildContext.
extension RadixThemeExtension on BuildContext {
  /// Get the current RadixThemeData.
  RadixThemeData get radixTheme => RadixTheme.of(this);

  /// Get the current RadixThemeData, or null if not found.
  RadixThemeData? get radixThemeOrNull => RadixTheme.maybeOf(this);
}
