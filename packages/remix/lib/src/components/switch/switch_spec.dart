part of 'switch.dart';

/// Resolved visual values for a [RemixSwitch].
@MixableSpec()
class RemixSwitchSpec with _$RemixSwitchSpec {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<BoxSpec> thumb;

  const RemixSwitchSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       thumb = thumb ?? const StyleSpec(spec: BoxSpec());
}
