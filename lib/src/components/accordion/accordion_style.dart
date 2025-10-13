part of 'accordion.dart';

class RemixAccordionStyle<T>
    extends
        RemixFlexContainerStyle<RemixAccordionSpec, RemixAccordionStyle<T>> {
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
  }) : $trigger = trigger,
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

  RemixAccordionStyle<T> trigger(FlexBoxStyler value) {
    return merge(RemixAccordionStyle<T>(trigger: value));
  }

  RemixAccordionStyle<T> leadingIcon(IconStyler value) {
    return merge(RemixAccordionStyle<T>(leadingIcon: value));
  }

  RemixAccordionStyle<T> title(TextStyler value) {
    return merge(RemixAccordionStyle<T>(title: value));
  }

  RemixAccordionStyle<T> trailingIcon(IconStyler value) {
    return merge(RemixAccordionStyle<T>(trailingIcon: value));
  }

  RemixAccordionStyle<T> content(BoxStyler value) {
    return merge(RemixAccordionStyle<T>(content: value));
  }

  /// Sets container alignment
  RemixAccordionStyle<T> alignment(Alignment value) {
    return merge(
      RemixAccordionStyle<T>(trigger: FlexBoxStyler(alignment: value)),
    );
  }

  /// Style when accordion is expanded
  RemixAccordionStyle<T> onExpanded(
    RemixAccordionStyle<T> Function(bool) builder,
  ) {
    return onBuilder((context) {
      final isExpanded = NakedAccordionItemState.of<T>(context).isExpanded;

      return builder(isExpanded);
    });
  }

  /// Style when accordion is collapsed
  RemixAccordionStyle<T> onCollapsed(RemixAccordionStyle<T> value) {
    return variants([
      VariantStyle(
        ContextVariant('onCollapsed', (context) {
          return !NakedAccordionItemState.of<T>(context).isExpanded;
        }),
        value,
      ),
    ]);
  }

  /// onCanCollapse
  RemixAccordionStyle<T> onCanCollapse(RemixAccordionStyle<T> value) {
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
  RemixAccordionStyle<T> onCanExpand(RemixAccordionStyle<T> value) {
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
  RemixAccordionStyle<T> padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixAccordionStyle<T>(trigger: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixAccordionStyle<T> textColor(Color value) {
    return merge(
      RemixAccordionStyle<T>(
        trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixAccordionStyle<T> size(double width, double height) {
    return merge(
      RemixAccordionStyle<T>(
        trigger: FlexBoxStyler(
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
  RemixAccordionStyle<T> borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixAccordionStyle<T>(
        trigger: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixAccordionStyle<T> constraints(BoxConstraintsMix value) {
    return merge(
      RemixAccordionStyle<T>(trigger: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixAccordionStyle<T> decoration(DecorationMix value) {
    return merge(
      RemixAccordionStyle<T>(trigger: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixAccordionStyle<T> margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle<T>(trigger: FlexBoxStyler(margin: value)));
  }

  @override
  RemixAccordionStyle<T> foregroundDecoration(DecorationMix value) {
    return merge(
      RemixAccordionStyle<T>(
        trigger: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixAccordionStyle<T> transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixAccordionStyle<T>(
        trigger: FlexBoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  RemixAccordionStyle<T> flex(FlexStyler value) {
    return merge(RemixAccordionStyle<T>(trigger: FlexBoxStyler()));
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
  RemixAccordionStyle<T> merge(RemixAccordionStyle? other) {
    if (other == null) return this;

    return RemixAccordionStyle<T>.create(
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
  RemixAccordionStyle<T> variants(
    List<VariantStyle<RemixAccordionSpec>> value,
  ) {
    return merge(RemixAccordionStyle<T>(variants: value));
  }

  @override
  RemixAccordionStyle<T> animate(AnimationConfig animation) {
    return merge(RemixAccordionStyle<T>(animation: animation));
  }

  @override
  RemixAccordionStyle<T> wrap(WidgetModifierConfig value) {
    return merge(RemixAccordionStyle<T>(modifier: value));
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
