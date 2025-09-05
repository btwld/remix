part of 'radio.dart';

class RemixRadioStyle extends Style<RadioSpec>
    with
        StyleModifierMixin<RemixRadioStyle, RadioSpec>,
        StyleVariantMixin<RemixRadioStyle, RadioSpec>,
        ModifierStyleMixin<RemixRadioStyle, RadioSpec>,
        BorderStyleMixin<RemixRadioStyle>,
        BorderRadiusStyleMixin<RemixRadioStyle>,
        ShadowStyleMixin<RemixRadioStyle>,
        DecorationStyleMixin<RemixRadioStyle>,
        SpacingStyleMixin<RemixRadioStyle>,
        TransformStyleMixin<RemixRadioStyle>,
        ConstraintStyleMixin<RemixRadioStyle>,
        AnimationStyleMixin<RadioSpec, RemixRadioStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $indicatorContainer;
  final Prop<StyleSpec<BoxSpec>>? $indicator;
  final Prop<StyleSpec<TextSpec>>? $label;

  const RemixRadioStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? indicatorContainer,
    Prop<StyleSpec<BoxSpec>>? indicator,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  RemixRadioStyle({
    FlexBoxStyler? container,
    BoxStyler? indicatorContainer,
    BoxStyler? indicator,
    TextStyler? label,
    AnimationConfig? animation,
    List<VariantStyle<RadioSpec>>? variants,
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

  /// Sets container padding
  RemixRadioStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixRadioStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixRadioStyle color(Color value) {
    return merge(RemixRadioStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixRadioStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixRadioStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container decoration
  RemixRadioStyle decoration(DecorationMix value) {
    return merge(RemixRadioStyle(
      container: FlexBoxStyler(decoration: value),
    ));
  }

  /// Sets flex spacing
  RemixRadioStyle spacing(double value) {
    return merge(RemixRadioStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets indicator container styling
  RemixRadioStyle indicatorContainer(BoxStyler value) {
    return merge(RemixRadioStyle(indicatorContainer: value));
  }

  /// Sets indicator styling
  RemixRadioStyle indicator(BoxStyler value) {
    return merge(RemixRadioStyle(indicator: value));
  }

  @override
  RemixRadioStyle variants(List<VariantStyle<RadioSpec>> value) {
    return merge(RemixRadioStyle(variants: value));
  }

  @override
  RemixRadioStyle wrap(ModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  // Abstract method implementations for mixins
  
  @override
  RemixRadioStyle animate(AnimationConfig config) {
    return merge(RemixRadioStyle(animation: config));
  }
  
  @override
  RemixRadioStyle constraints(BoxConstraintsMix value) {
    return merge(RemixRadioStyle(container: FlexBoxStyler(constraints: value)));
  }
  
  @override
  RemixRadioStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixRadioStyle(container: FlexBoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixRadioStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixRadioStyle(container: FlexBoxStyler(transform: value, alignment: alignment)));
  }

  @override
  StyleSpec<RadioSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RadioSpec(
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
  RemixRadioStyle merge(RemixRadioStyle? other) {
    if (other == null) return this;

    return RemixRadioStyle.create(
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

final DefaultRemixRadioStyle = RemixRadioStyle(
  container: FlexBoxStyler(
    alignment: Alignment.centerLeft,
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: RemixTokens.spaceSm(),
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
      shape: BoxShape.circle,
      color: RemixTokens.background(),
    ),
  ),
  indicator: BoxStyler(
    constraints: BoxConstraintsMix(
      minWidth: 10,
      maxWidth: 10,
      minHeight: 10,
      maxHeight: 10,
    ),
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: RemixTokens.textPrimary(),
    ),
  ),
  label: TextStyler(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: RemixTokens.fontSizeMd(),
    ),
  ),
);

extension RadioVariants on RemixRadioStyle {
  /// Primary radio variant with blue colors
  static RemixRadioStyle get primary => RemixRadioStyle(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceSm(),
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
            shape: BoxShape.circle,
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
        ),
        indicator: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 10,
            maxWidth: 10,
            minHeight: 10,
            maxHeight: 10,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
      );

  /// Secondary radio variant with grey colors
  static RemixRadioStyle get secondary => RemixRadioStyle(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceSm(),
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
            shape: BoxShape.circle,
            color: RemixTokens.surface(),
          ),
        ),
        indicator: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 10,
            maxWidth: 10,
            minHeight: 10,
            maxHeight: 10,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.textSecondary(),
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
      );

  /// Compact radio variant with smaller size
  static RemixRadioStyle get compact => RemixRadioStyle(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
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
            shape: BoxShape.circle,
            color: RemixTokens.background(),
          ),
        ),
        indicator: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 8,
            maxWidth: 8,
            minHeight: 8,
            maxHeight: 8,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.textPrimary(),
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
      );
}
