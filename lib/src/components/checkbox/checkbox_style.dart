part of 'checkbox.dart';

// Private per-component constants (sizes only)
const _kSpaceSm = 8.0;
const _kFontSizeMd = 14.0;
const _kIconSizeMd = 16.0;

class RemixCheckboxStyle extends Style<CheckboxSpec>
    with
        StyleModifierMixin<RemixCheckboxStyle, CheckboxSpec>,
        StyleVariantMixin<RemixCheckboxStyle, CheckboxSpec>,
        ModifierStyleMixin<RemixCheckboxStyle, CheckboxSpec>,
        BorderStyleMixin<RemixCheckboxStyle>,
        BorderRadiusStyleMixin<RemixCheckboxStyle>,
        ShadowStyleMixin<RemixCheckboxStyle>,
        DecorationStyleMixin<RemixCheckboxStyle>,
        SpacingStyleMixin<RemixCheckboxStyle>,
        TransformStyleMixin<RemixCheckboxStyle>,
        ConstraintStyleMixin<RemixCheckboxStyle>,
        AnimationStyleMixin<CheckboxSpec, RemixCheckboxStyle> {
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

  /// Sets checkbox background color
  RemixCheckboxStyle color(Color value) {
    return merge(RemixCheckboxStyle(
      indicatorContainer: BoxStyler(decoration: BoxDecorationMix(color: value)),
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

  /// Sets label color
  RemixCheckboxStyle labelColor(Color value) {
    return merge(RemixCheckboxStyle(
      label: TextStyler(style: TextStyleMix(color: value)),
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
  RemixCheckboxStyle variants(List<VariantStyle<CheckboxSpec>> value) {
    return merge(RemixCheckboxStyle(variants: value));
  }

  // Modifier support
  @override
  RemixCheckboxStyle wrap(ModifierConfig value) {
    return merge(RemixCheckboxStyle(modifier: value));
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

final DefaultRemixCheckboxStyle = RemixCheckboxStyle(
  container: FlexBoxStyler(
    alignment: Alignment.centerLeft,
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: _kSpaceSm,
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
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.primary(), width: 1.5),
      ),
      borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
      color: Colors.transparent,
    ),
  ),
  indicator: IconStyler(color: RemixTokens.primary(), size: _kIconSizeMd),
  label: TextStyler(
    style: TextStyleMix(color: RemixTokens.primary(), fontSize: _kFontSizeMd),
  ),
);

extension CheckboxVariants on RemixCheckboxStyle {
  /// Solid checkbox - filled black box with white check
  static RemixCheckboxStyle get solid => RemixCheckboxStyle(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: _kSpaceSm,
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
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 1.5),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.primary(),
          ),
        ),
        indicator:
            IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeMd),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
          ),
        ),
      );

  /// Outline checkbox - white box with black border and black check
  static RemixCheckboxStyle get outline => RemixCheckboxStyle(
        container: FlexBoxStyler(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: _kSpaceSm,
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
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 1.5),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: Colors.transparent,
          ),
        ),
        indicator: IconStyler(color: RemixTokens.primary(), size: _kIconSizeMd),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
          ),
        ),
      );
}
