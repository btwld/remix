part of 'checkbox.dart';

class RemixCheckboxStyle extends Style<CheckboxSpec>
    with
        StyleModifierMixin<RemixCheckboxStyle, CheckboxSpec>,
        StyleVariantMixin<RemixCheckboxStyle, CheckboxSpec> {
  final Prop<WidgetSpec<FlexBoxSpec>>? $container;
  final Prop<WidgetSpec<BoxSpec>>? $indicatorContainer;
  final Prop<WidgetSpec<IconSpec>>? $indicator;
  final Prop<WidgetSpec<TextSpec>>? $label;

  const RemixCheckboxStyle.create({
    Prop<WidgetSpec<FlexBoxSpec>>? container,
    Prop<WidgetSpec<BoxSpec>>? indicatorContainer,
    Prop<WidgetSpec<IconSpec>>? indicator,
    Prop<WidgetSpec<TextSpec>>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  RemixCheckboxStyle({
    FlexBoxStyle? container,
    BoxStyle? indicatorContainer,
    IconStyle? indicator,
    TextStyling? label,
    AnimationConfig? animation,
    List<VariantStyle<CheckboxSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          indicatorContainer: Prop.maybeMix(indicatorContainer),
          indicator: Prop.maybeMix(indicator),
          label: Prop.maybeMix(label),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  /// Factory for checkbox size (indicator container size)
  factory RemixCheckboxStyle.size(double value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxStyle(
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
  factory RemixCheckboxStyle.color(Color value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxStyle(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for checkbox border radius
  factory RemixCheckboxStyle.borderRadius(double radius) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxStyle(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for checkbox border
  factory RemixCheckboxStyle.border(BoxBorderMix value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxStyle(
        decoration: BoxDecorationMix(border: value),
      ),
    );
  }

  /// Factory for indicator color
  factory RemixCheckboxStyle.indicatorColor(Color value) {
    return RemixCheckboxStyle(indicator: IconStyle(color: value));
  }

  /// Factory for label color
  factory RemixCheckboxStyle.labelColor(Color value) {
    return RemixCheckboxStyle(
      label: TextStyling(style: TextStyleMix(color: value)),
    );
  }

  // Instance methods (chainable)

  /// Sets checkbox size
  RemixCheckboxStyle size(double value) {
    return merge(RemixCheckboxStyle.size(value));
  }

  /// Sets checkbox background color
  RemixCheckboxStyle color(Color value) {
    return merge(RemixCheckboxStyle.color(value));
  }

  /// Sets checkbox border radius
  RemixCheckboxStyle borderRadius(double radius) {
    return merge(RemixCheckboxStyle.borderRadius(radius));
  }

  /// Sets checkbox border
  RemixCheckboxStyle border(BoxBorderMix value) {
    return merge(RemixCheckboxStyle.border(value));
  }

  /// Sets indicator color
  RemixCheckboxStyle indicatorColor(Color value) {
    return merge(RemixCheckboxStyle.indicatorColor(value));
  }

  /// Sets label color
  RemixCheckboxStyle labelColor(Color value) {
    return merge(RemixCheckboxStyle.labelColor(value));
  }

  /// Sets animation
  RemixCheckboxStyle animate(AnimationConfig animation) {
    return merge(RemixCheckboxStyle(animation: animation));
  }

  /// Sets variant
  @override
  RemixCheckboxStyle variant(Variant variant, RemixCheckboxStyle style) {
    return merge(RemixCheckboxStyle(variants: [VariantStyle(variant, style)]));
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

  @override
  WidgetSpec<CheckboxSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: CheckboxSpec(
        container: MixOps.resolve(context, $container),
        indicatorContainer: MixOps.resolve(context, $indicatorContainer),
        indicator: MixOps.resolve(context, $indicator),
        label: MixOps.resolve(context, $label),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

final DefaultRemixCheckboxStyle = RemixCheckboxStyle(
  container: FlexBoxStyle(
    alignment: Alignment.centerLeft,
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: 8.0,
  ),
  indicatorContainer: BoxStyle(
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
  indicator: IconStyle(color: RemixTokens.textPrimary(), size: 16.0),
  label: TextStyling(
    style: TextStyleMix(color: RemixTokens.textPrimary(), fontSize: 14.0),
  ),
);

extension CheckboxVariants on RemixCheckboxStyle {
  /// Primary checkbox variant with blue colors
  static RemixCheckboxStyle get primary => RemixCheckboxStyle(
        container: FlexBoxStyle(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
        ),
        indicatorContainer: BoxStyle(
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
        indicator: IconStyle(color: RemixTokens.primary(), size: 16.0),
        label: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14.0,
          ),
        ),
      );

  /// Secondary checkbox variant with grey colors
  static RemixCheckboxStyle get secondary => RemixCheckboxStyle(
        container: FlexBoxStyle(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8.0,
        ),
        indicatorContainer: BoxStyle(
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
        indicator: IconStyle(color: RemixTokens.textSecondary(), size: 16.0),
        label: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14.0,
          ),
        ),
      );

  /// Compact checkbox variant with smaller size
  static RemixCheckboxStyle get compact => RemixCheckboxStyle(
        container: FlexBoxStyle(
          alignment: Alignment.centerLeft,
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 4.0,
        ),
        indicatorContainer: BoxStyle(
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
        indicator: IconStyle(color: RemixTokens.textPrimary(), size: 14.0),
        label: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 12.0,
          ),
        ),
      );
}
