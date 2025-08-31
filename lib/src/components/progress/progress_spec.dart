part of 'progress.dart';

class ProgressSpec extends Spec<ProgressSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> track;
  final StyleSpec<BoxSpec> fill;
  final StyleSpec<BoxSpec> outerContainer;

  const ProgressSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? fill,
    StyleSpec<BoxSpec>? outerContainer,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        track = track ?? const StyleSpec(spec: BoxSpec()),
        fill = fill ?? const StyleSpec(spec: BoxSpec()),
        outerContainer = outerContainer ?? const StyleSpec(spec: BoxSpec());

  ProgressSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? fill,
    StyleSpec<BoxSpec>? outerContainer,
  }) {
    return ProgressSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      fill: fill ?? this.fill,
      outerContainer: outerContainer ?? this.outerContainer,
    );
  }

  ProgressSpec lerp(ProgressSpec? other, double t) {
    if (other == null) return this;

    return ProgressSpec(
      container: MixOps.lerp(container, other.container, t)!,
      track: MixOps.lerp(track, other.track, t)!,
      fill: MixOps.lerp(fill, other.fill, t)!,
      outerContainer: MixOps.lerp(outerContainer, other.outerContainer, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('track', track))
      ..add(DiagnosticsProperty('fill', fill))
      ..add(DiagnosticsProperty('outerContainer', outerContainer));
  }

  @override
  List<Object?> get props => [container, track, fill, outerContainer];
}
