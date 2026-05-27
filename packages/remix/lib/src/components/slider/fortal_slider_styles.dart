part of 'slider.dart';

enum FortalSliderSize { size1, size2, size3 }

enum FortalSliderVariant { surface, soft }

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
