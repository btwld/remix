part of 'select.dart';

class RemixSelectStyle extends RemixStyle<SelectSpec, RemixSelectStyle> {
  final Prop<StyleSpec<BoxSpec>>? $menuContainer;
  final Prop<StyleSpec<SelectTriggerSpec>>? $trigger;
  final Prop<StyleSpec<SelectMenuItemSpec>>? $item;
  final Prop<StyleSpec<CompositedTransformFollowerSpec>>? $position;

  const RemixSelectStyle.create({
    Prop<StyleSpec<BoxSpec>>? menuContainer,
    Prop<StyleSpec<SelectTriggerSpec>>? trigger,
    Prop<StyleSpec<SelectMenuItemSpec>>? item,
    Prop<StyleSpec<CompositedTransformFollowerSpec>>? position,
    super.variants,
    super.animation,
    super.modifier,
  })  : $menuContainer = menuContainer,
        $trigger = trigger,
        $item = item,
        $position = position;

  RemixSelectStyle({
    BoxStyler? menuContainer,
    RemixSelectTriggerStyle? trigger,
    RemixSelectMenuItemStyle? item,
    RemixCompositedTransformFollowerStyle? position,
    AnimationConfig? animation,
    List<VariantStyle<SelectSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          menuContainer: Prop.maybeMix(menuContainer),
          trigger: Prop.maybeMix(trigger),
          item: Prop.maybeMix(item),
          position: Prop.maybeMix(position),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets menu container styling
  RemixSelectStyle menuContainer(BoxStyler value) {
    return merge(RemixSelectStyle(menuContainer: value));
  }

  /// Sets trigger styling
  RemixSelectStyle trigger(RemixSelectTriggerStyle value) {
    return merge(RemixSelectStyle(trigger: value));
  }

  /// Sets menu item styling
  RemixSelectStyle item(RemixSelectMenuItemStyle value) {
    return merge(RemixSelectStyle(item: value));
  }

  /// Sets follower position styling
  RemixSelectStyle position(RemixCompositedTransformFollowerStyle value) {
    return merge(RemixSelectStyle(position: value));
  }

  // Abstract method implementations for mixins (delegating to menuContainer)

  RemixSelectStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixSelectStyle(
      menuContainer: BoxStyler(foregroundDecoration: value),
    ));
  }

  RemixSelectStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixSelectStyle(
      menuContainer: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  RemixSelectStyle withVariants(List<VariantStyle<SelectSpec>> value) {
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
  StyleSpec<SelectSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SelectSpec(
        trigger: MixOps.resolve(context, $trigger),
        menuContainer: MixOps.resolve(context, $menuContainer),
        item: MixOps.resolve(context, $item),
        position: MixOps.resolve(context, $position),
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
      item: MixOps.merge($item, other.$item),
      position: MixOps.merge($position, other.$position),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $menuContainer,
        $trigger,
        $item,
        $position,
        $variants,
        $animation,
        $modifier,
      ];
}

// Style classes for sub-specs
class RemixSelectTriggerStyle extends RemixFlexContainerStyle<SelectTriggerSpec,
    RemixSelectTriggerStyle>
    with
        LabelStyleMixin<RemixSelectTriggerStyle>,
        IconStyleMixin<RemixSelectTriggerStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectTriggerStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $icon = icon;

  RemixSelectTriggerStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectTriggerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container styling directly
  RemixSelectTriggerStyle container(FlexBoxStyler value) {
    return merge(RemixSelectTriggerStyle(container: value));
  }

  /// Sets label styling
  RemixSelectTriggerStyle label(TextStyler value) {
    return merge(RemixSelectTriggerStyle(label: value));
  }

  /// Sets icon styling
  RemixSelectTriggerStyle icon(IconStyler value) {
    return merge(RemixSelectTriggerStyle(icon: value));
  }

  @override
  StyleSpec<SelectTriggerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SelectTriggerSpec(
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
      icon: other.$icon ?? $icon,
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
  RemixSelectTriggerStyle withVariants(
    List<VariantStyle<SelectTriggerSpec>> value,
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
    return merge(RemixSelectTriggerStyle(
      container: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixSelectTriggerStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixSelectTriggerStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  // FlexStyleMixin implementation
  @override
  RemixSelectTriggerStyle flex(FlexStyler value) {
    return merge(RemixSelectTriggerStyle(container: FlexBoxStyler()));
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

class RemixSelectMenuItemStyle extends RemixFlexContainerStyle<
    SelectMenuItemSpec, RemixSelectMenuItemStyle>
    with
        LabelStyleMixin<RemixSelectMenuItemStyle>,
        IconStyleMixin<RemixSelectMenuItemStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectMenuItemStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixSelectMenuItemStyle({
    FlexBoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<SelectMenuItemSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container styling directly
  RemixSelectMenuItemStyle container(FlexBoxStyler value) {
    return merge(RemixSelectMenuItemStyle(container: value));
  }

  /// Sets text styling
  RemixSelectMenuItemStyle text(TextStyler value) {
    return merge(RemixSelectMenuItemStyle(text: value));
  }

  /// Sets icon styling
  RemixSelectMenuItemStyle icon(IconStyler value) {
    return merge(RemixSelectMenuItemStyle(icon: value));
  }

  @override
  RemixSelectMenuItemStyle label(TextStyler value) {
    return text(value);
  }

  @override
  StyleSpec<SelectMenuItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SelectMenuItemSpec(
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
      text: other.$text ?? $text,
      icon: other.$icon ?? $icon,
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
  RemixSelectMenuItemStyle withVariants(
    List<VariantStyle<SelectMenuItemSpec>> value,
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
    return merge(RemixSelectMenuItemStyle(
      container: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixSelectMenuItemStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixSelectMenuItemStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  // FlexStyleMixin implementation
  @override
  RemixSelectMenuItemStyle flex(FlexStyler value) {
    return merge(RemixSelectMenuItemStyle(container: FlexBoxStyler()));
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

class RemixCompositedTransformFollowerStyle
    extends Style<CompositedTransformFollowerSpec> {
  final Prop<Alignment>? $targetAnchor;
  final Prop<Alignment>? $followerAnchor;
  final Prop<Offset>? $offset;

  const RemixCompositedTransformFollowerStyle.create({
    Prop<Alignment>? targetAnchor,
    Prop<Alignment>? followerAnchor,
    Prop<Offset>? offset,
    super.variants,
    super.animation,
    super.modifier,
  })  : $targetAnchor = targetAnchor,
        $followerAnchor = followerAnchor,
        $offset = offset;

  RemixCompositedTransformFollowerStyle({
    Alignment? targetAnchor,
    Alignment? followerAnchor,
    Offset? offset,
    AnimationConfig? animation,
    List<VariantStyle<CompositedTransformFollowerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          targetAnchor: Prop.maybe(targetAnchor),
          followerAnchor: Prop.maybe(followerAnchor),
          offset: Prop.maybe(offset),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  RemixCompositedTransformFollowerStyle withVariants(
    List<VariantStyle<CompositedTransformFollowerSpec>> value,
  ) {
    return merge(RemixCompositedTransformFollowerStyle(variants: value));
  }

  @override
  StyleSpec<CompositedTransformFollowerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CompositedTransformFollowerSpec(
        offset: MixOps.resolve(context, $offset),
        targetAnchor: MixOps.resolve(context, $targetAnchor),
        followerAnchor: MixOps.resolve(context, $followerAnchor),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCompositedTransformFollowerStyle merge(
    RemixCompositedTransformFollowerStyle? other,
  ) {
    if (other == null) return this;

    return RemixCompositedTransformFollowerStyle.create(
      targetAnchor: other.$targetAnchor ?? $targetAnchor,
      followerAnchor: other.$followerAnchor ?? $followerAnchor,
      offset: other.$offset ?? $offset,
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $targetAnchor,
        $followerAnchor,
        $offset,
        $variants,
        $animation,
        $modifier,
      ];
}
