part of 'badge.dart';

/// Resolved visual properties for a [RemixBadge].
@MixableSpec()
class RemixBadgeSpec with _$RemixBadgeSpec {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;

  const RemixBadgeSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());
}
