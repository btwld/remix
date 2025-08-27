part of 'badge.dart';

class BadgeSpec extends Spec<BadgeSpec> with Diagnosticable {
  final BoxSpec container;
  final TextSpec text;
  final IconSpec icon;

  const BadgeSpec({BoxSpec? container, TextSpec? text, IconSpec? icon})
      : container = container ?? const BoxSpec(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  BadgeSpec copyWith({BoxSpec? container, TextSpec? text, IconSpec? icon}) {
    return BadgeSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

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
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, text, icon];
}
