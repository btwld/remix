part of 'list_item.dart';

class RemixListItemStyle extends Style<ListItemSpec>
    with
        StyleModifierMixin<RemixListItemStyle, ListItemSpec>,
        StyleVariantMixin<RemixListItemStyle, ListItemSpec> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<FlexSpec>>? $flex;
  final Prop<StyleSpec<BoxSpec>>? $contentContainer;
  final Prop<StyleSpec<FlexSpec>>? $contentFlex;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<TextSpec>>? $subtitle;
  final Prop<StyleSpec<IconSpec>>? $leading;
  final Prop<StyleSpec<IconSpec>>? $trailing;

  const RemixListItemStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<FlexSpec>>? flex,
    Prop<StyleSpec<BoxSpec>>? contentContainer,
    Prop<StyleSpec<FlexSpec>>? contentFlex,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<TextSpec>>? subtitle,
    Prop<StyleSpec<IconSpec>>? leading,
    Prop<StyleSpec<IconSpec>>? trailing,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $flex = flex,
        $contentContainer = contentContainer,
        $contentFlex = contentFlex,
        $title = title,
        $subtitle = subtitle,
        $leading = leading,
        $trailing = trailing;

  RemixListItemStyle({
    BoxStyler? container,
    FlexStyler? flex,
    BoxStyler? contentContainer,
    FlexStyler? contentFlex,
    TextStyler? title,
    TextStyler? subtitle,
    IconStyler? leading,
    IconStyler? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ListItemSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          flex: Prop.maybeMix(flex),
          contentContainer: Prop.maybeMix(contentContainer),
          contentFlex: Prop.maybeMix(contentFlex),
          title: Prop.maybeMix(title),
          subtitle: Prop.maybeMix(subtitle),
          leading: Prop.maybeMix(leading),
          trailing: Prop.maybeMix(trailing),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  StyleSpec<ListItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ListItemSpec(
        container: MixOps.resolve(context, $container),
        flex: MixOps.resolve(context, $flex),
        contentContainer: MixOps.resolve(context, $contentContainer),
        contentFlex: MixOps.resolve(context, $contentFlex),
        title: MixOps.resolve(context, $title),
        subtitle: MixOps.resolve(context, $subtitle),
        leading: MixOps.resolve(context, $leading),
        trailing: MixOps.resolve(context, $trailing),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixListItemStyle variant(Variant variant, RemixListItemStyle style) {
    return merge(RemixListItemStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixListItemStyle variants(List<VariantStyle<ListItemSpec>> value) {
    return merge(RemixListItemStyle(variants: value));
  }

  @override
  RemixListItemStyle wrap(ModifierConfig value) {
    return merge(RemixListItemStyle(modifier: value));
  }

  @override
  RemixListItemStyle merge(RemixListItemStyle? other) {
    if (other == null) return this;

    return RemixListItemStyle.create(
      container: MixOps.merge($container, other.$container),
      flex: MixOps.merge($flex, other.$flex),
      contentContainer:
          MixOps.merge($contentContainer, other.$contentContainer),
      contentFlex: MixOps.merge($contentFlex, other.$contentFlex),
      title: MixOps.merge($title, other.$title),
      subtitle: MixOps.merge($subtitle, other.$subtitle),
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $flex,
        $contentContainer,
        $contentFlex,
        $title,
        $subtitle,
        $leading,
        $trailing,
        $variants,
        $animation,
        $modifier,
      ];
}

final DefaultRemixListItemStyle = RemixListItemStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.symmetric(vertical: 12, horizontal: 16),
  ),
  flex: FlexStyler(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 16,
  ),
  contentContainer: BoxStyler(),
  contentFlex: FlexStyler(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 2,
  ),
  title: TextStyler(
    style: TextStyleMix(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  subtitle: TextStyler(
    style: TextStyleMix(
      color: RemixTokens.textSecondary(),
      fontSize: RemixTokens.fontSizeSm(),
    ),
  ),
  leading: IconStyler(size: 24),
  trailing: IconStyler(size: 20),
);
