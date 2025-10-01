part of 'accordion.dart';

class RemixAccordionStyle
    extends RemixFlexContainerStyle<RemixAccordionSpec, RemixAccordionStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<RemixAccordionItemSpec>>? $item;

  const RemixAccordionStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<RemixAccordionItemSpec>>? item,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $item = item;

  RemixAccordionStyle({
    FlexBoxStyler? container,
    RemixAccordionItemStyle? item,
    AnimationConfig? animation,
    List<VariantStyle<RemixAccordionSpec>>? variants,
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

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixAccordionStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixAccordionStyle color(Color value) {
    return merge(RemixAccordionStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value))));
  }

  @override
  RemixAccordionStyle size(double width, double height) {
    return merge(RemixAccordionStyle(
        container: FlexBoxStyler(
            constraints: BoxConstraintsMix(
                minWidth: width,
                maxWidth: width,
                minHeight: height,
                maxHeight: height))));
  }

  @override
  RemixAccordionStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixAccordionStyle(
        container:
            FlexBoxStyler(decoration: BoxDecorationMix(borderRadius: radius))));
  }

  @override
  RemixAccordionStyle constraints(BoxConstraintsMix value) {
    return merge(
        RemixAccordionStyle(container: FlexBoxStyler(constraints: value)));
  }

  @override
  RemixAccordionStyle decoration(DecorationMix value) {
    return merge(
        RemixAccordionStyle(container: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixAccordionStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixAccordionStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixAccordionStyle(
        container: FlexBoxStyler(foregroundDecoration: value)));
  }

  @override
  RemixAccordionStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixAccordionStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  RemixAccordionStyle flex(FlexStyler value) {
    return merge(RemixAccordionStyle(container: FlexBoxStyler().flex(value)));
  }

  @override
  StyleSpec<RemixAccordionSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixAccordionSpec(
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
  RemixAccordionStyle variants(List<VariantStyle<RemixAccordionSpec>> value) {
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

class RemixAccordionItemStyle extends RemixFlexContainerStyle<
    RemixAccordionItemSpec, RemixAccordionItemStyle> {
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
    List<VariantStyle<RemixAccordionItemSpec>>? variants,
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

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixAccordionItemStyle padding(EdgeInsetsGeometryMix value) {
    return merge(
        RemixAccordionItemStyle(trigger: FlexBoxStyler(padding: value)));
  }

  @override
  RemixAccordionItemStyle color(Color value) {
    return merge(RemixAccordionItemStyle(
        trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value))));
  }

  @override
  RemixAccordionItemStyle size(double width, double height) {
    return merge(RemixAccordionItemStyle(
        trigger: FlexBoxStyler(
            constraints: BoxConstraintsMix(
                minWidth: width,
                maxWidth: width,
                minHeight: height,
                maxHeight: height))));
  }

  @override
  RemixAccordionItemStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixAccordionItemStyle(
        trigger:
            FlexBoxStyler(decoration: BoxDecorationMix(borderRadius: radius))));
  }

  @override
  RemixAccordionItemStyle constraints(BoxConstraintsMix value) {
    return merge(
        RemixAccordionItemStyle(trigger: FlexBoxStyler(constraints: value)));
  }

  @override
  RemixAccordionItemStyle decoration(DecorationMix value) {
    return merge(
        RemixAccordionItemStyle(trigger: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixAccordionItemStyle margin(EdgeInsetsGeometryMix value) {
    return merge(
        RemixAccordionItemStyle(trigger: FlexBoxStyler(margin: value)));
  }

  @override
  RemixAccordionItemStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixAccordionItemStyle(
        trigger: FlexBoxStyler(foregroundDecoration: value)));
  }

  @override
  RemixAccordionItemStyle transform(Matrix4 value,
      {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixAccordionItemStyle(
        trigger: FlexBoxStyler(alignment: alignment, transform: value)));
  }

  @override
  RemixAccordionItemStyle flex(FlexStyler value) {
    return merge(RemixAccordionItemStyle(trigger: FlexBoxStyler()));
  }

  @override
  StyleSpec<RemixAccordionItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixAccordionItemSpec(
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
  RemixAccordionItemStyle variants(
      List<VariantStyle<RemixAccordionItemSpec>> value) {
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
