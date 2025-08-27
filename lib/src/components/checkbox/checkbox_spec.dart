part of 'checkbox.dart';

class CheckboxSpec extends Spec<CheckboxSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final BoxSpec indicatorContainer;
  final IconSpec indicator;
  final TextSpec label;

  const CheckboxSpec({
    FlexBoxSpec? container,
    BoxSpec? indicatorContainer,
    IconSpec? indicator,
    TextSpec? label,
  })  : container = container ?? const FlexBoxSpec(),
        indicatorContainer = indicatorContainer ?? const BoxSpec(),
        indicator = indicator ?? const IconSpec(),
        label = label ?? const TextSpec();

  CheckboxSpec copyWith({
    FlexBoxSpec? container,
    BoxSpec? indicatorContainer,
    IconSpec? indicator,
    TextSpec? label,
  }) {
    return CheckboxSpec(
      container: container ?? this.container,
      indicatorContainer: indicatorContainer ?? this.indicatorContainer,
      indicator: indicator ?? this.indicator,
      label: label ?? this.label,
    );
  }

  CheckboxSpec lerp(CheckboxSpec? other, double t) {
    if (other == null) return this;

    return CheckboxSpec(
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
