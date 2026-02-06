// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSpinnerSpecMethods on Spec<RemixSpinnerSpec>, Diagnosticable {
  double? get size;
  double? get strokeWidth;
  Color? get indicatorColor;
  Color? get trackColor;
  double? get trackStrokeWidth;
  Duration? get duration;

  @override
  RemixSpinnerSpec copyWith({
    double? size,
    double? strokeWidth,
    Color? indicatorColor,
    Color? trackColor,
    double? trackStrokeWidth,
    Duration? duration,
  }) {
    return RemixSpinnerSpec(
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      trackColor: trackColor ?? this.trackColor,
      trackStrokeWidth: trackStrokeWidth ?? this.trackStrokeWidth,
      duration: duration ?? this.duration,
    );
  }

  @override
  RemixSpinnerSpec lerp(RemixSpinnerSpec? other, double t) {
    return RemixSpinnerSpec(
      size: MixOps.lerp(size, other?.size, t),
      strokeWidth: MixOps.lerp(strokeWidth, other?.strokeWidth, t),
      indicatorColor: MixOps.lerp(indicatorColor, other?.indicatorColor, t),
      trackColor: MixOps.lerp(trackColor, other?.trackColor, t),
      trackStrokeWidth: MixOps.lerp(
        trackStrokeWidth,
        other?.trackStrokeWidth,
        t,
      ),
      duration: MixOps.lerpSnap(duration, other?.duration, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('strokeWidth', strokeWidth))
      ..add(ColorProperty('indicatorColor', indicatorColor))
      ..add(ColorProperty('trackColor', trackColor))
      ..add(DoubleProperty('trackStrokeWidth', trackStrokeWidth))
      ..add(DiagnosticsProperty('duration', duration));
  }

  @override
  List<Object?> get props => [
    size,
    strokeWidth,
    indicatorColor,
    trackColor,
    trackStrokeWidth,
    duration,
  ];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSpinnerStyleMixin on Style<RemixSpinnerSpec>, Diagnosticable {
  Prop<Duration>? get $duration;
  Prop<Color>? get $indicatorColor;
  Prop<double>? get $size;
  Prop<double>? get $strokeWidth;
  Prop<Color>? get $trackColor;
  Prop<double>? get $trackStrokeWidth;

  /// Sets the duration.
  RemixSpinnerStyle duration(Duration value) {
    return merge(RemixSpinnerStyle(duration: value));
  }

  /// Sets the indicatorColor.
  RemixSpinnerStyle indicatorColor(Color value) {
    return merge(RemixSpinnerStyle(indicatorColor: value));
  }

  /// Sets the size.
  RemixSpinnerStyle size(double value) {
    return merge(RemixSpinnerStyle(size: value));
  }

  /// Sets the strokeWidth.
  RemixSpinnerStyle strokeWidth(double value) {
    return merge(RemixSpinnerStyle(strokeWidth: value));
  }

  /// Sets the trackColor.
  RemixSpinnerStyle trackColor(Color value) {
    return merge(RemixSpinnerStyle(trackColor: value));
  }

  /// Sets the trackStrokeWidth.
  RemixSpinnerStyle trackStrokeWidth(double value) {
    return merge(RemixSpinnerStyle(trackStrokeWidth: value));
  }

  /// Sets the animation configuration.
  RemixSpinnerStyle animate(AnimationConfig value) {
    return merge(RemixSpinnerStyle(animation: value));
  }

  /// Sets the style variants.
  RemixSpinnerStyle variants(List<VariantStyle<RemixSpinnerSpec>> value) {
    return merge(RemixSpinnerStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSpinnerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSpinnerStyle(modifier: value));
  }

  /// Merges with another [RemixSpinnerStyle].
  @override
  RemixSpinnerStyle merge(RemixSpinnerStyle? other) {
    return RemixSpinnerStyle.create(
      duration: MixOps.merge($duration, other?.$duration),
      indicatorColor: MixOps.merge($indicatorColor, other?.$indicatorColor),
      size: MixOps.merge($size, other?.$size),
      strokeWidth: MixOps.merge($strokeWidth, other?.$strokeWidth),
      trackColor: MixOps.merge($trackColor, other?.$trackColor),
      trackStrokeWidth: MixOps.merge(
        $trackStrokeWidth,
        other?.$trackStrokeWidth,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSpinnerSpec>] using context.
  @override
  StyleSpec<RemixSpinnerSpec> resolve(BuildContext context) {
    final spec = RemixSpinnerSpec(
      duration: MixOps.resolve(context, $duration),
      indicatorColor: MixOps.resolve(context, $indicatorColor),
      size: MixOps.resolve(context, $size),
      strokeWidth: MixOps.resolve(context, $strokeWidth),
      trackColor: MixOps.resolve(context, $trackColor),
      trackStrokeWidth: MixOps.resolve(context, $trackStrokeWidth),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('duration', $duration))
      ..add(DiagnosticsProperty('indicatorColor', $indicatorColor))
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('strokeWidth', $strokeWidth))
      ..add(DiagnosticsProperty('trackColor', $trackColor))
      ..add(DiagnosticsProperty('trackStrokeWidth', $trackStrokeWidth));
  }

  @override
  List<Object?> get props => [
    $duration,
    $indicatorColor,
    $size,
    $strokeWidth,
    $trackColor,
    $trackStrokeWidth,
    $animation,
    $modifier,
    $variants,
  ];
}
