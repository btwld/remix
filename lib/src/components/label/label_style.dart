part of 'label.dart';

class RemixLabelStyle extends Style<LabelSpec>
    with
        StyleModifierMixin<RemixLabelStyle, LabelSpec>,
        StyleVariantMixin<RemixLabelStyle, LabelSpec> {
  final Prop<TypographySpec>? $label;
  final Prop<IconographySpec>? $leading;
  final Prop<IconographySpec>? $trailing;
  final Prop<FlexLayoutSpec>? $flex;

  const RemixLabelStyle.create({
    Prop<TypographySpec>? label,
    Prop<IconographySpec>? leading,
    Prop<IconographySpec>? trailing,
    Prop<FlexLayoutSpec>? flex,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $label = label,
        $leading = leading,
        $trailing = trailing,
        $flex = flex;

  RemixLabelStyle({
    TypographyMix? label,
    IconographyMix? leading,
    IconographyMix? trailing,
    FlexLayoutMix? flex,
    AnimationConfig? animation,
    List<VariantStyle<LabelSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          label: label != null ? Prop.mix(label) : null,
          leading: leading != null ? Prop.mix(leading) : null,
          trailing: trailing != null ? Prop.mix(trailing) : null,
          flex: flex != null ? Prop.mix(flex) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixLabelStyle.value(LabelSpec spec) => RemixLabelStyle(
        label: TypographyMix.maybeValue(spec.label),
        leading: IconographyMix.maybeValue(spec.leading),
        trailing: IconographyMix.maybeValue(spec.trailing),
        flex: FlexLayoutMix.maybeValue(spec.flex),
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
  LabelSpec resolve(BuildContext context) {
    return LabelSpec(
      label: MixOps.resolve(context, $label),
      leading: MixOps.resolve(context, $leading),
      trailing: MixOps.resolve(context, $trailing),
      flex: MixOps.resolve(context, $flex),
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
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

/// Default label styles and variants
class RemixRemixLabelStyles {
  /// Default label style
  static RemixLabelStyle get defaultStyle => RemixLabelStyle(
        flex: FlexLayoutMix(spacing: 8),
      );

  /// Primary label variant
  static RemixLabelStyle get primary => RemixLabelStyle(
        label: TypographyMix(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconographyMix(color: RemixTokens.primary(), size: 20),
        flex: FlexLayoutMix(spacing: 8),
      );

  /// Secondary label variant
  static RemixLabelStyle get secondary => RemixLabelStyle(
        label: TypographyMix(
          style: TextStyleMix(
            color: RemixTokens.textSecondary(),
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconographyMix(color: RemixTokens.textSecondary(), size: 20),
        flex: FlexLayoutMix(spacing: 8),
      );

  /// Compact label variant with reduced spacing
  static RemixLabelStyle get compact => RemixLabelStyle(
        label: TypographyMix(),
        leading: IconographyMix(size: 16),
        flex: FlexLayoutMix(spacing: 4),
      );

  /// Large label variant with increased spacing
  static RemixLabelStyle get large => RemixLabelStyle(
        label: TypographyMix(style: TextStyleMix(fontSize: 16)),
        leading: IconographyMix(size: 24),
        flex: FlexLayoutMix(spacing: 12),
      );
}
