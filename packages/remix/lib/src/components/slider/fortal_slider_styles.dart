part of 'slider.dart';

/// Fortal slider size presets.
enum FortalSliderSize {
  /// Compact slider with a 13 px thumb and 6 px track.
  size1,

  /// Default slider with a 16 px thumb and 8 px track.
  size2,

  /// Large slider with a 19 px thumb and 10 px track.
  size3,
}

/// Fortal slider color variants.
enum FortalSliderVariant {
  /// Neutral track with the active accent indicator.
  surface,

  /// Softer accent treatment for lower-emphasis controls.
  soft,
}

/// Creates a Fortal-themed [RemixSliderStyle].
///
/// The returned style can be passed to [RemixSlider.style] or called directly
/// as a widget factory via [RemixSliderStyle.call].
@MixWidget()
RemixSliderStyle fortalSliderStyle({
  FortalSliderVariant variant = .surface,
  FortalSliderSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalSliderSurfaceStyle(size),
    .soft => _fortalSliderSoftStyle(size),
  };
}

RemixSliderStyle _fortalSliderBaseStyle(FortalSliderSize size) {
  return RemixSliderStyle()
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
      .merge(_fortalSliderSizeStyle(size));
}

RemixSliderStyle _fortalSliderSurfaceStyle([FortalSliderSize size = .size2]) {
  return _fortalSliderBaseStyle(size)
      .trackColor(FortalTokens.gray3())
      .rangeColor(FortalTokens.accentIndicator())
      .onDisabled(
        RemixSliderStyle()
            .trackColor(FortalTokens.accentTrack())
            .rangeColor(FortalTokens.accentIndicator())
            .thumbColor(FortalTokens.colorSurface()),
      );
}

RemixSliderStyle _fortalSliderSoftStyle([FortalSliderSize size = .size2]) {
  return _fortalSliderBaseStyle(size)
      .trackColor(FortalTokens.gray4())
      .rangeColor(FortalTokens.accent6())
      .onDisabled(
        RemixSliderStyle()
            .trackColor(FortalTokens.accent4())
            .rangeColor(FortalTokens.accent9())
            .thumbColor(FortalTokens.accent9()),
      );
}

RemixSliderStyle _fortalSliderSizeStyle(FortalSliderSize size) {
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
