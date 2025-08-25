part of 'switch.dart';

class SwitchSpec extends WidgetSpec<SwitchSpec> {
  final ContainerSpec container;
  final ContainerSpec track;
  final ContainerSpec thumb;

  const SwitchSpec({
    ContainerSpec? container,
    ContainerSpec? track,
    ContainerSpec? thumb,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        track = track ?? const ContainerSpec(),
        thumb = thumb ?? const ContainerSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  SwitchSpec copyWith({
    ContainerSpec? container,
    ContainerSpec? track,
    ContainerSpec? thumb,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return SwitchSpec(
      container: container ?? this.container,
      track: track ?? this.track,
      thumb: thumb ?? this.thumb,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  SwitchSpec lerp(SwitchSpec? other, double t) {
    if (other == null) return this;

    return SwitchSpec(
      container: MixOps.lerp(container, other.container, t)!,
      track: MixOps.lerp(track, other.track, t)!,
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
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
      ..add(DiagnosticsProperty('thumb', thumb));
  }

  @override
  List<Object?> get props => [...super.props, container, track, thumb];
}
