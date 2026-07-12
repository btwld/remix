part of 'select.dart';

/// Style configuration for [RemixSelect] trigger and menu overlay.
@MixableStyler()
class RemixSelectStyler extends RemixStyler<RemixSelectSpec, RemixSelectStyler>
    with Diagnosticable, _$RemixSelectStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $menuContainer;
  @MixableField(setterType: RemixSelectTriggerStyler)
  final Prop<StyleSpec<RemixSelectTriggerSpec>>? $trigger;
  @MixableField(setterType: RemixSelectMenuItemStyler)
  final Prop<StyleSpec<RemixSelectMenuItemSpec>>? $item;

  const RemixSelectStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? menuContainer,
    Prop<StyleSpec<RemixSelectTriggerSpec>>? trigger,
    Prop<StyleSpec<RemixSelectMenuItemSpec>>? item,
    super.variants,
    super.animation,
    super.modifier,
  }) : $menuContainer = menuContainer,
       $trigger = trigger,
       $item = item;

  RemixSelectStyler({
    FlexBoxStyler? menuContainer,
    RemixSelectTriggerStyler? trigger,
    RemixSelectMenuItemStyler? item,
    AnimationConfig? animation,
    List<VariantStyle<RemixSelectSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         menuContainer: Prop.maybeMix(menuContainer),
         trigger: Prop.maybeMix(trigger),
         item: Prop.maybeMix(item),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Creates a [RemixSelect] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// RemixSelectStyler()
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
    Key? key,
    required RemixSelectTrigger trigger,
    required List<RemixSelectItem<T>> items,
    T? selectedValue,
    OverlayPositionConfig positioning = const OverlayPositionConfig(
      targetAnchor: .bottomCenter,
      followerAnchor: .topCenter,
    ),
    ValueChanged<T?>? onChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    bool enabled = true,
    bool closeOnSelect = true,
    String? semanticLabel,
    FocusNode? focusNode,
  }) {
    return RemixSelect(
      key: key,
      trigger: trigger,
      items: items,
      selectedValue: selectedValue,
      positioning: positioning,
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

  RemixSelectStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSelectStyler(
        menuContainer: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  RemixSelectStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSelectStyler(
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
class RemixSelectTriggerStyler
    extends
        RemixFlexContainerStyler<
          RemixSelectTriggerSpec,
          RemixSelectTriggerStyler
        >
    with
        LabelStyleMixin<RemixSelectTriggerStyler>,
        IconStyleMixin<RemixSelectTriggerStyler>,
        Diagnosticable,
        _$RemixSelectTriggerStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectTriggerStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixSelectTriggerStyler({
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
  RemixSelectTriggerStyler alignment(Alignment value) {
    return merge(
      RemixSelectTriggerStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixSelectTriggerStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixSelectTriggerStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixSelectTriggerStyler decoration(DecorationMix value) {
    return merge(
      RemixSelectTriggerStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixSelectTriggerStyler margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectTriggerStyler(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixSelectTriggerStyler padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectTriggerStyler(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixSelectTriggerStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSelectTriggerStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixSelectTriggerStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSelectTriggerStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixSelectTriggerStyler flex(FlexStyler value) {
    return merge(
      RemixSelectTriggerStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}

/// Style configuration for an item in a [RemixSelect] menu.
@MixableStyler()
class RemixSelectMenuItemStyler
    extends
        RemixFlexContainerStyler<
          RemixSelectMenuItemSpec,
          RemixSelectMenuItemStyler
        >
    with
        LabelStyleMixin<RemixSelectMenuItemStyler>,
        IconStyleMixin<RemixSelectMenuItemStyler>,
        Diagnosticable,
        _$RemixSelectMenuItemStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectMenuItemStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $text = text,
       $icon = icon;

  RemixSelectMenuItemStyler({
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
  RemixSelectMenuItemStyler alignment(Alignment value) {
    return merge(
      RemixSelectMenuItemStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  /// Sets label styling (delegates to text for consistency with mixin)
  @override
  RemixSelectMenuItemStyler label(TextStyler value) {
    return text(value);
  }

  // Abstract method implementations for mixins

  @override
  RemixSelectMenuItemStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixSelectMenuItemStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixSelectMenuItemStyler decoration(DecorationMix value) {
    return merge(
      RemixSelectMenuItemStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixSelectMenuItemStyler margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectMenuItemStyler(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixSelectMenuItemStyler padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixSelectMenuItemStyler(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixSelectMenuItemStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSelectMenuItemStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixSelectMenuItemStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSelectMenuItemStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixSelectMenuItemStyler flex(FlexStyler value) {
    return merge(
      RemixSelectMenuItemStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}
