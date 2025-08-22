part of 'progress.dart';

class ProgressSpec extends WidgetSpec<ProgressSpec> {
  final WidgetContainerProperties container;
  final WidgetContainerProperties track;
  final WidgetContainerProperties fill;
  final WidgetContainerProperties outerContainer;

  const ProgressSpec({
    WidgetContainerProperties? container,
    WidgetContainerProperties? track,
    WidgetContainerProperties? fill,
    WidgetContainerProperties? outerContainer,
  })  : container = container ?? const WidgetContainerProperties(),
        track = track ?? const WidgetContainerProperties(),
        fill = fill ?? const WidgetContainerProperties(),
        outerContainer = outerContainer ?? const WidgetContainerProperties();

  @override
  ProgressSpec copyWith({
    WidgetContainerProperties? container,
    WidgetContainerProperties? track,
    WidgetContainerProperties? fill,
    WidgetContainerProperties? outerContainer,
  }) {
    return ProgressSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      fill: fill ?? this.fill,
      outerContainer: outerContainer ?? this.outerContainer,
    );
  }

  @override
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
