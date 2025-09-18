part of 'card.dart';


enum FortalCardSize {
  size1,
  size2,
  size3,
}

enum FortalCardVariant {
  surface,
  classic,
  ghost,
}

/// Factory class for creating Fortal-compliant card styles.
///
/// Provides static methods to create RemixCardStyle instances for all
/// Fortal UI card variants using the FortalTokens system.
class FortalCardStyles {
  const FortalCardStyles._();

  /// Factory constructor for FortalCardStyle with variant and size parameters.
  ///
  /// Returns a RemixCardStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixCardStyle create({
    FortalCardVariant variant = FortalCardVariant.surface,
    FortalCardSize size = FortalCardSize.size2,
  }) {
    return switch (variant) {
      FortalCardVariant.surface => surface(size: size),
      FortalCardVariant.classic => classic(size: size),
      FortalCardVariant.ghost => ghost(size: size),
    };
  }

  static RemixCardStyle base({FortalCardSize size = FortalCardSize.size2}) {
    return RemixCardStyle()
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a surface variant card style.
  ///
  /// Surface cards use panel solid background with subtle borders.
  /// Used for standard content containers.
  static RemixCardStyle surface({FortalCardSize size = FortalCardSize.size2}) {
    return base(size: size)
        // Visual styling per radix_components.generated.json
        // card-background-color: var(--color-panel)
        // card-border-width: 0px
        // card-border-radius: var(--radius-6)
        // card-padding: var(--space-8)
        .color(FortalTokens.colorPanelSolid())
        .borderRadiusAll(FortalTokens.radius6());
  }

  /// Creates a classic variant card style.
  ///
  /// Classic cards use panel solid background with stronger borders and shadow.
  /// Used for elevated content containers with traditional appearance.
  static RemixCardStyle classic({FortalCardSize size = FortalCardSize.size2}) {
    return base(size: size)
        // Visual styling per radix_components.generated.json
        // card-background-color: var(--color-panel)
        // card-border-width: 0px (classic keeps elevation via shadow)
        // card-border-radius: var(--radius-6)
        .color(FortalTokens.colorPanelSolid())
        .borderRadiusAll(FortalTokens.radius6())
        // Add subtle layered shadow for elevation
        .shadows(FortalTokens.shadow2().map(BoxShadowMix.value).toList());
  }

  /// Creates a ghost variant card style.
  ///
  /// Ghost cards have no background or border.
  /// Used for subtle content grouping without visual container.
  static RemixCardStyle ghost({FortalCardSize size = FortalCardSize.size2}) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(Colors.transparent);
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCardStyle _sizeStyle(FortalCardSize size) {
    return switch (size) {
      FortalCardSize.size1 => RemixCardStyle()
          .padding(EdgeInsetsGeometryMix.all(24.0)),
      // Per JSON: card-padding = space-8 (32px) for default
      FortalCardSize.size2 => RemixCardStyle()
          .padding(EdgeInsetsGeometryMix.all(32.0)),
      FortalCardSize.size3 => RemixCardStyle()
          .padding(EdgeInsetsGeometryMix.all(36.0)),
    };
  }
}
