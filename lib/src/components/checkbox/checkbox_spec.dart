part of 'checkbox.dart';

class CheckboxSpec extends WidgetSpec<CheckboxSpec> {
  final ContainerSpec container;
  final FlexLayoutSpec flex;
  final ContainerSpec indicatorContainer;
  final IconographySpec indicator;
  final TypographySpec label;

  const CheckboxSpec({
    ContainerSpec? container,
    FlexLayoutSpec? flex,
    ContainerSpec? indicatorContainer,
    IconographySpec? indicator,
    TypographySpec? label,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        flex = flex ?? const FlexLayoutSpec(),
        indicatorContainer = indicatorContainer ?? const ContainerSpec(),
        indicator = indicator ?? const IconographySpec(),
        label = label ?? const TypographySpec(),
        super(
          animation: animation,
          widgetModifiers: widgetModifiers,
          inherit: inherit,
        );

  @override
  CheckboxSpec copyWith({
    ContainerSpec? container,
    FlexLayoutSpec? flex,
    ContainerSpec? indicatorContainer,
    IconographySpec? indicator,
    TypographySpec? label,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return CheckboxSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      indicatorContainer: indicatorContainer ?? this.indicatorContainer,
      indicator: indicator ?? this.indicator,
      label: label ?? this.label,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  CheckboxSpec lerp(CheckboxSpec? other, double t) {
    if (other == null) return this;

    return CheckboxSpec(
      container: MixOps.lerp(container, other.container, t)!,
      flex: MixOps.lerp(flex, other.flex, t)!,
      indicatorContainer:
          MixOps.lerp(indicatorContainer, other.indicatorContainer, t)!,
      indicator: MixOps.lerp(indicator, other.indicator, t)!,
      label: MixOps.lerp(label, other.label, t)!,
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
      ..add(DiagnosticsProperty('indicatorContainer', indicatorContainer))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('label', label));
  }

  @override
  List<Object?> get props =>
      [...super.props, container, flex, indicatorContainer, indicator, label];
}
