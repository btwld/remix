part of 'checkbox.dart';

class RemixCheckboxStyle extends Style<CheckboxSpec>
    with
        StyleModifierMixin<RemixCheckboxStyle, CheckboxSpec>,
        StyleVariantMixin<RemixCheckboxStyle, CheckboxSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<FlexSpec>? $flex;
  final Prop<BoxSpec>? $indicatorContainer;
  final Prop<IconSpec>? $indicator;
  final Prop<TextSpec>? $label;

  const RemixCheckboxStyle.create({
    Prop<BoxSpec>? container,
    Prop<FlexSpec>? flex,
    Prop<BoxSpec>? indicatorContainer,
    Prop<IconSpec>? indicator,
    Prop<TextSpec>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator,
        $label = label;

  RemixCheckboxStyle({
    BoxMix? container,
    FlexMix? flex,
    BoxMix? indicatorContainer,
    IconMix? indicator,
    TextMix? label,
    AnimationConfig? animation,
    List<VariantStyle<CheckboxSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          flex: Prop.maybeMix(flex),
          indicatorContainer: Prop.maybeMix(indicatorContainer),
          indicator: Prop.maybeMix(indicator),
          label: Prop.maybeMix(label),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixCheckboxStyle.value(CheckboxSpec spec) => RemixCheckboxStyle(
        container: BoxMix.maybeValue(spec.container),
        flex: FlexMix.maybeValue(spec.flex),
        indicatorContainer: BoxMix.maybeValue(spec.indicatorContainer),
        indicator: IconMix.maybeValue(spec.indicator),
        label: TextMix.maybeValue(spec.label),
      );

  /// Factory for checkbox size (indicator container size)
  factory RemixCheckboxStyle.size(double value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxMix(
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
      indicatorContainer: BoxMix(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for checkbox border radius
  factory RemixCheckboxStyle.borderRadius(double radius) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for checkbox border
  factory RemixCheckboxStyle.border(BoxBorderMix value) {
    return RemixCheckboxStyle(
      indicatorContainer: BoxMix(
        decoration: BoxDecorationMix(border: value),
      ),
    );
  }

  /// Factory for indicator color
  factory RemixCheckboxStyle.indicatorColor(Color value) {
    return RemixCheckboxStyle(indicator: IconMix(color: value));
  }

  /// Factory for label color
  factory RemixCheckboxStyle.labelColor(Color value) {
    return RemixCheckboxStyle(
      label: TextMix(style: TextStyleMix(color: value)),
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
        flex: MixOps.resolve(context, $flex),
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
      flex: MixOps.merge($flex, other.$flex),
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
        $flex,
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
  container: BoxMix(alignment: Alignment.centerLeft),
  flex: FlexMix(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: RemixTokens.spaceSm(),
  ),
  indicatorContainer: BoxMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1.5,
      )),
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
      color: RemixTokens.background(),
    ),
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 20,
      maxWidth: 20,
      minHeight: 20,
      maxHeight: 20,
    ),
  ),
  indicator: IconMix(
    color: RemixTokens.textPrimary(),
    size: RemixTokens.iconSizeMd(),
  ),
  label: TextMix(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: RemixTokens.fontSizeMd(),
    ),
  ),
);

extension CheckboxVariants on RemixCheckboxStyle {
  /// Primary checkbox variant with blue colors
  static RemixCheckboxStyle get primary => RemixCheckboxStyle(
        container: BoxMix(alignment: Alignment.centerLeft),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceSm(),
        ),
        indicatorContainer: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.primary(),
              width: 1.5,
            )),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        indicator: IconMix(
          color: RemixTokens.primary(),
          size: RemixTokens.iconSizeMd(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
      );

  /// Secondary checkbox variant with grey colors
  static RemixCheckboxStyle get secondary => RemixCheckboxStyle(
        container: BoxMix(alignment: Alignment.centerLeft),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceSm(),
        ),
        indicatorContainer: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 1.5,
            )),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.surface(),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 20,
            maxWidth: 20,
            minHeight: 20,
            maxHeight: 20,
          ),
        ),
        indicator: IconMix(
          color: RemixTokens.textSecondary(),
          size: RemixTokens.iconSizeMd(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
          ),
        ),
      );

  /// Compact checkbox variant with smaller size
  static RemixCheckboxStyle get compact => RemixCheckboxStyle(
        container: BoxMix(alignment: Alignment.centerLeft),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        indicatorContainer: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1.5,
            )),
            borderRadius: BorderRadiusMix.circular(3),
            color: RemixTokens.background(),
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 16,
            maxWidth: 16,
            minHeight: 16,
            maxHeight: 16,
          ),
        ),
        indicator: IconMix(
          color: RemixTokens.textPrimary(),
          size: RemixTokens.iconSizeSm(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
      );
}
