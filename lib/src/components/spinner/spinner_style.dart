part of 'spinner.dart';

// Private per-component constants (sizes only)
const _kSizeSm = 16.0;
const _kSizeMd = 24.0;
const _kSizeLg = 32.0;
const _kStrokeSm = 1.0;
const _kStrokeMd = 1.5;
const _kDurationMs = 1000;

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
        size: _kSizeMd,
        strokeWidth: _kStrokeMd,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: _kDurationMs),
        style: SpinnerType.solid,
      );

  /// Small spinner style
  static RemixSpinnerStyle get small => RemixSpinnerStyle(
        size: _kSizeSm,
        strokeWidth: _kStrokeSm,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: _kDurationMs),
        style: SpinnerType.solid,
      );

  /// Large spinner style
  static RemixSpinnerStyle get large => RemixSpinnerStyle(
        size: _kSizeLg,
        strokeWidth: 2.0,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: _kDurationMs),
        style: SpinnerType.solid,
      );

  /// Dotted spinner style
  static RemixSpinnerStyle get dotted => RemixSpinnerStyle(
        size: _kSizeMd,
        strokeWidth: _kStrokeMd,
        color: RemixTokens.primary(),
        duration: const Duration(milliseconds: _kDurationMs),
        style: SpinnerType.dotted,
      );
}
