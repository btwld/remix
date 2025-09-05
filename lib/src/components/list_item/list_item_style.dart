part of 'list_item.dart';

class RemixListItemStyle extends Style<ListItemSpec>
    with
        StyleModifierMixin<RemixListItemStyle, ListItemSpec>,
        StyleVariantMixin<RemixListItemStyle, ListItemSpec>,
        DecorationStyleMixin<RemixListItemStyle>,
        ModifierStyleMixin<RemixListItemStyle, ListItemSpec>,
        BorderStyleMixin<RemixListItemStyle>,
        BorderRadiusStyleMixin<RemixListItemStyle>,
        ShadowStyleMixin<RemixListItemStyle>,
        SpacingStyleMixin<RemixListItemStyle>,
        TransformStyleMixin<RemixListItemStyle>,
        ConstraintStyleMixin<RemixListItemStyle>,
        AnimationStyleMixin<ListItemSpec, RemixListItemStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $contentContainer;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<TextSpec>>? $subtitle;
  final Prop<StyleSpec<IconSpec>>? $leading;
  final Prop<StyleSpec<IconSpec>>? $trailing;

  const RemixListItemStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? contentContainer,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<TextSpec>>? subtitle,
    Prop<StyleSpec<IconSpec>>? leading,
    Prop<StyleSpec<IconSpec>>? trailing,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $contentContainer = contentContainer,
        $title = title,
        $subtitle = subtitle,
        $leading = leading,
        $trailing = trailing;

  RemixListItemStyle({
    BoxStyler? container,
    BoxStyler? contentContainer,
    TextStyler? title,
    TextStyler? subtitle,
    IconStyler? leading,
    IconStyler? trailing,
    AnimationConfig? animation,
    List<VariantStyle<ListItemSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          contentContainer: Prop.maybeMix(contentContainer),
          title: Prop.maybeMix(title),
          subtitle: Prop.maybeMix(subtitle),
          leading: Prop.maybeMix(leading),
          trailing: Prop.maybeMix(trailing),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Convenience methods that delegate to container and contentContainer

  /// Sets container padding
  RemixListItemStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixListItemStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container background color
  RemixListItemStyle color(Color value) {
    return merge(RemixListItemStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixListItemStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixListItemStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container margin
  RemixListItemStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixListItemStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container decoration
  RemixListItemStyle decoration(DecorationMix value) {
    return merge(RemixListItemStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets content container styling
  RemixListItemStyle content(BoxStyler value) {
    return merge(RemixListItemStyle(contentContainer: value));
  }

  @override
  StyleSpec<ListItemSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ListItemSpec(
        container: MixOps.resolve(context, $container),
        contentContainer: MixOps.resolve(context, $contentContainer),
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
  RemixListItemStyle variants(List<VariantStyle<ListItemSpec>> value) {
    return merge(RemixListItemStyle(variants: value));
  }

  @override
  RemixListItemStyle wrap(ModifierConfig value) {
    return merge(RemixListItemStyle(modifier: value));
  }

  // Abstract method implementations for mixins
  
  @override
  RemixListItemStyle animate(AnimationConfig config) {
    return merge(RemixListItemStyle(animation: config));
  }
  
  @override
  RemixListItemStyle constraints(BoxConstraintsMix value) {
    return merge(RemixListItemStyle(container: BoxStyler(constraints: value)));
  }
  
  @override
  RemixListItemStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixListItemStyle(container: BoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixListItemStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixListItemStyle(container: BoxStyler(transform: value, alignment: alignment)));
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
      leading: MixOps.merge($leading, other.$leading),
      trailing: MixOps.merge($trailing, other.$trailing),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $contentContainer,
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
  contentContainer: BoxStyler(),
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
