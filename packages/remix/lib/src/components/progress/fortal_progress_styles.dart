part of 'progress.dart';

/// Fortal progress size presets.
enum FortalProgressSize { size1, size2, size3 }

/// Fortal progress color variants.
enum FortalProgressVariant { surface, soft }

/// Fortal-themed preset for [RemixProgress].
RemixProgressStyler fortalProgressStyler({
  FortalProgressVariant variant = .surface,
  FortalProgressSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalProgressSurfaceStyler(size),
    .soft => _fortalProgressSoftStyler(size),
  };
}

RemixProgressStyler _fortalProgressBaseStyler(FortalProgressSize size) {
  return RemixProgressStyler()
      .width(.infinity)
      .merge(_fortalProgressSizeStyler(size));
}

RemixProgressStyler _fortalProgressSurfaceStyler([
  FortalProgressSize size = .size2,
]) {
  return _fortalProgressBaseStyler(size)
      .foregroundDecoration(
        BoxDecorationMix()
            .border(
              BoxBorderMix.all(BorderSideMix().color(FortalTokens.grayA5())),
            )
            .borderRadius(
              BorderRadiusGeometryMix.all(FortalTokens.radiusFull()),
            ),
      )
      .track(BoxStyler().color(FortalTokens.gray3()).width(.infinity))
      .indicator(BoxStyler().color(FortalTokens.accentIndicator()));
}

RemixProgressStyler _fortalProgressSoftStyler([
  FortalProgressSize size = .size2,
]) {
  return _fortalProgressBaseStyler(size)
      .track(
        BoxStyler()
            .color(FortalTokens.gray4())
            .borderRadiusAll(FortalTokens.radiusFull())
            .width(.infinity),
      )
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent9())
            .borderRadiusAll(FortalTokens.radiusFull()),
      );
}

RemixProgressStyler _fortalProgressSizeStyler(FortalProgressSize size) {
  return switch (size) {
    .size1 =>
      RemixProgressStyler()
          .height(4.0)
          .track(
            BoxStyler().height(4.0).borderRadiusAll(FortalTokens.radius1()),
          )
          .indicator(
            BoxStyler().height(4.0).borderRadiusAll(FortalTokens.radius1()),
          ),
    .size2 =>
      RemixProgressStyler()
          .height(8.0)
          .track(
            BoxStyler().height(8.0).borderRadiusAll(FortalTokens.radius2()),
          )
          .indicator(
            BoxStyler().height(8.0).borderRadiusAll(FortalTokens.radius2()),
          ),
    .size3 =>
      RemixProgressStyler()
          .height(12.0)
          .track(
            BoxStyler().height(12.0).borderRadiusAll(FortalTokens.radius3()),
          )
          .indicator(
            BoxStyler().height(12.0).borderRadiusAll(FortalTokens.radius3()),
          ),
  };
}

/// Fortal-themed preset for [RemixProgress].
class FortalProgress extends StatelessWidget {
  const FortalProgress({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
  });

  const FortalProgress.surface({
    super.key,
    this.size = .size2,
    required this.value,
  }) : variant = FortalProgressVariant.surface;

  const FortalProgress.soft({
    super.key,
    this.size = .size2,
    required this.value,
  }) : variant = FortalProgressVariant.soft;

  final FortalProgressVariant variant;

  final FortalProgressSize size;

  final double value;

  @override
  Widget build(BuildContext context) {
    return fortalProgressStyler(
      variant: this.variant,
      size: this.size,
    ).call(key: this.key, value: this.value);
  }
}
