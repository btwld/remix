part of 'avatar.dart';

class AvatarSpec extends Spec<AvatarSpec> with Diagnosticable {
  final BoxSpec container;
  final TextSpec text;
  final IconSpec icon;

  const AvatarSpec({BoxSpec? container, TextSpec? text, IconSpec? icon})
      : container = container ?? const BoxSpec(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  @override
  AvatarSpec copyWith({BoxSpec? container, TextSpec? text, IconSpec? icon}) {
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
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('text', text, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, text, icon];
}
