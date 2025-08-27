part of 'radio.dart';

class RadioSpec extends Spec<RadioSpec> with Diagnosticable {
  final BoxSpec container;
  final FlexSpec flex;
  final BoxSpec indicatorContainer;
  final BoxSpec indicator;
  final TextSpec label;

  const RadioSpec({
    BoxSpec? container,
    FlexSpec? flex,
    BoxSpec? indicatorContainer,
    BoxSpec? indicator,
    TextSpec? label,
  })  : container = container ?? const BoxSpec(),
        flex = flex ?? const FlexSpec(),
        indicatorContainer = indicatorContainer ?? const BoxSpec(),
        indicator = indicator ?? const BoxSpec(),
        label = label ?? const TextSpec();

  RadioSpec copyWith({
    BoxSpec? container,
    FlexSpec? flex,
    BoxSpec? indicatorContainer,
    BoxSpec? indicator,
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
  List<Object?> get props =>
      [container, flex, indicatorContainer, indicator, label];
}
