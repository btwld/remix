part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final WidgetSpec<TextSpec> label;
  final WidgetSpec<IconSpec> leading;
  final WidgetSpec<IconSpec> trailing;
  final WidgetSpec<FlexSpec> flex;

  const LabelSpec({
    WidgetSpec<TextSpec>? label,
    WidgetSpec<IconSpec>? leading,
    WidgetSpec<IconSpec>? trailing,
    WidgetSpec<FlexSpec>? flex,
  })  : label = label ?? const WidgetSpec(spec: TextSpec()),
        leading = leading ?? const WidgetSpec(spec: IconSpec()),
        trailing = trailing ?? const WidgetSpec(spec: IconSpec()),
        flex = flex ?? const WidgetSpec(spec: FlexSpec());

  LabelSpec copyWith({
    WidgetSpec<TextSpec>? label,
    WidgetSpec<IconSpec>? leading,
    WidgetSpec<IconSpec>? trailing,
    WidgetSpec<FlexSpec>? flex,
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
