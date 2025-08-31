part of 'checkbox.dart';

class CheckboxSpec extends Spec<CheckboxSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<BoxSpec> indicatorContainer;
  final StyleSpec<IconSpec> indicator;
  final StyleSpec<TextSpec> label;

  const CheckboxSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<TextSpec>? label,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        indicatorContainer =
            indicatorContainer ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: IconSpec()),
        label = label ?? const StyleSpec(spec: TextSpec());

  CheckboxSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<TextSpec>? label,
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
  List<Object?> get props => [container, indicatorContainer, indicator, label];
}
