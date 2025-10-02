part of 'spinner.dart';

class RemixSpinnerStyle
    extends RemixStyle<RemixSpinnerSpec, RemixSpinnerStyle> {
  final Prop<double>? $size;
  final Prop<double>? $strokeWidth;
  final Prop<Color>? $indicatorColor;
  final Prop<Color>? $trackColor;
  final Prop<double>? $trackStrokeWidth;
  final Prop<Duration>? $duration;

  const RemixSpinnerStyle.create({
    Prop<double>? size,
    Prop<double>? strokeWidth,
    Prop<Color>? indicatorColor,
    Prop<Color>? trackColor,
    Prop<double>? trackStrokeWidth,
    Prop<Duration>? duration,
    super.variants,
    super.animation,
    super.modifier,
  })  : $size = size,
        $strokeWidth = strokeWidth,
        $indicatorColor = indicatorColor,
        $trackColor = trackColor,
        $trackStrokeWidth = trackStrokeWidth,
        $duration = duration;

  RemixSpinnerStyle({
    double? size,
    double? strokeWidth,
    Color? indicatorColor,
    Color? trackColor,
    double? trackStrokeWidth,
    Duration? duration,
    AnimationConfig? animation,
    List<VariantStyle<RemixSpinnerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          size: Prop.maybe(size),
          strokeWidth: Prop.maybe(strokeWidth),
          indicatorColor: Prop.maybe(indicatorColor),
          trackColor: Prop.maybe(trackColor),
          trackStrokeWidth: Prop.maybe(trackStrokeWidth),
          duration: Prop.maybe(duration),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods for fluent API (return new instances)
  RemixSpinnerStyle size(double value) {
    return merge(RemixSpinnerStyle(size: value));
  }

  RemixSpinnerStyle indicatorColor(Color value) {
    return merge(RemixSpinnerStyle(indicatorColor: value));
  }

  RemixSpinnerStyle trackColor(Color value) {
    return merge(RemixSpinnerStyle(trackColor: value));
  }

  RemixSpinnerStyle strokeWidth(double value) {
    return merge(RemixSpinnerStyle(strokeWidth: value));
  }

  RemixSpinnerStyle trackStrokeWidth(double value) {
    return merge(RemixSpinnerStyle(trackStrokeWidth: value));
  }

  RemixSpinnerStyle duration(Duration value) {
    return merge(RemixSpinnerStyle(duration: value));
  }

  // Animate support
  RemixSpinnerStyle animate(AnimationConfig animation) {
    return merge(RemixSpinnerStyle(animation: animation));
  }

  RemixSpinner call() {
    return RemixSpinner(style: this);
  }

  // Variant support

  @override
  RemixSpinnerStyle variants(List<VariantStyle<RemixSpinnerSpec>> value) {
    return merge(RemixSpinnerStyle(variants: value));
  }

  @override
  RemixSpinnerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSpinnerStyle(modifier: value));
  }

  @override
  StyleSpec<RemixSpinnerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSpinnerSpec(
        size: MixOps.resolve(context, $size),
        strokeWidth: MixOps.resolve(context, $strokeWidth),
        indicatorColor: MixOps.resolve(context, $indicatorColor),
        trackColor: MixOps.resolve(context, $trackColor),
        trackStrokeWidth: MixOps.resolve(context, $trackStrokeWidth),
        duration: MixOps.resolve(context, $duration),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSpinnerStyle merge(RemixSpinnerStyle? other) {
    if (other == null) return this;

    return RemixSpinnerStyle.create(
      size: MixOps.merge($size, other.$size),
      strokeWidth: MixOps.merge($strokeWidth, other.$strokeWidth),
      indicatorColor: MixOps.merge($indicatorColor, other.$indicatorColor),
      trackColor: MixOps.merge($trackColor, other.$trackColor),
      trackStrokeWidth: MixOps.merge($trackStrokeWidth, other.$trackStrokeWidth),
      duration: MixOps.merge($duration, other.$duration),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $size,
        $strokeWidth,
        $indicatorColor,
        $trackColor,
        $trackStrokeWidth,
        $duration,
        $variants,
        $animation,
        $modifier,
      ];
}
