// ABOUTME: Factory for creating RemixBadgeStyle instances using Radix design tokens
// ABOUTME: Provides 4 Radix badge variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'badge.dart';

/// Factory class for creating Radix-compliant badge styles.
///
/// Provides static methods to create RemixBadgeStyle instances for all
/// Radix UI badge variants using the RadixTokens system.
class RadixBadgeStyles {
  const RadixBadgeStyles._();

  /// Creates a solid variant badge style.
  ///
  /// Solid badges have high emphasis with solid accent background color.
  /// Used for important status indicators.
  static RemixBadgeStyle solid({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixBadgeStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(sizeConfig.radius)
              .paddingX(sizeConfig.paddingX)
              .paddingY(sizeConfig.paddingY)
              .height(sizeConfig.height),
        )
        // Text styling
        .text(
          TextStyler()
              .color(RadixTokens.accentContrast())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        );
  }

  /// Creates a soft variant badge style.
  ///
  /// Soft badges have medium emphasis with subtle accent tinted background.
  /// Used for secondary status indicators.
  static RemixBadgeStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixBadgeStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(sizeConfig.radius)
              .paddingX(sizeConfig.paddingX)
              .paddingY(sizeConfig.paddingY)
              .height(sizeConfig.height),
        )
        // Text styling
        .text(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        );
  }

  /// Creates a surface variant badge style.
  ///
  /// Surface badges have subtle emphasis with accent-tinted surface.
  /// Used for neutral status indicators.
  static RemixBadgeStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixBadgeStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(RadixTokens.accentSurface())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(sizeConfig.radius)
              .paddingX(sizeConfig.paddingX)
              .paddingY(sizeConfig.paddingY)
              .height(sizeConfig.height),
        )
        // Text styling
        .text(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        );
  }

  /// Creates an outline variant badge style.
  ///
  /// Outline badges have border-focused emphasis with transparent background.
  /// Used for subtle status indicators.
  static RemixBadgeStyle outline({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixBadgeStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(Colors.transparent)
              .borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(sizeConfig.radius)
              .paddingX(sizeConfig.paddingX)
              .paddingY(sizeConfig.paddingY)
              .height(sizeConfig.height),
        )
        // Text styling
        .text(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        );
  }

  /// Gets size configuration for the given size index.
  static _BadgeSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _BadgeSizeConfig(
          height: 18.0,
          paddingX: 6.0,
          paddingY: 2.0,
          fontSize: 11.0,
          radius: RadixTokens.radius2(),
        );
      case 2:
        return _BadgeSizeConfig(
          height: 22.0,
          paddingX: 8.0,
          paddingY: 3.0,
          fontSize: 12.0,
          radius: RadixTokens.radius3(),
        );
      case 3:
        return _BadgeSizeConfig(
          height: 26.0,
          paddingX: 10.0,
          paddingY: 4.0,
          fontSize: 13.0,
          radius: RadixTokens.radius3(),
        );
      default:
        // Default to size 2 if invalid size provided
        return _BadgeSizeConfig(
          height: 22.0,
          paddingX: 8.0,
          paddingY: 3.0,
          fontSize: 12.0,
          radius: RadixTokens.radius3(),
        );
    }
  }
}

/// Internal configuration for badge sizes.
class _BadgeSizeConfig {
  final double height;
  final double paddingX;
  final double paddingY;
  final double fontSize;
  final Radius radius;

  const _BadgeSizeConfig({
    required this.height,
    required this.paddingX,
    required this.paddingY,
    required this.fontSize,
    required this.radius,
  });
}