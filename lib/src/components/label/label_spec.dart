part of 'label.dart';

class LabelSpec extends WidgetSpec<LabelSpec> {
  final double spacing;
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;

  const LabelSpec({
    double? spacing,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : spacing = spacing ?? 8,
        label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  LabelSpec copyWith({
    double? spacing,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return LabelSpec(
      spacing: spacing ?? this.spacing,
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('spacing', spacing))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing));
  }

  @override
  List<Object?> get props => [...super.props, spacing, label, leading, trailing];
}