part of 'radio.dart';

class RadioSpec extends WidgetSpec<RadioSpec> {
  final WidgetContainerProperties container;
  final WidgetFlexProperties flex;
  final WidgetContainerProperties indicatorContainer;
  final WidgetContainerProperties indicator;
  final TextSpec label;

  const RadioSpec({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    WidgetContainerProperties? indicatorContainer,
    WidgetContainerProperties? indicator,
    TextSpec? label,
  })  : container = container ?? const WidgetContainerProperties(),
        flex = flex ?? const WidgetFlexProperties(),
        indicatorContainer = indicatorContainer ?? const WidgetContainerProperties(),
        indicator = indicator ?? const WidgetContainerProperties(),
        label = label ?? const TextSpec();

  @override
  RadioSpec copyWith({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    WidgetContainerProperties? indicatorContainer,
    WidgetContainerProperties? indicator,
    TextSpec? label,
  }) {
    return RadioSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      indicatorContainer: indicatorContainer ?? this.indicatorContainer,
      indicator: indicator ?? this.indicator,
      label: label ?? this.label,
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
  List<Object?> get props => [container, flex, indicatorContainer, indicator, label];
}
