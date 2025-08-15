part of 'list_item.dart';

class RemixListItemStyle extends Style<ListItemSpec>
    with
        StyleModifierMixin<RemixListItemStyle, ListItemSpec>,
        StyleVariantMixin<RemixListItemStyle, ListItemSpec> {
  final Prop<FlexBoxSpec>? $container;
  final Prop<FlexBoxSpec>? $contentContainer;
  final Prop<TextSpec>? $title;
  final Prop<TextSpec>? $subtitle;
  final Prop<IconSpec>? $leadingIcon;
  final Prop<IconSpec>? $trailingIcon;

  const RemixListItemStyle.create({
    Prop<FlexBoxSpec>? container,
    Prop<FlexBoxSpec>? contentContainer,
    Prop<TextSpec>? title,
    Prop<TextSpec>? subtitle,
    Prop<IconSpec>? leadingIcon,
    Prop<IconSpec>? trailingIcon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $contentContainer = contentContainer,
        $title = title,
        $subtitle = subtitle,
        $leadingIcon = leadingIcon,
        $trailingIcon = trailingIcon;

  RemixListItemStyle({
    FlexBoxMix? container,
    FlexBoxMix? contentContainer,
    TextMix? title,
    TextMix? subtitle,
    IconMix? leadingIcon,
    IconMix? trailingIcon,
    AnimationConfig? animation,
    List<VariantStyle<ListItemSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          contentContainer:
              contentContainer != null ? Prop.mix(contentContainer) : null,
          title: title != null ? Prop.mix(title) : null,
          subtitle: subtitle != null ? Prop.mix(subtitle) : null,
          leadingIcon: leadingIcon != null ? Prop.mix(leadingIcon) : null,
          trailingIcon: trailingIcon != null ? Prop.mix(trailingIcon) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  @override
  ListItemSpec resolve(BuildContext context) {
    return ListItemSpec(
      container: MixOps.resolve(context, $container),
      contentContainer: MixOps.resolve(context, $contentContainer),
      title: MixOps.resolve(context, $title),
      subtitle: MixOps.resolve(context, $subtitle),
      leadingIcon: MixOps.resolve(context, $leadingIcon),
      trailingIcon: MixOps.resolve(context, $trailingIcon),
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
      contentContainer:
          MixOps.merge($contentContainer, other.$contentContainer),
      title: MixOps.merge($title, other.$title),
      subtitle: MixOps.merge($subtitle, other.$subtitle),
      leadingIcon: MixOps.merge($leadingIcon, other.$leadingIcon),
      trailingIcon: MixOps.merge($trailingIcon, other.$trailingIcon),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $contentContainer,
        $title,
        $subtitle,
        $leadingIcon,
        $trailingIcon,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixListItemStyle = RemixListItemStyle(
  container: FlexBoxMix(
    box: BoxMix(
      padding: EdgeInsetsMix.symmetric(vertical: 12, horizontal: 16),
    ),
    flex: FlexMix(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.center,
      gap: 16,
    ),
  ),
  contentContainer: FlexBoxMix(
    flex: FlexMix(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      gap: 2,
    ),
  ),
  title: TextMix(
    style: TextStyleMix(fontSize: 16, fontWeight: FontWeight.w500),
  ),
  subtitle: TextMix(
    style: TextStyleMix(color: Colors.grey[600], fontSize: 14),
  ),
  leadingIcon: IconMix(size: 24),
  trailingIcon: IconMix(size: 20),
);
