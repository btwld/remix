part of 'callout.dart';

@MixableSpec()
class RemixCalloutSpec extends Spec<RemixCalloutSpec>
    with Diagnosticable, _$RemixCalloutSpecMethods {
  @override
  final StyleSpec<FlexBoxSpec> container;
  @override
  final StyleSpec<TextSpec> text;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixCalloutSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
