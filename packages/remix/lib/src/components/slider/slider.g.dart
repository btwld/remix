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
