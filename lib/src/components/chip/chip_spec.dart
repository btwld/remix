part of 'chip.dart';

class ChipSpec extends WidgetSpec<ChipSpec> {
  final WidgetContainerProperties container;
  final WidgetFlexProperties flex;
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;

  const ChipSpec({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  })  : container = container ?? const WidgetContainerProperties(),
        flex = flex ?? const WidgetFlexProperties(),
        label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec();

  @override
  ChipSpec copyWith({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  }) {
    return ChipSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
    );
  }

  @override
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