part of 'spinner.dart';

class RemixSpinnerStyle extends RemixStyle<RemixSpinnerSpec, RemixSpinnerStyle> {
  final Prop<double>? $size;
  final Prop<double>? $strokeWidth;
  final Prop<Color>? $color;
  final Prop<Duration>? $duration;
  final Prop<SpinnerType>? $type;

  const RemixSpinnerStyle.create({
    Prop<double>? size,
    Prop<double>? strokeWidth,
    Prop<Color>? color,
    Prop<Duration>? duration,
    Prop<SpinnerType>? type,
    super.variants,
    super.animation,
    super.modifier,
  })  : $size = size,
        $strokeWidth = strokeWidth,
        $color = color,
        $duration = duration,
        $type = type;

  RemixSpinnerStyle({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerType? type,
    AnimationConfig? animation,
    List<VariantStyle<RemixSpinnerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          size: Prop.maybe(size),
          strokeWidth: Prop.maybe(strokeWidth),
          color: Prop.maybe(color),
          duration: Prop.maybe(duration),
          type: Prop.maybe(type),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods for fluent API (return new instances)
  RemixSpinnerStyle size(double value) {
    return merge(RemixSpinnerStyle(size: value));
  }

  RemixSpinnerStyle color(Color value) {
    return merge(RemixSpinnerStyle(color: value));
  }

  RemixSpinnerStyle strokeWidth(double value) {
    return merge(RemixSpinnerStyle(strokeWidth: value));
  }

  RemixSpinnerStyle duration(Duration value) {
    return merge(RemixSpinnerStyle(duration: value));
  }

  RemixSpinnerStyle spinnerType(SpinnerType value) {
    return merge(RemixSpinnerStyle(type: value));
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
        color: MixOps.resolve(context, $color),
        duration: MixOps.resolve(context, $duration),
        type: MixOps.resolve(context, $type),
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
      color: MixOps.merge($color, other.$color),
      duration: MixOps.merge($duration, other.$duration),
      type: MixOps.merge($type, other.$type),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $size,
        $strokeWidth,
        $color,
        $duration,
        $type,
        $variants,
        $animation,
        $modifier,
      ];
}
