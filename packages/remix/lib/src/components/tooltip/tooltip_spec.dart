part of 'tooltip.dart';

@MixableSpec()
class RemixTooltipSpec extends Spec<RemixTooltipSpec>
    with Diagnosticable, _$RemixTooltipSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final Duration? waitDuration;
  @override
  final Duration? showDuration;

  const RemixTooltipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    this.waitDuration = const Duration(milliseconds: 300),
    this.showDuration = const Duration(milliseconds: 1500),
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());
}
