part of 'divider.dart';

@MixableSpec()
class RemixDividerSpec extends Spec<RemixDividerSpec>
    with Diagnosticable, _$RemixDividerSpecMethods {
  @override
  final StyleSpec<BoxSpec>? container;

  const RemixDividerSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
