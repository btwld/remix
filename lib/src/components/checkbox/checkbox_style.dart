part of 'checkbox.dart';

class RemixCheckBoxStyler extends Style<CheckboxSpec>
    with
        StyleModifierMixin<RemixCheckBoxStyler, CheckboxSpec>,
        StyleVariantMixin<RemixCheckBoxStyler, CheckboxSpec> {
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

  /// Factory for checkbox size (indicator container size)
  factory RemixCheckBoxStyler.size(double value) {
    return RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: value,
          maxWidth: value,
          minHeight: value,
          maxHeight: value,
        ),
      ),
    );
  }

  /// Factory for checkbox background color
  factory RemixCheckBoxStyler.color(Color value) {
    return RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for checkbox border radius
  factory RemixCheckBoxStyler.borderRadius(double radius) {
    return RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for checkbox border
  factory RemixCheckBoxStyler.border(BoxBorderMix value) {
    return RemixCheckBoxStyler(
      indicatorContainer: BoxStyler(
        decoration: BoxDecorationMix(border: value),
      ),
    );
  }

  /// Factory for indicator color
  factory RemixCheckBoxStyler.indicatorColor(Color value) {
    return RemixCheckBoxStyler(indicator: IconStyler(color: value));
  }

  /// Factory for label color
  factory RemixCheckBoxStyler.labelColor(Color value) {
    return RemixCheckBoxStyler(
      label: TextStyler(style: TextStyleMix(color: value)),
    );
  }

  // Instance methods (chainable)

  /// Sets checkbox size
  RemixCheckBoxStyler size(double value) {
    return merge(RemixCheckBoxStyler.size(value));
  }

  /// Sets checkbox background color
  RemixCheckBoxStyler color(Color value) {
    return merge(RemixCheckBoxStyler.color(value));
  }

  /// Sets checkbox border radius
  RemixCheckBoxStyler borderRadius(double radius) {
    return merge(RemixCheckBoxStyler.borderRadius(radius));
  }

  /// Sets checkbox border
  RemixCheckBoxStyler border(BoxBorderMix value) {
    return merge(RemixCheckBoxStyler.border(value));
  }

  /// Sets indicator color
  RemixCheckBoxStyler indicatorColor(Color value) {
    return merge(RemixCheckBoxStyler.indicatorColor(value));
  }

  /// Sets label color
  RemixCheckBoxStyler labelColor(Color value) {
    return merge(RemixCheckBoxStyler.labelColor(value));
  }

  /// Sets animation
  RemixCheckBoxStyler animate(AnimationConfig animation) {
    return merge(RemixCheckBoxStyler(animation: animation));
  }

  /// Sets variant
  @override
  RemixCheckBoxStyler variant(Variant variant, RemixCheckBoxStyler style) {
    return merge(RemixCheckBoxStyler(variants: [VariantStyle(variant, style)]));
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
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
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
