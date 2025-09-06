part of 'label.dart';

// Private per-component constants (sizes only)
const _kFontSizeMd = 14.0; // keep size local for now

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

  // ---------- Fluent helpers (text, icon, layout) ----------

  /// Sets the text color for the label
  RemixLabelStyle textColor(Color value) {
    return merge(
      RemixLabelStyle(label: TextStyler(style: TextStyleMix(color: value))),
    );
  }

  /// Sets the font size for the label
  RemixLabelStyle fontSize(double value) {
    return merge(
      RemixLabelStyle(
        label: TextStyler(style: TextStyleMix.fontSize(value)),
      ),
    );
  }

  /// Sets the font weight for the label
  RemixLabelStyle fontWeight(FontWeight value) {
    return merge(
      RemixLabelStyle(
        label: TextStyler(style: TextStyleMix(fontWeight: value)),
      ),
    );
  }

  /// Sets the font style for the label
  RemixLabelStyle fontStyle(FontStyle value) {
    return merge(
      RemixLabelStyle(
        label: TextStyler(style: TextStyleMix(fontStyle: value)),
      ),
    );
  }

  /// Sets the icon color
  RemixLabelStyle iconColor(Color value) {
    return merge(RemixLabelStyle(icon: IconStyler(color: value)));
  }

  /// Sets the icon size
  RemixLabelStyle iconSize(double value) {
    return merge(RemixLabelStyle(icon: IconStyler(size: value)));
  }

  /// Sets the spacing between icon and label
  RemixLabelStyle spacing(double value) {
    return merge(RemixLabelStyle(flex: FlexStyler(spacing: value)));
  }

  /// Sets the icon position relative to the text
  RemixLabelStyle iconPosition(IconPosition position) {
    return merge(RemixLabelStyle(iconPosition: position));
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
        iconPosition:
            MixOps.resolve(context, $iconPosition) ?? IconPosition.leading,
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
  /// Default label style (simple)
  static RemixLabelStyle get defaultStyle => RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix(
              color: RemixTokens.primary(), fontSize: _kFontSizeMd,),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: 20),
        flex: FlexStyler(spacing: RemixTokens.spaceSm()),
      );
}
