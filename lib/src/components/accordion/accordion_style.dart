part of 'accordion.dart';

class RemixAccordionStyle
    extends RemixFlexContainerStyle<RemixAccordionSpec, RemixAccordionStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $trigger;
  final Prop<StyleSpec<IconSpec>>? $leadingIcon;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<IconSpec>>? $trailingIcon;
  final Prop<StyleSpec<BoxSpec>>? $content;

  const RemixAccordionStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? trigger,
    Prop<StyleSpec<IconSpec>>? leadingIcon,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<IconSpec>>? trailingIcon,
    Prop<StyleSpec<BoxSpec>>? content,
    super.variants,
    super.animation,
    super.modifier,
  })  : $trigger = trigger,
        $leadingIcon = leadingIcon,
        $title = title,
        $trailingIcon = trailingIcon,
        $content = content;

  RemixAccordionStyle({
    FlexBoxStyler? trigger,
    IconStyler? leadingIcon,
    TextStyler? title,
    IconStyler? trailingIcon,
    BoxStyler? content,
    AnimationConfig? animation,
    List<VariantStyle<RemixAccordionSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          trigger: Prop.maybeMix(trigger),
          leadingIcon: Prop.maybeMix(leadingIcon),
          title: Prop.maybeMix(title),
          trailingIcon: Prop.maybeMix(trailingIcon),
          content: Prop.maybeMix(content),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  RemixAccordionStyle trigger(FlexBoxStyler value) {
    return merge(RemixAccordionStyle(trigger: value));
  }

  RemixAccordionStyle leadingIcon(IconStyler value) {
    return merge(RemixAccordionStyle(leadingIcon: value));
  }

  RemixAccordionStyle title(TextStyler value) {
    return merge(RemixAccordionStyle(title: value));
  }

  RemixAccordionStyle trailingIcon(IconStyler value) {
    return merge(RemixAccordionStyle(trailingIcon: value));
  }

  RemixAccordionStyle content(BoxStyler value) {
    return merge(RemixAccordionStyle(content: value));
  }

  /// Sets container alignment
  RemixAccordionStyle alignment(Alignment value) {
    return merge(
      RemixAccordionStyle(trigger: FlexBoxStyler(alignment: value)),
    );
  }

  /// Style when accordion is expanded
  RemixAccordionStyle onExpanded(RemixAccordionStyle Function(bool) builder) {
    return onBuilder((context) {
      final isExpanded = NakedAccordionItemState.of(context).isExpanded;

      return builder(isExpanded);
    });
  }

  // /// Style when accordion is collapsed
  // RemixAccordionStyle onCollapsed(RemixAccordionStyle value) {
  //   return variants([
  //     VariantStyle(
  //       ContextVariant('onCollapsed', (context) {
  //         return !NakedAccordionItemState.of(context).isExpanded;
  //       }),
  //       value,
  //     ),
  //   ]);
  // }

  /// onCanCollapse
  RemixAccordionStyle onCanCollapse(RemixAccordionStyle value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanCollapse', (context) {
          return NakedAccordionItemState.of(context).canCollapse;
        }),
        value,
      ),
    ]);
  }

  /// onCanExpand
  RemixAccordionStyle onCanExpand(RemixAccordionStyle value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanExpand', (context) {
          return NakedAccordionItemState.of(context).canExpand;
        }),
        value,
      ),
    ]);
  }

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixAccordionStyle padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixAccordionStyle(trigger: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixAccordionStyle color(Color value) {
    return merge(RemixAccordionStyle(
      trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  @override
  RemixAccordionStyle size(double width, double height) {
    return merge(RemixAccordionStyle(
      trigger: FlexBoxStyler(
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
  RemixAccordionStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixAccordionStyle(
      trigger:
          FlexBoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
    ));
  }

  @override
  RemixAccordionStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixAccordionStyle(trigger: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixAccordionStyle decoration(DecorationMix value) {
    return merge(
      RemixAccordionStyle(trigger: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixAccordionStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle(trigger: FlexBoxStyler(margin: value)));
  }

  @override
  RemixAccordionStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixAccordionStyle(
      trigger: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixAccordionStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixAccordionStyle(
      trigger: FlexBoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  RemixAccordionStyle flex(FlexStyler value) {
    return merge(RemixAccordionStyle(trigger: FlexBoxStyler()));
  }

  @override
  StyleSpec<RemixAccordionSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixAccordionSpec(
        trigger: MixOps.resolve(context, $trigger),
        leadingIcon: MixOps.resolve(context, $leadingIcon),
        title: MixOps.resolve(context, $title),
        trailingIcon: MixOps.resolve(context, $trailingIcon),
        content: MixOps.resolve(context, $content),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    if (other == null) return this;

    return RemixAccordionStyle.create(
      trigger: MixOps.merge($trigger, other.$trigger),
      leadingIcon: MixOps.merge($leadingIcon, other.$leadingIcon),
      title: MixOps.merge($title, other.$title),
      trailingIcon: MixOps.merge($trailingIcon, other.$trailingIcon),
      content: MixOps.merge($content, other.$content),
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
        $trigger,
        $leadingIcon,
        $title,
        $trailingIcon,
        $content,
        $variants,
        $animation,
        $modifier,
      ];
}
