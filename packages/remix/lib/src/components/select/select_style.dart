part of 'select.dart';

/// Style configuration for [RemixSelect] trigger and menu overlay.
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
}

/// Style configuration for the visible [RemixSelect] trigger.
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

  /// Sets container alignment
  RemixSelectTriggerStyle alignment(Alignment value) {
    return merge(
      RemixSelectTriggerStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  // Abstract method implementations for mixins

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
}

/// Style configuration for an item in a [RemixSelect] menu.
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

  // Abstract method implementations for mixins

  @override
  RemixSelectMenuItemStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixSelectMenuItemStyle(container: FlexBoxStyler(constraints: value)),
    );
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
}
