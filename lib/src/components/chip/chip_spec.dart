part of 'chip.dart';

class ChipSpec extends Spec<ChipSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec label;
  final IconSpec leadingIcon;
  final IconSpec trailingIcon;

  const ChipSpec({
    FlexBoxSpec? container,
    TextSpec? label,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
  })  : container = container ?? const FlexBoxSpec(),
        label = label ?? const TextSpec(),
        leadingIcon = leadingIcon ?? const IconSpec(),
        trailingIcon = trailingIcon ?? const IconSpec();

  @override
  ChipSpec copyWith({
    FlexBoxSpec? container,
    TextSpec? label,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
  }) {
    return ChipSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
    );
  }

  @override
  ChipSpec lerp(ChipSpec? other, double t) {
    if (other == null) return this;

    return ChipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t)!,
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('leadingIcon', leadingIcon, defaultValue: null));
    properties.add(DiagnosticsProperty('trailingIcon', trailingIcon, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, label, leadingIcon, trailingIcon];
}