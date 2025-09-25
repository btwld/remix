part of 'accordion.dart';

class RemixAccordionStyle extends RemixStyle<AccordionSpec, RemixAccordionStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<AccordionItemSpec>>? $item;

  const RemixAccordionStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<AccordionItemSpec>>? item,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $item = item;

  RemixAccordionStyle({
    FlexBoxStyler? container,
    RemixAccordionItemStyle? item,
    AnimationConfig? animation,
    List<VariantStyle<AccordionSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          item: Prop.maybeMix(item),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  RemixAccordionStyle container(FlexBoxStyler value) {
    return merge(RemixAccordionStyle(container: value));
  }

  RemixAccordionStyle item(RemixAccordionItemStyle value) {
    return merge(RemixAccordionStyle(item: value));
  }

  @override
  StyleSpec<AccordionSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: AccordionSpec(
        container: MixOps.resolve(context, $container),
        item: MixOps.resolve(context, $item),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    if (other == null) return this;

    return RemixAccordionStyle.create(
      container: MixOps.merge($container, other.$container),
      item: MixOps.merge($item, other.$item),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixAccordionStyle variants(List<VariantStyle<AccordionSpec>> value) {
    return merge(RemixAccordionStyle(variants: value));
  }

  @override
  RemixAccordionStyle animate(AnimationConfig animation) {
    return merge(RemixAccordionStyle(animation: animation));
  }

  @override
  RemixAccordionStyle wrap(WidgetModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $item,
        $variants,
        $animation,
        $modifier,
      ];
}

class RemixAccordionItemStyle extends RemixStyle<AccordionItemSpec, RemixAccordionItemStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $trigger;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<BoxSpec>>? $content;

  const RemixAccordionItemStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? trigger,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<BoxSpec>>? content,
    super.variants,
    super.animation,
    super.modifier,
  })  : $trigger = trigger,
        $title = title,
        $icon = icon,
        $content = content;

  RemixAccordionItemStyle({
    FlexBoxStyler? trigger,
    TextStyler? title,
    IconStyler? icon,
    BoxStyler? content,
    AnimationConfig? animation,
    List<VariantStyle<AccordionItemSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          trigger: Prop.maybeMix(trigger),
          title: Prop.maybeMix(title),
          icon: Prop.maybeMix(icon),
          content: Prop.maybeMix(content),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  RemixAccordionItemStyle trigger(FlexBoxStyler value) {
    return merge(RemixAccordionItemStyle(trigger: value));
  }

  RemixAccordionItemStyle title(TextStyler value) {
    return merge(RemixAccordionItemStyle(title: value));
  }

  RemixAccordionItemStyle icon(IconStyler value) {
    return merge(RemixAccordionItemStyle(icon: value));
  }

  RemixAccordionItemStyle content(BoxStyler value) {
    return merge(RemixAccordionItemStyle(content: value));
  }

  @override
  StyleSpec<AccordionItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: AccordionItemSpec(
        trigger: MixOps.resolve(context, $trigger),
        title: MixOps.resolve(context, $title),
        icon: MixOps.resolve(context, $icon),
        content: MixOps.resolve(context, $content),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixAccordionItemStyle merge(RemixAccordionItemStyle? other) {
    if (other == null) return this;

    return RemixAccordionItemStyle.create(
      trigger: MixOps.merge($trigger, other.$trigger),
      title: MixOps.merge($title, other.$title),
      icon: MixOps.merge($icon, other.$icon),
      content: MixOps.merge($content, other.$content),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixAccordionItemStyle variants(List<VariantStyle<AccordionItemSpec>> value) {
    return merge(RemixAccordionItemStyle(variants: value));
  }

  @override
  RemixAccordionItemStyle animate(AnimationConfig animation) {
    return merge(RemixAccordionItemStyle(animation: animation));
  }

  @override
  RemixAccordionItemStyle wrap(WidgetModifierConfig value) {
    return merge(RemixAccordionItemStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $trigger,
        $title,
        $icon,
        $content,
        $variants,
        $animation,
        $modifier,
      ];
}