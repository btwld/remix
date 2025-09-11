// ABOUTME: Factory for creating RemixProgressStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix progress variants with proper token-based styling

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
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
  /// Used for standard progress indicators. Compose with size methods like .size2().
  static RemixProgressStyle classic() {
    return RemixProgressStyle()
        // Container styling - no size properties
        .container(
          BoxStyler()
              .width(double.infinity),
        )
        // Track styling (background bar)
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull()))
              .width(double.infinity),
        )
        // Indicator styling (progress fill)
        .indicator(
          BoxStyler()
              .color(RadixTokens.accentIndicator()) // accent9 equivalent
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        );
  }

  /// Creates a surface variant progress style.
  ///
  /// Surface progress uses the same colors as classic.
  /// Used for forms with consistent visual appearance. Compose with size methods like .size2().
  static RemixProgressStyle surface() {
    return RemixProgressStyle()
        // Container styling - no size properties
        .container(
          BoxStyler()
              .width(double.infinity),
        )
        // Track styling (background bar) - same as classic
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull()))
              .width(double.infinity),
        )
        // Indicator styling (progress fill) - same as classic
        .indicator(
          BoxStyler()
              .color(RadixTokens.accentIndicator()) // accent9 equivalent
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        );
  }

  /// Creates a soft variant progress style.
  ///
  /// Soft progress uses accent color scale for track and indicator.
  /// Used for progress indicators that need accent color integration. Compose with size methods like .size2().
  static RemixProgressStyle soft() {
    return RemixProgressStyle()
        // Container styling - no size properties
        .container(
          BoxStyler()
              .width(double.infinity),
        )
        // Track styling (background bar) - uses accent4 instead of gray
        .track(
          BoxStyler()
              .color(RadixTokens.accent4())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull()))
              .width(double.infinity),
        )
        // Indicator styling (progress fill) - uses accent9
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        );
  }

  /// Creates size 1 progress style.
  ///
  /// Smallest progress size with 4px height.
  static RemixProgressStyle size1() {
    return RemixProgressStyle()
        .container(
          BoxStyler().height(4.0),
        )
        .track(
          BoxStyler()
              .height(4.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius1())),
        )
        .indicator(
          BoxStyler()
              .height(4.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius1())),
        );
  }

  /// Creates size 2 progress style.
  ///
  /// Default progress size with 8px height.
  static RemixProgressStyle size2() {
    return RemixProgressStyle()
        .container(
          BoxStyler().height(8.0),
        )
        .track(
          BoxStyler()
              .height(8.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
        )
        .indicator(
          BoxStyler()
              .height(8.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
        );
  }

  /// Creates size 3 progress style.
  ///
  /// Largest progress size with 12px height.
  static RemixProgressStyle size3() {
    return RemixProgressStyle()
        .container(
          BoxStyler().height(12.0),
        )
        .track(
          BoxStyler()
              .height(12.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
        )
        .indicator(
          BoxStyler()
              .height(12.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
        );
  }
}

/// Extension methods for sizing progress components.
extension RadixProgressStyleExt on RemixProgressStyle {
  /// Applies size 1 styling (4px height).
  RemixProgressStyle size1() => merge(RadixProgressStyles.size1());

  /// Applies size 2 styling (8px height).
  RemixProgressStyle size2() => merge(RadixProgressStyles.size2());

  /// Applies size 3 styling (12px height).
  RemixProgressStyle size3() => merge(RadixProgressStyles.size3());
}
