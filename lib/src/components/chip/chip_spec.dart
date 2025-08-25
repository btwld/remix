part of 'chip.dart';

class ChipSpec extends WidgetSpec<ChipSpec> {
  final ContainerSpec container;
  final FlexProperties flex;
  final TextSpec label;
  final IconSpec leading;
  final IconSpec trailing;

  const ChipSpec({
    ContainerSpec? container,
    FlexProperties? flex,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        flex = flex ?? const FlexProperties(),
        label = label ?? const TextSpec(),
        leading = leading ?? const IconSpec(),
        trailing = trailing ?? const IconSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  ChipSpec copyWith({
    ContainerSpec? container,
    FlexProperties? flex,
    TextSpec? label,
    IconSpec? leading,
    IconSpec? trailing,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return ChipSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      label: label ?? this.label,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [...super.props, container, flex, label, leading, trailing];
}