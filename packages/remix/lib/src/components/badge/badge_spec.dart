part of 'badge.dart';

@MixableSpec()
class RemixBadgeSpec extends Spec<RemixBadgeSpec>
    with Diagnosticable, _$RemixBadgeSpecMethods {
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
