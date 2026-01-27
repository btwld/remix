part of 'card.dart';

enum FortalCardSize { size1, size2, size3 }

enum FortalCardVariant { surface, classic, ghost }

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
    FortalCardVariant variant = .surface,
    FortalCardSize size = .size2,
  }) {
    return switch (variant) {
      .surface => surface(size: size),
      .classic => classic(size: size),
      .ghost => ghost(size: size),
    };
  }

  static RemixCardStyle base({FortalCardSize size = .size2}) {
    return RemixCardStyle()
    // Merge with size-specific styles
    .merge(_sizeStyle(size));
  }

  /// Creates a surface variant card style.
  ///
  /// Surface cards use panel solid background with subtle borders.
  /// Used for standard content containers.
  static RemixCardStyle surface({FortalCardSize size = .size2}) {
    return base(size: size)
        .borderAll(
          color: FortalTokens.gray6(),
          width: FortalTokens.borderWidth1(),
        )
        .borderRadiusAll(FortalTokens.radius5());
  }

  /// Creates a classic variant card style.
  ///
  /// Classic cards use panel solid background with stronger borders and shadow.
  /// Used for elevated content containers with traditional appearance.
  static RemixCardStyle classic({FortalCardSize size = .size2}) {
    return base(size: size)
        .color(FortalTokens.graySurface())
        .borderAll(
          color: FortalTokens.gray6(),
          width: FortalTokens.borderWidth1(),
        )
        .shadow(
          BoxShadowMix()
              .color(FortalTokens.grayA3())
              .offset(x: 0, y: 2)
              .blurRadius(3)
              .spreadRadius(0),
        )
        .borderRadiusAll(FortalTokens.radius5())
        // Add subtle layered shadow for elevation
        .merge(RemixCardStyle(container: BoxStyler.create()));
  }

  /// Creates a ghost variant card style.
  ///
  /// Ghost cards have no background or border.
  /// Used for subtle content grouping without visual container.
  static RemixCardStyle ghost({FortalCardSize size = .size2}) {
    return base(size: size)
    // Visual styling only - no size properties
    .color(Colors.transparent);
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCardStyle _sizeStyle(FortalCardSize size) {
    return switch (size) {
      .size1 => RemixCardStyle().paddingAll(
        FortalTokens.space4(),
      ),
      // Per JSON: card-padding = space-8 (32px) for default
      .size2 => RemixCardStyle().paddingAll(
        FortalTokens.space5(),
      ),
      .size3 => RemixCardStyle().paddingAll(
        FortalTokens.space6(),
      ),
    };
  }
}
