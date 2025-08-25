part of 'tooltip.dart';

class TooltipSpec extends WidgetSpec<TooltipSpec> {
  final ContainerSpec container;
  final TextSpec text;

  const TooltipSpec({
    ContainerSpec? container,
    TextSpec? text,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        text = text ?? const TextSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  TooltipSpec copyWith({
    ContainerSpec? container,
    TextSpec? text,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return TooltipSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  TooltipSpec lerp(TooltipSpec? other, double t) {
    if (other == null) return this;

    return TooltipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      text: MixOps.lerp(text, other.text, t)!,
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
      ..add(DiagnosticsProperty('text', text));
  }

  @override
  List<Object?> get props => [...super.props, container, text];
}
