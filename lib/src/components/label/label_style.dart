part of 'label.dart';

class RemixLabelStyle extends Style<LabelSpec>
    with
        StyleModifierMixin<RemixLabelStyle, LabelSpec>,
        StyleVariantMixin<RemixLabelStyle, LabelSpec> {
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $leading;
  final Prop<StyleSpec<IconSpec>>? $trailing;
  final Prop<StyleSpec<FlexSpec>>? $flex;

  const RemixLabelStyle.create({
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? leading,
    Prop<StyleSpec<IconSpec>>? trailing,
    Prop<StyleSpec<FlexSpec>>? flex,
    super.variants,
    super.animation,
    super.modifier,
  })  : $label = label,
        $leading = leading,
        $trailing = trailing,
        $flex = flex;

  RemixLabelStyle({
    TextStyler? label,
    IconStyler? leading,
    IconStyler? trailing,
    FlexStyler? flex,
    AnimationConfig? animation,
    List<VariantStyle<LabelSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          label: Prop.maybeMix(label),
          leading: Prop.maybeMix(leading),
          trailing: Prop.maybeMix(trailing),
          flex: Prop.maybeMix(flex),
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
        leading: MixOps.resolve(context, $leading),
        trailing: MixOps.resolve(context, $trailing),
        flex: MixOps.resolve(context, $flex),
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
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      flex: MixOps.merge($flex, other.$flex),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [
        $label,
        $leading,
        $trailing,
        $flex,
        $variants,
        $animation,
        $modifier,
      ];
}

/// Default label styles and variants
class RemixRemixLabelStyles {
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
        leading: IconStyler(color: RemixTokens.primary(), size: 20),
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
        leading: IconStyler(color: RemixTokens.textSecondary(), size: 20),
        flex: FlexStyler(spacing: 8),
      );

  /// Compact label variant with reduced spacing
  static RemixLabelStyle get compact => RemixLabelStyle(
        label: TextStyler(),
        leading: IconStyler(size: 16),
        flex: FlexStyler(spacing: 4),
      );

  /// Large label variant with increased spacing
  static RemixLabelStyle get large => RemixLabelStyle(
        label: TextStyler(style: TextStyleMix(fontSize: 16)),
        leading: IconStyler(size: 24),
        flex: FlexStyler(spacing: 12),
      );
}
