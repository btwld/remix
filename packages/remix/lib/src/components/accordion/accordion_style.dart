part of 'accordion.dart';

@MixableStyler()
class RemixAccordionStyle
    extends RemixFlexContainerStyle<RemixAccordionSpec, RemixAccordionStyle>
    with Diagnosticable, _$RemixAccordionStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $trigger;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $leadingIcon;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $title;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $trailingIcon;
  @MixableField(setterType: BoxStyler)
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

  /// Sets container alignment
  RemixAccordionStyle alignment(Alignment value) {
    return merge(RemixAccordionStyle(trigger: FlexBoxStyler(alignment: value)));
  }

  /// Style when accordion is collapsed
  RemixAccordionStyle onExpanded<T>(RemixAccordionStyle value) {
    return variants([
      VariantStyle(
        ContextVariant('onExpanded', (context) {
          return NakedAccordionItemState.of<T>(context).isExpanded;
        }),
        value,
      ),
    ]);
  }

  /// Style when accordion is collapsed
  RemixAccordionStyle onCollapsed<T>(RemixAccordionStyle value) {
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
  RemixAccordionStyle onCanExpand<T>(RemixAccordionStyle value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanExpand', (context) {
          return NakedAccordionItemState.of<T>(context).canExpand;
        }),
        value,
      ),
    ]);
  }

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixAccordionStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyle(trigger: FlexBoxStyler(padding: value)));
  }

  @override
  RemixAccordionStyle color(Color value) {
    return merge(
      RemixAccordionStyle(
        trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixAccordionStyle size(double width, double height) {
    return merge(
      RemixAccordionStyle(
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
  RemixAccordionStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixAccordionStyle(
        trigger: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
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
    return merge(
      RemixAccordionStyle(trigger: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixAccordionStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixAccordionStyle(
        trigger: FlexBoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  RemixAccordionStyle flex(FlexStyler value) {
    return merge(RemixAccordionStyle(trigger: FlexBoxStyler().flex(value)));
  }
}
