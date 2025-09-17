part of 'checkbox.dart';



class RemixCheckboxStyle
    extends RemixFlexContainerStyle<CheckboxSpec, RemixCheckboxStyle>
    with
        LabelStyleMixin<RemixCheckboxStyle>,
        IconStyleMixin<RemixCheckboxStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $indicatorContainer;
  final Prop<StyleSpec<IconSpec>>? $indicator;
  final Prop<StyleSpec<TextSpec>>? $label;

  const RemixCheckboxStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? indicatorContainer,
    Prop<StyleSpec<IconSpec>>? indicator,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  RemixCheckboxStyle({
    FlexBoxStyler? container,
    BoxStyler? indicatorContainer,
    IconStyler? indicator,
    TextStyler? label,
    AnimationConfig? animation,
    List<VariantStyle<CheckboxSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          indicatorContainer: Prop.maybeMix(indicatorContainer),
          indicator: Prop.maybeMix(indicator),
          label: Prop.maybeMix(label),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods (chainable)

  /// Sets checkbox size
  RemixCheckboxStyle checkboxSize(double value) {
    return merge(RemixCheckboxStyle(
      indicatorContainer: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: value,
          maxWidth: value,
          minHeight: value,
          maxHeight: value,
        ),
      ),
    ));
  }

  /// Sets checkbox border radius
  RemixCheckboxStyle checkboxBorderRadius(double radius) {
    return merge(RemixCheckboxStyle(
      indicatorContainer: BoxStyler(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    ));
  }

  /// Sets checkbox border
  RemixCheckboxStyle border(BoxBorderMix value) {
    return merge(RemixCheckboxStyle(
      indicatorContainer: BoxStyler(
        decoration: BoxDecorationMix(border: value),
      ),
    ));
  }

  /// Sets indicator color
  RemixCheckboxStyle indicatorColor(Color value) {
    return merge(RemixCheckboxStyle(indicator: IconStyler(color: value)));
  }

  @override
  RemixCheckboxStyle icon(IconStyler value) {
    return merge(RemixCheckboxStyle(indicator: value));
  }

  @override
  RemixCheckboxStyle label(TextStyler value) {
    return merge(RemixCheckboxStyle(label: value));
  }

  /// Sets container padding
  RemixCheckboxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckboxStyle(
      container: FlexBoxStyler(padding: value),
    ));
  }

  /// Sets flex spacing
  RemixCheckboxStyle spacing(double value) {
    return merge(RemixCheckboxStyle(
      container: FlexBoxStyler(spacing: value),
    ));
  }

  /// Sets indicator container styling
  RemixCheckboxStyle indicatorContainer(BoxStyler value) {
    return merge(RemixCheckboxStyle(indicatorContainer: value));
  }

  /// Sets checkbox background color
  @override
  RemixCheckboxStyle color(Color value) {
    return merge(RemixCheckboxStyle(
      indicatorContainer: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets checkbox size with separate width and height
  @override
  RemixCheckboxStyle size(double width, double height) {
    return merge(RemixCheckboxStyle(
      indicatorContainer: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  /// Sets checkbox border radius with full geometry support
  @override
  RemixCheckboxStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCheckboxStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets animation
  @override
  RemixCheckboxStyle animate(AnimationConfig animation) {
    return merge(RemixCheckboxStyle(animation: animation));
  }

  @override
  RemixCheckboxStyle withVariants(List<VariantStyle<CheckboxSpec>> value) {
    return merge(RemixCheckboxStyle(variants: value));
  }

  // Modifier support
  @override
  RemixCheckboxStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCheckboxStyle(modifier: value));
  }

  // FlexStyleMixin implementation
  @override
  RemixCheckboxStyle flex(FlexStyler value) {
    return merge(RemixCheckboxStyle(container: FlexBoxStyler()));
  }

  // Abstract method implementations for mixins

  @override
  RemixCheckboxStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixCheckboxStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixCheckboxStyle decoration(DecorationMix value) {
    return merge(
      RemixCheckboxStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixCheckboxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckboxStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixCheckboxStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixCheckboxStyle(
      container: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixCheckboxStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixCheckboxStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  StyleSpec<CheckboxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CheckboxSpec(
        container: MixOps.resolve(context, $container),
        indicatorContainer: MixOps.resolve(context, $indicatorContainer),
        indicator: MixOps.resolve(context, $indicator),
        label: MixOps.resolve(context, $label),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCheckboxStyle merge(RemixCheckboxStyle? other) {
    if (other == null) return this;

    return RemixCheckboxStyle.create(
      container: MixOps.merge($container, other.$container),
      indicatorContainer:
          MixOps.merge($indicatorContainer, other.$indicatorContainer),
      indicator: MixOps.merge($indicator, other.$indicator),
      label: MixOps.merge($label, other.$label),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $indicatorContainer,
        $indicator,
        $label,
        $variants,
        $animation,
        $modifier,
      ];
}


