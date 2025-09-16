// ABOUTME: Factory constructors for RemixProgressStyle variants using Radix design tokens
// ABOUTME: Provides RadixProgressStyle subclass with variant + size aware composition

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'progress.dart';

enum RadixProgressSize {
  size1,
  size2,
  size3,
}

enum RadixProgressVariant {
  classic,
  surface,
  soft,
}

/// RadixProgressStyle utility class for creating Radix-themed progress styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Radix token JSON.
class RadixProgressStyle {
  const RadixProgressStyle._();

  /// Factory constructor for RadixProgressStyle with variant and size parameters.
  ///
  /// Returns a RemixProgressStyle configured with Radix design tokens.
  /// Defaults to classic variant with size2.
  static RemixProgressStyle create({
    RadixProgressVariant variant = RadixProgressVariant.classic,
    RadixProgressSize size = RadixProgressSize.size2,
  }) {
    return switch (variant) {
      RadixProgressVariant.classic => classic(size: size),
      RadixProgressVariant.surface => surface(size: size),
      RadixProgressVariant.soft => soft(size: size),
    };
  }

  static RemixProgressStyle base({
    RadixProgressSize size = RadixProgressSize.size2,
  }) {
    return RemixProgressStyle()
        // Container styling - no focus for progress
        .container(BoxStyler().width(double.infinity))
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixProgressStyle classic({
    RadixProgressSize size = RadixProgressSize.size2,
  }) {
    return base(size: size)
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

  static RemixProgressStyle surface({
    RadixProgressSize size = RadixProgressSize.size2,
  }) {
    return base(size: size)
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

  static RemixProgressStyle soft({
    RadixProgressSize size = RadixProgressSize.size2,
  }) {
    return base(size: size)
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


  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixProgressStyle _sizeStyle(RadixProgressSize size) {
    return switch (size) {
      RadixProgressSize.size1 => RemixProgressStyle()
          .container(BoxStyler().height(4.0))
          .track(
            BoxStyler()
                .height(4.0)
                .borderRadius(BorderRadiusMix.all(RadixTokens.radius1())),
          )
          .indicator(
            BoxStyler()
                .height(4.0)
                .borderRadius(BorderRadiusMix.all(RadixTokens.radius1())),
          ),
      RadixProgressSize.size2 => RemixProgressStyle()
          .container(BoxStyler().height(8.0))
          .track(
            BoxStyler()
                .height(8.0)
                .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
          )
          .indicator(
            BoxStyler()
                .height(8.0)
                .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
          ),
      RadixProgressSize.size3 => RemixProgressStyle()
          .container(BoxStyler().height(12.0))
          .track(
            BoxStyler()
                .height(12.0)
                .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
          )
          .indicator(
            BoxStyler()
                .height(12.0)
                .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
          ),
    };
  }
}

