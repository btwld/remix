part of 'slider.dart';

const Size _remixSliderDefaultThumbSize = Size(16.0, 16.0);
const double _remixSliderDefaultTrackStrokeWidth = 8.0;

/// Linearly interpolates between two Paint objects
///
/// The [t] argument represents position on timeline (0.0 to 1.0)
/// Returns [a] when t=0.0, [b] when t=1.0, interpolated values between
Paint lerpPaint(Paint? a, Paint? b, double t) {
  if (a == null && b == null) return Paint.from(_defaultTrackPaint);
  if (a == null) return Paint.from(b!);
  if (b == null) return Paint.from(a);

  return Paint()
    ..color = Color.lerp(a.color, b.color, t) ?? _defaultTrackPaint.color
    ..strokeWidth = lerpDouble(a.strokeWidth, b.strokeWidth, t) ??
        _defaultTrackPaint.strokeWidth
    ..strokeCap = t < 0.5 ? a.strokeCap : b.strokeCap
    ..style = PaintingStyle.stroke // Always stroke for slider tracks
    ..isAntiAlias = t < 0.5 ? a.isAntiAlias : b.isAntiAlias;
}

// Default Paint configurations
final _defaultTrackPaint = Paint()
  ..color = MixColors.grey
  ..strokeWidth = _remixSliderDefaultTrackStrokeWidth
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

final _defaultRangePaint = Paint()
  ..color = MixColors.black
  ..strokeWidth = _remixSliderDefaultTrackStrokeWidth
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

class RemixSliderSpec extends Spec<RemixSliderSpec> with Diagnosticable {
  static const Size defaultThumbSize = _remixSliderDefaultThumbSize;
  static const double defaultTrackStrokeWidth =
      _remixSliderDefaultTrackStrokeWidth;

  final StyleSpec<BoxSpec> thumb;
  final Paint track;
  final Paint range;

  RemixSliderSpec({
    StyleSpec<BoxSpec>? thumb,
    Paint? track,
    Paint? range,
  })  : thumb = thumb ?? const StyleSpec(spec: BoxSpec()),
        track = track ?? _defaultTrackPaint,
        range = range ?? _defaultRangePaint;

  RemixSliderSpec copyWith({
    StyleSpec<BoxSpec>? thumb,
    Paint? track,
    Paint? range,
  }) {
    return RemixSliderSpec(
      thumb: thumb ?? this.thumb,
      track: track ?? this.track,
      range: range ?? this.range,
    );
  }

  RemixSliderSpec lerp(RemixSliderSpec? other, double t) {
    if (other == null) return this;

    return RemixSliderSpec(
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
      track: lerpPaint(track, other.track, t),
      range: lerpPaint(range, other.range, t),
    );
  }

  double get trackThickness =>
      math.max(track.strokeWidth, range.strokeWidth);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('thumb', thumb))
      ..add(DiagnosticsProperty('track', track))
      ..add(DiagnosticsProperty('range', range));
  }

  @override
  List<Object?> get props => [thumb, track, range];
}
