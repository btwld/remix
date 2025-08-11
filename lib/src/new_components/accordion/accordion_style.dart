part of 'accordion.dart';

class AccordionStyle extends Style<AccordionSpec>
    with StyleModifierMixin<AccordionStyle, AccordionSpec>, StyleVariantMixin<AccordionStyle, AccordionSpec> {
  final Prop<BoxSpec>? $itemContainer;
  final Prop<BoxSpec>? $contentContainer;
  final Prop<FlexBoxSpec>? $headerContainer;
  final Prop<IconSpec>? $leadingIcon;
  final Prop<IconSpec>? $trailingIcon;
  final Prop<TextSpec>? $titleStyle;
  final Prop<TextSpec>? $contentStyle;

  const AccordionStyle.create({
    Prop<BoxSpec>? itemContainer,
    Prop<BoxSpec>? contentContainer,
    Prop<FlexBoxSpec>? headerContainer,
    Prop<IconSpec>? leadingIcon,
    Prop<IconSpec>? trailingIcon,
    Prop<TextSpec>? titleStyle,
    Prop<TextSpec>? contentStyle,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $itemContainer = itemContainer,
        $contentContainer = contentContainer,
        $headerContainer = headerContainer,
        $leadingIcon = leadingIcon,
        $trailingIcon = trailingIcon,
        $titleStyle = titleStyle,
        $contentStyle = contentStyle;

  AccordionStyle({
    BoxMix? itemContainer,
    BoxMix? contentContainer,
    FlexBoxMix? headerContainer,
    IconMix? leadingIcon,
    IconMix? trailingIcon,
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
          leadingIcon: leadingIcon != null ? Prop.mix(leadingIcon) : null,
          trailingIcon: trailingIcon != null ? Prop.mix(trailingIcon) : null,
          titleStyle: titleStyle != null ? Prop.mix(titleStyle) : null,
          contentStyle: contentStyle != null ? Prop.mix(contentStyle) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  @override
  AccordionSpec resolve(BuildContext context) {
    return AccordionSpec(
      itemContainer: MixOps.resolve(context, $itemContainer),
      contentContainer: MixOps.resolve(context, $contentContainer),
      headerContainer: MixOps.resolve(context, $headerContainer),
      leadingIcon: MixOps.resolve(context, $leadingIcon),
      trailingIcon: MixOps.resolve(context, $trailingIcon),
      titleStyle: MixOps.resolve(context, $titleStyle),
      contentStyle: MixOps.resolve(context, $contentStyle),
    );
  }

  @override
  AccordionStyle merge(AccordionStyle? other) {
    if (other == null) return this;

    return AccordionStyle.create(
      itemContainer: MixOps.merge($itemContainer, other.$itemContainer),
      contentContainer:
          MixOps.merge($contentContainer, other.$contentContainer),
      headerContainer: MixOps.merge($headerContainer, other.$headerContainer),
      leadingIcon: MixOps.merge($leadingIcon, other.$leadingIcon),
      trailingIcon: MixOps.merge($trailingIcon, other.$trailingIcon),
      titleStyle: MixOps.merge($titleStyle, other.$titleStyle),
      contentStyle: MixOps.merge($contentStyle, other.$contentStyle),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  AccordionStyle variant(Variant variant, AccordionStyle style) {
    return merge(AccordionStyle(variants: [VariantStyle(variant, style)]));
  }
  
  @override
  AccordionStyle variants(List<VariantStyle<AccordionSpec>> value) {
    return merge(AccordionStyle(variants: value));
  }

  @override
  AccordionStyle wrap(ModifierConfig value) {
    return merge(AccordionStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $itemContainer,
        $contentContainer,
        $headerContainer,
        $leadingIcon,
        $trailingIcon,
        $titleStyle,
        $contentStyle,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultAccordionStyle = AccordionStyle(
  itemContainer: BoxMix(
    margin: EdgeInsetsMix(bottom: 12),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: Colors.grey[300]!,
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(12),
    ),
  ),
  contentContainer: BoxMix(
    padding: EdgeInsetsMix.fromLTRB(12, 0, 12, 12),
    constraints: BoxConstraintsMix(minWidth: double.infinity),
  ),
  headerContainer: FlexBoxMix(
    box: BoxMix(
      padding: EdgeInsetsMix.all(12),
    ),
    flex: FlexMix(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
    ),
  ),
  leadingIcon: IconMix(size: 20),
  trailingIcon: IconMix(size: 20),
  titleStyle: TextMix(
    style: TextStyleMix(
      color: Colors.grey[800],
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  contentStyle: TextMix(
    style: TextStyleMix(
      color: Colors.grey[800],
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
);
