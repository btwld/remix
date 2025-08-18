part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final double spacing;
  final TextSpec label;
  final IconSpec leadingIcon;
  final IconSpec trailingIcon;

  const LabelSpec({
    double? spacing,
    TextSpec? label,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
  })  : spacing = spacing ?? 8,
        label = label ?? const TextSpec(),
        leadingIcon = leadingIcon ?? const IconSpec(),
        trailingIcon = trailingIcon ?? const IconSpec();

  @override
  LabelSpec copyWith({
    double? spacing,
    TextSpec? label,
    IconSpec? leadingIcon,
    IconSpec? trailingIcon,
  }) {
    return LabelSpec(
      spacing: spacing ?? this.spacing,
      label: label ?? this.label,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
    );
  }

  @override
  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      spacing: MixOps.lerp(spacing, other.spacing, t),
      label: MixOps.lerp(label, other.label, t),
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t),
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('spacing', spacing, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('leadingIcon', leadingIcon, defaultValue: null));
    properties.add(
      DiagnosticsProperty('trailingIcon', trailingIcon, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [spacing, label, leadingIcon, trailingIcon];
}