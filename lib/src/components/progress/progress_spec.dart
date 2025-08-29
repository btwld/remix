part of 'progress.dart';

class ProgressSpec extends Spec<ProgressSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<BoxSpec> track;
  final WidgetSpec<BoxSpec> fill;
  final WidgetSpec<BoxSpec> outerContainer;

  const ProgressSpec({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<BoxSpec>? track,
    WidgetSpec<BoxSpec>? fill,
    WidgetSpec<BoxSpec>? outerContainer,
  })  : container = container ?? const WidgetSpec(spec: BoxSpec()),
        track = track ?? const WidgetSpec(spec: BoxSpec()),
        fill = fill ?? const WidgetSpec(spec: BoxSpec()),
        outerContainer = outerContainer ?? const WidgetSpec(spec: BoxSpec());

  ProgressSpec copyWith({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<BoxSpec>? track,
    WidgetSpec<BoxSpec>? fill,
    WidgetSpec<BoxSpec>? outerContainer,
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
