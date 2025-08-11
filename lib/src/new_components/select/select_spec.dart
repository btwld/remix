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

  @override
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
    properties.add(DiagnosticsProperty('trigger', trigger, defaultValue: null));
    properties.add(DiagnosticsProperty('menuContainer', menuContainer, defaultValue: null));
    properties.add(DiagnosticsProperty('item', item, defaultValue: null));
    properties.add(DiagnosticsProperty('position', position, defaultValue: null));
  }

  @override
  List<Object?> get props => [trigger, menuContainer, item, position];
}

class SelectTriggerSpec extends Spec<SelectTriggerSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final TextSpec label;
  final IconThemeData icon;

  const SelectTriggerSpec({
    FlexBoxSpec? container,
    TextSpec? label,
    IconThemeData? icon,
  })  : container = container ?? const FlexBoxSpec(),
        label = label ?? const TextSpec(),
        icon = icon ?? const IconThemeData();

  @override
  SelectTriggerSpec copyWith({
    FlexBoxSpec? container,
    TextSpec? label,
    IconThemeData? icon,
  }) {
    return SelectTriggerSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  SelectTriggerSpec lerp(SelectTriggerSpec? other, double t) {
    if (other == null) return this;

    return SelectTriggerSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      icon: IconThemeData.lerp(icon, other.icon, t),
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, label, icon];
}

class SelectMenuItemSpec extends Spec<SelectMenuItemSpec> with Diagnosticable {
  final FlexBoxSpec container;
  final TextStyle textStyle;
  final IconThemeData icon;

  const SelectMenuItemSpec({
    FlexBoxSpec? container,
    TextStyle? textStyle,
    IconThemeData? icon,
  })  : container = container ?? const FlexBoxSpec(),
        textStyle = textStyle ?? const TextStyle(),
        icon = icon ?? const IconThemeData();

  @override
  SelectMenuItemSpec copyWith({
    FlexBoxSpec? container,
    TextStyle? textStyle,
    IconThemeData? icon,
  }) {
    return SelectMenuItemSpec(
      container: container ?? this.container,
      textStyle: textStyle ?? this.textStyle,
      icon: icon ?? this.icon,
    );
  }

  @override
  SelectMenuItemSpec lerp(SelectMenuItemSpec? other, double t) {
    if (other == null) return this;

    return SelectMenuItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      icon: IconThemeData.lerp(icon, other.icon, t),
    );
  }


  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('textStyle', textStyle, defaultValue: null));
    properties.add(DiagnosticsProperty('icon', icon, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, textStyle, icon];
}