part of 'slider.dart';

enum FortalSliderSize { size1, size2, size3 }

enum FortalSliderVariant { classic, surface, soft }

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
  /// Defaults to classic variant with size2.
  static RemixSliderStyle create({
    FortalSliderVariant variant = FortalSliderVariant.classic,
    FortalSliderSize size = FortalSliderSize.size2,
  }) {
    return switch (variant) {
      FortalSliderVariant.classic => classic(size: size),
      FortalSliderVariant.surface => surface(size: size),
      FortalSliderVariant.soft => soft(size: size),
    };
  }

  static RemixSliderStyle base({
    FortalSliderSize size = FortalSliderSize.size2,
  }) {
    return RemixSliderStyle()
        // Focus state
        .onFocused(
          RemixSliderStyle().thumb(
            BoxStyler().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixSliderStyle classic({
    FortalSliderSize size = FortalSliderSize.size2,
  }) {
    return base(size: size)
        // Track styling (background rail)
        .trackColor(FortalTokens.accentTrack()) // gray6 equivalent
        // Range styling (filled portion)
        .rangeColor(FortalTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling with border
        .thumb(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .trackColor(FortalTokens.accentTrack())
              .rangeColor(FortalTokens.accentIndicator())
              .thumb(
                BoxStyler()
                    .color(FortalTokens.colorSurface())
                    .borderAll(
                      color: FortalTokens.gray7(),
                      width: FortalTokens.borderWidth1(),
                    ),
              ),
        );
  }

  static RemixSliderStyle surface({
    FortalSliderSize size = FortalSliderSize.size2,
  }) {
    return base(size: size)
        // Track styling (background rail)
        .trackColor(FortalTokens.accentTrack()) // gray6 equivalent
        // Range styling (filled portion)
        .rangeColor(FortalTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling without border
        .thumb(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .trackColor(FortalTokens.accentTrack())
              .rangeColor(FortalTokens.accentIndicator())
              .thumbColor(FortalTokens.colorSurface()),
        );
  }

  static RemixSliderStyle soft({
    FortalSliderSize size = FortalSliderSize.size2,
  }) {
    return base(size: size)
        // Track styling (background rail) - uses accent4 instead of gray
        .trackColor(FortalTokens.accent4())
        // Range styling (filled portion) - uses accent9
        .rangeColor(FortalTokens.accent9())
        // Thumb styling - uses accent9 color
        .thumb(
          BoxStyler()
              .color(FortalTokens.accent9())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // Disabled state
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
      FortalSliderSize.size1 => RemixSliderStyle(
        thumb: BoxStyler().width(16.0).height(16.0),
        track: Paint()
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        range: Paint()
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      ),
      // Per JSON:
      // slider-track-size = calc(space-2 * 1.25) = 10px
      // slider-thumb-size = calc(track-size + space-1) = 14px
      FortalSliderSize.size2 => RemixSliderStyle(
        thumb: BoxStyler().width(14.0).height(14.0),
        track: Paint()
          ..strokeWidth = 10.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        range: Paint()
          ..strokeWidth = 10.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      ),
      FortalSliderSize.size3 => RemixSliderStyle(
        thumb: BoxStyler().width(24.0).height(24.0),
        track: Paint()
          ..strokeWidth = 8.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        range: Paint()
          ..strokeWidth = 8.0
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
      ),
    };
  }
}
