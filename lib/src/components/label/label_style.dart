part of 'label.dart';

class RemixLabelStyle extends Style<LabelSpec>
    with
        StyleModifierMixin<RemixLabelStyle, LabelSpec>,
        StyleVariantMixin<RemixLabelStyle, LabelSpec> {
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;
  final Prop<FlexSpec>? $flex;

  const RemixLabelStyle.create({
    Prop<TextSpec>? label,
    Prop<IconSpec>? leading,
    Prop<IconSpec>? trailing,
    Prop<FlexSpec>? flex,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $label = label,
        $leading = leading,
        $trailing = trailing,
        $flex = flex;

  RemixLabelStyle({
    TextMix? label,
    IconMix? leading,
    IconMix? trailing,
    FlexMix? flex,
    AnimationConfig? animation,
    List<VariantStyle<LabelSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          label: Prop.maybeMix(label),
          leading: Prop.maybeMix(leading),
          trailing: Prop.maybeMix(trailing),
          flex: Prop.maybeMix(flex),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixLabelStyle.value(LabelSpec spec) => RemixLabelStyle(
        label: TextMix.maybeValue(spec.label),
        leading: IconMix.maybeValue(spec.leading),
        trailing: IconMix.maybeValue(spec.trailing),
        flex: FlexMix.maybeValue(spec.flex),
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
      inherit: $inherit,
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
        flex: FlexMix(spacing: 8),
      );

  /// Primary label variant
  static RemixLabelStyle get primary => RemixLabelStyle(
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(color: RemixTokens.primary(), size: 20),
        flex: FlexMix(spacing: 8),
      );

  /// Secondary label variant
  static RemixLabelStyle get secondary => RemixLabelStyle(
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textSecondary(),
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconMix(color: RemixTokens.textSecondary(), size: 20),
        flex: FlexMix(spacing: 8),
      );

  /// Compact label variant with reduced spacing
  static RemixLabelStyle get compact => RemixLabelStyle(
        label: TextMix(),
        leading: IconMix(size: 16),
        flex: FlexMix(spacing: 4),
      );

  /// Large label variant with increased spacing
  static RemixLabelStyle get large => RemixLabelStyle(
        label: TextMix(style: TextStyleMix(fontSize: 16)),
        leading: IconMix(size: 24),
        flex: FlexMix(spacing: 12),
      );
}
