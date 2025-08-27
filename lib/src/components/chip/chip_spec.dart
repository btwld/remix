part of 'chip.dart';

class ChipSpec extends Spec<ChipSpec> with Diagnosticable {
  final BoxSpec container;
  final FlexSpec flex;
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;

  const ChipSpec({
    BoxSpec? container,
    FlexSpec? flex,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  })  : container = container ?? const BoxSpec(),
        flex = flex ?? const FlexSpec(),
        label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec();

  ChipSpec copyWith({
    BoxSpec? container,
    FlexSpec? flex,
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
