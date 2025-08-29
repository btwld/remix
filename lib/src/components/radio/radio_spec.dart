part of 'radio.dart';

class RadioSpec extends Spec<RadioSpec> with Diagnosticable {
  final WidgetSpec<FlexBoxSpec> container;
  final WidgetSpec<BoxSpec> indicatorContainer;
  final WidgetSpec<BoxSpec> indicator;
  final WidgetSpec<TextSpec> label;

  const RadioSpec({
    WidgetSpec<FlexBoxSpec>? container,
    WidgetSpec<BoxSpec>? indicatorContainer,
    WidgetSpec<BoxSpec>? indicator,
    WidgetSpec<TextSpec>? label,
  })  : container = container ?? const WidgetSpec(spec: FlexBoxSpec()),
        indicatorContainer = indicatorContainer ?? const WidgetSpec(spec: BoxSpec()),
        indicator = indicator ?? const WidgetSpec(spec: BoxSpec()),
        label = label ?? const WidgetSpec(spec: TextSpec());

  RadioSpec copyWith({
    WidgetSpec<FlexBoxSpec>? container,
    WidgetSpec<BoxSpec>? indicatorContainer,
    WidgetSpec<BoxSpec>? indicator,
    WidgetSpec<TextSpec>? label,
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
