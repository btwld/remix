part of 'slider.dart';

const Size _remixSliderDefaultThumbSize = Size(16.0, 16.0);
const double _remixSliderDefaultTrackStrokeWidth = 8.0;

const Color _defaultTrackColor = MixColors.grey;
const Color _defaultRangeColor = MixColors.black;

/// Resolved visual values for a [RemixSlider].
///
/// A slider spec contains the thumb box style plus the track and range colors
/// and stroke widths used when painting the control.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class RemixSliderSpec with _$RemixSliderSpec {
  /// Default thumb size used when the thumb style does not resolve a size.
  static const Size defaultThumbSize = _remixSliderDefaultThumbSize;

  /// Default stroke width for both the track and range.
  static const double defaultTrackStrokeWidth =
      _remixSliderDefaultTrackStrokeWidth;

  /// Resolved style for the slider thumb.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> thumb;

  /// Color of the unfilled slider track.
  @override
  final Color trackColor;

  /// Stroke width of the unfilled slider track.
  @override
  final double trackWidth;

  /// Color of the filled slider range.
  @override
  final Color rangeColor;

  /// Stroke width of the filled slider range.
  @override
  final double rangeWidth;

  /// Creates resolved slider styling values.
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

  /// Largest track or range width used for layout clearance.
  double get trackThickness => math.max(trackWidth, rangeWidth);
}
