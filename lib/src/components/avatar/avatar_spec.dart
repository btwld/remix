part of 'avatar.dart';

class RemixAvatarSpec extends Spec<RemixAvatarSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> text;
  final StyleSpec<IconSpec> icon;

  const RemixAvatarSpec({StyleSpec<BoxSpec>? container, StyleSpec<TextSpec>? text, StyleSpec<IconSpec>? icon})
      : container = container ?? const StyleSpec(spec: BoxSpec()),
        text = text ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  RemixAvatarSpec copyWith({StyleSpec<BoxSpec>? container, StyleSpec<TextSpec>? text, StyleSpec<IconSpec>? icon}) {
    return RemixAvatarSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  RemixAvatarSpec lerp(RemixAvatarSpec? other, double t) {
    if (other == null) return this;

    return RemixAvatarSpec(
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
