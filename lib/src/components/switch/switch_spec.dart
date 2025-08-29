part of 'switch.dart';

class SwitchSpec extends Spec<SwitchSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<BoxSpec> track;
  final WidgetSpec<BoxSpec> thumb;

  const SwitchSpec({WidgetSpec<BoxSpec>? container, WidgetSpec<BoxSpec>? track, WidgetSpec<BoxSpec>? thumb})
      : container = container ?? const WidgetSpec(spec: BoxSpec()),
        track = track ?? const WidgetSpec(spec: BoxSpec()),
        thumb = thumb ?? const WidgetSpec(spec: BoxSpec());

  SwitchSpec copyWith({WidgetSpec<BoxSpec>? container, WidgetSpec<BoxSpec>? track, WidgetSpec<BoxSpec>? thumb}) {
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
