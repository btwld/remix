part of 'checkbox.dart';

class CheckboxSpec extends Spec<CheckboxSpec> with Diagnosticable {
  final BoxSpec container;
  final BoxSpec indicatorContainer;
  final IconSpec indicator;
  final TextSpec label;

  const CheckboxSpec({
    BoxSpec? container,
    BoxSpec? indicatorContainer,
    IconSpec? indicator,
    TextSpec? label,
  })  : container = container ?? const BoxSpec(),
        indicatorContainer = indicatorContainer ?? const BoxSpec(),
        indicator = indicator ?? const IconSpec(),
        label = label ?? const TextSpec();

  @override
  CheckboxSpec copyWith({
    BoxSpec? container,
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

  @override
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
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty(
      'indicatorContainer',
      indicatorContainer,
      defaultValue: null,
    ));
    properties
        .add(DiagnosticsProperty('indicator', indicator, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, indicatorContainer, indicator, label];
}
