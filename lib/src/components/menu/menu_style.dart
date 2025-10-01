part of 'menu.dart';

class RemixMenuStyle extends RemixStyle<RemixMenuSpec, RemixMenuStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $trigger;
  final Prop<StyleSpec<TextSpec>>? $triggerLabel;
  final Prop<StyleSpec<IconSpec>>? $triggerIcon;
  final Prop<StyleSpec<BoxSpec>>? $menuContainer;
  final Prop<StyleSpec<RemixMenuItemSpec>>? $item;

  const RemixMenuStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? trigger,
    Prop<StyleSpec<TextSpec>>? triggerLabel,
    Prop<StyleSpec<IconSpec>>? triggerIcon,
    Prop<StyleSpec<BoxSpec>>? menuContainer,
    Prop<StyleSpec<RemixMenuItemSpec>>? item,
    super.variants,
    super.animation,
    super.modifier,
  })  : $trigger = trigger,
        $triggerLabel = triggerLabel,
        $triggerIcon = triggerIcon,
        $menuContainer = menuContainer,
        $item = item;

  RemixMenuStyle({
    FlexBoxStyler? trigger,
    TextStyler? triggerLabel,
    IconStyler? triggerIcon,
    BoxStyler? menuContainer,
    RemixMenuItemStyle? item,
    AnimationConfig? animation,
    List<VariantStyle<RemixMenuSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          trigger: Prop.maybeMix(trigger),
          triggerLabel: Prop.maybeMix(triggerLabel),
          triggerIcon: Prop.maybeMix(triggerIcon),
          menuContainer: Prop.maybeMix(menuContainer),
          item: Prop.maybeMix(item),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  RemixMenuStyle trigger(FlexBoxStyler value) {
    return merge(RemixMenuStyle(trigger: value));
  }

  RemixMenuStyle triggerLabel(TextStyler value) {
    return merge(RemixMenuStyle(triggerLabel: value));
  }

  RemixMenuStyle triggerIcon(IconStyler value) {
    return merge(RemixMenuStyle(triggerIcon: value));
  }

  RemixMenuStyle menuContainer(BoxStyler value) {
    return merge(RemixMenuStyle(menuContainer: value));
  }

  RemixMenuStyle item(RemixMenuItemStyle value) {
    return merge(RemixMenuStyle(item: value));
  }

  @override
  StyleSpec<RemixMenuSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixMenuSpec(
        trigger: MixOps.resolve(context, $trigger),
        triggerLabel: MixOps.resolve(context, $triggerLabel),
        triggerIcon: MixOps.resolve(context, $triggerIcon),
        menuContainer: MixOps.resolve(context, $menuContainer),
        item: MixOps.resolve(context, $item),
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
      triggerLabel: MixOps.merge($triggerLabel, other.$triggerLabel),
      triggerIcon: MixOps.merge($triggerIcon, other.$triggerIcon),
      menuContainer: MixOps.merge($menuContainer, other.$menuContainer),
      item: MixOps.merge($item, other.$item),
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
        $triggerLabel,
        $triggerIcon,
        $menuContainer,
        $item,
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
  })  : $container = container,
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

  RemixMenuItemStyle container(FlexBoxStyler value) {
    return merge(RemixMenuItemStyle(container: value));
  }

  RemixMenuItemStyle label(TextStyler value) {
    return merge(RemixMenuItemStyle(label: value));
  }

  RemixMenuItemStyle leadingIcon(IconStyler value) {
    return merge(RemixMenuItemStyle(leadingIcon: value));
  }

  RemixMenuItemStyle trailingIcon(IconStyler value) {
    return merge(RemixMenuItemStyle(trailingIcon: value));
  }

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixMenuItemStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixMenuItemStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixMenuItemStyle color(Color value) {
    return merge(RemixMenuItemStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  @override
  RemixMenuItemStyle size(double width, double height) {
    return merge(RemixMenuItemStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  @override
  RemixMenuItemStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixMenuItemStyle(
      container:
          FlexBoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
    ));
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

  /// Sets container alignment
  RemixMenuItemStyle alignment(Alignment value) {
    return merge(RemixMenuItemStyle(container: FlexBoxStyler(alignment: value)));
  }

  @override
  RemixMenuItemStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixMenuItemStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixMenuItemStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixMenuItemStyle(
      container: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixMenuItemStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixMenuItemStyle(
      container: FlexBoxStyler(transform: value, transformAlignment: alignment),
    ));
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
