part of 'label.dart';

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final double spacing;
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;

  const LabelSpec({
    double? spacing,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  })  : spacing = spacing ?? 8,
        label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec();

  @override
  LabelSpec copyWith({
    double? spacing,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
  }) {
    return LabelSpec(
      spacing: spacing ?? this.spacing,
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
    );
  }

  @override
  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      spacing: MixOps.lerp(spacing, other.spacing, t),
      label: MixOps.lerp(label, other.label, t),
      leading: MixOps.lerp(leading, other.leading, t),
      trailing: MixOps.lerp(trailing, other.trailing, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('spacing', spacing, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('leading', leading, defaultValue: null));
    properties.add(
      DiagnosticsProperty('trailing', trailing, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [spacing, label, leading, trailing];
}