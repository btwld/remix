part of 'badge.dart';

class BadgeSpec extends Spec<BadgeSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<TextSpec> text;
  final WidgetSpec<IconSpec> icon;

  const BadgeSpec({WidgetSpec<BoxSpec>? container, WidgetSpec<TextSpec>? text, WidgetSpec<IconSpec>? icon})
      : container = container ?? const WidgetSpec(spec: BoxSpec()),
        text = text ?? const WidgetSpec(spec: TextSpec()),
        icon = icon ?? const WidgetSpec(spec: IconSpec());

  BadgeSpec copyWith({WidgetSpec<BoxSpec>? container, WidgetSpec<TextSpec>? text, WidgetSpec<IconSpec>? icon}) {
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
