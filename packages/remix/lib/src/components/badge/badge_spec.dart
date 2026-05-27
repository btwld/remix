part of 'badge.dart';

@MixableSpec()
class RemixBadgeSpec with _$RemixBadgeSpec {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> text;

  const RemixBadgeSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec());
}
