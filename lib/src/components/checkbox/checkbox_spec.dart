part of 'checkbox.dart';

class CheckboxSpec extends Spec<CheckboxSpec> with Diagnosticable {
  final WidgetSpec<FlexBoxSpec> container;
  final WidgetSpec<BoxSpec> indicatorContainer;
  final WidgetSpec<IconSpec> indicator;
  final WidgetSpec<TextSpec> label;

  const CheckboxSpec({
    WidgetSpec<FlexBoxSpec>? container,
    WidgetSpec<BoxSpec>? indicatorContainer,
    WidgetSpec<IconSpec>? indicator,
    WidgetSpec<TextSpec>? label,
  })  : container = container ?? const WidgetSpec(spec: FlexBoxSpec()),
        indicatorContainer = indicatorContainer ?? const WidgetSpec(spec: BoxSpec()),
        indicator = indicator ?? const WidgetSpec(spec: IconSpec()),
        label = label ?? const WidgetSpec(spec: TextSpec());

  CheckboxSpec copyWith({
    WidgetSpec<FlexBoxSpec>? container,
    WidgetSpec<BoxSpec>? indicatorContainer,
    WidgetSpec<IconSpec>? indicator,
    WidgetSpec<TextSpec>? label,
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
