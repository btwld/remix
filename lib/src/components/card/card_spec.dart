part of 'card.dart';

class CardSpec extends WidgetSpec<CardSpec> {
  final ContainerProperties container;

  const CardSpec({
    ContainerProperties? container,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerProperties(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  CardSpec copyWith({
    ContainerProperties? container,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return CardSpec(
      container: container ?? this.container,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  CardSpec lerp(CardSpec? other, double t) {
    if (other == null) return this;

    return CardSpec(
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
