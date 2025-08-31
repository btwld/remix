part of 'switch.dart';

class SwitchSpec extends Spec<SwitchSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> track;
  final StyleSpec<BoxSpec> thumb;

  const SwitchSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? thumb,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        track = track ?? const StyleSpec(spec: BoxSpec()),
        thumb = thumb ?? const StyleSpec(spec: BoxSpec());

  SwitchSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? thumb,
  }) {
    return SwitchSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      thumb: thumb ?? this.thumb,
    );
  }

  SwitchSpec lerp(SwitchSpec? other, double t) {
    if (other == null) return this;

    return SwitchSpec(
      container: MixOps.lerp(container, other.container, t)!,
      track: MixOps.lerp(track, other.track, t)!,
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('track', track))
      ..add(DiagnosticsProperty('thumb', thumb));
  }

  @override
  List<Object?> get props => [container, track, thumb];
}
