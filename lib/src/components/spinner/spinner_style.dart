part of 'spinner.dart';

class SpinnerStyle extends Style<SpinnerSpec>
    with StyleModifierMixin<SpinnerStyle, SpinnerSpec>, StyleVariantMixin<SpinnerStyle, SpinnerSpec> {
  final Prop<double>? $size;
  final Prop<double>? $strokeWidth;
  final Prop<Color>? $color;
  final Prop<Duration>? $duration;
  final Prop<SpinnerStyleType>? $style;

  const SpinnerStyle.create({
    Prop<double>? size,
    Prop<double>? strokeWidth,
    Prop<Color>? color,
    Prop<Duration>? duration,
    Prop<SpinnerStyleType>? style,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $size = size,
        $strokeWidth = strokeWidth,
        $color = color,
        $duration = duration,
        $style = style;

  SpinnerStyle({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerStyleType? style,
    AnimationConfig? animation,
    List<VariantStyle<SpinnerSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          size: Prop.maybe(size),
          strokeWidth: Prop.maybe(strokeWidth),
          color: Prop.maybe(color),
          duration: Prop.maybe(duration),
          style: Prop.maybe(style),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory SpinnerStyle.value(SpinnerSpec spec) => SpinnerStyle(
        size: spec.size,
        strokeWidth: spec.strokeWidth,
        color: spec.color,
        duration: spec.duration,
        style: spec.style,
      );

  // Factory constructors for common patterns
  factory SpinnerStyle.size(double value) {
    return SpinnerStyle(size: value);
  }

  factory SpinnerStyle.color(Color value) {
    return SpinnerStyle(color: value);
  }

  // Instance methods for fluent API (return new instances)
  SpinnerStyle size(double value) {
    return merge(SpinnerStyle.size(value));
  }

  SpinnerStyle color(Color value) {
    return merge(SpinnerStyle.color(value));
  }

  // Animate support
  SpinnerStyle animate(AnimationConfig animation) {
    return merge(SpinnerStyle(animation: animation));
  }

  // Variant support
  @override
  SpinnerStyle variant(Variant variant, SpinnerStyle style) {
    return merge(SpinnerStyle(variants: [VariantStyle(variant, style)]));
  }

  RemixSpinner call() {
    return RemixSpinner(
      style: this,
    );
  }

  @override
  SpinnerStyle variants(List<VariantStyle<SpinnerSpec>> value) {
    return merge(SpinnerStyle(variants: value));
  }

  @override
  SpinnerStyle wrap(ModifierConfig value) {
    return merge(SpinnerStyle(modifier: value));
  }

  @override
  SpinnerSpec resolve(BuildContext context) {
    return SpinnerSpec(
      size: MixOps.resolve(context, $size),
      strokeWidth: MixOps.resolve(context, $strokeWidth),
      color: MixOps.resolve(context, $color),
      duration: MixOps.resolve(context, $duration),
      style: MixOps.resolve(context, $style),
    );
  }

  @override
  SpinnerStyle merge(SpinnerStyle? other) {
    if (other == null) return this;

    return SpinnerStyle.create(
      size: MixOps.merge($size, other.$size),
      strokeWidth: MixOps.merge($strokeWidth, other.$strokeWidth),
      color: MixOps.merge($color, other.$color),
      duration: MixOps.merge($duration, other.$duration),
      style: MixOps.merge($style, other.$style),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $size,
        $strokeWidth,
        $color,
        $duration,
        $style,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultSpinnerStyle = SpinnerStyle(
  size: 24,
  strokeWidth: 1.5,
  color: Colors.black,
  duration: const Duration(milliseconds: 1000),
  style: SpinnerStyleType.solid,
);

/// Default spinner styles and variants
class SpinnerStyles {
  /// Default spinner style
  static SpinnerStyle get defaultStyle => SpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: Colors.black,
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyleType.solid,
      );

  /// Primary spinner variant
  static SpinnerStyle get primary => SpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: Colors.blue,
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyleType.solid,
      );

  /// Secondary spinner variant
  static SpinnerStyle get secondary => SpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: Colors.grey,
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyleType.solid,
      );

  /// Small spinner variant
  static SpinnerStyle get small => SpinnerStyle(
        size: 16,
        strokeWidth: 1,
        color: Colors.black,
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyleType.solid,
      );

  /// Large spinner variant
  static SpinnerStyle get large => SpinnerStyle(
        size: 32,
        strokeWidth: 2,
        color: Colors.black,
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyleType.solid,
      );

  /// Dotted spinner variant
  static SpinnerStyle get dotted => SpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: Colors.black,
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyleType.dotted,
      );
}