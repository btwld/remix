part of 'badge.dart';

class BadgeSpec extends WidgetSpec<BadgeSpec> {
  final ContainerSpec container;
  final TextSpec text;
  final IconSpec icon;

  const BadgeSpec({
    ContainerSpec? container,
    TextSpec? text,
    IconSpec? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  BadgeSpec copyWith({
    ContainerSpec? container,
    TextSpec? text,
    IconSpec? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return BadgeSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  BadgeSpec lerp(BadgeSpec? other, double t) {
    if (other == null) return this;

    return BadgeSpec(
      container: MixOps.lerp(container, other.container, t)!,
      text: MixOps.lerp(text, other.text, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
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
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [...super.props, container, text, icon];
}
