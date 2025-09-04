part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;
  final StyleSpec<FlexSpec> flex;
  final IconPosition iconPosition;

  const LabelSpec({
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<FlexSpec>? flex,
    this.iconPosition = IconPosition.leading,
  })  : label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec()),
        flex = flex ?? const StyleSpec(spec: FlexSpec());

  LabelSpec copyWith({
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<FlexSpec>? flex,
    IconPosition? iconPosition,
  }) {
    return LabelSpec(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      flex: flex ?? this.flex,
      iconPosition: iconPosition ?? this.iconPosition,
    );
  }

  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      label: MixOps.lerp(label, other.label, t),
      icon: MixOps.lerp(icon, other.icon, t),
      flex: MixOps.lerp(flex, other.flex, t),
      iconPosition: t < 0.5 ? iconPosition : other.iconPosition,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('iconPosition', iconPosition));
  }

  @override
  List<Object?> get props => [label, icon, flex, iconPosition];
}