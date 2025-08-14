part of 'label.dart';

class LabelStyle extends Style<LabelSpec>
    with StyleModifierMixin<LabelStyle, LabelSpec>, StyleVariantMixin<LabelStyle, LabelSpec> {
  final Prop<double>? $spacing;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $icon;
  final Prop<IconPosition>? $iconPosition;

  const LabelStyle.create({
    Prop<double>? spacing,
    Prop<TextSpec>? label,
    Prop<IconSpec>? icon,
    Prop<IconPosition>? iconPosition,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $spacing = spacing,
        $label = label,
        $icon = icon,
        $iconPosition = iconPosition;

  LabelStyle({
    double? spacing,
    TextMix? label,
    IconMix? icon,
    IconPosition? iconPosition,
    AnimationConfig? animation,
    List<VariantStyle<LabelSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          spacing: Prop.maybe(spacing),
          label: label != null ? Prop.mix(label) : null,
          icon: icon != null ? Prop.mix(icon) : null,
          iconPosition: Prop.maybe(iconPosition),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory LabelStyle.value(LabelSpec spec) => LabelStyle(
        spacing: spec.spacing,
        label: TextMix.maybeValue(spec.label),
        icon: IconMix.maybeValue(spec.icon),
        iconPosition: spec.iconPosition,
      );

  @override
  LabelStyle variant(Variant variant, LabelStyle style) {
    return merge(LabelStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  LabelStyle variants(List<VariantStyle<LabelSpec>> value) {
    return merge(LabelStyle(variants: value));
  }

  @override
  LabelStyle wrap(ModifierConfig value) {
    return merge(LabelStyle(modifier: value));
  }

  @override
  LabelSpec resolve(BuildContext context) {
    return LabelSpec(
      spacing: MixOps.resolve(context, $spacing),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
      iconPosition: MixOps.resolve(context, $iconPosition),
    );
  }

  @override
  LabelStyle merge(LabelStyle? other) {
    if (other == null) return this;

    return LabelStyle.create(
      spacing: MixOps.merge($spacing, other.$spacing),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      iconPosition: MixOps.merge($iconPosition, other.$iconPosition),
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
        $icon,
        $iconPosition,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

/// Default label styles and variants
class LabelStyles {
  /// Default label style
  static LabelStyle get defaultStyle => LabelStyle(spacing: 8);

  /// Primary label variant
  static LabelStyle get primary => LabelStyle(
        spacing: 8,
        label: TextMix(
          style: TextStyleMix(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.blue, size: 20),
      );

  /// Secondary label variant
  static LabelStyle get secondary => LabelStyle(
        spacing: 8,
        label: TextMix(
          style: TextStyleMix(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconMix(color: Colors.grey, size: 20),
      );

  /// Compact label variant with reduced spacing
  static LabelStyle get compact => LabelStyle(
        spacing: 4,
        label: TextMix(),
        icon: IconMix(size: 16),
      );

  /// Large label variant with increased spacing
  static LabelStyle get large => LabelStyle(
        spacing: 12,
        label: TextMix(style: TextStyleMix(fontSize: 16)),
        icon: IconMix(size: 24),
      );
}
