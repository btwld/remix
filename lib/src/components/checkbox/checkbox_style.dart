part of 'checkbox.dart';

class RemixCheckBoxStyler extends Style<CheckboxSpec>
    with
        StyleModifierMixin<RemixCheckBoxStyler, CheckboxSpec>,
        StyleVariantMixin<RemixCheckBoxStyler, CheckboxSpec>,
        ModifierStyleMixin<RemixCheckBoxStyler, CheckboxSpec>,
        BorderStyleMixin<RemixCheckBoxStyler>,
        BorderRadiusStyleMixin<RemixCheckBoxStyler>,
        ShadowStyleMixin<RemixCheckBoxStyler>,
        DecorationStyleMixin<RemixCheckBoxStyler>,
        SpacingStyleMixin<RemixCheckBoxStyler>,
        TransformStyleMixin<RemixCheckBoxStyler>,
        ConstraintStyleMixin<RemixCheckBoxStyler>,
        AnimationStyleMixin<CheckboxSpec, RemixCheckBoxStyler> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $indicatorContainer;
  final Prop<StyleSpec<IconSpec>>? $indicator;
  final Prop<StyleSpec<TextSpec>>? $label;

  const RemixCheckBoxStyler.create({
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

  RemixCheckBoxStyler({
    FlexBoxStyler? container,
    BoxStyler? indicatorContainer,
    IconStyler? indicator,
    TextStyler? label,
    AnimationConfig? animation,
    List<VariantStyle<CheckboxSpec>>? variants,
    ModifierConfig? modifier,
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
  RemixCheckBoxStyler checkboxSize(double value) {
    return merge(RemixCheckBoxStyler(
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
  
  /// Sets checkbox size with separate width and height
  @override
  RemixCheckBoxStyler size(double width, double height) {
    return merge(RemixCheckBoxStyler(
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

  /// Sets checkbox background color
  RemixCheckBoxStyler color(Color value) {
    return merge(RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets checkbox border radius
  RemixCheckBoxStyler checkboxBorderRadius(double radius) {
    return merge(RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    ));
  }
  
  /// Sets checkbox border radius with full geometry support
  @override
  RemixCheckBoxStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCheckBoxStyler(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(
          borderRadius: radius,
        ),
      ),
    ));
  }

  /// Sets checkbox border
  RemixCheckBoxStyler border(BoxBorderMix value) {
    return merge(RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(
        decoration: BoxDecorationMix(border: value),
      ),
    ));
  }

  /// Sets indicator color
  RemixCheckBoxStyler indicatorColor(Color value) {
    return merge(RemixCheckBoxStyler(indicator: IconStyler(color: value)));
  }

  /// Sets container padding
  RemixCheckBoxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckBoxStyler(
      container: FlexBoxStyler(padding: value),
    ));
  }

  /// Sets flex spacing
  RemixCheckBoxStyler spacing(double value) {
    return merge(RemixCheckBoxStyler(
      container: FlexBoxStyler(spacing: value),
    ));
  }

  /// Sets indicator container styling
  RemixCheckBoxStyler indicatorContainer(BoxStyler value) {
    return merge(RemixCheckBoxStyler(indicatorContainer: value));
  }

  /// Sets label color
  RemixCheckBoxStyler labelColor(Color value) {
    return merge(RemixCheckBoxStyler(
      label: TextStyler(style: TextStyleMix(color: value)),
    ));
  }

  /// Sets animation
  @override
  RemixCheckBoxStyler animate(AnimationConfig animation) {
    return merge(RemixCheckBoxStyler(animation: animation));
  }


  @override
  RemixCheckBoxStyler variants(List<VariantStyle<CheckboxSpec>> value) {
    return merge(RemixCheckBoxStyler(variants: value));
  }

  // Modifier support
  @override
  RemixCheckBoxStyler wrap(ModifierConfig value) {
    return merge(RemixCheckBoxStyler(modifier: value));
  }

  // Abstract method implementations for mixins
  
  @override
  RemixCheckBoxStyler constraints(BoxConstraintsMix value) {
    return merge(RemixCheckBoxStyler(container: FlexBoxStyler(constraints: value)));
  }
  
  @override
  RemixCheckBoxStyler decoration(DecorationMix value) {
    return merge(RemixCheckBoxStyler(container: FlexBoxStyler(decoration: value)));
  }
  
  @override
  RemixCheckBoxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckBoxStyler(container: FlexBoxStyler(margin: value)));
  }
  
  @override
  RemixCheckBoxStyler foregroundDecoration(DecorationMix value) {
    return merge(RemixCheckBoxStyler(container: FlexBoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixCheckBoxStyler transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixCheckBoxStyler(container: FlexBoxStyler(transform: value, alignment: alignment)));
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
  RemixCheckBoxStyler merge(RemixCheckBoxStyler? other) {
    if (other == null) return this;

    return RemixCheckBoxStyler.create(
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

final DefaultRemixCheckBoxStyler = RemixCheckBoxStyler(
  container: FlexBoxStyler(
    alignment: Alignment.centerLeft,
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: 8.0,
  ),
  indicatorContainer: BoxStyler(
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1.5,
      )),
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
      color: RemixTokens.background(),
    ),
  ),
  indicator: IconStyler(color: RemixTokens.textPrimary(), size: 16.0),
  label: TextStyler(
    style: TextStyleMix(color: RemixTokens.textPrimary(), fontSize: 14.0),
  ),
);

extension CheckboxVariants on RemixCheckBoxStyler {
  /// Primary checkbox variant with blue colors
  static RemixCheckBoxStyler get primary => RemixCheckBoxStyler(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
        ),
        indicatorContainer: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.primary(),
              width: 1.5,
            )),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
        ),
        indicator: IconStyler(color: RemixTokens.primary(), size: 16.0),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14.0,
          ),
        ),
      );

  /// Secondary checkbox variant with grey colors
  static RemixCheckBoxStyler get secondary => RemixCheckBoxStyler(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
        ),
        indicatorContainer: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 1.5,
            )),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.surface(),
          ),
        ),
        indicator: IconStyler(color: RemixTokens.textSecondary(), size: 16.0),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14.0,
          ),
        ),
      );

  /// Compact checkbox variant with smaller size
  static RemixCheckBoxStyler get compact => RemixCheckBoxStyler(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
        ),
        indicatorContainer: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1.5,
            )),
            borderRadius: BorderRadiusMix.circular(3),
            color: RemixTokens.background(),
          ),
        ),
        indicator: IconStyler(color: RemixTokens.textPrimary(), size: 14.0),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 12.0,
          ),
        ),
      );
}
