part of 'select.dart';

@MixableStyler()
class RemixSelectStyle extends RemixStyle<RemixSelectSpec, RemixSelectStyle>
    with Diagnosticable, _$RemixSelectStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $menuContainer;
  @MixableField(setterType: RemixSelectTriggerStyle)
  final Prop<StyleSpec<RemixSelectTriggerSpec>>? $trigger;

  const RemixSelectStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? menuContainer,
    Prop<StyleSpec<RemixSelectTriggerSpec>>? trigger,
    super.variants,
    super.animation,
    super.modifier,
  }) : $menuContainer = menuContainer,
       $trigger = trigger;

  RemixSelectStyle({
    FlexBoxStyler? menuContainer,
    RemixSelectTriggerStyle? trigger,
    AnimationConfig? animation,
    List<VariantStyle<RemixSelectSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         menuContainer: Prop.maybeMix(menuContainer),
         trigger: Prop.maybeMix(trigger),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets menu container styling
  RemixSelectStyle menuContainer(FlexBoxStyler value) {
    return merge(RemixSelectStyle(menuContainer: value));
  }

  /// Sets trigger styling
  RemixSelectStyle trigger(RemixSelectTriggerStyle value) {
    return merge(RemixSelectStyle(trigger: value));
  }

  /// Creates a [RemixSelect] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// RemixSelectStyle()
  ///   .trigger(...)
  ///   .menuContainer(...)
  ///   .call<String>(
  ///     trigger: RemixSelectTrigger(placeholder: 'Select an option'),
  ///     items: [
  ///       RemixSelectItem(value: 'apple', label: 'Apple'),
  ///       RemixSelectItem(value: 'banana', label: 'Banana'),
  ///     ],
  ///   )
  /// ```
  RemixSelect<T> call<T>({
    required RemixSelectTrigger trigger,
    required List<RemixSelectItem<T>> items,
    T? selectedValue,
    ValueChanged<T?>? onChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    bool enabled = true,
    bool closeOnSelect = true,
    String? semanticLabel,
    FocusNode? focusNode,
  }) {
    return RemixSelect(
      trigger: trigger,
      items: items,
      selectedValue: selectedValue,
      onChanged: onChanged,
      onOpen: onOpen,
      onClose: onClose,
      enabled: enabled,
      semanticLabel: semanticLabel,
      closeOnSelect: closeOnSelect,
      focusNode: focusNode,
      style: this,
    );
  }

  // Abstract method implementations for mixins (delegating to menuContainer)

  RemixSelectStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSelectStyle(
        menuContainer: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  RemixSelectStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSelectStyle(
        menuContainer: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixSelectStyle variants(List<VariantStyle<RemixSelectSpec>> value) {
    return merge(RemixSelectStyle(variants: value));
  }

  @override
  RemixSelectStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSelectStyle(modifier: value));
  }

  @override
  RemixSelectStyle animate(AnimationConfig animation) {
    return merge(RemixSelectStyle(animation: animation));
  }

  @override
  StyleSpec<RemixSelectSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSelectSpec(
        trigger: MixOps.resolve(context, $trigger),
        menuContainer: MixOps.resolve(context, $menuContainer),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSelectStyle merge(RemixSelectStyle? other) {
    if (other == null) return this;

    return RemixSelectStyle.create(
      menuContainer: MixOps.merge($menuContainer, other.$menuContainer),
      trigger: MixOps.merge($trigger, other.$trigger),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
    $menuContainer,
    $trigger,
    $variants,
    $animation,
    $modifier,
  ];
}

// Style classes for sub-specs
@MixableStyler()
class RemixSelectTriggerStyle
    extends
        RemixFlexContainerStyle<RemixSelectTriggerSpec, RemixSelectTriggerStyle>
    with
        LabelStyleMixin<RemixSelectTriggerStyle>,
        IconStyleMixin<RemixSelectTriggerStyle>,
        Diagnosticable,
        _$RemixSelectTriggerStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectTriggerStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixSelectTriggerStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixSelectTriggerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets label styling
  RemixSelectTriggerStyle label(TextStyler value) {
    return merge(RemixSelectTriggerStyle(label: value));
  }

  /// Sets icon styling
  RemixSelectTriggerStyle icon(IconStyler value) {
    return merge(RemixSelectTriggerStyle(icon: value));
  }

  /// Sets container alignment
  RemixSelectTriggerStyle alignment(Alignment value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  @override
  StyleSpec<RemixSelectTriggerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSelectTriggerSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSelectTriggerStyle merge(RemixSelectTriggerStyle? other) {
    if (other == null) return this;

    return RemixSelectTriggerStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixSelectTriggerStyle animate(AnimationConfig config) {
    return merge(RemixSelectTriggerStyle(animation: config));
  }

  @override
  RemixSelectTriggerStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixSelectTriggerStyle decoration(DecorationMix value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixSelectTriggerStyle variants(
    List<VariantStyle<RemixSelectTriggerSpec>> value,
  ) {
    return merge(RemixSelectTriggerStyle(variants: value));
  }

  @override
  RemixSelectTriggerStyle margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixSelectTriggerStyle padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixSelectTriggerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSelectTriggerStyle(modifier: value));
  }

  @override
  RemixSelectTriggerStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSelectTriggerStyle(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixSelectTriggerStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSelectTriggerStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixSelectTriggerStyle flex(FlexStyler value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler().flex(value)),
    );
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $variants,
    $animation,
    $modifier,
  ];
}

@MixableStyler()
class RemixSelectMenuItemStyle
    extends
        RemixFlexContainerStyle<
          RemixSelectMenuItemSpec,
          RemixSelectMenuItemStyle
        >
    with
        LabelStyleMixin<RemixSelectMenuItemStyle>,
        IconStyleMixin<RemixSelectMenuItemStyle>,
        Diagnosticable,
        _$RemixSelectMenuItemStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectMenuItemStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $text = text,
       $icon = icon;

  RemixSelectMenuItemStyle({
    FlexBoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixSelectMenuItemSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         text: Prop.maybeMix(text),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets text styling
  RemixSelectMenuItemStyle text(TextStyler value) {
    return merge(RemixSelectMenuItemStyle(text: value));
  }

  /// Sets icon styling
  RemixSelectMenuItemStyle icon(IconStyler value) {
    return merge(RemixSelectMenuItemStyle(icon: value));
  }

  /// Sets container alignment
  RemixSelectMenuItemStyle alignment(Alignment value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  /// Sets label styling (delegates to text for consistency with mixin)
  @override
  RemixSelectMenuItemStyle label(TextStyler value) {
    return text(value);
  }

  @override
  StyleSpec<RemixSelectMenuItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSelectMenuItemSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSelectMenuItemStyle merge(RemixSelectMenuItemStyle? other) {
    if (other == null) return this;

    return RemixSelectMenuItemStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixSelectMenuItemStyle animate(AnimationConfig config) {
    return merge(RemixSelectMenuItemStyle(animation: config));
  }

  @override
  RemixSelectMenuItemStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixSelectMenuItemStyle variants(
    List<VariantStyle<RemixSelectMenuItemSpec>> value,
  ) {
    return merge(RemixSelectMenuItemStyle(variants: value));
  }

  @override
  RemixSelectMenuItemStyle decoration(DecorationMix value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixSelectMenuItemStyle margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixSelectMenuItemStyle padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixSelectMenuItemStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSelectMenuItemStyle(modifier: value));
  }

  @override
  RemixSelectMenuItemStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSelectMenuItemStyle(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixSelectMenuItemStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSelectMenuItemStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixSelectMenuItemStyle flex(FlexStyler value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler().flex(value)),
    );
  }

  @override
  List<Object?> get props => [
    $container,
    $text,
    $icon,
    $variants,
    $animation,
    $modifier,
  ];
}
