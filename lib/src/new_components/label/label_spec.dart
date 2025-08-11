part of 'label.dart';

enum IconPosition {
  start,
  end,
}

class LabelSpec extends Spec<LabelSpec> with Diagnosticable {
  final double spacing;
  final TextSpec label;
  final IconSpec icon;
  final IconPosition iconPosition;

  const LabelSpec({
    double? spacing,
    TextSpec? label,
    IconSpec? icon,
    IconPosition? iconPosition,
  })  : spacing = spacing ?? 8,
        label = label ?? const TextSpec(),
        icon = icon ?? const IconSpec(),
        iconPosition = iconPosition ?? IconPosition.start;

  @override
  LabelSpec copyWith({
    double? spacing,
    TextSpec? label,
    IconSpec? icon,
    IconPosition? iconPosition,
  }) {
    return LabelSpec(
      spacing: spacing ?? this.spacing,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      iconPosition: iconPosition ?? this.iconPosition,
    );
  }

  @override
  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      spacing: MixOps.lerp(spacing, other.spacing, t),
      label: MixOps.lerp(label, other.label, t),
      icon: MixOps.lerp(icon, other.icon, t),
      iconPosition: MixOps.lerp(iconPosition, other.iconPosition, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty('spacing', spacing, defaultValue: null),
    );
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
    properties.add(
      DiagnosticsProperty('iconPosition', iconPosition, defaultValue: null),
    );
  }

  @override
  List<Object?> get props => [spacing, label, icon, iconPosition];
}
