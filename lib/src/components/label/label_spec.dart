part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;
  final FlexSpec flex;

  const LabelSpec({
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
    FlexSpec? flex,
  })  : label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        flex = flex ?? const FlexSpec();

  LabelSpec copyWith({
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
    FlexSpec? flex,
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
