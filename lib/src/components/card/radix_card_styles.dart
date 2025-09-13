// ABOUTME: Factory for creating RemixCardStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix card variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'card.dart';

// Export the extension so it's available when importing this file
export 'card.dart' show RadixCardStyleExt;

/// Factory class for creating Radix-compliant card styles.
///
/// Provides static methods to create RemixCardStyle instances for all
/// Radix UI card variants using the RadixTokens system.
class RadixCardStyles {
  const RadixCardStyles._();

  /// Creates a surface variant card style.
  ///
  /// Surface cards use panel solid background with subtle borders.
  /// Used for standard content containers. Compose with size methods like .size2().
  static RemixCardStyle surface() {
    return RemixCardStyle()
        // Visual styling only - no size properties
        .container(
      BoxStyler().color(RadixTokens.colorPanelSolid()).borderAll(
            color: RadixTokens.gray6(),
            width: RadixTokens.borderWidth1(),
          ),
    );
  }

  /// Creates a classic variant card style.
  ///
  /// Classic cards use panel solid background with stronger borders and shadow.
  /// Used for elevated content containers with traditional appearance.
  /// Compose with size methods like .size2().
  static RemixCardStyle classic() {
    return RemixCardStyle()
        // Visual styling only - no size properties
        .container(BoxStyler().color(RadixTokens.colorPanelSolid()).borderAll(
              color: RadixTokens.gray7(),
              width: RadixTokens.borderWidth1(),
            ))
        // Add subtle layered shadow for elevation
        .shadows(RadixTokens.shadow2().map(BoxShadowMix.value).toList());
  }

  /// Creates a ghost variant card style.
  ///
  /// Ghost cards have no background or border.
  /// Used for subtle content grouping without visual container.
  /// Compose with size methods like .size2().
  static RemixCardStyle ghost() {
    return RemixCardStyle()
        // Visual styling only - no size properties
        .container(BoxStyler().color(Colors.transparent));
  }

  /// Creates a size 1 card style (small).
  ///
  /// Small cards for compact layouts and dense interfaces.
  static RemixCardStyle size1() {
    return RemixCardStyle()
        .padding(EdgeInsetsGeometryMix.all(12.0))
        .borderRadius(BorderRadiusMix.all(RadixTokens.radius2()));
  }

  /// Creates a size 2 card style (medium - default).
  ///
  /// Standard cards for most common use cases.
  static RemixCardStyle size2() {
    return RemixCardStyle()
        .padding(EdgeInsetsGeometryMix.all(16.0))
        .borderRadius(BorderRadiusMix.all(RadixTokens.radius3()));
  }

  /// Creates a size 3 card style (large).
  ///
  /// Large cards for prominent content and accessibility needs.
  static RemixCardStyle size3() {
    return RemixCardStyle()
        .padding(EdgeInsetsGeometryMix.all(20.0))
        .borderRadius(BorderRadiusMix.all(RadixTokens.radius4()));
  }
}
