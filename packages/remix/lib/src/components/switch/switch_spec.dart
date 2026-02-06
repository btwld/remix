part of 'switch.dart';

@MixableSpec()
class RemixSwitchSpec extends Spec<RemixSwitchSpec>
    with Diagnosticable, _$RemixSwitchSpecMethods {
  @override
  final StyleSpec<BoxSpec>? container;
  @override
  final StyleSpec<BoxSpec>? thumb;

  const RemixSwitchSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       thumb = thumb ?? const StyleSpec(spec: BoxSpec());
}
