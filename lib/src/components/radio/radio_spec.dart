part of 'radio.dart';

class RadioSpec extends Spec<RadioSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final BoxSpec indicatorContainer;
  final BoxSpec indicator;
  final TextSpec label;

  const RadioSpec({
    FlexBoxSpec? container,
    BoxSpec? indicatorContainer,
    BoxSpec? indicator,
    TextSpec? label,
  })  : container = container ?? const FlexBoxSpec(),
        indicatorContainer = indicatorContainer ?? const BoxSpec(),
        indicator = indicator ?? const BoxSpec(),
        label = label ?? const TextSpec();

  RadioSpec copyWith({
    FlexBoxSpec? container,
    BoxSpec? indicatorContainer,
    BoxSpec? indicator,
    TextSpec? label,
  }) {
    return RadioSpec(
      container: container ?? this.container,
      indicatorContainer: indicatorContainer ?? this.indicatorContainer,
      indicator: indicator ?? this.indicator,
      label: label ?? this.label,
    );
  }

  RadioSpec lerp(RadioSpec? other, double t) {
    if (other == null) return this;

    return RadioSpec(
      container: MixOps.lerp(container, other.container, t)!,
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
      ..add(DiagnosticsProperty('indicatorContainer', indicatorContainer))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('label', label));
  }

  @override
  List<Object?> get props =>
      [container, indicatorContainer, indicator, label];
}
