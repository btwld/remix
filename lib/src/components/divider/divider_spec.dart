part of 'divider.dart';

class DividerSpec extends WidgetSpec<DividerSpec> {
  final ContainerProperties container;

  const DividerSpec({
    ContainerProperties? container,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerProperties(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  DividerSpec copyWith({
    ContainerProperties? container,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return DividerSpec(
      container: container ?? this.container,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  DividerSpec lerp(DividerSpec? other, double t) {
    if (other == null) return this;

    return DividerSpec(
      container: MixOps.lerp(container, other.container, t)!,
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [...super.props, container];
}
