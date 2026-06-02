part of 'progress.dart';

enum FortalProgressSize { size1, size2, size3 }

enum FortalProgressVariant { surface, soft }

RemixProgressStyle fortalProgressStyle({
  FortalProgressVariant variant = .surface,
  FortalProgressSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalProgressSurfaceStyle(size),
    .soft => _fortalProgressSoftStyle(size),
  };
}

RemixProgressStyle _fortalProgressBaseStyle(FortalProgressSize size) {
  return RemixProgressStyle()
      .width(double.infinity)
      .merge(_fortalProgressSizeStyle(size));
}

RemixProgressStyle _fortalProgressSurfaceStyle([
  FortalProgressSize size = .size2,
]) {
  return _fortalProgressBaseStyle(size)
      .foregroundDecoration(
        BoxDecorationMix()
            .border(
              BoxBorderMix.all(BorderSideMix().color(FortalTokens.grayA5())),
            )
            .borderRadius(
              BorderRadiusGeometryMix.all(FortalTokens.radiusFull()),
            ),
      )
      .track(BoxStyler().color(FortalTokens.gray3()).width(double.infinity))
      .indicator(BoxStyler().color(FortalTokens.accentIndicator()));
}

RemixProgressStyle _fortalProgressSoftStyle([
  FortalProgressSize size = .size2,
]) {
  return _fortalProgressBaseStyle(size)
      .track(
        BoxStyler()
            .color(FortalTokens.gray4())
            .borderRadiusAll(FortalTokens.radiusFull())
            .width(double.infinity),
      )
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent9())
            .borderRadiusAll(FortalTokens.radiusFull()),
      );
}

RemixProgressStyle _fortalProgressSizeStyle(FortalProgressSize size) {
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
