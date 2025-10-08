part of 'progress.dart';

enum FortalProgressSize { size1, size2, size3 }

enum FortalProgressVariant { classic, surface, soft }

/// FortalProgressStyles utility class for creating Fortal-themed progress styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalProgressStyles {
  const FortalProgressStyles._();

  /// Factory constructor for FortalProgressStyles with variant and size parameters.
  ///
  /// Returns a RemixProgressStyle configured with Fortal design tokens.
  /// Defaults to classic variant with size2.
  static RemixProgressStyle create({
    FortalProgressVariant variant = FortalProgressVariant.classic,
    FortalProgressSize size = FortalProgressSize.size2,
  }) {
    return switch (variant) {
      FortalProgressVariant.classic => classic(size: size),
      FortalProgressVariant.surface => surface(size: size),
      FortalProgressVariant.soft => soft(size: size),
    };
  }

  static RemixProgressStyle base({
    FortalProgressSize size = FortalProgressSize.size2,
  }) {
    return RemixProgressStyle()
        // Container styling - no focus for progress
        .width(double.infinity)
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixProgressStyle classic({
    FortalProgressSize size = FortalProgressSize.size2,
  }) {
    return base(size: size)
        // Track styling (background bar)
        .track(
          BoxStyler()
              .color(FortalTokens.gray6()) // gray6 equivalent
              .borderRadiusAll(FortalTokens.radiusFull())
              .width(double.infinity),
        )
        // Indicator styling (progress fill)
        .indicator(
          BoxStyler()
              .color(FortalTokens.accentIndicator()) // accent9 equivalent
              .borderRadiusAll(FortalTokens.radiusFull()),
        );
  }

  static RemixProgressStyle surface({
    FortalProgressSize size = FortalProgressSize.size2,
  }) {
    return base(size: size)
        // Track styling (background bar) - same as classic
        .track(
          BoxStyler()
              .color(FortalTokens.gray6()) // gray6 equivalent
              .borderRadiusAll(FortalTokens.radiusFull())
              .width(double.infinity),
        )
        // Indicator styling (progress fill) - same as classic
        .indicator(
          BoxStyler()
              .color(FortalTokens.accentIndicator()) // accent9 equivalent
              .borderRadiusAll(FortalTokens.radiusFull()),
        );
  }

  static RemixProgressStyle soft({
    FortalProgressSize size = FortalProgressSize.size2,
  }) {
    return base(size: size)
        // Track styling (background bar) - uses accent4 instead of gray
        .track(
          BoxStyler()
              .color(FortalTokens.accent4())
              .borderRadiusAll(FortalTokens.radiusFull())
              .width(double.infinity),
        )
        // Indicator styling (progress fill) - uses accent9
        .indicator(
          BoxStyler()
              .color(FortalTokens.accent9())
              .borderRadiusAll(FortalTokens.radiusFull()),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixProgressStyle _sizeStyle(FortalProgressSize size) {
    return switch (size) {
      FortalProgressSize.size1 =>
        RemixProgressStyle()
            .height(4.0)
            .track(
              BoxStyler().height(4.0).borderRadiusAll(FortalTokens.radius1()),
            )
            .indicator(
              BoxStyler().height(4.0).borderRadiusAll(FortalTokens.radius1()),
            ),
      FortalProgressSize.size2 =>
        RemixProgressStyle()
            .height(8.0)
            .track(
              BoxStyler().height(8.0).borderRadiusAll(FortalTokens.radius2()),
            )
            .indicator(
              BoxStyler().height(8.0).borderRadiusAll(FortalTokens.radius2()),
            ),
      FortalProgressSize.size3 =>
        RemixProgressStyle()
            .height(12.0)
            .track(
              BoxStyler().height(12.0).borderRadiusAll(FortalTokens.radius3()),
            )
            .indicator(
              BoxStyler().height(12.0).borderRadiusAll(FortalTokens.radius3()),
            ),
    };
  }
}
