part of 'slider.dart';

const Size _remixSliderDefaultThumbSize = Size(16.0, 16.0);
const double _remixSliderDefaultTrackStrokeWidth = 8.0;

// Default track and range configurations
const Color _defaultTrackColor = MixColors.grey;
const Color _defaultRangeColor = MixColors.black;

@MixableSpec()
class RemixSliderSpec extends Spec<RemixSliderSpec>
    with Diagnosticable, _$RemixSliderSpecMethods {
  static const Size defaultThumbSize = _remixSliderDefaultThumbSize;
  static const double defaultTrackStrokeWidth =
      _remixSliderDefaultTrackStrokeWidth;

  @override
  final StyleSpec<BoxSpec> thumb;
  @override
  final Color trackColor;
  @override
  final double trackWidth;
  @override
  final Color rangeColor;
  @override
  final double rangeWidth;

  RemixSliderSpec({
    StyleSpec<BoxSpec>? thumb,
    Color? trackColor,
    double? trackWidth,
    Color? rangeColor,
    double? rangeWidth,
  }) : thumb = thumb ?? const StyleSpec(spec: BoxSpec()),
       rangeColor = rangeColor ?? _defaultRangeColor,
       trackWidth = trackWidth ?? _remixSliderDefaultTrackStrokeWidth,
       rangeWidth = rangeWidth ?? _remixSliderDefaultTrackStrokeWidth,
       trackColor = trackColor ?? _defaultTrackColor;

  double get trackThickness => math.max(trackWidth, rangeWidth);
}
