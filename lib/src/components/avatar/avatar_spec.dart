part of 'avatar.dart';

class AvatarSpec extends WidgetSpec<AvatarSpec> {
  final WidgetContainerProperties container;
  final TextSpec text;
  final IconSpec icon;

  const AvatarSpec({WidgetContainerProperties? container, TextSpec? text, IconSpec? icon})
      : container = container ?? const WidgetContainerProperties(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  @override
  AvatarSpec copyWith({WidgetContainerProperties? container, TextSpec? text, IconSpec? icon}) {
    return AvatarSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  AvatarSpec lerp(AvatarSpec? other, double t) {
    if (other == null) return this;

    return AvatarSpec(
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
