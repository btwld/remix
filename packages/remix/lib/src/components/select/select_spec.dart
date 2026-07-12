part of 'select.dart';

/// Resolved visual values for a [RemixSelect].
@MixableSpec()
class RemixSelectSpec with _$RemixSelectSpec {
  @override
  final StyleSpec<RemixSelectTriggerSpec> trigger;
  @override
  final StyleSpec<FlexBoxSpec> menuContainer;
  @override
  final StyleSpec<RemixSelectMenuItemSpec> item;

  const RemixSelectSpec({
    StyleSpec<RemixSelectTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? menuContainer,
    StyleSpec<RemixSelectMenuItemSpec>? item,
  }) : trigger = trigger ?? const StyleSpec(spec: RemixSelectTriggerSpec()),
       item = item ?? const StyleSpec(spec: RemixSelectMenuItemSpec()),
       menuContainer = menuContainer ?? const StyleSpec(spec: FlexBoxSpec());
}

/// Resolved visual values for the select trigger.
@MixableSpec()
class RemixSelectTriggerSpec with _$RemixSelectTriggerSpec {
  @override
  final StyleSpec<FlexBoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixSelectTriggerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}

/// Resolved visual values for a select menu item.
@MixableSpec()
class RemixSelectMenuItemSpec with _$RemixSelectMenuItemSpec {
  @override
  final StyleSpec<FlexBoxSpec> container;
  @override
  final StyleSpec<TextSpec> text;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixSelectMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
