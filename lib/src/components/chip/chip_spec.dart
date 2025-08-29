part of 'chip.dart';

class ChipSpec extends Spec<ChipSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<FlexSpec> flex;
  final WidgetSpec<TextSpec> label;
  final WidgetSpec<IconSpec> leading;
  final WidgetSpec<IconSpec> trailing;

  const ChipSpec({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<FlexSpec>? flex,
    WidgetSpec<TextSpec>? label,
    WidgetSpec<IconSpec>? leading,
    WidgetSpec<IconSpec>? trailing,
  })  : container = container ?? const WidgetSpec(spec: BoxSpec()),
        flex = flex ?? const WidgetSpec(spec: FlexSpec()),
        label = label ?? const WidgetSpec(spec: TextSpec()),
        leading = leading ?? const WidgetSpec(spec: IconSpec()),
        trailing = trailing ?? const WidgetSpec(spec: IconSpec());

  ChipSpec copyWith({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<FlexSpec>? flex,
    WidgetSpec<TextSpec>? label,
    WidgetSpec<IconSpec>? leading,
    WidgetSpec<IconSpec>? trailing,
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
