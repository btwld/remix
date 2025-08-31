part of 'select.dart';

class SelectSpec extends Spec<SelectSpec> with Diagnosticable {
  final StyleSpec<SelectTriggerSpec> trigger;
  final StyleSpec<BoxSpec> menuContainer;
  final StyleSpec<SelectMenuItemSpec> item;
  final StyleSpec<CompositedTransformFollowerSpec> position;

  const SelectSpec({
    StyleSpec<SelectTriggerSpec>? trigger,
    StyleSpec<BoxSpec>? menuContainer,
    StyleSpec<SelectMenuItemSpec>? item,
    StyleSpec<CompositedTransformFollowerSpec>? position,
  })  : trigger = trigger ?? const StyleSpec(spec: SelectTriggerSpec()),
        item = item ?? const StyleSpec(spec: SelectMenuItemSpec()),
        menuContainer = menuContainer ?? const StyleSpec(spec: BoxSpec()),
        position = position ??
            const StyleSpec(spec: CompositedTransformFollowerSpec());

  SelectSpec copyWith({
    StyleSpec<SelectTriggerSpec>? trigger,
    StyleSpec<BoxSpec>? menuContainer,
    StyleSpec<SelectMenuItemSpec>? item,
    StyleSpec<CompositedTransformFollowerSpec>? position,
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
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const SelectTriggerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  SelectTriggerSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
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
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> text;
  final StyleSpec<IconSpec> icon;

  const SelectMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        text = text ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  SelectMenuItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
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

Widget createSelectTriggerWidget(
  SelectTriggerSpec spec, {
  required String label,
  IconData? trailing,
}) {
  final ContainerWidget = spec.container;
  final LabelWidget = spec.label;
  final IconWidget = spec.icon;

  return ContainerWidget(
    direction: Axis.horizontal,
    children: [
      Expanded(child: LabelWidget(label)),
      if (trailing != null) IconWidget(icon: trailing),
    ],
  );
}

Widget createSelectMenuItemWidget(
  SelectMenuItemSpec spec, {
  required String text,
  IconData? icon,
  bool selected = false,
}) {
  final ContainerWidget = spec.container;
  final TextWidget = spec.text;
  final IconWidget = spec.icon;

  return ContainerWidget(
    direction: Axis.horizontal,
    children: [
      Expanded(child: TextWidget(text)),
      if (selected && icon != null) IconWidget(icon: icon),
    ],
  );
}

/// Extension on SelectTriggerSpec to provide call() method for creating widgets
extension SelectTriggerSpecWidget on SelectTriggerSpec {
  Widget call({required String label, IconData? trailing}) {
    return createSelectTriggerWidget(this, label: label, trailing: trailing);
  }
}

/// Extension on StyleSpec<SelectTriggerSpec> to provide call() method for creating widgets
extension SelectTriggerSpecWrappedWidget on StyleSpec<SelectTriggerSpec> {
  Widget call({required String label, IconData? trailing}) {
    return StyleSpecBuilder(
      wrappedSpec: this,
      builder: (context, spec) {
        return createSelectTriggerWidget(
          spec,
          label: label,
          trailing: trailing,
        );
      },
    );
  }
}

/// Extension on SelectMenuItemSpec to provide call() method for creating widgets
extension SelectMenuItemSpecWidget on SelectMenuItemSpec {
  Widget call({required String text, IconData? icon, bool selected = false}) {
    return createSelectMenuItemWidget(
      this,
      text: text,
      icon: icon,
      selected: selected,
    );
  }
}

/// Extension on StyleSpec<SelectMenuItemSpec> to provide call() method for creating widgets
extension SelectMenuItemSpecWrappedWidget on StyleSpec<SelectMenuItemSpec> {
  Widget call({required String text, IconData? icon, bool selected = false}) {
    return StyleSpecBuilder(
      wrappedSpec: this,
      builder: (context, spec) {
        return createSelectMenuItemWidget(
          spec,
          text: text,
          icon: icon,
          selected: selected,
        );
      },
    );
  }
}
