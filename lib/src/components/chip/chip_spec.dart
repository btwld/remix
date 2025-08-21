part of 'chip.dart';

class ChipSpec extends Spec<ChipSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;

  const ChipSpec({
    FlexBoxSpec? container,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  })  : container = container ?? const FlexBoxSpec(),
        label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec();

  @override
  ChipSpec copyWith({
    FlexBoxSpec? container,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  }) {
    return ChipSpec(
      container: container ?? this.container,
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
      label: MixOps.lerp(label, other.label, t)!,
      leading: MixOps.lerp(leading, other.leading, t)!,
      trailing: MixOps.lerp(trailing, other.trailing, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('leading', leading, defaultValue: null));
    properties.add(DiagnosticsProperty('trailing', trailing, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, label, leading, trailing];
}