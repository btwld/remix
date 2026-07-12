// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSpinnerSpec implements Spec<RemixSpinnerSpec>, Diagnosticable {
  double? get size;
  double? get strokeWidth;
  Color? get indicatorColor;
  Color? get trackColor;
  double? get trackStrokeWidth;
  Duration? get duration;

  @override
  Type get type => RemixSpinnerSpec;

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
  List<Object?> get props => [
    size,
    strokeWidth,
    indicatorColor,
    trackColor,
    trackStrokeWidth,
    duration,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSpinnerSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DoubleProperty('size', size))
      ..add(DoubleProperty('strokeWidth', strokeWidth))
      ..add(ColorProperty('indicatorColor', indicatorColor))
      ..add(ColorProperty('trackColor', trackColor))
      ..add(DoubleProperty('trackStrokeWidth', trackStrokeWidth))
      ..add(DiagnosticsProperty('duration', duration));
  }
}

@Deprecated(
  'Rename to `_\$RemixSpinnerSpec` and migrate the class declaration to `class RemixSpinnerSpec with _\$RemixSpinnerSpec`. The `_\$RemixSpinnerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSpinnerSpecMethods = _$RemixSpinnerSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixSpinner].
class FortalSpinner extends StatelessWidget {
  const FortalSpinner({super.key, this.size = .size2});

  final FortalSpinnerSize size;

  @override
  Widget build(BuildContext context) {
    return fortalSpinnerStyler(size: this.size).call(key: this.key);
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSpinnerStylerMixin on Style<RemixSpinnerSpec>, Diagnosticable {
  Prop<double>? get $size;
  Prop<double>? get $strokeWidth;
  Prop<Color>? get $indicatorColor;
  Prop<Color>? get $trackColor;
  Prop<double>? get $trackStrokeWidth;
  Prop<Duration>? get $duration;

  /// Sets the size.
  RemixSpinnerStyler size(double value) {
    return merge(RemixSpinnerStyler(size: value));
  }

  /// Sets the strokeWidth.
  RemixSpinnerStyler strokeWidth(double value) {
    return merge(RemixSpinnerStyler(strokeWidth: value));
  }

  /// Sets the indicatorColor.
  RemixSpinnerStyler indicatorColor(Color value) {
    return merge(RemixSpinnerStyler(indicatorColor: value));
  }

  /// Sets the trackColor.
  RemixSpinnerStyler trackColor(Color value) {
    return merge(RemixSpinnerStyler(trackColor: value));
  }

  /// Sets the trackStrokeWidth.
  RemixSpinnerStyler trackStrokeWidth(double value) {
    return merge(RemixSpinnerStyler(trackStrokeWidth: value));
  }

  /// Sets the duration.
  RemixSpinnerStyler duration(Duration value) {
    return merge(RemixSpinnerStyler(duration: value));
  }

  /// Sets the animation configuration.
  RemixSpinnerStyler animate(AnimationConfig value) {
    return merge(RemixSpinnerStyler(animation: value));
  }

  /// Sets the style variants.
  RemixSpinnerStyler variants(List<VariantStyle<RemixSpinnerSpec>> value) {
    return merge(RemixSpinnerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSpinnerStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSpinnerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSpinnerStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSpinnerStyler(modifier: value));
  }

  /// Merges with another [RemixSpinnerStyler].
  @override
  RemixSpinnerStyler merge(RemixSpinnerStyler? other) {
    return RemixSpinnerStyler.create(
      size: MixOps.merge($size, other?.$size),
      strokeWidth: MixOps.merge($strokeWidth, other?.$strokeWidth),
      indicatorColor: MixOps.merge($indicatorColor, other?.$indicatorColor),
      trackColor: MixOps.merge($trackColor, other?.$trackColor),
      trackStrokeWidth: MixOps.merge(
        $trackStrokeWidth,
        other?.$trackStrokeWidth,
      ),
      duration: MixOps.merge($duration, other?.$duration),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSpinnerSpec>] using [context].
  @override
  StyleSpec<RemixSpinnerSpec> resolve(BuildContext context) {
    final spec = RemixSpinnerSpec(
      size: MixOps.resolve(context, $size),
      strokeWidth: MixOps.resolve(context, $strokeWidth),
      indicatorColor: MixOps.resolve(context, $indicatorColor),
      trackColor: MixOps.resolve(context, $trackColor),
      trackStrokeWidth: MixOps.resolve(context, $trackStrokeWidth),
      duration: MixOps.resolve(context, $duration),
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
      ..add(DiagnosticsProperty('size', $size))
      ..add(DiagnosticsProperty('strokeWidth', $strokeWidth))
      ..add(DiagnosticsProperty('indicatorColor', $indicatorColor))
      ..add(DiagnosticsProperty('trackColor', $trackColor))
      ..add(DiagnosticsProperty('trackStrokeWidth', $trackStrokeWidth))
      ..add(DiagnosticsProperty('duration', $duration));
  }

  @override
  List<Object?> get props => [
    $size,
    $strokeWidth,
    $indicatorColor,
    $trackColor,
    $trackStrokeWidth,
    $duration,
    $animation,
    $modifier,
    $variants,
  ];
}
