part of 'menu.dart';

// ============================================================================
// TRIGGER STYLE - Menu trigger content styling (not a button!)
// Note: NakedMenu wraps trigger in NakedButton, so this styles the content only
// ============================================================================

@MixableStyler()
class RemixMenuTriggerStyle
    extends RemixFlexContainerStyle<RemixMenuTriggerSpec, RemixMenuTriggerStyle>
    with
        LabelStyleMixin<RemixMenuTriggerStyle>,
        IconStyleMixin<RemixMenuTriggerStyle>,
        Diagnosticable,
        _$RemixMenuTriggerStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixMenuTriggerStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixMenuTriggerStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuTriggerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  RemixMenuTriggerStyle alignment(Alignment value) {
    return merge(
      RemixMenuTriggerStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  @override
  RemixMenuTriggerStyle padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixMenuTriggerStyle(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixMenuTriggerStyle color(Color value) {
    return merge(
      RemixMenuTriggerStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixMenuTriggerStyle size(double width, double height) {
    return merge(
      RemixMenuTriggerStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  @override
  RemixMenuTriggerStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixMenuTriggerStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixMenuTriggerStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixMenuTriggerStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixMenuTriggerStyle decoration(DecorationMix value) {
    return merge(
      RemixMenuTriggerStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixMenuTriggerStyle margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixMenuTriggerStyle(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixMenuTriggerStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixMenuTriggerStyle(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixMenuTriggerStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixMenuTriggerStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixMenuTriggerStyle flex(FlexStyler value) {
    return merge(RemixMenuTriggerStyle(container: FlexBoxStyler().flex(value)));
  }
}

// ============================================================================
// MENU STYLE - Main menu style
// Provides trigger/overlay specs + default styles for items/dividers via StyleProvider
// ============================================================================

@MixableStyler()
class RemixMenuStyle extends RemixStyle<RemixMenuSpec, RemixMenuStyle>
    with Diagnosticable, _$RemixMenuStyleMixin {
  /// Trigger styling (resolved into spec)
  @MixableField(setterType: RemixMenuTriggerStyle)
  final Prop<StyleSpec<RemixMenuTriggerSpec>>? $trigger;

  /// Overlay styling (resolved into spec)
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $overlay;

  /// Default item style (provided to children via StyleProvider, NOT in spec)
  @MixableField(setterType: RemixMenuItemStyle)
  final Prop<StyleSpec<RemixMenuItemSpec>>? $item;

  /// Default divider style (provided to children via StyleProvider, NOT in spec)
  @MixableField(setterType: RemixDividerStyle)
  final Prop<StyleSpec<RemixDividerSpec>>? $divider;

  const RemixMenuStyle.create({
    Prop<StyleSpec<RemixMenuTriggerSpec>>? trigger,
    Prop<StyleSpec<FlexBoxSpec>>? overlay,
    Prop<StyleSpec<RemixMenuItemSpec>>? item,
    Prop<StyleSpec<RemixDividerSpec>>? divider,
    super.variants,
    super.animation,
    super.modifier,
  }) : $trigger = trigger,
       $overlay = overlay,
       $item = item,
       $divider = divider;

  RemixMenuStyle({
    RemixMenuTriggerStyle? trigger,
    FlexBoxStyler? overlay,
    RemixMenuItemStyle? item,
    RemixDividerStyle? divider,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         trigger: Prop.maybeMix(trigger),
         overlay: Prop.maybeMix(overlay),
         item: Prop.maybeMix(item),
         divider: Prop.maybeMix(divider),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Creates a [RemixMenu] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// RemixMenuStyle()
  ///   .trigger(...)
  ///   .overlay(...)
  ///   .call<String>(
  ///     trigger: RemixMenuTrigger(label: 'Options'),
  ///     items: [...],
  ///   )
  /// ```
  RemixMenu<T> call<T>({
    required RemixMenuTrigger trigger,
    required List<RemixMenuItemData<T>> items,
    MenuController? controller,
    ValueChanged<T>? onSelected,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    VoidCallback? onCanceled,
    FocusNode? triggerFocusNode,
  }) {
    return RemixMenu(
      trigger: trigger,
      items: items,
      controller: controller,
      onSelected: onSelected,
      onOpen: onOpen,
      onClose: onClose,
      onCanceled: onCanceled,
      triggerFocusNode: triggerFocusNode,
      style: this,
    );
  }
}

@MixableStyler()
class RemixMenuItemStyle
    extends RemixFlexContainerStyle<RemixMenuItemSpec, RemixMenuItemStyle>
    with Diagnosticable, _$RemixMenuItemStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $leadingIcon;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $trailingIcon;

  const RemixMenuItemStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? leadingIcon,
    Prop<StyleSpec<IconSpec>>? trailingIcon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $leadingIcon = leadingIcon,
       $trailingIcon = trailingIcon;

  RemixMenuItemStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? leadingIcon,
    IconStyler? trailingIcon,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuItemSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         leadingIcon: Prop.maybeMix(leadingIcon),
         trailingIcon: Prop.maybeMix(trailingIcon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment
  RemixMenuItemStyle alignment(Alignment value) {
    return merge(
      RemixMenuItemStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixMenuItemStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixMenuItemStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixMenuItemStyle color(Color value) {
    return merge(
      RemixMenuItemStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixMenuItemStyle size(double width, double height) {
    return merge(
      RemixMenuItemStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  @override
  RemixMenuItemStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixMenuItemStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixMenuItemStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixMenuItemStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixMenuItemStyle decoration(DecorationMix value) {
    return merge(
      RemixMenuItemStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixMenuItemStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixMenuItemStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixMenuItemStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixMenuItemStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixMenuItemStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixMenuItemStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixMenuItemStyle flex(FlexStyler value) {
    return merge(RemixMenuItemStyle(container: FlexBoxStyler().flex(value)));
  }
}
