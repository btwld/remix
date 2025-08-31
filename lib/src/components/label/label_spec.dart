part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> leading;
  final StyleSpec<IconSpec> trailing;
  final StyleSpec<FlexSpec> flex;

  const LabelSpec({
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leading,
    StyleSpec<IconSpec>? trailing,
    StyleSpec<FlexSpec>? flex,
  })  : label = label ?? const StyleSpec(spec: TextSpec()),
        leading = leading ?? const StyleSpec(spec: IconSpec()),
        trailing = trailing ?? const StyleSpec(spec: IconSpec()),
        flex = flex ?? const StyleSpec(spec: FlexSpec());

  LabelSpec copyWith({
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leading,
    StyleSpec<IconSpec>? trailing,
    StyleSpec<FlexSpec>? flex,
  }) {
    return LabelSpec(
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      flex: flex ?? this.flex,
    );
  }

  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      label: MixOps.lerp(label, other.label, t),
      leading: MixOps.lerp(leading, other.leading, t),
      trailing: MixOps.lerp(trailing, other.trailing, t),
      flex: MixOps.lerp(flex, other.flex, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing))
      ..add(DiagnosticsProperty('flex', flex));
  }

  @override
  List<Object?> get props => [label, leading, trailing, flex];
}
