// ABOUTME: Factory for creating RemixBadgeStyle instances using Radix design tokens
// ABOUTME: Provides 4 Radix badge variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'badge.dart';

// Export the extension so it's available when importing this file
export 'badge.dart' show RadixBadgeStyleExt;

/// Factory class for creating Radix-compliant badge styles.
///
/// Provides static methods to create RemixBadgeStyle instances for all
/// Radix UI badge variants using the RadixTokens system.
class RadixBadgeStyles {
  const RadixBadgeStyles._();

  /// Creates a solid variant badge style.
  ///
  /// Solid badges have high emphasis with solid accent background color.
  /// Used for important status indicators. Compose with size methods like .size2().
  static RemixBadgeStyle solid() {
    return RemixBadgeStyle()
        // Container styling - no size properties
        .color(RadixTokens.accent9())
        // Text styling
        .textColor(RadixTokens.accentContrast());
  }

  /// Creates a soft variant badge style.
  ///
  /// Soft badges have medium emphasis with subtle accent tinted background.
  /// Used for secondary status indicators. Compose with size methods like .size2().
  static RemixBadgeStyle soft() {
    return RemixBadgeStyle()
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
  /// Used for neutral status indicators. Compose with size methods like .size2().
  static RemixBadgeStyle surface() {
    return RemixBadgeStyle()
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
  /// Used for subtle status indicators. Compose with size methods like .size2().
  static RemixBadgeStyle outline() {
    return RemixBadgeStyle()
        // Container styling - no size properties
        .color(Colors.transparent)
        .borderAll(
          color: RadixTokens.accent7(),
          width: RadixTokens.borderWidth1(),
        )
        // Text styling
        .textColor(RadixTokens.accent11());
  }

  /// Creates a size 1 badge style (small).
  ///
  /// Small badges for compact layouts and dense interfaces.
  /// Compose with variant methods like .solid().
  static RemixBadgeStyle size1() {
    return RemixBadgeStyle(
      container: BoxStyler()
          .constraints(BoxConstraintsMix(minHeight: 18.0, maxHeight: 18.0))
          .paddingX(6.0)
          .paddingY(2.0)
          .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
      text: TextStyler().fontSize(11.0).height(16.0 / 11.0),
    );
  }

  /// Creates a size 2 badge style (medium - default).
  ///
  /// Standard badges for most common use cases.
  /// Compose with variant methods like .solid().
  static RemixBadgeStyle size2() {
    return RemixBadgeStyle(
      container: BoxStyler()
          .constraints(BoxConstraintsMix(minHeight: 22.0, maxHeight: 22.0))
          .paddingX(8.0)
          .paddingY(3.0)
          .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
      text: TextStyler().fontSize(12.0).height(18.0 / 12.0),
    );
  }

  /// Creates a size 3 badge style (large).
  ///
  /// Large badges for prominent status indicators.
  /// Compose with variant methods like .solid().
  static RemixBadgeStyle size3() {
    return RemixBadgeStyle(
      container: BoxStyler()
          .constraints(BoxConstraintsMix(minHeight: 26.0, maxHeight: 26.0))
          .paddingX(10.0)
          .paddingY(4.0)
          .borderRadius(BorderRadiusMix.all(RadixTokens.radius3())),
      text: TextStyler().fontSize(13.0).height(20.0 / 13.0),
    );
  }
}
