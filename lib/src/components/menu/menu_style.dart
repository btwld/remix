part of 'menu.dart';

// ============================================================================
// TRIGGER STYLE - Menu trigger content styling (not a button!)
// Note: NakedMenu wraps trigger in NakedButton, so this styles the content only
// ============================================================================

class RemixMenuTriggerStyle
    extends
        RemixFlexContainerStyle<RemixMenuTriggerSpec, RemixMenuTriggerStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
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

  RemixMenuTriggerStyle label(TextStyler value) {
    return merge(RemixMenuTriggerStyle(label: value));
  }

  RemixMenuTriggerStyle icon(IconStyler value) {
    return merge(RemixMenuTriggerStyle(icon: value));
  }

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

  @override
  StyleSpec<RemixMenuTriggerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixMenuTriggerSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixMenuTriggerStyle merge(RemixMenuTriggerStyle? other) {
    if (other == null) return this;

    return RemixMenuTriggerStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixMenuTriggerStyle variants(
    List<VariantStyle<RemixMenuTriggerSpec>> value,
  ) {
    return merge(RemixMenuTriggerStyle(variants: value));
  }

  @override
  RemixMenuTriggerStyle animate(AnimationConfig animation) {
    return merge(RemixMenuTriggerStyle(animation: animation));
  }

  @override
  RemixMenuTriggerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixMenuTriggerStyle(modifier: value));
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

// ============================================================================
// MENU STYLE - Main menu style
// Provides trigger/overlay specs + default styles for items/dividers via StyleProvider
// ============================================================================

class RemixMenuStyle extends RemixStyle<RemixMenuSpec, RemixMenuStyle> {
  /// Trigger styling (resolved into spec)
  final Prop<StyleSpec<RemixMenuTriggerSpec>>? $trigger;

  /// Overlay styling (resolved into spec)
  final Prop<StyleSpec<FlexBoxSpec>>? $overlay;

  /// Default item style (provided to children via StyleProvider, NOT in spec)
  final Prop<StyleSpec<RemixMenuItemSpec>>? $item;

  /// Default divider style (provided to children via StyleProvider, NOT in spec)
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

  RemixMenuStyle trigger(RemixMenuTriggerStyle value) {
    return merge(RemixMenuStyle(trigger: value));
  }

  RemixMenuStyle overlay(FlexBoxStyler value) {
    return merge(RemixMenuStyle(overlay: value));
  }

  RemixMenuStyle item(RemixMenuItemStyle value) {
    return merge(RemixMenuStyle(item: value));
  }

  RemixMenuStyle divider(RemixDividerStyle value) {
    return merge(RemixMenuStyle(divider: value));
  }

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

  @override
  StyleSpec<RemixMenuSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixMenuSpec(
        trigger: MixOps.resolve(context, $trigger),
        overlay: MixOps.resolve(context, $overlay),
        item: MixOps.resolve(context, $item),
        divider: MixOps.resolve(context, $divider),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixMenuStyle merge(RemixMenuStyle? other) {
    if (other == null) return this;

    return RemixMenuStyle.create(
      trigger: MixOps.merge($trigger, other.$trigger),
      overlay: MixOps.merge($overlay, other.$overlay),
      item: MixOps.merge($item, other.$item),
      divider: MixOps.merge($divider, other.$divider),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixMenuStyle variants(List<VariantStyle<RemixMenuSpec>> value) {
    return merge(RemixMenuStyle(variants: value));
  }

  @override
  RemixMenuStyle animate(AnimationConfig animation) {
    return merge(RemixMenuStyle(animation: animation));
  }

  @override
  RemixMenuStyle wrap(WidgetModifierConfig value) {
    return merge(RemixMenuStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
    $trigger,
    $overlay,
    $item,
    $divider,
    $variants,
    $animation,
    $modifier,
  ];
}

class RemixMenuItemStyle
    extends RemixFlexContainerStyle<RemixMenuItemSpec, RemixMenuItemStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $leadingIcon;
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

  RemixMenuItemStyle label(TextStyler value) {
    return merge(RemixMenuItemStyle(label: value));
  }

  RemixMenuItemStyle leadingIcon(IconStyler value) {
    return merge(RemixMenuItemStyle(leadingIcon: value));
  }

  RemixMenuItemStyle trailingIcon(IconStyler value) {
    return merge(RemixMenuItemStyle(trailingIcon: value));
  }

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

  @override
  StyleSpec<RemixMenuItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixMenuItemSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        leadingIcon: MixOps.resolve(context, $leadingIcon),
        trailingIcon: MixOps.resolve(context, $trailingIcon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixMenuItemStyle merge(RemixMenuItemStyle? other) {
    if (other == null) return this;

    return RemixMenuItemStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      leadingIcon: MixOps.merge($leadingIcon, other.$leadingIcon),
      trailingIcon: MixOps.merge($trailingIcon, other.$trailingIcon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixMenuItemStyle variants(List<VariantStyle<RemixMenuItemSpec>> value) {
    return merge(RemixMenuItemStyle(variants: value));
  }

  @override
  RemixMenuItemStyle animate(AnimationConfig animation) {
    return merge(RemixMenuItemStyle(animation: animation));
  }

  @override
  RemixMenuItemStyle wrap(WidgetModifierConfig value) {
    return merge(RemixMenuItemStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $leadingIcon,
    $trailingIcon,
    $variants,
    $animation,
    $modifier,
  ];
}
