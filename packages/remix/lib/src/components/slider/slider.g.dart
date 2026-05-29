// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSliderSpec implements Spec<RemixSliderSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get thumb;
  Color get trackColor;
  double get trackWidth;
  Color get rangeColor;
  double get rangeWidth;

  @override
  Type get type => RemixSliderSpec;

  @override
  RemixSliderSpec copyWith({
    StyleSpec<BoxSpec>? thumb,
    Color? trackColor,
    double? trackWidth,
    Color? rangeColor,
    double? rangeWidth,
  }) {
    return RemixSliderSpec(
      thumb: thumb ?? this.thumb,
      trackColor: trackColor ?? this.trackColor,
      trackWidth: trackWidth ?? this.trackWidth,
      rangeColor: rangeColor ?? this.rangeColor,
      rangeWidth: rangeWidth ?? this.rangeWidth,
    );
  }

  @override
  RemixSliderSpec lerp(RemixSliderSpec? other, double t) {
    return RemixSliderSpec(
      thumb: thumb.lerp(other?.thumb, t),
      trackColor: MixOps.lerp(trackColor, other?.trackColor, t),
      trackWidth: MixOps.lerp(trackWidth, other?.trackWidth, t),
      rangeColor: MixOps.lerp(rangeColor, other?.rangeColor, t),
      rangeWidth: MixOps.lerp(rangeWidth, other?.rangeWidth, t),
    );
  }

  @override
  List<Object?> get props => [
    thumb,
    trackColor,
    trackWidth,
    rangeColor,
    rangeWidth,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSliderSpec &&
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
      ..add(DiagnosticsProperty('thumb', thumb))
      ..add(ColorProperty('trackColor', trackColor))
      ..add(DoubleProperty('trackWidth', trackWidth))
      ..add(ColorProperty('rangeColor', rangeColor))
      ..add(DoubleProperty('rangeWidth', rangeWidth));
  }
}

@Deprecated(
  'Rename to `_\$RemixSliderSpec` and migrate the class declaration to `class RemixSliderSpec with _\$RemixSliderSpec`. The `_\$RemixSliderSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSliderSpecMethods = _$RemixSliderSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

class FortalSlider extends StatelessWidget {
  const FortalSlider({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.onChangeStart,
    this.onChangeEnd,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
  });

  final FortalSliderVariant variant;

  final FortalSliderSize size;

  final double value;

  final ValueChanged<double>? onChanged;

  final double min;

  final double max;

  final ValueChanged<double>? onChangeStart;

  final ValueChanged<double>? onChangeEnd;

  final bool enabled;

  final bool enableHapticFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final int? snapDivisions;

  @override
  Widget build(BuildContext context) {
    return fortalSliderStyle(variant: this.variant, size: this.size).call(
      value: this.value,
      onChanged: this.onChanged,
      min: this.min,
      max: this.max,
      onChangeStart: this.onChangeStart,
      onChangeEnd: this.onChangeEnd,
      enabled: this.enabled,
      enableHapticFeedback: this.enableHapticFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      snapDivisions: this.snapDivisions,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSliderStyleMixin on Style<RemixSliderSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $thumb;
  Prop<Color>? get $trackColor;
  Prop<double>? get $trackWidth;
  Prop<Color>? get $rangeColor;
  Prop<double>? get $rangeWidth;

  /// Sets the thumb.
  RemixSliderStyle thumb(BoxStyler value) {
    return merge(RemixSliderStyle(thumb: value));
  }

  /// Sets the trackColor.
  RemixSliderStyle trackColor(Color value) {
    return merge(RemixSliderStyle(trackColor: value));
  }

  /// Sets the trackWidth.
  RemixSliderStyle trackWidth(double value) {
    return merge(RemixSliderStyle(trackWidth: value));
  }

  /// Sets the rangeColor.
  RemixSliderStyle rangeColor(Color value) {
    return merge(RemixSliderStyle(rangeColor: value));
  }

  /// Sets the rangeWidth.
  RemixSliderStyle rangeWidth(double value) {
    return merge(RemixSliderStyle(rangeWidth: value));
  }

  /// Sets the animation configuration.
  RemixSliderStyle animate(AnimationConfig value) {
    return merge(RemixSliderStyle(animation: value));
  }

  /// Sets the style variants.
  RemixSliderStyle variants(List<VariantStyle<RemixSliderSpec>> value) {
    return merge(RemixSliderStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSliderStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSliderStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSliderStyle modifier(WidgetModifierConfig value) {
    return merge(RemixSliderStyle(modifier: value));
  }

  /// Merges with another [RemixSliderStyle].
  @override
  RemixSliderStyle merge(RemixSliderStyle? other) {
    return RemixSliderStyle.create(
      thumb: MixOps.merge($thumb, other?.$thumb),
      trackColor: MixOps.merge($trackColor, other?.$trackColor),
      trackWidth: MixOps.merge($trackWidth, other?.$trackWidth),
      rangeColor: MixOps.merge($rangeColor, other?.$rangeColor),
      rangeWidth: MixOps.merge($rangeWidth, other?.$rangeWidth),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSliderSpec>] using [context].
  @override
  StyleSpec<RemixSliderSpec> resolve(BuildContext context) {
    final spec = RemixSliderSpec(
      thumb: MixOps.resolve(context, $thumb),
      trackColor: MixOps.resolve(context, $trackColor),
      trackWidth: MixOps.resolve(context, $trackWidth),
      rangeColor: MixOps.resolve(context, $rangeColor),
      rangeWidth: MixOps.resolve(context, $rangeWidth),
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
      ..add(DiagnosticsProperty('thumb', $thumb))
      ..add(DiagnosticsProperty('trackColor', $trackColor))
      ..add(DiagnosticsProperty('trackWidth', $trackWidth))
      ..add(DiagnosticsProperty('rangeColor', $rangeColor))
      ..add(DiagnosticsProperty('rangeWidth', $rangeWidth));
  }

  @override
  List<Object?> get props => [
    $thumb,
    $trackColor,
    $trackWidth,
    $rangeColor,
    $rangeWidth,
    $animation,
    $modifier,
    $variants,
  ];
}
