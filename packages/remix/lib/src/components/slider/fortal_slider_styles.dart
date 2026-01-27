part of 'slider.dart';

enum FortalSliderSize { size1, size2, size3 }

enum FortalSliderVariant { surface, soft }

/// FortalSliderStyles utility class for creating Fortal-themed slider styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalSliderStyles {
  const FortalSliderStyles._();

  /// Factory constructor for FortalSliderStyles with variant and size parameters.
  ///
  /// Returns a RemixSliderStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixSliderStyle create({
    FortalSliderVariant variant = .surface,
    FortalSliderSize size = .size2,
  }) {
    return switch (variant) {
      .surface => surface(size: size),
      .soft => soft(size: size),
    };
  }

  static RemixSliderStyle base({
    FortalSliderSize size = .size2,
  }) {
    return RemixSliderStyle()
        // Focus state
        .thumb(
          BoxStyler()
              .color(Colors.white)
              .shapeCircle(
                side: BorderSideMix()
                    .color(FortalTokens.grayA6())
                    .strokeAlign(BorderSide.strokeAlignOutside),
              )
              .shadow(
                BoxShadowMix()
                    .blurRadius(2)
                    .offset(x: 0, y: 1)
                    .color(FortalTokens.gray7()),
              ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixSliderStyle surface({
    FortalSliderSize size = .size2,
  }) {
    return base(size: size)
        .trackColor(FortalTokens.gray3())
        .rangeColor(FortalTokens.accentIndicator())
        .onDisabled(
          RemixSliderStyle()
              .trackColor(FortalTokens.accentTrack())
              .rangeColor(FortalTokens.accentIndicator())
              .thumbColor(FortalTokens.colorSurface()),
        );
  }

  static RemixSliderStyle soft({
    FortalSliderSize size = .size2,
  }) {
    return base(size: size)
        .trackColor(FortalTokens.gray4())
        .rangeColor(FortalTokens.accent6())
        .onDisabled(
          RemixSliderStyle()
              .trackColor(FortalTokens.accent4())
              .rangeColor(FortalTokens.accent9())
              .thumbColor(FortalTokens.accent9()),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSliderStyle _sizeStyle(FortalSliderSize size) {
    return switch (size) {
      .size1 => RemixSliderStyle(
        thumb: BoxStyler().size(13.0, 13.0),
        trackWidth: 6.0,
        rangeWidth: 6.0,
      ),
      .size2 => RemixSliderStyle(
        thumb: BoxStyler().size(16.0, 16.0),
        trackWidth: 8.0,
        rangeWidth: 8.0,
      ),
      .size3 => RemixSliderStyle(
        thumb: BoxStyler().size(19.0, 19.0),
        trackWidth: 10.0,
        rangeWidth: 10.0,
      ),
    };
  }
}
