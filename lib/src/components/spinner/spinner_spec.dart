part of 'spinner.dart';

enum SpinnerStyle {
  solid,
  dotted,
}

class SpinnerSpec extends Spec<SpinnerSpec> with Diagnosticable {
  final double? size;
  final double? strokeWidth;
  final Color? color;
  final Duration? duration;
  final SpinnerStyle? style;

  const SpinnerSpec({
    this.size,
    this.strokeWidth,
    this.color,
    this.duration,
    this.style,
  });

  SpinnerSpec copyWith({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerStyle? style,
  }) {
    return SpinnerSpec(
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      style: style ?? this.style,
    );
  }

  SpinnerSpec lerp(SpinnerSpec? other, double t) {
    if (other == null) return this;

    return SpinnerSpec(
      size: MixOps.lerp(size, other.size, t),
      strokeWidth: MixOps.lerp(strokeWidth, other.strokeWidth, t),
      color: MixOps.lerp(color, other.color, t),
      duration: MixOps.lerpSnap(duration, other.duration, t),
      style: MixOps.lerpSnap(style, other.style, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('size', size))
      ..add(DiagnosticsProperty('strokeWidth', strokeWidth))
      ..add(DiagnosticsProperty('color', color))
      ..add(DiagnosticsProperty('duration', duration))
      ..add(DiagnosticsProperty('style', style));
  }

  @override
  List<Object?> get props => [size, strokeWidth, color, duration, style];
}
