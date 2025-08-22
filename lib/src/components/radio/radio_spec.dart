part of 'radio.dart';

class RadioSpec extends WidgetSpec<RadioSpec> {
  final ContainerProperties container;
  final FlexProperties flex;
  final ContainerProperties indicatorContainer;
  final ContainerProperties indicator;
  final TextSpec label;

  const RadioSpec({
    ContainerProperties? container,
    FlexProperties? flex,
    ContainerProperties? indicatorContainer,
    ContainerProperties? indicator,
    TextSpec? label,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerProperties(),
        flex = flex ?? const FlexProperties(),
        indicatorContainer = indicatorContainer ?? const ContainerProperties(),
        indicator = indicator ?? const ContainerProperties(),
        label = label ?? const TextSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  RadioSpec copyWith({
    ContainerProperties? container,
    FlexProperties? flex,
    ContainerProperties? indicatorContainer,
    ContainerProperties? indicator,
    TextSpec? label,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return RadioSpec(
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
  RadioSpec lerp(RadioSpec? other, double t) {
    if (other == null) return this;

    return RadioSpec(
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
  List<Object?> get props => [...super.props, container, flex, indicatorContainer, indicator, label];
}
