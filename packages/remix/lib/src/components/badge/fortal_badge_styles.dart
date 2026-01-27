part of 'badge.dart';

enum FortalBadgeSize { size1, size2, size3 }

enum FortalBadgeVariant { solid, soft, surface, outline }

/// Factory class for creating Fortal-compliant badge styles.
///
/// Provides static methods to create RemixBadgeStyle instances for all
/// Fortal UI badge variants using the FortalTokens system.
class FortalBadgeStyles {
  const FortalBadgeStyles._();

  /// Factory constructor for FortalBadgeStyle with variant and size parameters.
  ///
  /// Returns a RemixBadgeStyle configured with Fortal design tokens.
  /// Defaults to solid variant with size2.
  static RemixBadgeStyle create({
    FortalBadgeVariant variant = .solid,
    FortalBadgeSize size = .size2,
  }) {
    return switch (variant) {
      .solid => solid(size: size),
      .soft => soft(size: size),
      .surface => surface(size: size),
      .outline => outline(size: size),
    };
  }

  static RemixBadgeStyle base({FortalBadgeSize size = .size2}) {
    return RemixBadgeStyle()
    // Merge with size-specific styles
    .merge(_sizeStyle(size));
  }

  /// Creates a solid variant badge style.
  ///
  /// Solid badges have high emphasis with solid accent background color.
  /// Used for important status indicators.
  static RemixBadgeStyle solid({FortalBadgeSize size = .size2}) {
    return base(size: size)
        // Container styling - no size properties
        .color(FortalTokens.accent9())
        // Text styling
        .labelColor(FortalTokens.accentContrast());
  }

  /// Creates a soft variant badge style.
  ///
  /// Soft badges have medium emphasis with subtle accent tinted background.
  /// Used for secondary status indicators.
  static RemixBadgeStyle soft({FortalBadgeSize size = .size2}) {
    return base(size: size)
        // Container styling - no size properties
        .color(FortalTokens.accentA3())
        // Text styling
        .labelColor(FortalTokens.accentA10());
  }

  /// Creates a surface variant badge style.
  ///
  /// Surface badges have subtle emphasis with accent-tinted surface.
  /// Used for neutral status indicators.
  static RemixBadgeStyle surface({
    FortalBadgeSize size = .size2,
  }) {
    return base(size: size)
        // Container styling - no size properties
        .color(FortalTokens.accentA2())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        // Text styling
        .labelColor(FortalTokens.accentA10());
  }

  /// Creates an outline variant badge style.
  ///
  /// Outline badges have border-focused emphasis with transparent background.
  /// Used for subtle status indicators.
  static RemixBadgeStyle outline({
    FortalBadgeSize size = .size2,
  }) {
    return base(size: size)
        // Container styling - no size properties
        .color(Colors.transparent)
        .borderAll(
          color: FortalTokens.accent7(),
          width: FortalTokens.borderWidth1(),
        )
        // Text styling
        .labelColor(FortalTokens.accentA10());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixBadgeStyle _sizeStyle(FortalBadgeSize size) {
    return switch (size) {
      .size1 => RemixBadgeStyle(
        container: BoxStyler()
            .paddingX(6.0)
            .paddingY(2.0)
            .borderRadiusAll(FortalTokens.radius2()),
        text: TextStyler().fontSize(11.0).height(16.0 / 11.0),
      ),
      .size2 => RemixBadgeStyle(
        container: BoxStyler()
            .paddingX(8.0)
            .paddingY(3.0)
            .borderRadiusAll(FortalTokens.radius3()),
        text: TextStyler().fontSize(12.0).height(18.0 / 12.0),
      ),
      .size3 => RemixBadgeStyle(
        container: BoxStyler()
            .paddingX(10.0)
            .paddingY(4.0)
            .borderRadiusAll(FortalTokens.radius3()),
        text: TextStyler().fontSize(13.0).height(20.0 / 13.0),
      ),
    };
  }
}
