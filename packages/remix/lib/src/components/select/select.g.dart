// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSelectSpec implements Spec<RemixSelectSpec>, Diagnosticable {
  StyleSpec<RemixSelectTriggerSpec> get trigger;
  StyleSpec<FlexBoxSpec> get menuContainer;
  StyleSpec<RemixSelectMenuItemSpec> get item;

  @override
  Type get type => RemixSelectSpec;

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
  List<Object?> get props => [trigger, menuContainer, item];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSelectSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('menuContainer', menuContainer))
      ..add(DiagnosticsProperty('item', item));
  }
}

@Deprecated(
  'Rename to `_\$RemixSelectSpec` and migrate the class declaration to `class RemixSelectSpec with _\$RemixSelectSpec`. The `_\$RemixSelectSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSelectSpecMethods = _$RemixSelectSpec; // ignore: unused_element

mixin _$RemixSelectTriggerSpec
    implements Spec<RemixSelectTriggerSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixSelectTriggerSpec;

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
  List<Object?> get props => [container, label, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSelectTriggerSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixSelectTriggerSpec` and migrate the class declaration to `class RemixSelectTriggerSpec with _\$RemixSelectTriggerSpec`. The `_\$RemixSelectTriggerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSelectTriggerSpecMethods = _$RemixSelectTriggerSpec; // ignore: unused_element

mixin _$RemixSelectMenuItemSpec
    implements Spec<RemixSelectMenuItemSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get text;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixSelectMenuItemSpec;

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
  List<Object?> get props => [container, text, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSelectMenuItemSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixSelectMenuItemSpec` and migrate the class declaration to `class RemixSelectMenuItemSpec with _\$RemixSelectMenuItemSpec`. The `_\$RemixSelectMenuItemSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSelectMenuItemSpecMethods = _$RemixSelectMenuItemSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSelectStylerMixin on Style<RemixSelectSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $menuContainer;
  Prop<StyleSpec<RemixSelectTriggerSpec>>? get $trigger;

  /// Sets the menuContainer.
  RemixSelectStyler menuContainer(FlexBoxStyler value) {
    return merge(RemixSelectStyler(menuContainer: value));
  }

  /// Sets the trigger.
  RemixSelectStyler trigger(RemixSelectTriggerStyler value) {
    return merge(RemixSelectStyler(trigger: value));
  }

  /// Sets the animation configuration.
  RemixSelectStyler animate(AnimationConfig value) {
    return merge(RemixSelectStyler(animation: value));
  }

  /// Sets the style variants.
  RemixSelectStyler variants(List<VariantStyle<RemixSelectSpec>> value) {
    return merge(RemixSelectStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSelectStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSelectStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSelectStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSelectStyler(modifier: value));
  }

  /// Merges with another [RemixSelectStyler].
  @override
  RemixSelectStyler merge(RemixSelectStyler? other) {
    return RemixSelectStyler.create(
      menuContainer: MixOps.merge($menuContainer, other?.$menuContainer),
      trigger: MixOps.merge($trigger, other?.$trigger),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectSpec>] using [context].
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

mixin _$RemixSelectTriggerStylerMixin
    on Style<RemixSelectTriggerSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixSelectTriggerStyler container(FlexBoxStyler value) {
    return merge(RemixSelectTriggerStyler(container: value));
  }

  /// Sets the label.
  RemixSelectTriggerStyler label(TextStyler value) {
    return merge(RemixSelectTriggerStyler(label: value));
  }

  /// Sets the icon.
  RemixSelectTriggerStyler icon(IconStyler value) {
    return merge(RemixSelectTriggerStyler(icon: value));
  }

  /// Sets the animation configuration.
  RemixSelectTriggerStyler animate(AnimationConfig value) {
    return merge(RemixSelectTriggerStyler(animation: value));
  }

  /// Sets the style variants.
  RemixSelectTriggerStyler variants(
    List<VariantStyle<RemixSelectTriggerSpec>> value,
  ) {
    return merge(RemixSelectTriggerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSelectTriggerStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSelectTriggerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSelectTriggerStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSelectTriggerStyler(modifier: value));
  }

  /// Merges with another [RemixSelectTriggerStyler].
  @override
  RemixSelectTriggerStyler merge(RemixSelectTriggerStyler? other) {
    return RemixSelectTriggerStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectTriggerSpec>] using [context].
  @override
  StyleSpec<RemixSelectTriggerSpec> resolve(BuildContext context) {
    final spec = RemixSelectTriggerSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}

mixin _$RemixSelectMenuItemStylerMixin
    on Style<RemixSelectMenuItemSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $text;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixSelectMenuItemStyler container(FlexBoxStyler value) {
    return merge(RemixSelectMenuItemStyler(container: value));
  }

  /// Sets the text.
  RemixSelectMenuItemStyler text(TextStyler value) {
    return merge(RemixSelectMenuItemStyler(text: value));
  }

  /// Sets the icon.
  RemixSelectMenuItemStyler icon(IconStyler value) {
    return merge(RemixSelectMenuItemStyler(icon: value));
  }

  /// Sets the animation configuration.
  RemixSelectMenuItemStyler animate(AnimationConfig value) {
    return merge(RemixSelectMenuItemStyler(animation: value));
  }

  /// Sets the style variants.
  RemixSelectMenuItemStyler variants(
    List<VariantStyle<RemixSelectMenuItemSpec>> value,
  ) {
    return merge(RemixSelectMenuItemStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSelectMenuItemStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSelectMenuItemStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSelectMenuItemStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSelectMenuItemStyler(modifier: value));
  }

  /// Merges with another [RemixSelectMenuItemStyler].
  @override
  RemixSelectMenuItemStyler merge(RemixSelectMenuItemStyler? other) {
    return RemixSelectMenuItemStyler.create(
      container: MixOps.merge($container, other?.$container),
      text: MixOps.merge($text, other?.$text),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectMenuItemSpec>] using [context].
  @override
  StyleSpec<RemixSelectMenuItemSpec> resolve(BuildContext context) {
    final spec = RemixSelectMenuItemSpec(
      container: MixOps.resolve(context, $container),
      text: MixOps.resolve(context, $text),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $text,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
