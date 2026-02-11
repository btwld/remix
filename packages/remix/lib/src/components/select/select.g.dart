// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSelectSpecMethods on Spec<RemixSelectSpec>, Diagnosticable {
  StyleSpec<RemixSelectTriggerSpec> get trigger;
  StyleSpec<FlexBoxSpec> get menuContainer;
  StyleSpec<RemixSelectMenuItemSpec> get item;

  @override
  RemixSelectSpec copyWith({
    StyleSpec<RemixSelectTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? menuContainer,
    StyleSpec<RemixSelectMenuItemSpec>? item,
  }) {
    return RemixSelectSpec(
      trigger: trigger ?? this.trigger,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
    );
  }

  @override
  RemixSelectSpec lerp(RemixSelectSpec? other, double t) {
    return RemixSelectSpec(
      trigger: trigger.lerp(other?.trigger, t),
      menuContainer: menuContainer.lerp(other?.menuContainer, t),
      item: item.lerp(other?.item, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('menuContainer', menuContainer))
      ..add(DiagnosticsProperty('item', item));
  }

  @override
  List<Object?> get props => [trigger, menuContainer, item];
}

mixin _$RemixSelectTriggerSpecMethods
    on Spec<RemixSelectTriggerSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
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

  @override
  RemixSelectTriggerSpec lerp(RemixSelectTriggerSpec? other, double t) {
    return RemixSelectTriggerSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
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

mixin _$RemixSelectMenuItemSpecMethods
    on Spec<RemixSelectMenuItemSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get text;
  StyleSpec<IconSpec> get icon;

  @override
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

  @override
  RemixSelectMenuItemSpec lerp(RemixSelectMenuItemSpec? other, double t) {
    return RemixSelectMenuItemSpec(
      container: container.lerp(other?.container, t),
      text: text.lerp(other?.text, t),
      icon: icon.lerp(other?.icon, t),
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

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSelectStyleMixin on Style<RemixSelectSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $menuContainer;
  Prop<StyleSpec<RemixSelectTriggerSpec>>? get $trigger;

  /// Sets the menuContainer.
  RemixSelectStyle menuContainer(FlexBoxStyler value) {
    return merge(RemixSelectStyle(menuContainer: value));
  }

  /// Sets the trigger.
  RemixSelectStyle trigger(RemixSelectTriggerStyle value) {
    return merge(RemixSelectStyle(trigger: value));
  }

  /// Sets the animation configuration.
  RemixSelectStyle animate(AnimationConfig value) {
    return merge(RemixSelectStyle(animation: value));
  }

  /// Sets the style variants.
  RemixSelectStyle variants(List<VariantStyle<RemixSelectSpec>> value) {
    return merge(RemixSelectStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSelectStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSelectStyle(modifier: value));
  }

  /// Merges with another [RemixSelectStyle].
  @override
  RemixSelectStyle merge(RemixSelectStyle? other) {
    return RemixSelectStyle.create(
      menuContainer: MixOps.merge($menuContainer, other?.$menuContainer),
      trigger: MixOps.merge($trigger, other?.$trigger),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectSpec>] using context.
  @override
  StyleSpec<RemixSelectSpec> resolve(BuildContext context) {
    final spec = RemixSelectSpec(
      menuContainer: MixOps.resolve(context, $menuContainer),
      trigger: MixOps.resolve(context, $trigger),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('menuContainer', $menuContainer))
      ..add(DiagnosticsProperty('trigger', $trigger));
  }

  @override
  List<Object?> get props => [
    $menuContainer,
    $trigger,
    $animation,
    $modifier,
    $variants,
  ];
}

mixin _$RemixSelectTriggerStyleMixin
    on Style<RemixSelectTriggerSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $label;

  /// Sets the container.
  RemixSelectTriggerStyle container(FlexBoxStyler value) {
    return merge(RemixSelectTriggerStyle(container: value));
  }

  /// Sets the icon.
  RemixSelectTriggerStyle icon(IconStyler value) {
    return merge(RemixSelectTriggerStyle(icon: value));
  }

  /// Sets the label.
  RemixSelectTriggerStyle label(TextStyler value) {
    return merge(RemixSelectTriggerStyle(label: value));
  }

  /// Sets the animation configuration.
  RemixSelectTriggerStyle animate(AnimationConfig value) {
    return merge(RemixSelectTriggerStyle(animation: value));
  }

  /// Sets the style variants.
  RemixSelectTriggerStyle variants(
    List<VariantStyle<RemixSelectTriggerSpec>> value,
  ) {
    return merge(RemixSelectTriggerStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSelectTriggerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSelectTriggerStyle(modifier: value));
  }

  /// Merges with another [RemixSelectTriggerStyle].
  @override
  RemixSelectTriggerStyle merge(RemixSelectTriggerStyle? other) {
    return RemixSelectTriggerStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectTriggerSpec>] using context.
  @override
  StyleSpec<RemixSelectTriggerSpec> resolve(BuildContext context) {
    final spec = RemixSelectTriggerSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      label: MixOps.resolve(context, $label),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}

mixin _$RemixSelectMenuItemStyleMixin
    on Style<RemixSelectMenuItemSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $text;

  /// Sets the container.
  RemixSelectMenuItemStyle container(FlexBoxStyler value) {
    return merge(RemixSelectMenuItemStyle(container: value));
  }

  /// Sets the icon.
  RemixSelectMenuItemStyle icon(IconStyler value) {
    return merge(RemixSelectMenuItemStyle(icon: value));
  }

  /// Sets the text.
  RemixSelectMenuItemStyle text(TextStyler value) {
    return merge(RemixSelectMenuItemStyle(text: value));
  }

  /// Sets the animation configuration.
  RemixSelectMenuItemStyle animate(AnimationConfig value) {
    return merge(RemixSelectMenuItemStyle(animation: value));
  }

  /// Sets the style variants.
  RemixSelectMenuItemStyle variants(
    List<VariantStyle<RemixSelectMenuItemSpec>> value,
  ) {
    return merge(RemixSelectMenuItemStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSelectMenuItemStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSelectMenuItemStyle(modifier: value));
  }

  /// Merges with another [RemixSelectMenuItemStyle].
  @override
  RemixSelectMenuItemStyle merge(RemixSelectMenuItemStyle? other) {
    return RemixSelectMenuItemStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      text: MixOps.merge($text, other?.$text),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectMenuItemSpec>] using context.
  @override
  StyleSpec<RemixSelectMenuItemSpec> resolve(BuildContext context) {
    final spec = RemixSelectMenuItemSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      text: MixOps.resolve(context, $text),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('text', $text));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $text,
    $animation,
    $modifier,
    $variants,
  ];
}
