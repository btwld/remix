part of 'radio.dart';

class RadioSpec extends Spec<RadioSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<BoxSpec> indicatorContainer;
  final StyleSpec<BoxSpec> indicator;
  final StyleSpec<TextSpec> label;

  const RadioSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<TextSpec>? label,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        indicatorContainer =
            indicatorContainer ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: BoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec());

  RadioSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<TextSpec>? label,
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
  List<Object?> get props => [container, indicatorContainer, indicator, label];
}
