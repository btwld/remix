// ABOUTME: Factory for creating RemixCardStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix card variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'card.dart';


enum RadixCardSize {
  size1,
  size2,
  size3,
}

enum RadixCardVariant {
  surface,
  classic,
  ghost,
}

/// Factory class for creating Radix-compliant card styles.
///
/// Provides static methods to create RemixCardStyle instances for all
/// Radix UI card variants using the RadixTokens system.
class RadixCardStyles {
  const RadixCardStyles._();

  /// Factory constructor for RadixCardStyle with variant and size parameters.
  ///
  /// Returns a RemixCardStyle configured with Radix design tokens.
  /// Defaults to surface variant with size2.
  static RemixCardStyle create({
    RadixCardVariant variant = RadixCardVariant.surface,
    RadixCardSize size = RadixCardSize.size2,
  }) {
    return switch (variant) {
      RadixCardVariant.surface => surface(size: size),
      RadixCardVariant.classic => classic(size: size),
      RadixCardVariant.ghost => ghost(size: size),
    };
  }

  static RemixCardStyle base({RadixCardSize size = RadixCardSize.size2}) {
    return RemixCardStyle()
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a surface variant card style.
  ///
  /// Surface cards use panel solid background with subtle borders.
  /// Used for standard content containers.
  static RemixCardStyle surface({RadixCardSize size = RadixCardSize.size2}) {
    return base(size: size)
        // Visual styling per radix_components.generated.json
        // card-background-color: var(--color-panel)
        // card-border-width: 0px
        // card-border-radius: var(--radius-6)
        // card-padding: var(--space-8)
        .container(
      BoxStyler().color(RadixTokens.colorPanelSolid()).decoration(
            BoxDecorationMix(
              borderRadius: BorderRadiusMix.all(RadixTokens.radius6()),
            ),
          ),
    );
  }

  /// Creates a classic variant card style.
  ///
  /// Classic cards use panel solid background with stronger borders and shadow.
  /// Used for elevated content containers with traditional appearance.
  static RemixCardStyle classic({RadixCardSize size = RadixCardSize.size2}) {
    return base(size: size)
        // Visual styling per radix_components.generated.json
        // card-background-color: var(--color-panel)
        // card-border-width: 0px (classic keeps elevation via shadow)
        // card-border-radius: var(--radius-6)
        .container(
          BoxStyler().color(RadixTokens.colorPanelSolid()).decoration(
                BoxDecorationMix(
                  borderRadius: BorderRadiusMix.all(RadixTokens.radius6()),
                ),
              ),
        )
        // Add subtle layered shadow for elevation
        .shadows(RadixTokens.shadow2().map(BoxShadowMix.value).toList());
  }

  /// Creates a ghost variant card style.
  ///
  /// Ghost cards have no background or border.
  /// Used for subtle content grouping without visual container.
  static RemixCardStyle ghost({RadixCardSize size = RadixCardSize.size2}) {
    return base(size: size)
        // Visual styling only - no size properties
        .container(BoxStyler().color(Colors.transparent));
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCardStyle _sizeStyle(RadixCardSize size) {
    return switch (size) {
      RadixCardSize.size1 => RemixCardStyle()
          .padding(EdgeInsetsGeometryMix.all(24.0)),
      // Per JSON: card-padding = space-8 (32px) for default
      RadixCardSize.size2 => RemixCardStyle()
          .padding(EdgeInsetsGeometryMix.all(32.0)),
      RadixCardSize.size3 => RemixCardStyle()
          .padding(EdgeInsetsGeometryMix.all(36.0)),
    };
  }
}
