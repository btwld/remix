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
    ..color = Color.lerp(a.color, b.color, t) ?? Colors.grey
    ..strokeWidth = lerpDouble(a.strokeWidth, b.strokeWidth, t) ?? 8.0
    ..strokeCap = t < 0.5 ? a.strokeCap : b.strokeCap
    ..style = PaintingStyle.stroke // Always stroke for slider tracks
    ..isAntiAlias = t < 0.5 ? a.isAntiAlias : b.isAntiAlias;
}

// Default paint for fallback
final _defaultPaint = Paint()
  ..color = Colors.grey
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

// Default Paint configurations (replacing PaintData defaults)
final _defaultBaseTrackPaint = Paint()
  ..color = Colors.grey
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

final _defaultActiveTrackPaint = Paint()
  ..color = Colors.black
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

final _defaultDivisionPaint = Paint()
  ..color = const Color(0x42000000) // Colors.black.withAlpha(66)
  ..strokeWidth = 8.0
  ..strokeCap = StrokeCap.round
  ..style = PaintingStyle.stroke;

class SliderSpec extends Spec<SliderSpec> with Diagnosticable {
  final BoxSpec thumb;
  final Paint baseTrack;
  final Paint activeTrack;
  final Paint division;

  SliderSpec({
    BoxSpec? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    Paint? division,
  })  : thumb = thumb ?? const BoxSpec(),
        baseTrack = baseTrack ?? _defaultBaseTrackPaint,
        activeTrack = activeTrack ?? _defaultActiveTrackPaint,
        division = division ?? _defaultDivisionPaint;

  SliderSpec copyWith({
    BoxSpec? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    Paint? division,
  }) {
    return SliderSpec(
      thumb: thumb ?? this.thumb,
      baseTrack: baseTrack ?? this.baseTrack,
      activeTrack: activeTrack ?? this.activeTrack,
      division: division ?? this.division,
    );
  }

  SliderSpec lerp(SliderSpec? other, double t) {
    if (other == null) return this;

    return SliderSpec(
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
      baseTrack: lerpPaint(baseTrack, other.baseTrack, t),
      activeTrack: lerpPaint(activeTrack, other.activeTrack, t),
      division: lerpPaint(division, other.division, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('thumb', thumb))
      ..add(DiagnosticsProperty('baseTrack', baseTrack))
      ..add(DiagnosticsProperty('activeTrack', activeTrack))
      ..add(DiagnosticsProperty('division', division));
  }

  @override
  List<Object?> get props => [thumb, baseTrack, activeTrack, division];
}
