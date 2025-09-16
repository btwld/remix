part of 'spinner.dart';

// Private per-component constants
const _kSizeMd = 24.0;
const _kStrokeMd = 1.5;
const _kDurationMs = 1000;

class RemixSpinnerStyle extends RemixStyle<SpinnerSpec, RemixSpinnerStyle> {
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
    List<VariantStyle<SpinnerSpec>>? variants,
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
  RemixSpinnerStyle withVariants(List<VariantStyle<SpinnerSpec>> value) {
    return merge(RemixSpinnerStyle(variants: value));
  }

  @override
  RemixSpinnerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSpinnerStyle(modifier: value));
  }

  @override
  StyleSpec<SpinnerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SpinnerSpec(
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

/// Spinner styles
class RemixSpinnerStyles {
  /// Base spinner style - standard size with primary color
  static RemixSpinnerStyle get baseStyle => RemixSpinnerStyle(
        size: _kSizeMd,
        strokeWidth: _kStrokeMd,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: _kDurationMs),
        type: SpinnerType.solid,
      );

}

/// Extension for convenience access to size methods
extension RemixSpinnerStyleExt on RemixSpinnerStyles {
  /// Small spinner size
  RemixSpinnerStyle get size1 => RemixSpinnerStyles.baseStyle.size(16.0).strokeWidth(1.5);
  
  /// Medium spinner size  
  RemixSpinnerStyle get size2 => RemixSpinnerStyles.baseStyle.size(20.0).strokeWidth(2.0);
  
  /// Large spinner size
  RemixSpinnerStyle get size3 => RemixSpinnerStyles.baseStyle.size(24.0).strokeWidth(2.5);
}
