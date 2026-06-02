part of 'menu.dart';

// ============================================================================
// TRIGGER SPEC - Menu trigger content specification
// ============================================================================

@MixableSpec()
class RemixMenuTriggerSpec with _$RemixMenuTriggerSpec {
  @override
  final StyleSpec<FlexBoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixMenuTriggerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}

// ============================================================================
// MENU SPEC - Main menu specification
// ============================================================================

@MixableSpec()
class RemixMenuSpec with _$RemixMenuSpec {
  @override
  final StyleSpec<RemixMenuTriggerSpec> trigger;
  @override
  final StyleSpec<FlexBoxSpec> overlay;
  @override
  final StyleSpec<RemixMenuItemSpec> item;
  @override
  final StyleSpec<RemixDividerSpec> divider;

  const RemixMenuSpec({
    StyleSpec<RemixMenuTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? overlay,
    StyleSpec<RemixMenuItemSpec>? item,
    StyleSpec<RemixDividerSpec>? divider,
  }) : trigger = trigger ?? const StyleSpec(spec: RemixMenuTriggerSpec()),
       overlay = overlay ?? const StyleSpec(spec: FlexBoxSpec()),
       item = item ?? const StyleSpec(spec: RemixMenuItemSpec()),
       divider = divider ?? const StyleSpec(spec: RemixDividerSpec());
}

// ============================================================================
// MENU ITEM SPEC
// ============================================================================

@MixableSpec()
class RemixMenuItemSpec with _$RemixMenuItemSpec {
  @override
  final StyleSpec<FlexBoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> leadingIcon;
  @override
  final StyleSpec<IconSpec> trailingIcon;

  const RemixMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       leadingIcon = leadingIcon ?? const StyleSpec(spec: IconSpec()),
       trailingIcon = trailingIcon ?? const StyleSpec(spec: IconSpec());
}
