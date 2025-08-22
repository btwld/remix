part of 'spinner.dart';

enum SpinnerStyle {
  solid,
  dotted,
}

class SpinnerSpec extends WidgetSpec<SpinnerSpec> {
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
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) : super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  SpinnerSpec copyWith({
    double? size,
    double? strokeWidth,
    Color? color,
    Duration? duration,
    SpinnerStyle? style,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return SpinnerSpec(
      size: size ?? this.size,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      style: style ?? this.style,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  SpinnerSpec lerp(SpinnerSpec? other, double t) {
    if (other == null) return this;

    return SpinnerSpec(
      size: MixOps.lerp(size, other.size, t),
      strokeWidth: MixOps.lerp(strokeWidth, other.strokeWidth, t),
      color: MixOps.lerp(color, other.color, t),
      duration: MixOps.lerpSnap(duration, other.duration, t),
      style: MixOps.lerpSnap(style, other.style, t),
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [...super.props, size, strokeWidth, color, duration, style];
}
