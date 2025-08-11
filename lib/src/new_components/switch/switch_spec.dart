part of 'switch.dart';

class SwitchSpec extends Spec<SwitchSpec> with Diagnosticable {
  final BoxSpec container;
  final BoxSpec track;
  final BoxSpec thumb;

  const SwitchSpec({BoxSpec? container, BoxSpec? track, BoxSpec? thumb})
      : container = container ?? const BoxSpec(),
        track = track ?? const BoxSpec(),
        thumb = thumb ?? const BoxSpec();

  @override
  SwitchSpec copyWith({BoxSpec? container, BoxSpec? track, BoxSpec? thumb}) {
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
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('track', track, defaultValue: null));
    properties.add(DiagnosticsProperty('thumb', thumb, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, track, thumb];
}
