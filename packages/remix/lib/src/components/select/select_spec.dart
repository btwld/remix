part of 'select.dart';

@MixableSpec()
class RemixSelectSpec extends Spec<RemixSelectSpec>
    with Diagnosticable, _$RemixSelectSpecMethods {
  @override
  final StyleSpec<RemixSelectTriggerSpec>? trigger;
  @override
  final StyleSpec<FlexBoxSpec>? menuContainer;
  @override
  final StyleSpec<RemixSelectMenuItemSpec>? item;

  const RemixSelectSpec({
    StyleSpec<RemixSelectTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? menuContainer,
    StyleSpec<RemixSelectMenuItemSpec>? item,
  }) : trigger = trigger ?? const StyleSpec(spec: RemixSelectTriggerSpec()),
       item = item ?? const StyleSpec(spec: RemixSelectMenuItemSpec()),
       menuContainer = menuContainer ?? const StyleSpec(spec: FlexBoxSpec());
}

@MixableSpec()
class RemixSelectTriggerSpec extends Spec<RemixSelectTriggerSpec>
    with Diagnosticable, _$RemixSelectTriggerSpecMethods {
  @override
  final StyleSpec<FlexBoxSpec>? container;
  @override
  final StyleSpec<TextSpec>? label;
  @override
  final StyleSpec<IconSpec>? icon;

  const RemixSelectTriggerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}

@MixableSpec()
class RemixSelectMenuItemSpec extends Spec<RemixSelectMenuItemSpec>
    with Diagnosticable, _$RemixSelectMenuItemSpecMethods {
  @override
  final StyleSpec<FlexBoxSpec>? container;
  @override
  final StyleSpec<TextSpec>? text;
  @override
  final StyleSpec<IconSpec>? icon;

  const RemixSelectMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
