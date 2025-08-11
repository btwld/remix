part of 'slider.dart';

class SliderSpec extends Spec<SliderSpec> with Diagnosticable {
  final BoxSpec thumb;
  final PaintData baseTrack;
  final PaintData activeTrack;
  final PaintData division;

  const SliderSpec({
    BoxSpec? thumb,
    PaintData? baseTrack,
    PaintData? activeTrack,
    PaintData? division,
  })  : thumb = thumb ?? const BoxSpec(),
        baseTrack = baseTrack ?? const PaintData(),
        activeTrack = activeTrack ?? const PaintData(),
        division = division ?? const PaintData();

  @override
  SliderSpec copyWith({
    BoxSpec? thumb,
    PaintData? baseTrack,
    PaintData? activeTrack,
    PaintData? division,
  }) {
    return SliderSpec(
      thumb: thumb ?? this.thumb,
      baseTrack: baseTrack ?? this.baseTrack,
      activeTrack: activeTrack ?? this.activeTrack,
      division: division ?? this.division,
    );
  }

  @override
  SliderSpec lerp(SliderSpec? other, double t) {
    if (other == null) return this;

    return SliderSpec(
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
      baseTrack: MixOps.lerp(baseTrack, other.baseTrack, t)!,
      activeTrack: MixOps.lerp(activeTrack, other.activeTrack, t)!,
      division: MixOps.lerp(division, other.division, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('thumb', thumb, defaultValue: null));
    properties.add(DiagnosticsProperty('baseTrack', baseTrack, defaultValue: null));
    properties.add(DiagnosticsProperty('activeTrack', activeTrack, defaultValue: null));
    properties.add(DiagnosticsProperty('division', division, defaultValue: null));
  }

  @override
  List<Object?> get props => [thumb, baseTrack, activeTrack, division];
}

class PaintData extends Spec<PaintData> with Diagnosticable {
  final double strokeWidth;
  final Color color;
  final StrokeCap strokeCap;

  const PaintData({
    double? strokeWidth,
    Color? color,
    StrokeCap? strokeCap,
  })  : strokeWidth = strokeWidth ?? 8,
        color = color ?? Colors.grey,
        strokeCap = strokeCap ?? StrokeCap.round;

  @override
  PaintData copyWith({
    double? strokeWidth,
    Color? color,
    StrokeCap? strokeCap,
  }) {
    return PaintData(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      strokeCap: strokeCap ?? this.strokeCap,
    );
  }

  @override
  PaintData lerp(PaintData? other, double t) {
    if (other == null) return this;

    return PaintData(
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t),
      color: Color.lerp(color, other.color, t),
      strokeCap: t < 0.5 ? strokeCap : other.strokeCap,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('strokeWidth', strokeWidth, defaultValue: 8));
    properties.add(ColorProperty('color', color, defaultValue: Colors.grey));
    properties.add(EnumProperty<StrokeCap>('strokeCap', strokeCap, defaultValue: StrokeCap.round));
  }

  @override
  List<Object?> get props => [strokeWidth, color, strokeCap];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is PaintData &&
        other.strokeWidth == strokeWidth &&
        other.color == color &&
        other.strokeCap == strokeCap;
  }

  @override
  int get hashCode => strokeWidth.hashCode ^ color.hashCode ^ strokeCap.hashCode;
}