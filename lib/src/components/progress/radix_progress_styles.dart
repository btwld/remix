// ABOUTME: Factory for creating RemixProgressStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix progress variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'progress.dart';

/// Factory class for creating Radix-compliant progress styles.
///
/// Provides static methods to create RemixProgressStyle instances for all
/// Radix UI progress variants using the RadixTokens system.
class RadixProgressStyles {
  const RadixProgressStyles._();

  /// Creates a classic variant progress style.
  ///
  /// Classic progress uses accent track and indicator colors.
  /// Used for standard progress indicators.
  static RemixProgressStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixProgressStyle()
        // Container styling
        .container(
          BoxStyler()
              .width(double.infinity)
              .height(sizeConfig.height),
        )
        // Track styling (background bar)
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(RadixTokens.radiusFull())
              .width(double.infinity)
              .height(sizeConfig.height),
        )
        // Indicator styling (progress fill)
        .indicator(
          BoxStyler()
              .color(RadixTokens.accentIndicator()) // accent9 equivalent
              .borderRadius(RadixTokens.radiusFull())
              .height(sizeConfig.height),
        );
  }

  /// Creates a surface variant progress style.
  ///
  /// Surface progress uses the same colors as classic.
  /// Used for forms with consistent visual appearance.
  static RemixProgressStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixProgressStyle()
        // Container styling
        .container(
          BoxStyler()
              .width(double.infinity)
              .height(sizeConfig.height),
        )
        // Track styling (background bar) - same as classic
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(RadixTokens.radiusFull())
              .width(double.infinity)
              .height(sizeConfig.height),
        )
        // Indicator styling (progress fill) - same as classic
        .indicator(
          BoxStyler()
              .color(RadixTokens.accentIndicator()) // accent9 equivalent
              .borderRadius(RadixTokens.radiusFull())
              .height(sizeConfig.height),
        );
  }

  /// Creates a soft variant progress style.
  ///
  /// Soft progress uses accent color scale for track and indicator.
  /// Used for progress indicators that need accent color integration.
  static RemixProgressStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixProgressStyle()
        // Container styling
        .container(
          BoxStyler()
              .width(double.infinity)
              .height(sizeConfig.height),
        )
        // Track styling (background bar) - uses accent4 instead of gray
        .track(
          BoxStyler()
              .color(RadixTokens.accent4())
              .borderRadius(RadixTokens.radiusFull())
              .width(double.infinity)
              .height(sizeConfig.height),
        )
        // Indicator styling (progress fill) - uses accent9
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(RadixTokens.radiusFull())
              .height(sizeConfig.height),
        );
  }

  /// Gets size configuration for the given size index.
  static _ProgressSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _ProgressSizeConfig(
          height: 4.0,
        );
      case 2:
        return _ProgressSizeConfig(
          height: 6.0,
        );
      case 3:
        return _ProgressSizeConfig(
          height: 8.0,
        );
      default:
        // Default to size 2 if invalid size provided
        return _ProgressSizeConfig(
          height: 6.0,
        );
    }
  }
}

/// Internal configuration for progress sizes.
class _ProgressSizeConfig {
  final double height;

  const _ProgressSizeConfig({
    required this.height,
  });
}