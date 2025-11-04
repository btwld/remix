part of 'progress.dart';

class RemixProgressSpec extends Spec<RemixProgressSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> track;
  final StyleSpec<BoxSpec> indicator;
  final StyleSpec<BoxSpec> trackContainer;

  const RemixProgressSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<BoxSpec>? trackContainer,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        track = track ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: BoxSpec()),
        trackContainer = trackContainer ?? const StyleSpec(spec: BoxSpec());

  RemixProgressSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<BoxSpec>? trackContainer,
  }) {
    return RemixProgressSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      indicator: indicator ?? this.indicator,
      trackContainer: trackContainer ?? this.trackContainer,
    );
  }

  RemixProgressSpec lerp(RemixProgressSpec? other, double t) {
    if (other == null) return this;

    return RemixProgressSpec(
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
