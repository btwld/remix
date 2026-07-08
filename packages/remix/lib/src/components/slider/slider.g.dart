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

/// Creates a Fortal-themed [RemixSliderStyler].
///
/// The returned style can be passed to [RemixSlider.style] or called directly
/// as a widget factory via [RemixSliderStyler.call].
class FortalSlider extends StatelessWidget {
  const FortalSlider({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
  });

  final FortalSliderVariant variant;

  final FortalSliderSize size;

  final double value;

  final ValueChanged<double>? onChanged;

  final ValueChanged<double>? onChangeStart;

  final ValueChanged<double>? onChangeEnd;

  final double min;

  final double max;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final int? snapDivisions;

  @override
  Widget build(BuildContext context) {
    return fortalSliderStyler(variant: this.variant, size: this.size).call(
      value: this.value,
      onChanged: this.onChanged,
      onChangeStart: this.onChangeStart,
      onChangeEnd: this.onChangeEnd,
      min: this.min,
      max: this.max,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      snapDivisions: this.snapDivisions,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSliderStylerMixin on Style<RemixSliderSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $thumb;
  Prop<Color>? get $trackColor;
  Prop<double>? get $trackWidth;
  Prop<Color>? get $rangeColor;
  Prop<double>? get $rangeWidth;

  /// Sets the thumb.
  RemixSliderStyler thumb(BoxStyler value) {
    return merge(RemixSliderStyler(thumb: value));
  }

  /// Sets the trackColor.
  RemixSliderStyler trackColor(Color value) {
    return merge(RemixSliderStyler(trackColor: value));
  }

  /// Sets the trackWidth.
  RemixSliderStyler trackWidth(double value) {
    return merge(RemixSliderStyler(trackWidth: value));
  }

  /// Sets the rangeColor.
  RemixSliderStyler rangeColor(Color value) {
    return merge(RemixSliderStyler(rangeColor: value));
  }

  /// Sets the rangeWidth.
  RemixSliderStyler rangeWidth(double value) {
    return merge(RemixSliderStyler(rangeWidth: value));
  }

  /// Sets the animation configuration.
  RemixSliderStyler animate(AnimationConfig value) {
    return merge(RemixSliderStyler(animation: value));
  }

  /// Sets the style variants.
  RemixSliderStyler variants(List<VariantStyle<RemixSliderSpec>> value) {
    return merge(RemixSliderStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSliderStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSliderStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSliderStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSliderStyler(modifier: value));
  }

  /// Merges with another [RemixSliderStyler].
  @override
  RemixSliderStyler merge(RemixSliderStyler? other) {
    return RemixSliderStyler.create(
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
