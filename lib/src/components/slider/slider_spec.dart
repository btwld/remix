part of 'slider.dart';

const Size _remixSliderDefaultThumbSize = Size(16.0, 16.0);
const double _remixSliderDefaultTrackStrokeWidth = 8.0;

// Default track and range configurations
const Color _defaultTrackColor = MixColors.grey;
const Color _defaultRangeColor = MixColors.black;

class RemixSliderSpec extends Spec<RemixSliderSpec> with Diagnosticable {
  static const Size defaultThumbSize = _remixSliderDefaultThumbSize;
  static const double defaultTrackStrokeWidth =
      _remixSliderDefaultTrackStrokeWidth;

  final StyleSpec<BoxSpec> thumb;
  final Color trackColor;
  final double trackWidth;
  final Color rangeColor;
  final double rangeWidth;

  RemixSliderSpec({
    StyleSpec<BoxSpec>? thumb,
    Color? trackColor,
    double? trackWidth,
    Color? rangeColor,
    double? rangeWidth,
  }) : thumb = thumb ?? const StyleSpec(spec: BoxSpec()),
       trackColor = trackColor ?? _defaultTrackColor,
       trackWidth = trackWidth ?? _remixSliderDefaultTrackStrokeWidth,
       rangeColor = rangeColor ?? _defaultRangeColor,
       rangeWidth = rangeWidth ?? _remixSliderDefaultTrackStrokeWidth;

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

  RemixSliderSpec lerp(RemixSliderSpec? other, double t) {
    if (other == null) return this;

    return RemixSliderSpec(
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
      trackColor: Color.lerp(trackColor, other.trackColor, t)!,
      trackWidth: lerpDouble(trackWidth, other.trackWidth, t)!,
      rangeColor: Color.lerp(rangeColor, other.rangeColor, t)!,
      rangeWidth: lerpDouble(rangeWidth, other.rangeWidth, t)!,
    );
  }

  double get trackThickness => math.max(trackWidth, rangeWidth);

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
