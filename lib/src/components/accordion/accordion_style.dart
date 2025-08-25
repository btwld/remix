part of 'accordion.dart';

class RemixAccordionStyle extends Style<AccordionSpec>
    with
        StyleModifierMixin<RemixAccordionStyle, AccordionSpec>,
        StyleVariantMixin<RemixAccordionStyle, AccordionSpec> {
  final Prop<ContainerSpec>? $itemContainer;
  final Prop<ContainerSpec>? $contentContainer;
  final Prop<ContainerSpec>? $headerContainer;
  final Prop<FlexProperties>? $headerFlex;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;
  final Prop<TextSpec>? $titleStyle;
  final Prop<TextSpec>? $contentStyle;

  const RemixAccordionStyle.create({
    Prop<ContainerSpec>? itemContainer,
    Prop<ContainerSpec>? contentContainer,
    Prop<ContainerSpec>? headerContainer,
    Prop<FlexProperties>? headerFlex,
    Prop<IconSpec>? leading,
    Prop<IconSpec>? trailing,
    Prop<TextSpec>? titleStyle,
    Prop<TextSpec>? contentStyle,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $itemContainer = itemContainer,
        $contentContainer = contentContainer,
        $headerContainer = headerContainer,
        $headerFlex = headerFlex,
        $leading = leading,
        $trailing = trailing,
        $titleStyle = titleStyle,
        $contentStyle = contentStyle;

  RemixAccordionStyle({
    ContainerSpecMix? itemContainer,
    ContainerSpecMix? contentContainer,
    ContainerSpecMix? headerContainer,
    FlexPropertiesMix? headerFlex,
    IconMix? leading,
    IconMix? trailing,
    TextMix? titleStyle,
    TextMix? contentStyle,
    AnimationConfig? animation,
    List<VariantStyle<AccordionSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          itemContainer: itemContainer != null ? Prop.mix(itemContainer) : null,
          contentContainer:
              contentContainer != null ? Prop.mix(contentContainer) : null,
          headerContainer:
              headerContainer != null ? Prop.mix(headerContainer) : null,
          headerFlex: headerFlex != null ? Prop.mix(headerFlex) : null,
          leading: leading != null ? Prop.mix(leading) : null,
          trailing: trailing != null ? Prop.mix(trailing) : null,
          titleStyle: titleStyle != null ? Prop.mix(titleStyle) : null,
          contentStyle: contentStyle != null ? Prop.mix(contentStyle) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixAccordionStyle.value(AccordionSpec spec) => RemixAccordionStyle(
        itemContainer: ContainerSpecMix.maybeValue(spec.itemContainer),
        contentContainer:
            ContainerSpecMix.maybeValue(spec.contentContainer),
        headerContainer:
            ContainerSpecMix.maybeValue(spec.headerContainer),
        headerFlex: FlexPropertiesMix.maybeValue(spec.headerFlex),
      );

  @override
  AccordionSpec resolve(BuildContext context) {
    return AccordionSpec(
      itemContainer: MixOps.resolve(context, $itemContainer),
      contentContainer: MixOps.resolve(context, $contentContainer),
      headerContainer: MixOps.resolve(context, $headerContainer),
      headerFlex: MixOps.resolve(context, $headerFlex),
      leading: MixOps.resolve(context, $leading),
      trailing: MixOps.resolve(context, $trailing),
      titleStyle: MixOps.resolve(context, $titleStyle),
      contentStyle: MixOps.resolve(context, $contentStyle),
    );
  }

  @override
  RemixAccordionStyle merge(RemixAccordionStyle? other) {
    if (other == null) return this;

    return RemixAccordionStyle.create(
      itemContainer: MixOps.merge($itemContainer, other.$itemContainer),
      contentContainer:
          MixOps.merge($contentContainer, other.$contentContainer),
      headerContainer: MixOps.merge($headerContainer, other.$headerContainer),
      headerFlex: MixOps.merge($headerFlex, other.$headerFlex),
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      titleStyle: MixOps.merge($titleStyle, other.$titleStyle),
      contentStyle: MixOps.merge($contentStyle, other.$contentStyle),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  RemixAccordionStyle variant(Variant variant, RemixAccordionStyle style) {
    return merge(RemixAccordionStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixAccordionStyle variants(List<VariantStyle<AccordionSpec>> value) {
    return merge(RemixAccordionStyle(variants: value));
  }

  @override
  RemixAccordionStyle wrap(ModifierConfig value) {
    return merge(RemixAccordionStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $itemContainer,
        $contentContainer,
        $headerContainer,
        $headerFlex,
        $leading,
        $trailing,
        $titleStyle,
        $contentStyle,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixAccordionStyle = RemixAccordionStyle(
  itemContainer: ContainerSpecMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(12),
    ),
    margin: EdgeInsetsMix(bottom: 12),
  ),
  contentContainer: ContainerSpecMix(
    padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
    constraints: BoxConstraintsMix(minWidth: double.infinity),
  ),
  headerContainer: ContainerSpecMix(padding: EdgeInsetsMix.all(12)),
  headerFlex: FlexPropertiesMix(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
  ),
  leading: IconMix(size: 20),
  trailing: IconMix(size: 20),
  titleStyle: TextMix(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  contentStyle: TextMix(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
);

extension AccordionVariants on RemixAccordionStyle {
  /// Default accordion variant (same as DefaultAccordionStyle)
  static RemixAccordionStyle get defaultVariant => RemixAccordionStyle(
        itemContainer: ContainerSpecMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
          margin: EdgeInsetsMix(bottom: 12),
        ),
        contentContainer: ContainerSpecMix(
          padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        headerContainer: ContainerSpecMix(
          padding: EdgeInsetsMix.all(12),
        ),
        headerFlex: FlexPropertiesMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        leading: IconMix(size: 20),
        trailing: IconMix(size: 20),
        titleStyle: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentStyle: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  /// Compact accordion variant with smaller padding
  static RemixAccordionStyle get compact => RemixAccordionStyle(
        itemContainer: ContainerSpecMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.border(),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(8),
          ),
          margin: EdgeInsetsMix(bottom: 8),
        ),
        contentContainer: ContainerSpecMix(
          padding: EdgeInsetsMix.fromLTRB(8, 0, 8, 8),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        headerContainer: ContainerSpecMix(
          padding: EdgeInsetsMix.all(8),
        ),
        headerFlex: FlexPropertiesMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        leading: IconMix(size: 16),
        trailing: IconMix(size: 16),
        titleStyle: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        contentStyle: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  /// Bordered accordion variant with prominent borders
  static RemixAccordionStyle get bordered => RemixAccordionStyle(
        itemContainer: ContainerSpecMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.textSecondary(),
              width: 2,
            )),
            borderRadius: BorderRadiusMix.circular(12),
          ),
          margin: EdgeInsetsMix(bottom: 12),
        ),
        contentContainer: ContainerSpecMix(
          padding: EdgeInsetsMix.fromLTRB(16, 0, 16, 16),
          constraints: BoxConstraintsMix(minWidth: double.infinity),
        ),
        headerContainer: ContainerSpecMix(
          padding: EdgeInsetsMix.all(16),
        ),
        headerFlex: FlexPropertiesMix(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        leading: IconMix(size: 20),
        trailing: IconMix(size: 20),
        titleStyle: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        contentStyle: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
}
