part of 'switch.dart';

class SwitchSpec extends WidgetSpec<SwitchSpec> {
  final WidgetContainerProperties container;
  final WidgetContainerProperties track;
  final WidgetContainerProperties thumb;

  const SwitchSpec({WidgetContainerProperties? container, WidgetContainerProperties? track, WidgetContainerProperties? thumb})
      : container = container ?? const WidgetContainerProperties(),
        track = track ?? const WidgetContainerProperties(),
        thumb = thumb ?? const WidgetContainerProperties();

  @override
  SwitchSpec copyWith({WidgetContainerProperties? container, WidgetContainerProperties? track, WidgetContainerProperties? thumb}) {
    return SwitchSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      thumb: thumb ?? this.thumb,
    );
  }

  @override
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
