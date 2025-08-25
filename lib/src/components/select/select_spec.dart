part of 'select.dart';

class SelectSpec extends WidgetSpec<SelectSpec> {
  final SelectTriggerSpec trigger;
  final ContainerSpec menuContainer;
  final SelectMenuItemSpec item;
  final CompositedTransformFollowerSpec position;

  const SelectSpec({
    SelectTriggerSpec? trigger,
    ContainerSpec? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : trigger = trigger ?? const SelectTriggerSpec(),
        item = item ?? const SelectMenuItemSpec(),
        menuContainer = menuContainer ?? const ContainerSpec(),
        position = position ?? const CompositedTransformFollowerSpec(),
        super(
          animation: animation,
          widgetModifiers: widgetModifiers,
          inherit: inherit,
        );

  @override
  SelectSpec copyWith({
    SelectTriggerSpec? trigger,
    ContainerSpec? menuContainer,
    SelectMenuItemSpec? item,
    CompositedTransformFollowerSpec? position,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return SelectSpec(
      trigger: trigger ?? this.trigger,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
      position: position ?? this.position,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props =>
      [...super.props, trigger, menuContainer, item, position];
}

class SelectTriggerSpec extends WidgetSpec<SelectTriggerSpec> {
  final ContainerSpec container;
  final FlexLayoutSpec flex;
  final TypographySpec label;
  final IconographySpec icon;

  const SelectTriggerSpec({
    ContainerSpec? container,
    FlexLayoutSpec? flex,
    TypographySpec? label,
    IconographySpec? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        flex = flex ?? const FlexLayoutSpec(),
        label = label ?? const TypographySpec(),
        icon = icon ?? const IconographySpec(),
        super(
          animation: animation,
          widgetModifiers: widgetModifiers,
          inherit: inherit,
        );

  @override
  SelectTriggerSpec copyWith({
    ContainerSpec? container,
    FlexLayoutSpec? flex,
    TypographySpec? label,
    IconographySpec? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return SelectTriggerSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [...super.props, container, flex, label, icon];
}

class SelectMenuItemSpec extends WidgetSpec<SelectMenuItemSpec> {
  final ContainerSpec container;
  final FlexLayoutSpec flex;
  final TypographySpec text;
  final IconographySpec icon;

  const SelectMenuItemSpec({
    ContainerSpec? container,
    FlexLayoutSpec? flex,
    TypographySpec? text,
    IconographySpec? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        flex = flex ?? const FlexLayoutSpec(),
        text = text ?? const TypographySpec(),
        icon = icon ?? const IconographySpec(),
        super(
          animation: animation,
          widgetModifiers: widgetModifiers,
          inherit: inherit,
        );

  @override
  SelectMenuItemSpec copyWith({
    ContainerSpec? container,
    FlexLayoutSpec? flex,
    TypographySpec? text,
    IconographySpec? icon,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return SelectMenuItemSpec(
      container: container ?? this.container,
      flex: flex ?? this.flex,
      text: text ?? this.text,
      icon: icon ?? this.icon,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
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
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [...super.props, container, flex, text, icon];
}
