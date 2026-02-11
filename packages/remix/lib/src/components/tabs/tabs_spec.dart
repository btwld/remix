part of 'tabs.dart';

@MixableSpec()
class RemixTabBarSpec extends Spec<RemixTabBarSpec>
    with Diagnosticable, _$RemixTabBarSpecMethods {
  @override
  final StyleSpec<FlexBoxSpec> container;

  const RemixTabBarSpec({StyleSpec<FlexBoxSpec>? container})
    : container = container ?? const StyleSpec(spec: FlexBoxSpec());
}

@MixableSpec()
class RemixTabSpec extends Spec<RemixTabSpec>
    with Diagnosticable, _$RemixTabSpecMethods {
  @override
  final StyleSpec<FlexBoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixTabSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}

@MixableSpec()
class RemixTabViewSpec extends Spec<RemixTabViewSpec>
    with Diagnosticable, _$RemixTabViewSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;

  const RemixTabViewSpec({StyleSpec<BoxSpec>? container})
    : container = container ?? const StyleSpec(spec: BoxSpec());
}
