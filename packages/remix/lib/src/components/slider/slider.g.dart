// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSliderSpecMethods on Spec<RemixSliderSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get thumb;
  Color? get trackColor;
  double? get trackWidth;
  Color? get rangeColor;
  double? get rangeWidth;

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
      thumb: thumb?.lerp(other?.thumb, t),
      trackColor: MixOps.lerp(trackColor, other?.trackColor, t),
      trackWidth: MixOps.lerp(trackWidth, other?.trackWidth, t),
      rangeColor: MixOps.lerp(rangeColor, other?.rangeColor, t),
      rangeWidth: MixOps.lerp(rangeWidth, other?.rangeWidth, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('thumb', thumb))
      ..add(ColorProperty('trackColor', trackColor))
      ..add(DoubleProperty('trackWidth', trackWidth))
      ..add(ColorProperty('rangeColor', rangeColor))
      ..add(DoubleProperty('rangeWidth', rangeWidth));
  }

  @override
  List<Object?> get props => [
    thumb,
    trackColor,
    trackWidth,
    rangeColor,
    rangeWidth,
  ];
}
