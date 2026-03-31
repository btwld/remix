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

  // -- Factory constructors for convenience --

  /// Creates a style with the given background color.
  factory RemixAccordionStyle.backgroundColor(Color value) =>
      RemixAccordionStyle().backgroundColor(value);

  /// Creates a style with the given padding.
  factory RemixAccordionStyle.padding(EdgeInsetsGeometryMix value) =>
      RemixAccordionStyle().padding(value);

  /// Creates a style with the given margin.
  factory RemixAccordionStyle.margin(EdgeInsetsGeometryMix value) =>
      RemixAccordionStyle().margin(value);

  /// Creates a style with the given decoration.
  factory RemixAccordionStyle.decoration(DecorationMix value) =>
      RemixAccordionStyle().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixAccordionStyle.alignment(Alignment value) =>
      RemixAccordionStyle().alignment(value);

  /// Creates a style with the given constraints.
  factory RemixAccordionStyle.constraints(BoxConstraintsMix value) =>
      RemixAccordionStyle().constraints(value);

  /// Creates a style with the given border radius.
  factory RemixAccordionStyle.borderRadius(BorderRadiusGeometryMix value) =>
      RemixAccordionStyle().borderRadius(value);

  /// Creates a style with the given spacing.
  factory RemixAccordionStyle.spacing(double value) =>
      RemixAccordionStyle().spacing(value);

  /// Creates a style with the given title color.
  factory RemixAccordionStyle.titleColor(Color value) =>
      RemixAccordionStyle().titleColor(value);

  /// Creates a style with the given title font size.
  factory RemixAccordionStyle.titleFontSize(double value) =>
      RemixAccordionStyle().titleFontSize(value);

  /// Creates a style with the given title font weight.
  factory RemixAccordionStyle.titleFontWeight(FontWeight value) =>
      RemixAccordionStyle().titleFontWeight(value);

  /// Creates a style with the given title style.
  factory RemixAccordionStyle.titleStyle(TextStyleMix value) =>
      RemixAccordionStyle().titleStyle(value);

  /// Creates a style with the given leading icon color.
  factory RemixAccordionStyle.leadingIconColor(Color value) =>
      RemixAccordionStyle().leadingIconColor(value);

  /// Creates a style with the given leading icon size.
  factory RemixAccordionStyle.leadingIconSize(double value) =>
      RemixAccordionStyle().leadingIconSize(value);

  /// Creates a style with the given trailing icon color.
  factory RemixAccordionStyle.trailingIconColor(Color value) =>
      RemixAccordionStyle().trailingIconColor(value);

  /// Creates a style with the given trailing icon size.
  factory RemixAccordionStyle.trailingIconSize(double value) =>
      RemixAccordionStyle().trailingIconSize(value);

  /// Creates a style with the given content color.
  factory RemixAccordionStyle.contentColor(Color value) =>
      RemixAccordionStyle().contentColor(value);

  /// Creates a style with the given content padding.
  factory RemixAccordionStyle.contentPadding(EdgeInsetsGeometryMix value) =>
      RemixAccordionStyle().contentPadding(value);

  /// Creates a style with the given content decoration.
  factory RemixAccordionStyle.contentDecoration(DecorationMix value) =>
      RemixAccordionStyle().contentDecoration(value);

  // -- Convenience instance methods --

  /// Sets the background color of the trigger.
  RemixAccordionStyle backgroundColor(Color value) {
    return merge(
      .new(
        trigger: .new(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the spacing between items in the trigger.
  RemixAccordionStyle spacing(double value) {
    return merge(RemixAccordionStyle(trigger: FlexBoxStyler(spacing: value)));
  }

  /// Sets title color.
  RemixAccordionStyle titleColor(Color value) {
    return title(TextStyler(style: TextStyleMix(color: value)));
  }

  /// Sets title font size.
  RemixAccordionStyle titleFontSize(double value) {
    return title(TextStyler(style: TextStyleMix(fontSize: value)));
  }

  /// Sets title font weight.
  RemixAccordionStyle titleFontWeight(FontWeight value) {
    return title(TextStyler(style: TextStyleMix(fontWeight: value)));
  }

  /// Sets title style using TextStyleMix directly.
  RemixAccordionStyle titleStyle(TextStyleMix value) {
    return title(TextStyler(style: value));
  }

  /// Sets leading icon color.
  RemixAccordionStyle leadingIconColor(Color value) {
    return leadingIcon(IconStyler(color: value));
  }

  /// Sets leading icon size.
  RemixAccordionStyle leadingIconSize(double value) {
    return leadingIcon(IconStyler(size: value));
  }

  /// Sets trailing icon color.
  RemixAccordionStyle trailingIconColor(Color value) {
    return trailingIcon(IconStyler(color: value));
  }

  /// Sets trailing icon size.
  RemixAccordionStyle trailingIconSize(double value) {
    return trailingIcon(IconStyler(size: value));
  }

  /// Sets content background color.
  RemixAccordionStyle contentColor(Color value) {
    return content(BoxStyler(decoration: BoxDecorationMix(color: value)));
  }

  /// Sets content padding.
  RemixAccordionStyle contentPadding(EdgeInsetsGeometryMix value) {
    return content(BoxStyler(padding: value));
  }

  /// Sets content decoration.
  RemixAccordionStyle contentDecoration(DecorationMix value) {
    return content(BoxStyler(decoration: value));
  }

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
