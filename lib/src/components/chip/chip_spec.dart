part of 'chip.dart';

class ChipSpec extends Spec<ChipSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<FlexSpec> flex;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> leading;
  final StyleSpec<IconSpec> trailing;

  const ChipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexSpec>? flex,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leading,
    StyleSpec<IconSpec>? trailing,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        flex = flex ?? const StyleSpec(spec: FlexSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        leading = leading ?? const StyleSpec(spec: IconSpec()),
        trailing = trailing ?? const StyleSpec(spec: IconSpec());

  ChipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<FlexSpec>? flex,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leading,
    StyleSpec<IconSpec>? trailing,
  }) {
    return ChipSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
    );
  }

  ChipSpec lerp(ChipSpec? other, double t) {
    if (other == null) return this;

    return ChipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      flex: MixOps.lerp(flex, other.flex, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      leading: MixOps.lerp(leading, other.leading, t)!,
      trailing: MixOps.lerp(trailing, other.trailing, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing));
  }

  @override
  List<Object?> get props => [container, flex, label, leading, trailing];
}
