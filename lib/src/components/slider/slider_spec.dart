part of 'slider.dart';

/// Linearly interpolates between two Paint objects
///
/// The [t] argument represents position on timeline (0.0 to 1.0)
/// Returns [a] when t=0.0, [b] when t=1.0, interpolated values between
Paint lerpPaint(Paint? a, Paint? b, double t) {
  if (a == null && b == null) return _defaultPaint;
  if (a == null) return Paint.from(b!);
  if (b == null) return Paint.from(a);

  return Paint()
    ..color = Color.lerp(a.color, b.color, t) ?? MixColors.grey
    ..strokeWidth = lerpDouble(a.strokeWidth, b.strokeWidth, t) ?? 8.0
    ..strokeCap = t < 0.5 ? a.strokeCap : b.strokeCap
    ..style = PaintingStyle.stroke // Always stroke for slider tracks
    ..isAntiAlias = t < 0.5 ? a.isAntiAlias : b.isAntiAlias;
}

// Default paint for fallback
final _defaultPaint = Paint()
  ..color = MixColors.grey
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

// Default Paint configurations (replacing PaintData defaults)
final _defaultBaseTrackPaint = Paint()
  ..color = MixColors.grey
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

final _defaultActiveTrackPaint = Paint()
  ..color = MixColors.black
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

class RemixSliderSpec extends Spec<RemixSliderSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> thumb;
  final Paint baseTrack;
  final Paint activeTrack;

  RemixSliderSpec({
    StyleSpec<BoxSpec>? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
  })  : thumb = thumb ?? const StyleSpec(spec: BoxSpec()),
        baseTrack = baseTrack ?? _defaultBaseTrackPaint,
        activeTrack = activeTrack ?? _defaultActiveTrackPaint;

  RemixSliderSpec copyWith({
    StyleSpec<BoxSpec>? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
  }) {
    return RemixSliderSpec(
      thumb: thumb ?? this.thumb,
      baseTrack: baseTrack ?? this.baseTrack,
      activeTrack: activeTrack ?? this.activeTrack,
    );
  }

  RemixSliderSpec lerp(RemixSliderSpec? other, double t) {
    if (other == null) return this;

    return RemixSliderSpec(
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
      baseTrack: lerpPaint(baseTrack, other.baseTrack, t),
      activeTrack: lerpPaint(activeTrack, other.activeTrack, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('thumb', thumb))
      ..add(DiagnosticsProperty('baseTrack', baseTrack))
      ..add(DiagnosticsProperty('activeTrack', activeTrack));
  }

  @override
  List<Object?> get props => [thumb, baseTrack, activeTrack];
}
