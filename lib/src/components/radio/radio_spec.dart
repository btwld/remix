part of 'radio.dart';

/// Defines the resolved styling structure for [RemixRadio].
///
/// The spec is populated by [RemixRadioStyle] and consumed by the widget when
/// building the control. It provides three [StyleSpec] segments representing the
/// outer container, the indicator container (outer ring), and the indicator fill
/// shown when the radio is selected.
class RemixRadioSpec extends Spec<RemixRadioSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> indicatorContainer;
  final StyleSpec<BoxSpec> indicator;

  const RemixRadioSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<BoxSpec>? indicator,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        indicatorContainer =
            indicatorContainer ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: BoxSpec());

  RemixRadioSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<BoxSpec>? indicator,
  }) {
    return RemixRadioSpec(
      container: container ?? this.container,
      indicatorContainer: indicatorContainer ?? this.indicatorContainer,
      indicator: indicator ?? this.indicator,
    );
  }

  RemixRadioSpec lerp(RemixRadioSpec? other, double t) {
    if (other == null) return this;

    return RemixRadioSpec(
      container: MixOps.lerp(container, other.container, t)!,
      indicatorContainer:
          MixOps.lerp(indicatorContainer, other.indicatorContainer, t)!,
      indicator: MixOps.lerp(indicator, other.indicator, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('indicatorContainer', indicatorContainer))
      ..add(DiagnosticsProperty('indicator', indicator));
  }

  @override
  List<Object?> get props => [container, indicatorContainer, indicator];
}
