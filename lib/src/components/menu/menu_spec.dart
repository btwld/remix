part of 'menu.dart';

class MenuSpec extends Spec<MenuSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> trigger;
  final StyleSpec<TextSpec> triggerLabel;
  final StyleSpec<IconSpec> triggerIcon;
  final StyleSpec<BoxSpec> menuContainer;
  final StyleSpec<MenuItemSpec> item;

  const MenuSpec({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<TextSpec>? triggerLabel,
    StyleSpec<IconSpec>? triggerIcon,
    StyleSpec<BoxSpec>? menuContainer,
    StyleSpec<MenuItemSpec>? item,
  })  : trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
        triggerLabel = triggerLabel ?? const StyleSpec(spec: TextSpec()),
        triggerIcon = triggerIcon ?? const StyleSpec(spec: IconSpec()),
        menuContainer = menuContainer ?? const StyleSpec(spec: BoxSpec()),
        item = item ?? const StyleSpec(spec: MenuItemSpec());

  MenuSpec copyWith({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<TextSpec>? triggerLabel,
    StyleSpec<IconSpec>? triggerIcon,
    StyleSpec<BoxSpec>? menuContainer,
    StyleSpec<MenuItemSpec>? item,
  }) {
    return MenuSpec(
      trigger: trigger ?? this.trigger,
      triggerLabel: triggerLabel ?? this.triggerLabel,
      triggerIcon: triggerIcon ?? this.triggerIcon,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
    );
  }

  MenuSpec lerp(MenuSpec? other, double t) {
    if (other == null) return this;

    return MenuSpec(
      trigger: MixOps.lerp(trigger, other.trigger, t)!,
      triggerLabel: MixOps.lerp(triggerLabel, other.triggerLabel, t)!,
      triggerIcon: MixOps.lerp(triggerIcon, other.triggerIcon, t)!,
      menuContainer: MixOps.lerp(menuContainer, other.menuContainer, t)!,
      item: MixOps.lerp(item, other.item, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('triggerLabel', triggerLabel))
      ..add(DiagnosticsProperty('triggerIcon', triggerIcon))
      ..add(DiagnosticsProperty('menuContainer', menuContainer))
      ..add(DiagnosticsProperty('item', item));
  }

  @override
  List<Object?> get props =>
      [trigger, triggerLabel, triggerIcon, menuContainer, item];
}

class MenuItemSpec extends Spec<MenuItemSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> leadingIcon;
  final StyleSpec<IconSpec> trailingIcon;

  const MenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        leadingIcon = leadingIcon ?? const StyleSpec(spec: IconSpec()),
        trailingIcon = trailingIcon ?? const StyleSpec(spec: IconSpec());

  MenuItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  }) {
    return MenuItemSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
    );
  }

  MenuItemSpec lerp(MenuItemSpec? other, double t) {
    if (other == null) return this;

    return MenuItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t)!,
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('leadingIcon', leadingIcon))
      ..add(DiagnosticsProperty('trailingIcon', trailingIcon));
  }

  @override
  List<Object?> get props => [container, label, leadingIcon, trailingIcon];
}