part of 'progress.dart';

class ProgressSpec extends WidgetSpec<ProgressSpec> {
  final ContainerSpec container;
  final ContainerSpec track;
  final ContainerSpec fill;
  final ContainerSpec outerContainer;

  const ProgressSpec({
    ContainerSpec? container,
    ContainerSpec? track,
    ContainerSpec? fill,
    ContainerSpec? outerContainer,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        track = track ?? const ContainerSpec(),
        fill = fill ?? const ContainerSpec(),
        outerContainer = outerContainer ?? const ContainerSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  ProgressSpec copyWith({
    ContainerSpec? container,
    ContainerSpec? track,
    ContainerSpec? fill,
    ContainerSpec? outerContainer,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return ProgressSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      fill: fill ?? this.fill,
      outerContainer: outerContainer ?? this.outerContainer,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [...super.props, container, track, fill, outerContainer];
}
