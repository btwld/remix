part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;
  final StyleSpec<FlexSpec> flex;

  const LabelSpec({
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<FlexSpec>? flex,
  })  : label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec()),
        flex = flex ?? const StyleSpec(spec: FlexSpec());

  LabelSpec copyWith({
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<FlexSpec>? flex,
  }) {
    return LabelSpec(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      flex: flex ?? this.flex,
    );
  }

  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      label: MixOps.lerp(label, other.label, t),
      icon: MixOps.lerp(icon, other.icon, t),
      flex: MixOps.lerp(flex, other.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('flex', flex));
  }

  @override
  List<Object?> get props => [label, icon, flex];
}