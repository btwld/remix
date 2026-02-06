part of 'card.dart';

@MixableSpec()
class RemixCardSpec extends Spec<RemixCardSpec>
    with Diagnosticable, _$RemixCardSpecMethods {
  @override
  final StyleSpec<BoxSpec>? container;

  const RemixCardSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
