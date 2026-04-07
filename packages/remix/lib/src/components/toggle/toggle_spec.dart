part of 'toggle.dart';

@MixableSpec()
class RemixToggleSpec extends Spec<RemixToggleSpec>
    with Diagnosticable, _$RemixToggleSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixToggleSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
