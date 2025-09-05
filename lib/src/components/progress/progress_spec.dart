part of 'progress.dart';

class ProgressSpec extends Spec<ProgressSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> track;
  final StyleSpec<BoxSpec> indicator;
  final StyleSpec<BoxSpec> trackContainer;

  const ProgressSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<BoxSpec>? trackContainer,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        track = track ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: BoxSpec()),
        trackContainer = trackContainer ?? const StyleSpec(spec: BoxSpec());

  ProgressSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<BoxSpec>? trackContainer,
  }) {
    return ProgressSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      indicator: indicator ?? this.indicator,
      trackContainer: trackContainer ?? this.trackContainer,
    );
  }

  ProgressSpec lerp(ProgressSpec? other, double t) {
    if (other == null) return this;

    return ProgressSpec(
      container: MixOps.lerp(container, other.container, t)!,
      track: MixOps.lerp(track, other.track, t)!,
      indicator: MixOps.lerp(indicator, other.indicator, t)!,
      trackContainer: MixOps.lerp(trackContainer, other.trackContainer, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('track', track))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('trackContainer', trackContainer));
  }

  @override
  List<Object?> get props => [container, track, indicator, trackContainer];
}
