part of 'select.dart';

class SelectSpec extends Spec<SelectSpec> with Diagnosticable {
  final SelectTriggerSpec trigger;
  final BoxSpec menuContainer;
  final SelectMenuItemSpec item;
  final CompositedTransformFollowerSpec position;

  const SelectSpec({
    SelectTriggerSpec? trigger,
    BoxSpec? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
  })  : trigger = trigger ?? const SelectTriggerSpec(),
        item = item ?? const SelectMenuItemSpec(),
        menuContainer = menuContainer ?? const BoxSpec(),
        position = position ?? const CompositedTransformFollowerSpec();

  SelectSpec copyWith({
    SelectTriggerSpec? trigger,
    BoxSpec? menuContainer,
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

class SelectTriggerSpec extends Spec<SelectTriggerSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec label;
  final IconSpec icon;

  const SelectTriggerSpec({
    FlexBoxSpec? container,
    TextSpec? label,
    IconSpec? icon,
  })  : container = container ?? const FlexBoxSpec(),
        label = label ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  SelectTriggerSpec copyWith({
    FlexBoxSpec? container,
    TextSpec? label,
    IconSpec? icon,
  }) {
    return SelectTriggerSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  SelectTriggerSpec lerp(SelectTriggerSpec? other, double t) {
    if (other == null) return this;

    return SelectTriggerSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, label, icon];
}

class SelectMenuItemSpec extends Spec<SelectMenuItemSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec text;
  final IconSpec icon;

  const SelectMenuItemSpec({
    FlexBoxSpec? container,
    TextSpec? text,
    IconSpec? icon,
  })  : container = container ?? const FlexBoxSpec(),
        text = text ?? const TextSpec(),
        icon = icon ?? const IconSpec();

  SelectMenuItemSpec copyWith({
    FlexBoxSpec? container,
    TextSpec? text,
    IconSpec? icon,
  }) {
    return SelectMenuItemSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  SelectMenuItemSpec lerp(SelectMenuItemSpec? other, double t) {
    if (other == null) return this;

    return SelectMenuItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      text: MixOps.lerp(text, other.text, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, text, icon];
}
