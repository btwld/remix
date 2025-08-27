part of 'progress.dart';

class ProgressSpec extends Spec<ProgressSpec> with Diagnosticable {
  final BoxSpec container;
  final BoxSpec track;
  final BoxSpec fill;
  final BoxSpec outerContainer;

  const ProgressSpec({
    BoxSpec? container,
    BoxSpec? track,
    BoxSpec? fill,
    BoxSpec? outerContainer,
  })  : container = container ?? const BoxSpec(),
        track = track ?? const BoxSpec(),
        fill = fill ?? const BoxSpec(),
        outerContainer = outerContainer ?? const BoxSpec();

  ProgressSpec copyWith({
    BoxSpec? container,
    BoxSpec? track,
    BoxSpec? fill,
    BoxSpec? outerContainer,
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
