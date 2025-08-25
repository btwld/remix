part of 'label.dart';

class LabelSpec extends WidgetSpec<LabelSpec> {
  final TypographySpec label;
  final IconographySpec leading;
  final IconographySpec trailing;
  final FlexLayoutSpec flex;

  const LabelSpec({
    TypographySpec? label,
    IconographySpec? leading,
    IconographySpec? trailing,
    FlexLayoutSpec? flex,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : label = label ?? const TypographySpec(),
        leading = leading ?? const IconographySpec(),
        trailing = trailing ?? const IconographySpec(),
        flex = flex ?? const FlexLayoutSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  LabelSpec copyWith({
    TypographySpec? label,
    IconographySpec? leading,
    IconographySpec? trailing,
    FlexLayoutSpec? flex,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return LabelSpec(
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      flex: flex ?? this.flex,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  LabelSpec lerp(LabelSpec? other, double t) {
    if (other == null) return this;

    return LabelSpec(
      label: MixOps.lerp(label, other.label, t),
      leading: MixOps.lerp(leading, other.leading, t),
      trailing: MixOps.lerp(trailing, other.trailing, t),
      flex: MixOps.lerp(flex, other.flex, t),
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('leading', leading))
      ..add(DiagnosticsProperty('trailing', trailing))
      ..add(DiagnosticsProperty('flex', flex));
  }

  @override
  List<Object?> get props => [...super.props, label, leading, trailing, flex];
}