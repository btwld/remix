part of 'radio.dart';

/// Defines the resolved styling structure for [RemixRadio].
///
/// The spec is populated by [RemixRadioStyle] and consumed by the widget when
/// building the control. It provides two [StyleSpec] segments representing the
/// container (outer ring) and the indicator fill shown when the radio is selected.
@MixableSpec()
class RemixRadioSpec extends Spec<RemixRadioSpec>
    with Diagnosticable, _$RemixRadioSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<BoxSpec> indicator;

  const RemixRadioSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       indicator = indicator ?? const StyleSpec(spec: BoxSpec());
}
