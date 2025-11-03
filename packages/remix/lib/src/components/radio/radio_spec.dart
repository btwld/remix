part of 'radio.dart';

/// Defines the resolved styling structure for [RemixRadio].
///
/// The spec is populated by [RemixRadioStyle] and consumed by the widget when
/// building the control. It provides two [StyleSpec] segments representing the
/// container (outer ring) and the indicator fill shown when the radio is selected.
class RemixRadioSpec extends Spec<RemixRadioSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> indicator;

  const RemixRadioSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: BoxSpec());

  RemixRadioSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
  }) {
    return RemixRadioSpec(
      container: container ?? this.container,
      indicator: indicator ?? this.indicator,
    );
  }

  RemixRadioSpec lerp(RemixRadioSpec? other, double t) {
    if (other == null) return this;

    return RemixRadioSpec(
      container: MixOps.lerp(container, other.container, t)!,
      indicator: MixOps.lerp(indicator, other.indicator, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('indicator', indicator));
  }

  @override
  List<Object?> get props => [container, indicator];
}
