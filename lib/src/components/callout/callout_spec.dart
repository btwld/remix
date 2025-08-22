part of 'callout.dart';

class CalloutSpec extends WidgetSpec<CalloutSpec> {
  final WidgetContainerProperties container;
  final TextSpec text;
  final IconSpec icon;

  const CalloutSpec({WidgetContainerProperties? container, TextSpec? text, IconSpec? icon})
      : container = container ?? const WidgetContainerProperties(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  @override
  CalloutSpec copyWith({WidgetContainerProperties? container, TextSpec? text, IconSpec? icon}) {
    return CalloutSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  CalloutSpec lerp(CalloutSpec? other, double t) {
    if (other == null) return this;

    return CalloutSpec(
      container: MixOps.lerp(container, other.container, t)!,
      text: MixOps.lerp(text, other.text, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
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
  List<Object?> get props => [container, text, icon];
}
