part of 'badge.dart';

class BadgeSpec extends Spec<BadgeSpec> with Diagnosticable {
  final BoxSpec container;
  final TextSpec text;
  final IconSpec icon;

  const BadgeSpec({BoxSpec? container, TextSpec? text, IconSpec? icon})
      : container = container ?? const BoxSpec(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  @override
  BadgeSpec copyWith({BoxSpec? container, TextSpec? text, IconSpec? icon}) {
    return BadgeSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  BadgeSpec lerp(BadgeSpec? other, double t) {
    if (other == null) return this;

    return BadgeSpec(
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
