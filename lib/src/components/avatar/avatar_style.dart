part of 'avatar.dart';

class RemixAvatarStyle extends RemixContainerStyle<AvatarSpec, RemixAvatarStyle>
    with LabelStyleMixin<RemixAvatarStyle>, IconStyleMixin<RemixAvatarStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixAvatarStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixAvatarStyle({
    BoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<AvatarSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets avatar size to a square
  RemixAvatarStyle square(double size) {
    return this.size(size, size);
  }

  /// Sets avatar size with width and height (alias)
  RemixAvatarStyle sizeWH(double width, double height) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  /// Sets background color
  RemixAvatarStyle color(Color value) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets border radius
  RemixAvatarStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(
          borderRadius: radius,
          shape: BoxShape.rectangle,
        ),
      ),
    ));
  }

  /// Sets text color
  RemixAvatarStyle textColor(Color value) {
    return label(TextStyler(style: TextStyleMix(color: value)));
  }

  /// Sets icon color
  RemixAvatarStyle iconColor(Color value) {
    return icon(IconStyler(color: value));
  }

  // Additional convenience methods that delegate to container

  /// Sets padding
  RemixAvatarStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(padding: value)));
  }

  /// Sets margin
  RemixAvatarStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixAvatarStyle decoration(DecorationMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixAvatarStyle constraints(BoxConstraintsMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(constraints: value)));
  }

  /// Sets animation
  RemixAvatarStyle animate(AnimationConfig animation) {
    return merge(RemixAvatarStyle(animation: animation));
  }

  @override
  RemixAvatarStyle label(TextStyler value) {
    return merge(RemixAvatarStyle(text: value));
  }

  @override
  RemixAvatarStyle icon(IconStyler value) {
    return merge(RemixAvatarStyle(icon: value));
  }

  // Instance methods (chainable)

  /// Sets avatar size with width and height
  @override
  RemixAvatarStyle size(double width, double height) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  @override
  RemixAvatarStyle withVariants(List<VariantStyle<AvatarSpec>> value) {
    return merge(RemixAvatarStyle(variants: value));
  }

  @override
  RemixAvatarStyle wrap(WidgetModifierConfig value) {
    return merge(RemixAvatarStyle(modifier: value));
  }

  @override
  StyleSpec<AvatarSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: AvatarSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixAvatarStyle merge(RemixAvatarStyle? other) {
    if (other == null) return this;

    return RemixAvatarStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  // Abstract method implementations for mixins (only missing ones)

  @override
  RemixAvatarStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixAvatarStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixAvatarStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}
