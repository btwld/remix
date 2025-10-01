part of 'badge.dart';

class RemixBadgeStyle
    extends RemixContainerStyle<RemixBadgeSpec, RemixBadgeStyle>
    with LabelStyleMixin<RemixBadgeStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;

  const RemixBadgeStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text;

  RemixBadgeStyle({
    BoxStyler? container,
    TextStyler? text,
    AnimationConfig? animation,
    List<VariantStyle<RemixBadgeSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods (chainable)

  /// Sets background color
  RemixBadgeStyle color(Color value) {
    return merge(RemixBadgeStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets border radius
  RemixBadgeStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixBadgeStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets padding
  RemixBadgeStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(padding: value)));
  }

  /// Sets text color
  RemixBadgeStyle textColor(Color value) {
    return label(TextStyler(style: TextStyleMix(color: value)));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixBadgeStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixBadgeStyle decoration(DecorationMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets container alignment
  RemixBadgeStyle alignment(Alignment value) {
    return merge(RemixBadgeStyle(container: BoxStyler(alignment: value)));
  }

  @override
  RemixBadgeStyle label(TextStyler value) {
    return merge(RemixBadgeStyle(text: value));
  }

  /// Sets constraints
  @override
  RemixBadgeStyle constraints(BoxConstraintsMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(constraints: value)));
  }

  /// Sets animation
  @override
  RemixBadgeStyle animate(AnimationConfig animation) {
    return merge(RemixBadgeStyle(animation: animation));
  }

  @override
  RemixBadgeStyle variants(List<VariantStyle<RemixBadgeSpec>> value) {
    return merge(RemixBadgeStyle(variants: value));
  }

  @override
  RemixBadgeStyle wrap(WidgetModifierConfig value) {
    return merge(RemixBadgeStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixBadgeStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixBadgeStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixBadgeStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixBadgeStyle(
      container: BoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  StyleSpec<RemixBadgeSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixBadgeSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixBadgeStyle merge(RemixBadgeStyle? other) {
    if (other == null) return this;

    return RemixBadgeStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $variants,
        $animation,
        $modifier,
      ];
}
