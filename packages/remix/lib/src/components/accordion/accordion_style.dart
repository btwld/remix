part of 'accordion.dart';

/// Style configuration for [RemixAccordion] trigger, icons, title, and content.
@MixableStyler()
class RemixAccordionStyler
    extends RemixFlexContainerStyler<RemixAccordionSpec, RemixAccordionStyler>
    with Diagnosticable, _$RemixAccordionStylerMixin {
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

  const RemixAccordionStyler.create({
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

  RemixAccordionStyler({
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
  factory RemixAccordionStyler.backgroundColor(Color value) =>
      RemixAccordionStyler().backgroundColor(value);

  /// Creates a style with the given padding.
  factory RemixAccordionStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixAccordionStyler().padding(value);

  /// Creates a style with the given margin.
  factory RemixAccordionStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixAccordionStyler().margin(value);

  /// Creates a style with the given decoration.
  factory RemixAccordionStyler.decoration(DecorationMix value) =>
      RemixAccordionStyler().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixAccordionStyler.alignment(Alignment value) =>
      RemixAccordionStyler().alignment(value);

  /// Creates a style with the given constraints.
  factory RemixAccordionStyler.constraints(BoxConstraintsMix value) =>
      RemixAccordionStyler().constraints(value);

  /// Creates a style with the given border radius.
  factory RemixAccordionStyler.borderRadius(BorderRadiusGeometryMix value) =>
      RemixAccordionStyler().borderRadius(value);

  /// Creates a style with the given spacing.
  factory RemixAccordionStyler.spacing(double value) =>
      RemixAccordionStyler().spacing(value);

  /// Creates a style with the given title color.
  factory RemixAccordionStyler.titleColor(Color value) =>
      RemixAccordionStyler().titleColor(value);

  /// Creates a style with the given title font size.
  factory RemixAccordionStyler.titleFontSize(double value) =>
      RemixAccordionStyler().titleFontSize(value);

  /// Creates a style with the given title font weight.
  factory RemixAccordionStyler.titleFontWeight(FontWeight value) =>
      RemixAccordionStyler().titleFontWeight(value);

  /// Creates a style with the given title style.
  factory RemixAccordionStyler.titleStyle(TextStyleMix value) =>
      RemixAccordionStyler().titleStyle(value);

  /// Creates a style with the given leading icon color.
  factory RemixAccordionStyler.leadingIconColor(Color value) =>
      RemixAccordionStyler().leadingIconColor(value);

  /// Creates a style with the given leading icon size.
  factory RemixAccordionStyler.leadingIconSize(double value) =>
      RemixAccordionStyler().leadingIconSize(value);

  /// Creates a style with the given trailing icon color.
  factory RemixAccordionStyler.trailingIconColor(Color value) =>
      RemixAccordionStyler().trailingIconColor(value);

  /// Creates a style with the given trailing icon size.
  factory RemixAccordionStyler.trailingIconSize(double value) =>
      RemixAccordionStyler().trailingIconSize(value);

  /// Creates a style with the given content color.
  factory RemixAccordionStyler.contentColor(Color value) =>
      RemixAccordionStyler().contentColor(value);

  /// Creates a style with the given content padding.
  factory RemixAccordionStyler.contentPadding(EdgeInsetsGeometryMix value) =>
      RemixAccordionStyler().contentPadding(value);

  /// Creates a style with the given content decoration.
  factory RemixAccordionStyler.contentDecoration(DecorationMix value) =>
      RemixAccordionStyler().contentDecoration(value);

  // -- Convenience instance methods --

  /// Sets the background color of the trigger.
  RemixAccordionStyler backgroundColor(Color value) {
    return merge(
      RemixAccordionStyler(
        trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the spacing between items in the trigger.
  RemixAccordionStyler spacing(double value) {
    return merge(RemixAccordionStyler(trigger: FlexBoxStyler(spacing: value)));
  }

  /// Sets title color.
  RemixAccordionStyler titleColor(Color value) {
    return title(TextStyler(style: TextStyleMix(color: value)));
  }

  /// Sets title font size.
  RemixAccordionStyler titleFontSize(double value) {
    return title(TextStyler(style: TextStyleMix(fontSize: value)));
  }

  /// Sets title font weight.
  RemixAccordionStyler titleFontWeight(FontWeight value) {
    return title(TextStyler(style: TextStyleMix(fontWeight: value)));
  }

  /// Sets title style using TextStyleMix directly.
  RemixAccordionStyler titleStyle(TextStyleMix value) {
    return title(TextStyler(style: value));
  }

  /// Sets leading icon color.
  RemixAccordionStyler leadingIconColor(Color value) {
    return leadingIcon(IconStyler(color: value));
  }

  /// Sets leading icon size.
  RemixAccordionStyler leadingIconSize(double value) {
    return leadingIcon(IconStyler(size: value));
  }

  /// Sets trailing icon color.
  RemixAccordionStyler trailingIconColor(Color value) {
    return trailingIcon(IconStyler(color: value));
  }

  /// Sets trailing icon size.
  RemixAccordionStyler trailingIconSize(double value) {
    return trailingIcon(IconStyler(size: value));
  }

  /// Sets content background color.
  RemixAccordionStyler contentColor(Color value) {
    return content(BoxStyler(decoration: BoxDecorationMix(color: value)));
  }

  /// Sets content padding.
  RemixAccordionStyler contentPadding(EdgeInsetsGeometryMix value) {
    return content(BoxStyler(padding: value));
  }

  /// Sets content decoration.
  RemixAccordionStyler contentDecoration(DecorationMix value) {
    return content(BoxStyler(decoration: value));
  }

  /// Sets container alignment
  RemixAccordionStyler alignment(Alignment value) {
    return merge(
      RemixAccordionStyler(trigger: FlexBoxStyler(alignment: value)),
    );
  }

  /// Style when the accordion is expanded.
  RemixAccordionStyler onExpanded<T>(RemixAccordionStyler value) {
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
  RemixAccordionStyler onCollapsed<T>(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onCollapsed', (context) {
          return !NakedAccordionItemState.of<T>(context).isExpanded;
        }),
        value,
      ),
    ]);
  }

  /// Style when the accordion item can collapse.
  RemixAccordionStyler onCanCollapse(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanCollapse', (context) {
          return NakedAccordionItemState.of(context).canCollapse;
        }),
        value,
      ),
    ]);
  }

  /// Style when the accordion item can expand.
  RemixAccordionStyler onCanExpand<T>(RemixAccordionStyler value) {
    return variants([
      VariantStyle(
        ContextVariant('onCanExpand', (context) {
          return NakedAccordionItemState.of<T>(context).canExpand;
        }),
        value,
      ),
    ]);
  }

  /// Creates a [RemixAccordion] widget with this style applied.
  RemixAccordion<T> call<T>({
    Key? key,
    required T value,
    required Widget child,
    String? title,
    IconData? leadingIcon,
    IconData? trailingIcon,
    NakedAccordionTriggerBuilder<T>? builder,
    bool enabled = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    bool enableFeedback = true,
    bool autofocus = false,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    ValueChanged<bool>? onHoverChange,
    ValueChanged<bool>? onPressChange,
    String? semanticLabel,
    Widget Function(Widget, Animation<double>)? transitionBuilder,
  }) {
    return RemixAccordion(
      key: key,
      value: value,
      title: title,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel,
      transitionBuilder:
          transitionBuilder ?? RemixAccordion.defaultAccordionTransitionBuilder,
      style: this,
      child: child,
      builder: builder,
    );
  }

  // RemixFlexContainerStyler mixin implementations
  @override
  RemixAccordionStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyler(trigger: FlexBoxStyler(padding: value)));
  }

  @override
  RemixAccordionStyler color(Color value) {
    return merge(
      RemixAccordionStyler(
        trigger: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixAccordionStyler size(double width, double height) {
    return merge(
      RemixAccordionStyler(
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
  RemixAccordionStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixAccordionStyler(
        trigger: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixAccordionStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixAccordionStyler(trigger: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixAccordionStyler decoration(DecorationMix value) {
    return merge(
      RemixAccordionStyler(trigger: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixAccordionStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAccordionStyler(trigger: FlexBoxStyler(margin: value)));
  }

  @override
  RemixAccordionStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixAccordionStyler(trigger: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixAccordionStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixAccordionStyler(
        trigger: FlexBoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  RemixAccordionStyler flex(FlexStyler value) {
    return merge(RemixAccordionStyler(trigger: FlexBoxStyler().flex(value)));
  }
}
