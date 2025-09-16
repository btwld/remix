// ABOUTME: Factory for creating RemixBadgeStyle instances using Radix design tokens
// ABOUTME: Provides 4 Radix badge variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'badge.dart';


enum RadixBadgeSize {
  size1,
  size2,
  size3,
}

enum RadixBadgeVariant {
  solid,
  soft,
  surface,
  outline,
}

/// Factory class for creating Radix-compliant badge styles.
///
/// Provides static methods to create RemixBadgeStyle instances for all
/// Radix UI badge variants using the RadixTokens system.
class RadixBadgeStyles {
  const RadixBadgeStyles._();

  /// Factory constructor for RadixBadgeStyle with variant and size parameters.
  ///
  /// Returns a RemixBadgeStyle configured with Radix design tokens.
  /// Defaults to solid variant with size2.
  static RemixBadgeStyle create({
    RadixBadgeVariant variant = RadixBadgeVariant.solid,
    RadixBadgeSize size = RadixBadgeSize.size2,
  }) {
    return switch (variant) {
      RadixBadgeVariant.solid => solid(size: size),
      RadixBadgeVariant.soft => soft(size: size),
      RadixBadgeVariant.surface => surface(size: size),
      RadixBadgeVariant.outline => outline(size: size),
    };
  }

  static RemixBadgeStyle base({RadixBadgeSize size = RadixBadgeSize.size2}) {
    return RemixBadgeStyle()
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a solid variant badge style.
  ///
  /// Solid badges have high emphasis with solid accent background color.
  /// Used for important status indicators.
  static RemixBadgeStyle solid({RadixBadgeSize size = RadixBadgeSize.size2}) {
    return base(size: size)
        // Container styling - no size properties
        .color(RadixTokens.accent9())
        // Text styling
        .textColor(RadixTokens.accentContrast());
  }

  /// Creates a soft variant badge style.
  ///
  /// Soft badges have medium emphasis with subtle accent tinted background.
  /// Used for secondary status indicators.
  static RemixBadgeStyle soft({RadixBadgeSize size = RadixBadgeSize.size2}) {
    return base(size: size)
        // Container styling - no size properties
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // Text styling
        .textColor(RadixTokens.accent11());
  }

  /// Creates a surface variant badge style.
  ///
  /// Surface badges have subtle emphasis with accent-tinted surface.
  /// Used for neutral status indicators.
  static RemixBadgeStyle surface({
    RadixBadgeSize size = RadixBadgeSize.size2,
  }) {
    return base(size: size)
        // Container styling - no size properties
        .color(RadixTokens.accentSurface())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // Text styling
        .textColor(RadixTokens.accent11());
  }

  /// Creates an outline variant badge style.
  ///
  /// Outline badges have border-focused emphasis with transparent background.
  /// Used for subtle status indicators.
  static RemixBadgeStyle outline({
    RadixBadgeSize size = RadixBadgeSize.size2,
  }) {
    return base(size: size)
        // Container styling - no size properties
        .color(Colors.transparent)
        .borderAll(
          color: RadixTokens.accent7(),
          width: RadixTokens.borderWidth1(),
        )
        // Text styling
        .textColor(RadixTokens.accent11());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixBadgeStyle _sizeStyle(RadixBadgeSize size) {
    return switch (size) {
      RadixBadgeSize.size1 => RemixBadgeStyle(
          container: BoxStyler()
              .constraints(BoxConstraintsMix(minHeight: 18.0, maxHeight: 18.0))
              .paddingX(6.0)
              .paddingY(2.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
          text: TextStyler().fontSize(11.0).height(16.0 / 11.0),
        ),
      RadixBadgeSize.size2 => RemixBadgeStyle(
          container: BoxStyler()
              .constraints(BoxConstraintsMix(minHeight: 22.0, maxHeight: 22.0))
              .paddingX(8.0)
              .paddingY(3.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
          text: TextStyler().fontSize(12.0).height(18.0 / 12.0),
        ),
      RadixBadgeSize.size3 => RemixBadgeStyle(
          container: BoxStyler()
              .constraints(BoxConstraintsMix(minHeight: 26.0, maxHeight: 26.0))
              .paddingX(10.0)
              .paddingY(4.0)
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
          text: TextStyler().fontSize(13.0).height(20.0 / 13.0),
        ),
    };
  }
}
