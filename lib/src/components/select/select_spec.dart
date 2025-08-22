part of 'select.dart';

class SelectSpec extends WidgetSpec<SelectSpec> {
  final SelectTriggerSpec trigger;
  final WidgetContainerProperties menuContainer;
  final SelectMenuItemSpec item;
  final CompositedTransformFollowerSpec position;

  const SelectSpec({
    SelectTriggerSpec? trigger,
    WidgetContainerProperties? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
  })  : trigger = trigger ?? const SelectTriggerSpec(),
        item = item ?? const SelectMenuItemSpec(),
        menuContainer = menuContainer ?? const WidgetContainerProperties(),
        position = position ?? const CompositedTransformFollowerSpec();

  @override
  SelectSpec copyWith({
    SelectTriggerSpec? trigger,
    WidgetContainerProperties? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
  }) {
    return SelectSpec(
      trigger: trigger ?? this.trigger,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
      position: position ?? this.position,
    );
  }

  @override
  SelectSpec lerp(SelectSpec? other, double t) {
    if (other == null) return this;

    return SelectSpec(
      trigger: MixOps.lerp(trigger, other.trigger, t)!,
      menuContainer: MixOps.lerp(menuContainer, other.menuContainer, t)!,
      item: MixOps.lerp(item, other.item, t)!,
      position: MixOps.lerp(position, other.position, t)!,
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('menuContainer', menuContainer))
      ..add(DiagnosticsProperty('item', item))
      ..add(DiagnosticsProperty('position', position));
  }

  @override
  List<Object?> get props => [trigger, menuContainer, item, position];
}

class SelectTriggerSpec extends WidgetSpec<SelectTriggerSpec> {
  final WidgetContainerProperties container;
  final WidgetFlexProperties flex;
  final TextSpec label;
  final IconSpec icon;

  const SelectTriggerSpec({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    TextSpec? label,
    IconSpec? icon,
  })  : container = container ?? const WidgetContainerProperties(),
        flex = flex ?? const WidgetFlexProperties(),
        label = label ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  @override
  SelectTriggerSpec copyWith({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    TextSpec? label,
    IconSpec? icon,
  }) {
    return SelectTriggerSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  SelectTriggerSpec lerp(SelectTriggerSpec? other, double t) {
    if (other == null) return this;

    return SelectTriggerSpec(
      container: MixOps.lerp(container, other.container, t)!,
      flex: MixOps.lerp(flex, other.flex, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, flex, label, icon];
}

class SelectMenuItemSpec extends WidgetSpec<SelectMenuItemSpec> {
  final WidgetContainerProperties container;
  final WidgetFlexProperties flex;
  final TextSpec text;
  final IconSpec icon;

  const SelectMenuItemSpec({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    TextSpec? text,
    IconSpec? icon,
  })  : container = container ?? const WidgetContainerProperties(),
        flex = flex ?? const WidgetFlexProperties(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  @override
  SelectMenuItemSpec copyWith({
    WidgetContainerProperties? container,
    WidgetFlexProperties? flex,
    TextSpec? text,
    IconSpec? icon,
  }) {
    return SelectMenuItemSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  SelectMenuItemSpec lerp(SelectMenuItemSpec? other, double t) {
    if (other == null) return this;

    return SelectMenuItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      flex: MixOps.lerp(flex, other.flex, t)!,
      text: MixOps.lerp(text, other.text, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('flex', flex))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, flex, text, icon];
}