part of 'menu.dart';

class RemixMenuSpec extends Spec<RemixMenuSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> trigger;
  final StyleSpec<TextSpec> triggerLabel;
  final StyleSpec<IconSpec> triggerIcon;
  final StyleSpec<BoxSpec> menuContainer;
  final StyleSpec<RemixMenuItemSpec> item;

  const RemixMenuSpec({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<TextSpec>? triggerLabel,
    StyleSpec<IconSpec>? triggerIcon,
    StyleSpec<BoxSpec>? menuContainer,
    StyleSpec<RemixMenuItemSpec>? item,
  })  : trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
        triggerLabel = triggerLabel ?? const StyleSpec(spec: TextSpec()),
        triggerIcon = triggerIcon ?? const StyleSpec(spec: IconSpec()),
        menuContainer = menuContainer ?? const StyleSpec(spec: BoxSpec()),
        item = item ?? const StyleSpec(spec: RemixMenuItemSpec());

  RemixMenuSpec copyWith({
    StyleSpec<FlexBoxSpec>? trigger,
    StyleSpec<TextSpec>? triggerLabel,
    StyleSpec<IconSpec>? triggerIcon,
    StyleSpec<BoxSpec>? menuContainer,
    StyleSpec<RemixMenuItemSpec>? item,
  }) {
    return RemixMenuSpec(
      trigger: trigger ?? this.trigger,
      triggerLabel: triggerLabel ?? this.triggerLabel,
      triggerIcon: triggerIcon ?? this.triggerIcon,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
    );
  }

  RemixMenuSpec lerp(RemixMenuSpec? other, double t) {
    if (other == null) return this;

    return RemixMenuSpec(
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

class RemixMenuItemSpec extends Spec<RemixMenuItemSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> leadingIcon;
  final StyleSpec<IconSpec> trailingIcon;

  const RemixMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        leadingIcon = leadingIcon ?? const StyleSpec(spec: IconSpec()),
        trailingIcon = trailingIcon ?? const StyleSpec(spec: IconSpec());

  RemixMenuItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  }) {
    return RemixMenuItemSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
    );
  }

  RemixMenuItemSpec lerp(RemixMenuItemSpec? other, double t) {
    if (other == null) return this;

    return RemixMenuItemSpec(
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
