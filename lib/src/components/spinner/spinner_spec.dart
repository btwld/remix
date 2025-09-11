part of 'spinner.dart';

enum SpinnerType {
  solid,
  dotted,
}

class SpinnerSpec extends Spec<SpinnerSpec> with Diagnosticable {
  final double? size;
  final double? strokeWidth;
  final Color? color;
  final Duration? duration;
  final SpinnerType? _type;

  const SpinnerSpec({
    this.size,
    this.strokeWidth,
    this.color,
    this.duration,
    SpinnerType? type,
  }) : _type = type;

  /// Gets the spinner type value
  SpinnerType? get spinnerType => _type;

  SpinnerSpec copyWith({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerType? type,
  }) {
    return SpinnerSpec(
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      type: type ?? this._type,
    );
  }

  SpinnerSpec lerp(SpinnerSpec? other, double t) {
    if (other == null) return this;

    return SpinnerSpec(
      size: MixOps.lerp(size, other.size, t),
      strokeWidth: MixOps.lerp(strokeWidth, other.strokeWidth, t),
      color: MixOps.lerp(color, other.color, t),
      duration: MixOps.lerpSnap(duration, other.duration, t),
      type: MixOps.lerpSnap(_type, other._type, t),
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
      ..add(DiagnosticsProperty('type', _type));
  }

  @override
  List<Object?> get props => [size, strokeWidth, color, duration, _type];
}
