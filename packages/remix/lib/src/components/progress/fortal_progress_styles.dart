part of 'progress.dart';

enum FortalProgressSize { size1, size2, size3 }

enum FortalProgressVariant { surface, soft }

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
    FortalProgressVariant variant = .surface,
    FortalProgressSize size = .size2,
  }) {
    return switch (variant) {
      .surface => surface(size: size),
      .soft => soft(size: size),
    };
  }

  static RemixProgressStyle base({
    FortalProgressSize size = .size2,
  }) {
    return RemixProgressStyle()
        // Container styling - no focus for progress
        .width(double.infinity)
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixProgressStyle surface({
    FortalProgressSize size = .size2,
  }) {
    return base(size: size)
        .foregroundDecoration(
          BoxDecorationMix()
              .border(
                BoxBorderMix.all(BorderSideMix().color(FortalTokens.grayA5())),
              )
              .borderRadius(
                BorderRadiusGeometryMix.all(FortalTokens.radiusFull()),
              ),
        )
        // Track styling (background bar) - same as classic
        .track(
          BoxStyler()
              .color(FortalTokens.gray3()) // gray6 equivalent
              .width(double.infinity),
        )
        // Indicator styling (progress fill) - same as classic
        .indicator(BoxStyler().color(FortalTokens.accentIndicator()));
  }

  static RemixProgressStyle soft({
    FortalProgressSize size = .size2,
  }) {
    return base(size: size)
        // Track styling (background bar) - uses accent4 instead of gray
        .track(
          BoxStyler()
              .color(FortalTokens.gray4())
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
      .size1 =>
        RemixProgressStyle()
            .height(4.0)
            .track(
              BoxStyler().height(4.0).borderRadiusAll(FortalTokens.radius1()),
            )
            .indicator(
              BoxStyler().height(4.0).borderRadiusAll(FortalTokens.radius1()),
            ),
      .size2 =>
        RemixProgressStyle()
            .height(8.0)
            .track(
              BoxStyler().height(8.0).borderRadiusAll(FortalTokens.radius2()),
            )
            .indicator(
              BoxStyler().height(8.0).borderRadiusAll(FortalTokens.radius2()),
            ),
      .size3 =>
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
