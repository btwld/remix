part of 'chip.dart';

class RemixChipStyle extends Style<ChipSpec>
    with
        StyleModifierMixin<RemixChipStyle, ChipSpec>,
        StyleVariantMixin<RemixChipStyle, ChipSpec> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<FlexSpec>>? $flex;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $leading;
  final Prop<StyleSpec<IconSpec>>? $trailing;

  const RemixChipStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<FlexSpec>>? flex,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? leading,
    Prop<StyleSpec<IconSpec>>? trailing,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $flex = flex,
        $label = label,
        $leading = leading,
        $trailing = trailing;

  RemixChipStyle({
    BoxStyler? container,
    FlexStyler? flex,
    TextStyler? label,
    IconStyler? leading,
    IconStyler? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ChipSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          flex: Prop.maybeMix(flex),
          label: Prop.maybeMix(label),
          leading: Prop.maybeMix(leading),
          trailing: Prop.maybeMix(trailing),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  StyleSpec<ChipSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ChipSpec(
        container: MixOps.resolve(context, $container),
        flex: MixOps.resolve(context, $flex),
        label: MixOps.resolve(context, $label),
        leading: MixOps.resolve(context, $leading),
        trailing: MixOps.resolve(context, $trailing),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixChipStyle merge(RemixChipStyle? other) {
    if (other == null) return this;

    return RemixChipStyle.create(
      container: MixOps.merge($container, other.$container),
      flex: MixOps.merge($flex, other.$flex),
      label: MixOps.merge($label, other.$label),
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixChipStyle variant(Variant variant, RemixChipStyle style) {
    return merge(RemixChipStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixChipStyle variants(List<VariantStyle<ChipSpec>> value) {
    return merge(RemixChipStyle(variants: value));
  }

  @override
  RemixChipStyle wrap(ModifierConfig value) {
    return merge(RemixChipStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $flex,
        $label,
        $leading,
        $trailing,
        $variants,
        $animation,
        $modifier,
      ];
}

final DefaultRemixChipStyle = RemixChipStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.symmetric(
      vertical: RemixTokens.spaceXs(),
      horizontal: RemixTokens.spaceMd(),
    ),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
      color: RemixTokens.surfaceVariant(),
    ),
  ),
  flex: FlexStyler(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: RemixTokens.spaceXs(),
  ),
  label: TextStyler(
    style: TextStyleMix(
      fontSize: RemixTokens.fontSizeMd(),
      fontWeight: FontWeight.w500,
    ),
  ),
  leading: IconStyler(size: RemixTokens.iconSizeMd()),
  trailing: IconStyler(size: RemixTokens.iconSizeMd()),
);

extension ChipVariants on RemixChipStyle {
  /// Primary chip variant with blue colors
  static RemixChipStyle get primary => RemixChipStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
        ),
        flex: FlexStyler(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconStyler(
          color: RemixTokens.primary(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconStyler(
          color: RemixTokens.primary(),
          size: RemixTokens.iconSizeMd(),
        ),
      );

  /// Secondary chip variant with grey colors
  static RemixChipStyle get secondary => RemixChipStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.surface(),
          ),
        ),
        flex: FlexStyler(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconStyler(
          color: RemixTokens.textSecondary(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconStyler(
          color: RemixTokens.textSecondary(),
          size: RemixTokens.iconSizeMd(),
        ),
      );

  /// Success chip variant with green colors
  static RemixChipStyle get success => RemixChipStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.success().withValues(alpha: 0.1),
          ),
        ),
        flex: FlexStyler(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.success(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconStyler(
          color: RemixTokens.success(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconStyler(
          color: RemixTokens.success(),
          size: RemixTokens.iconSizeMd(),
        ),
      );

  /// Warning chip variant with orange colors
  static RemixChipStyle get warning => RemixChipStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.warning().withValues(alpha: 0.1),
          ),
        ),
        flex: FlexStyler(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.warning(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconStyler(
          color: RemixTokens.warning(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconStyler(
          color: RemixTokens.warning(),
          size: RemixTokens.iconSizeMd(),
        ),
      );
}
