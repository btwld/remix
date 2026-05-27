part of 'divider.dart';

@MixableSpec()
class RemixDividerSpec with _$RemixDividerSpec {
  @override
  final StyleSpec<BoxSpec> container;

  const RemixDividerSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
