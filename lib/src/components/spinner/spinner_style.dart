part of 'spinner.dart';

class RemixSpinnerStyle extends Style<SpinnerSpec>
    with
        StyleModifierMixin<RemixSpinnerStyle, SpinnerSpec>,
        StyleVariantMixin<RemixSpinnerStyle, SpinnerSpec> {
  final Prop<double>? $size;
  final Prop<double>? $strokeWidth;
  final Prop<Color>? $color;
  final Prop<Duration>? $duration;
  final Prop<SpinnerType>? $style;

  const RemixSpinnerStyle.create({
    Prop<double>? size,
    Prop<double>? strokeWidth,
    Prop<Color>? color,
    Prop<Duration>? duration,
    Prop<SpinnerType>? style,
    super.variants,
    super.animation,
    super.modifier,
  })  : $size = size,
        $strokeWidth = strokeWidth,
        $color = color,
        $duration = duration,
        $style = style;

  RemixSpinnerStyle({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerType? style,
    AnimationConfig? animation,
    List<VariantStyle<SpinnerSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          size: Prop.maybe(size),
          strokeWidth: Prop.maybe(strokeWidth),
          color: Prop.maybe(color),
          duration: Prop.maybe(duration),
          style: Prop.maybe(style),
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
    return merge(RemixSpinnerStyle(style: value));
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
  RemixSpinnerStyle variant(Variant variant, RemixSpinnerStyle style) {
    return merge(RemixSpinnerStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixSpinnerStyle variants(List<VariantStyle<SpinnerSpec>> value) {
    return merge(RemixSpinnerStyle(variants: value));
  }

  @override
  RemixSpinnerStyle wrap(ModifierConfig value) {
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
        style: MixOps.resolve(context, $style),
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
      style: MixOps.merge($style, other.$style),
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
        $style,
        $variants,
        $animation,
        $modifier,
      ];
}


/// Default spinner styles and variants
class RemixSpinnerStyles {
  /// Default spinner style
  static RemixSpinnerStyle get defaultStyle => RemixSpinnerStyle(
        size: RemixTokens.iconSizeXl(),
        strokeWidth: 1.5,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerType.solid,
      );

  /// Primary spinner variant
  static RemixSpinnerStyle get primary => RemixSpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerType.solid,
      );

  /// Secondary spinner variant
  static RemixSpinnerStyle get secondary => RemixSpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: RemixTokens.textSecondary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerType.solid,
      );

  /// Small spinner variant
  static RemixSpinnerStyle get small => RemixSpinnerStyle(
        size: 16,
        strokeWidth: 1,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerType.solid,
      );

  /// Large spinner variant
  static RemixSpinnerStyle get large => RemixSpinnerStyle(
        size: 32,
        strokeWidth: 2,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerType.solid,
      );

  /// Dotted spinner variant
  static RemixSpinnerStyle get dotted => RemixSpinnerStyle(
        size: RemixTokens.iconSizeXl(),
        strokeWidth: 1.5,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerType.dotted,
      );
}
