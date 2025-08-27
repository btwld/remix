part of 'chip.dart';

class RemixChipStyle extends Style<ChipSpec>
    with
        StyleModifierMixin<RemixChipStyle, ChipSpec>,
        StyleVariantMixin<RemixChipStyle, ChipSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<FlexSpec>? $flex;
  final Prop<TextSpec>? $label;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;

  const RemixChipStyle.create({
    Prop<BoxSpec>? container,
    Prop<FlexSpec>? flex,
    Prop<TextSpec>? label,
    Prop<IconSpec>? leading,
    Prop<IconSpec>? trailing,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $label = label,
        $leading = leading,
        $trailing = trailing;

  RemixChipStyle({
    BoxMix? container,
    FlexMix? flex,
    TextMix? label,
    IconMix? leading,
    IconMix? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ChipSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          flex: Prop.maybeMix(flex),
          label: Prop.maybeMix(label),
          leading: Prop.maybeMix(leading),
          trailing: Prop.maybeMix(trailing),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixChipStyle.value(ChipSpec spec) => RemixChipStyle(
        container: BoxMix.maybeValue(spec.container),
        flex: FlexMix.maybeValue(spec.flex),
        label: TextMix.maybeValue(spec.label),
        leading: IconMix.maybeValue(spec.leading),
        trailing: IconMix.maybeValue(spec.trailing),
      );

  @override
  WidgetSpec<ChipSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: ChipSpec(
        container: MixOps.resolve(context, $container),
        flex: MixOps.resolve(context, $flex),
        label: MixOps.resolve(context, $label),
        leading: MixOps.resolve(context, $leading),
        trailing: MixOps.resolve(context, $trailing),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

final DefaultRemixChipStyle = RemixChipStyle(
  container: BoxMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
      color: RemixTokens.surfaceVariant(),
    ),
    padding: EdgeInsetsMix.symmetric(
      vertical: RemixTokens.spaceXs(),
      horizontal: RemixTokens.spaceMd(),
    ),
  ),
  flex: FlexMix(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    spacing: RemixTokens.spaceXs(),
  ),
  label: TextMix(
    style: TextStyleMix(
      fontSize: RemixTokens.fontSizeMd(),
      fontWeight: FontWeight.w500,
    ),
  ),
  leading: IconMix(size: RemixTokens.iconSizeMd()),
  trailing: IconMix(size: RemixTokens.iconSizeMd()),
);

extension ChipVariants on RemixChipStyle {
  /// Primary chip variant with blue colors
  static RemixChipStyle get primary => RemixChipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
        ),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(
          color: RemixTokens.primary(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconMix(
          color: RemixTokens.primary(),
          size: RemixTokens.iconSizeMd(),
        ),
      );

  /// Secondary chip variant with grey colors
  static RemixChipStyle get secondary => RemixChipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.surface(),
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
        ),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(
          color: RemixTokens.textSecondary(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconMix(
          color: RemixTokens.textSecondary(),
          size: RemixTokens.iconSizeMd(),
        ),
      );

  /// Success chip variant with green colors
  static RemixChipStyle get success => RemixChipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.success().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
        ),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.success(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(
          color: RemixTokens.success(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconMix(
          color: RemixTokens.success(),
          size: RemixTokens.iconSizeMd(),
        ),
      );

  /// Warning chip variant with orange colors
  static RemixChipStyle get warning => RemixChipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusXl()),
            color: RemixTokens.warning().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceMd(),
          ),
        ),
        flex: FlexMix(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: RemixTokens.spaceXs(),
        ),
        label: TextMix(
          style: TextStyleMix(
            color: RemixTokens.warning(),
            fontSize: RemixTokens.fontSizeMd(),
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconMix(
          color: RemixTokens.warning(),
          size: RemixTokens.iconSizeMd(),
        ),
        trailing: IconMix(
          color: RemixTokens.warning(),
          size: RemixTokens.iconSizeMd(),
        ),
      );
}
