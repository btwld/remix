part of 'label.dart';

class RemixLabelStyle extends Style<LabelSpec>
    with
        StyleModifierMixin<RemixLabelStyle, LabelSpec>,
        StyleVariantMixin<RemixLabelStyle, LabelSpec> {
  final Prop<double>? $spacing;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;

  const RemixLabelStyle.create({
    Prop<double>? spacing,
    Prop<TextSpec>? label,
    Prop<IconSpec>? leading,
    Prop<IconSpec>? trailing,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $spacing = spacing,
        $label = label,
        $leading = leading,
        $trailing = trailing;

  RemixLabelStyle({
    double? spacing,
    TextMix? label,
    IconMix? leading,
    IconMix? trailing,
    AnimationConfig? animation,
    List<VariantStyle<LabelSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          spacing: Prop.maybe(spacing),
          label: label != null ? Prop.mix(label) : null,
          leading: leading != null ? Prop.mix(leading) : null,
          trailing: trailing != null ? Prop.mix(trailing) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixLabelStyle.value(LabelSpec spec) => RemixLabelStyle(
        spacing: spec.spacing,
        label: TextMix.maybeValue(spec.label),
        leading: IconMix.maybeValue(spec.leading),
        trailing: IconMix.maybeValue(spec.trailing),
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
      spacing: MixOps.resolve(context, $spacing),
      label: MixOps.resolve(context, $label),
      leading: MixOps.resolve(context, $leading),
      trailing: MixOps.resolve(context, $trailing),
    );
  }

  @override
  RemixLabelStyle merge(RemixLabelStyle? other) {
    if (other == null) return this;

    return RemixLabelStyle.create(
      spacing: MixOps.merge($spacing, other.$spacing),
      label: MixOps.merge($label, other.$label),
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $spacing,
        $label,
        $leading,
        $trailing,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

/// Default label styles and variants
class RemixRemixLabelStyles {
  /// Default label style
  static RemixLabelStyle get defaultStyle => RemixLabelStyle(spacing: 8);

  /// Primary label variant
  static RemixLabelStyle get primary => RemixLabelStyle(
        spacing: 8,
        label: TextMix(
          style: TextStyleMix(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(color: Colors.blue, size: 20),
      );

  /// Secondary label variant
  static RemixLabelStyle get secondary => RemixLabelStyle(
        spacing: 8,
        label: TextMix(
          style: TextStyleMix(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconMix(color: Colors.grey, size: 20),
      );

  /// Compact label variant with reduced spacing
  static RemixLabelStyle get compact => RemixLabelStyle(
        spacing: 4,
        label: TextMix(),
        leading: IconMix(size: 16),
      );

  /// Large label variant with increased spacing
  static RemixLabelStyle get large => RemixLabelStyle(
        spacing: 12,
        label: TextMix(style: TextStyleMix(fontSize: 16)),
        leading: IconMix(size: 24),
      );
}
