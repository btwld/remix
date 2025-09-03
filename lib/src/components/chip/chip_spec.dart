part of 'chip.dart';

class ChipSpec extends Spec<ChipSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<FlexSpec> flex;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const ChipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexSpec>? flex,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        flex = flex ?? const StyleSpec(spec: FlexSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  ChipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexSpec>? flex,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return ChipSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  ChipSpec lerp(ChipSpec? other, double t) {
    if (other == null) return this;

    return ChipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      flex: MixOps.lerp(flex, other.flex, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, flex, label, icon];
}
