part of 'list_item.dart';

class RemixListItemStyle extends Style<ListItemSpec>
    with
        StyleModifierMixin<RemixListItemStyle, ListItemSpec>,
        StyleVariantMixin<RemixListItemStyle, ListItemSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<FlexSpec>? $flex;
  final Prop<BoxSpec>? $contentContainer;
  final Prop<FlexSpec>? $contentFlex;
  final Prop<TextSpec>? $title;
  final Prop<TextSpec>? $subtitle;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;

  const RemixListItemStyle.create({
    Prop<BoxSpec>? container,
    Prop<FlexSpec>? flex,
    Prop<BoxSpec>? contentContainer,
    Prop<FlexSpec>? contentFlex,
    Prop<TextSpec>? title,
    Prop<TextSpec>? subtitle,
    Prop<IconSpec>? leading,
    Prop<IconSpec>? trailing,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $flex = flex,
        $contentContainer = contentContainer,
        $contentFlex = contentFlex,
        $title = title,
        $subtitle = subtitle,
        $leading = leading,
        $trailing = trailing;

  RemixListItemStyle({
    BoxMix? container,
    FlexMix? flex,
    BoxMix? contentContainer,
    FlexMix? contentFlex,
    TextMix? title,
    TextMix? subtitle,
    IconMix? leading,
    IconMix? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ListItemSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
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
          inherit: inherit,
        );

  factory RemixListItemStyle.value(ListItemSpec spec) => RemixListItemStyle(
        container: BoxMix.maybeValue(spec.container),
        flex: FlexMix.maybeValue(spec.flex),
        contentContainer: BoxMix.maybeValue(spec.contentContainer),
        contentFlex: FlexMix.maybeValue(spec.contentFlex),
      );

  @override
  WidgetSpec<ListItemSpec> resolve(BuildContext context) {
    return WidgetSpec(
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
      inherit: $inherit,
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
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

final DefaultRemixListItemStyle = RemixListItemStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.symmetric(vertical: 12, horizontal: 16),
  ),
  flex: FlexMix(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    spacing: 16,
  ),
  contentContainer: BoxMix(),
  contentFlex: FlexMix(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    spacing: 2,
  ),
  title: TextMix(
    style: TextStyleMix(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  subtitle: TextMix(
    style: TextStyleMix(
      color: RemixTokens.textSecondary(),
      fontSize: RemixTokens.fontSizeSm(),
    ),
  ),
  leading: IconMix(size: 24),
  trailing: IconMix(size: 20),
);
