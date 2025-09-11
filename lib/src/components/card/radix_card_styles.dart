// ABOUTME: Factory for creating RemixCardStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix card variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'card.dart';

/// Factory class for creating Radix-compliant card styles.
///
/// Provides static methods to create RemixCardStyle instances for all
/// Radix UI card variants using the RadixTokens system.
class RadixCardStyles {
  const RadixCardStyles._();

  /// Creates a surface variant card style.
  ///
  /// Surface cards use panel solid background with subtle borders.
  /// Used for standard content containers.
  static RemixCardStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixCardStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(RadixTokens.colorPanelSolid())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(BorderRadiusMix.all(sizeConfig.radius))
              .padding(EdgeInsetsGeometryMix.fromEdgeInsets(sizeConfig.padding)),
        );
  }

  /// Creates a classic variant card style.
  ///
  /// Classic cards use panel solid background with stronger borders and shadow.
  /// Used for elevated content containers with traditional appearance.
  static RemixCardStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixCardStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(RadixTokens.colorPanelSolid())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(sizeConfig.radius)
              .padding(sizeConfig.padding)
              // TODO: Add shadow when shadow tokens are available
              // .shadow(RadixTokens.shadow2)
              ,
        );
  }

  /// Creates a ghost variant card style.
  ///
  /// Ghost cards have no background or border.
  /// Used for subtle content grouping without visual container.
  static RemixCardStyle ghost({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixCardStyle()
        // Container styling
        .container(
          BoxStyler()
              .color(Colors.transparent)
              .borderRadius(BorderRadiusMix.all(sizeConfig.radius))
              .padding(EdgeInsetsGeometryMix.fromEdgeInsets(sizeConfig.padding)),
        );
  }

  /// Gets size configuration for the given size index.
  /// Note: Card uniquely has 5 size options (1-5) unlike other components.
  static _CardSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _CardSizeConfig(
          padding: EdgeInsets.all(12.0),
          radius: RadixTokens.radius2(),
        );
      case 2:
        return _CardSizeConfig(
          padding: EdgeInsets.all(16.0),
          radius: RadixTokens.radius3(),
        );
      case 3:
        return _CardSizeConfig(
          padding: EdgeInsets.all(20.0),
          radius: RadixTokens.radius4(),
        );
      case 4:
        return _CardSizeConfig(
          padding: EdgeInsets.all(24.0),
          radius: RadixTokens.radius5(),
        );
      case 5:
        return _CardSizeConfig(
          padding: EdgeInsets.all(32.0),
          radius: RadixTokens.radius6(),
        );
      default:
        // Default to size 2 if invalid size provided
        return _CardSizeConfig(
          padding: EdgeInsets.all(16.0),
          radius: RadixTokens.radius3(),
        );
    }
  }
}

/// Internal configuration for card sizes.
class _CardSizeConfig {
  final EdgeInsets padding;
  final Radius radius;

  const _CardSizeConfig({
    required this.padding,
    required this.radius,
  });
}