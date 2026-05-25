part of 'card.dart';

@MixableSpec()
class RemixCardSpec with _$RemixCardSpec {
  @override
  final StyleSpec<BoxSpec> container;

  const RemixCardSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
