part of 'spinner.dart';

class RemixSpinnerStyle extends Style<SpinnerSpec>
    with
        StyleModifierMixin<RemixSpinnerStyle, SpinnerSpec>,
        StyleVariantMixin<RemixSpinnerStyle, SpinnerSpec> {
  final Prop<double>? $size;
  final Prop<double>? $strokeWidth;
  final Prop<Color>? $color;
  final Prop<Duration>? $duration;
  final Prop<SpinnerStyle>? $style;

  const RemixSpinnerStyle.create({
    Prop<double>? size,
    Prop<double>? strokeWidth,
    Prop<Color>? color,
    Prop<Duration>? duration,
    Prop<SpinnerStyle>? style,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
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
    SpinnerStyle? style,
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

  factory RemixSpinnerStyle.value(SpinnerSpec spec) => RemixSpinnerStyle(
        size: spec.size,
        strokeWidth: spec.strokeWidth,
        color: spec.color,
        duration: spec.duration,
        style: spec.style,
      );

  // Factory constructors for common patterns
  factory RemixSpinnerStyle.size(double value) {
    return RemixSpinnerStyle(size: value);
  }

  factory RemixSpinnerStyle.color(Color value) {
    return RemixSpinnerStyle(color: value);
  }

  // Instance methods for fluent API (return new instances)
  RemixSpinnerStyle size(double value) {
    return merge(RemixSpinnerStyle.size(value));
  }

  RemixSpinnerStyle color(Color value) {
    return merge(RemixSpinnerStyle.color(value));
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
  WidgetSpec<SpinnerSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: SpinnerSpec(
        size: MixOps.resolve(context, $size),
        strokeWidth: MixOps.resolve(context, $strokeWidth),
        color: MixOps.resolve(context, $color),
        duration: MixOps.resolve(context, $duration),
        style: MixOps.resolve(context, $style),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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

final DefaultRemixSpinnerStyle = RemixSpinnerStyle(
  size: RemixTokens.iconSizeXl(),
  strokeWidth: 1.5,
  color: RemixTokens.textPrimary(),
  duration: const Duration(milliseconds: 1000),
  style: SpinnerStyle.solid,
);

/// Default spinner styles and variants
class RemixSpinnerStyles {
  /// Default spinner style
  static RemixSpinnerStyle get defaultStyle => RemixSpinnerStyle(
        size: RemixTokens.iconSizeXl(),
        strokeWidth: 1.5,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyle.solid,
      );

  /// Primary spinner variant
  static RemixSpinnerStyle get primary => RemixSpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyle.solid,
      );

  /// Secondary spinner variant
  static RemixSpinnerStyle get secondary => RemixSpinnerStyle(
        size: 24,
        strokeWidth: 1.5,
        color: RemixTokens.textSecondary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyle.solid,
      );

  /// Small spinner variant
  static RemixSpinnerStyle get small => RemixSpinnerStyle(
        size: 16,
        strokeWidth: 1,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyle.solid,
      );

  /// Large spinner variant
  static RemixSpinnerStyle get large => RemixSpinnerStyle(
        size: 32,
        strokeWidth: 2,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyle.solid,
      );

  /// Dotted spinner variant
  static RemixSpinnerStyle get dotted => RemixSpinnerStyle(
        size: RemixTokens.iconSizeXl(),
        strokeWidth: 1.5,
        color: RemixTokens.textPrimary(),
        duration: const Duration(milliseconds: 1000),
        style: SpinnerStyle.dotted,
      );
}
