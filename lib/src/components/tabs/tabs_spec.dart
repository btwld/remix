part of 'tabs.dart';

class RemixTabBarSpec extends Spec<RemixTabBarSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;

  const RemixTabBarSpec({StyleSpec<FlexBoxSpec>? container})
      : container = container ?? const StyleSpec(spec: FlexBoxSpec());

  RemixTabBarSpec copyWith({StyleSpec<FlexBoxSpec>? container}) {
    return RemixTabBarSpec(container: container ?? this.container);
  }

  RemixTabBarSpec lerp(RemixTabBarSpec? other, double t) {
    if (other == null) return this;

    return RemixTabBarSpec(
      container: MixOps.lerp(container, other.container, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}

class RemixTabSpec extends Spec<RemixTabSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const RemixTabSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  RemixTabSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixTabSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  RemixTabSpec lerp(RemixTabSpec? other, double t) {
    if (other == null) return this;

    return RemixTabSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, label, icon];
}

class RemixTabViewSpec extends Spec<RemixTabViewSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;

  const RemixTabViewSpec({StyleSpec<BoxSpec>? container})
      : container = container ?? const StyleSpec(spec: BoxSpec());

  RemixTabViewSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixTabViewSpec(container: container ?? this.container);
  }

  RemixTabViewSpec lerp(RemixTabViewSpec? other, double t) {
    if (other == null) return this;

    return RemixTabViewSpec(
      container: MixOps.lerp(container, other.container, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}
