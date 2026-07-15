part of 'card.dart';

/// Resolved visual properties for a [RemixCard].
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class RemixCardSpec with _$RemixCardSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  const RemixCardSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
