part of 'spinner.dart';

class RemixSpinnerSpec extends Spec<RemixSpinnerSpec> with Diagnosticable {
  final double? size;
  final double? strokeWidth;
  final Color? indicatorColor;
  final Color? trackColor;
  final double? trackStrokeWidth;
  final Duration? duration;

  const RemixSpinnerSpec({
    this.size,
    this.strokeWidth,
    this.indicatorColor,
    this.trackColor,
    this.trackStrokeWidth,
    this.duration,
  });

  RemixSpinnerSpec copyWith({
    double? size,
    double? strokeWidth,
    Color? indicatorColor,
    Color? trackColor,
    double? trackStrokeWidth,
    Duration? duration,
  }) {
    return RemixSpinnerSpec(
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      trackColor: trackColor ?? this.trackColor,
      trackStrokeWidth: trackStrokeWidth ?? this.trackStrokeWidth,
      duration: duration ?? this.duration,
    );
  }

  RemixSpinnerSpec lerp(RemixSpinnerSpec? other, double t) {
    if (other == null) return this;

    return RemixSpinnerSpec(
      size: MixOps.lerp(size, other.size, t),
      strokeWidth: MixOps.lerp(strokeWidth, other.strokeWidth, t),
      indicatorColor: MixOps.lerp(indicatorColor, other.indicatorColor, t),
      trackColor: MixOps.lerp(trackColor, other.trackColor, t),
      trackStrokeWidth: MixOps.lerp(trackStrokeWidth, other.trackStrokeWidth, t),
      duration: MixOps.lerpSnap(duration, other.duration, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('strokeWidth', strokeWidth))
      ..add(DiagnosticsProperty('indicatorColor', indicatorColor))
      ..add(DiagnosticsProperty('trackColor', trackColor))
      ..add(DiagnosticsProperty('trackStrokeWidth', trackStrokeWidth))
      ..add(DiagnosticsProperty('duration', duration));
  }

  @override
  List<Object?> get props => [
        size,
        strokeWidth,
        indicatorColor,
        trackColor,
        trackStrokeWidth,
        duration,
      ];
}
