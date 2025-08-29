part of 'label.dart';

class RemixLabelStyle extends Style<LabelSpec>
    with
        StyleModifierMixin<RemixLabelStyle, LabelSpec>,
        StyleVariantMixin<RemixLabelStyle, LabelSpec> {
  final Prop<WidgetSpec<TextSpec>>? $label;
  final Prop<WidgetSpec<IconSpec>>? $leading;
  final Prop<WidgetSpec<IconSpec>>? $trailing;
  final Prop<WidgetSpec<FlexSpec>>? $flex;

  const RemixLabelStyle.create({
    Prop<WidgetSpec<TextSpec>>? label,
    Prop<WidgetSpec<IconSpec>>? leading,
    Prop<WidgetSpec<IconSpec>>? trailing,
    Prop<WidgetSpec<FlexSpec>>? flex,
    super.variants,
    super.animation,
    super.modifier,
  })  : $label = label,
        $leading = leading,
        $trailing = trailing,
        $flex = flex;

  RemixLabelStyle({
    TextStyling? label,
    IconStyle? leading,
    IconStyle? trailing,
    FlexStyle? flex,
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
  WidgetSpec<LabelSpec> resolve(BuildContext context) {
    return WidgetSpec(
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
        flex: FlexStyle(spacing: 8),
      );

  /// Primary label variant
  static RemixLabelStyle get primary => RemixLabelStyle(
        label: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconStyle(color: RemixTokens.primary(), size: 20),
        flex: FlexStyle(spacing: 8),
      );

  /// Secondary label variant
  static RemixLabelStyle get secondary => RemixLabelStyle(
        label: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textSecondary(),
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconStyle(color: RemixTokens.textSecondary(), size: 20),
        flex: FlexStyle(spacing: 8),
      );

  /// Compact label variant with reduced spacing
  static RemixLabelStyle get compact => RemixLabelStyle(
        label: TextStyling(),
        leading: IconStyle(size: 16),
        flex: FlexStyle(spacing: 4),
      );

  /// Large label variant with increased spacing
  static RemixLabelStyle get large => RemixLabelStyle(
        label: TextStyling(style: TextStyleMix(fontSize: 16)),
        leading: IconStyle(size: 24),
        flex: FlexStyle(spacing: 12),
      );
}
