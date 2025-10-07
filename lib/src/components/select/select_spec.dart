part of 'select.dart';

class RemixSelectSpec extends Spec<RemixSelectSpec> with Diagnosticable {
  final StyleSpec<RemixSelectTriggerSpec> trigger;
  final StyleSpec<FlexBoxSpec> menuContainer;
  final StyleSpec<RemixSelectMenuItemSpec> item;
  final StyleSpec<RemixCompositedTransformFollowerSpec> position;

  const RemixSelectSpec({
    StyleSpec<RemixSelectTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? menuContainer,
    StyleSpec<RemixSelectMenuItemSpec>? item,
    StyleSpec<RemixCompositedTransformFollowerSpec>? position,
  })  : trigger = trigger ?? const StyleSpec(spec: RemixSelectTriggerSpec()),
        item = item ?? const StyleSpec(spec: RemixSelectMenuItemSpec()),
        menuContainer = menuContainer ?? const StyleSpec(spec: FlexBoxSpec()),
        position = position ??
            const StyleSpec(spec: RemixCompositedTransformFollowerSpec());

  RemixSelectSpec copyWith({
    StyleSpec<RemixSelectTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? menuContainer,
    StyleSpec<RemixSelectMenuItemSpec>? item,
    StyleSpec<RemixCompositedTransformFollowerSpec>? position,
  }) {
    return RemixSelectSpec(
      trigger: trigger ?? this.trigger,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
      position: position ?? this.position,
    );
  }

  RemixSelectSpec lerp(RemixSelectSpec? other, double t) {
    if (other == null) return this;

    return RemixSelectSpec(
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

class RemixSelectTriggerSpec extends Spec<RemixSelectTriggerSpec>
    with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const RemixSelectTriggerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  RemixSelectTriggerSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixSelectTriggerSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  RemixSelectTriggerSpec lerp(RemixSelectTriggerSpec? other, double t) {
    if (other == null) return this;

    return RemixSelectTriggerSpec(
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

class RemixSelectMenuItemSpec extends Spec<RemixSelectMenuItemSpec>
    with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> text;
  final StyleSpec<IconSpec> icon;

  const RemixSelectMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        text = text ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  RemixSelectMenuItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixSelectMenuItemSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  RemixSelectMenuItemSpec lerp(RemixSelectMenuItemSpec? other, double t) {
    if (other == null) return this;

    return RemixSelectMenuItemSpec(
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
