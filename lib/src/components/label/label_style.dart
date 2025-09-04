part of 'label.dart';

class RemixLabelStyle extends Style<LabelSpec>
    with
        StyleModifierMixin<RemixLabelStyle, LabelSpec>,
        StyleVariantMixin<RemixLabelStyle, LabelSpec> {
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<FlexSpec>>? $flex;
  final Prop<IconPosition>? $iconPosition;

  const RemixLabelStyle.create({
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<FlexSpec>>? flex,
    Prop<IconPosition>? iconPosition,
    super.variants,
    super.animation,
    super.modifier,
  })  : $label = label,
        $icon = icon,
        $flex = flex,
        $iconPosition = iconPosition;

  RemixLabelStyle({
    TextStyler? label,
    IconStyler? icon,
    FlexStyler? flex,
    IconPosition? iconPosition,
    AnimationConfig? animation,
    List<VariantStyle<LabelSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          flex: Prop.maybeMix(flex),
          iconPosition: iconPosition != null ? Prop.value(iconPosition) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  RemixLabelStyle variant(Variant variant, RemixLabelStyle style) {
    return merge(RemixLabelStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixLabelStyle variants(List<VariantStyle<LabelSpec>> value) {
    return merge(RemixLabelStyle(variants: value));
  }

  @override
  RemixLabelStyle wrap(ModifierConfig value) {
    return merge(RemixLabelStyle(modifier: value));
  }

  @override
  StyleSpec<LabelSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: LabelSpec(
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
        flex: MixOps.resolve(context, $flex),
        iconPosition: MixOps.resolve(context, $iconPosition) ?? IconPosition.leading,
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixLabelStyle merge(RemixLabelStyle? other) {
    if (other == null) return this;

    return RemixLabelStyle.create(
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      flex: MixOps.merge($flex, other.$flex),
      iconPosition: MixOps.merge($iconPosition, other.$iconPosition),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $label,
        $icon,
        $flex,
        $iconPosition,
        $variants,
        $animation,
        $modifier,
      ];
}

/// Default label styles and variants
class RemixLabelStyles {
  /// Default label style
  static RemixLabelStyle get defaultStyle => RemixLabelStyle(
        flex: FlexStyler(spacing: 8),
      );

  /// Primary label variant
  static RemixLabelStyle get primary => RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: 20),
        flex: FlexStyler(spacing: 8),
      );

  /// Secondary label variant
  static RemixLabelStyle get secondary => RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textSecondary(),
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.textSecondary(), size: 20),
        flex: FlexStyler(spacing: 8),
      );

  /// Compact label variant with reduced spacing
  static RemixLabelStyle get compact => RemixLabelStyle(
        label: TextStyler(),
        icon: IconStyler(size: 16),
        flex: FlexStyler(spacing: 4),
      );

  /// Large label variant with increased spacing
  static RemixLabelStyle get large => RemixLabelStyle(
        label: TextStyler(style: TextStyleMix(fontSize: 16)),
        icon: IconStyler(size: 24),
        flex: FlexStyler(spacing: 12),
      );
}