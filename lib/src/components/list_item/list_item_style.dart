part of 'list_item.dart';

class RemixListItemStyle extends Style<ListItemSpec>
    with
        StyleModifierMixin<RemixListItemStyle, ListItemSpec>,
        StyleVariantMixin<RemixListItemStyle, ListItemSpec> {
  final Prop<ContainerProperties>? $container;
  final Prop<FlexProperties>? $flex;
  final Prop<ContainerProperties>? $contentContainer;
  final Prop<FlexProperties>? $contentFlex;
  final Prop<TextSpec>? $title;
  final Prop<TextSpec>? $subtitle;
  final Prop<IconSpec>? $leading;
  final Prop<IconSpec>? $trailing;

  const RemixListItemStyle.create({
    Prop<ContainerProperties>? container,
    Prop<FlexProperties>? flex,
    Prop<ContainerProperties>? contentContainer,
    Prop<FlexProperties>? contentFlex,
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
    ContainerPropertiesMix? container,
    FlexPropertiesMix? flex,
    ContainerPropertiesMix? contentContainer,
    FlexPropertiesMix? contentFlex,
    TextMix? title,
    TextMix? subtitle,
    IconMix? leading,
    IconMix? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ListItemSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          flex: flex != null ? Prop.mix(flex) : null,
          contentContainer:
              contentContainer != null ? Prop.mix(contentContainer) : null,
          contentFlex: contentFlex != null ? Prop.mix(contentFlex) : null,
          title: title != null ? Prop.mix(title) : null,
          subtitle: subtitle != null ? Prop.mix(subtitle) : null,
          leading: leading != null ? Prop.mix(leading) : null,
          trailing: trailing != null ? Prop.mix(trailing) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixListItemStyle.value(ListItemSpec spec) => RemixListItemStyle(
        container: ContainerPropertiesMix.maybeValue(spec.container),
        flex: FlexPropertiesMix.maybeValue(spec.flex),
        contentContainer: ContainerPropertiesMix.maybeValue(spec.contentContainer),
        contentFlex: FlexPropertiesMix.maybeValue(spec.contentFlex),
      );

  @override
  ListItemSpec resolve(BuildContext context) {
    return ListItemSpec(
      container: MixOps.resolve(context, $container),
      flex: MixOps.resolve(context, $flex),
      contentContainer: MixOps.resolve(context, $contentContainer),
      contentFlex: MixOps.resolve(context, $contentFlex),
      title: MixOps.resolve(context, $title),
      subtitle: MixOps.resolve(context, $subtitle),
      leading: MixOps.resolve(context, $leading),
      trailing: MixOps.resolve(context, $trailing),
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
  container: ContainerPropertiesMix(
    padding: EdgeInsetsMix.symmetric(vertical: 12, horizontal: 16),
  ),
  flex: FlexPropertiesMix(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    gap: 16,
  ),
  contentContainer: ContainerPropertiesMix(),
  contentFlex: FlexPropertiesMix(
    direction: Axis.vertical,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    gap: 2,
  ),
  title: TextMix(
    style: TextStyleMix(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  subtitle: TextMix(
    style: TextStyleMix(color: RemixTokens.textSecondary(), fontSize: RemixTokens.fontSizeSm()),
  ),
  leading: IconMix(size: 24),
  trailing: IconMix(size: 20),
);
