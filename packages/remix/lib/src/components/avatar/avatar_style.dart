part of 'avatar.dart';

@MixableStyler()
class RemixAvatarStyle
    extends RemixContainerStyle<RemixAvatarSpec, RemixAvatarStyle>
    with
        LabelStyleMixin<RemixAvatarStyle>,
        IconStyleMixin<RemixAvatarStyle>,
        Diagnosticable,
        _$RemixAvatarStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $text;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixAvatarStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $text = text,
       $icon = icon;

  RemixAvatarStyle({
    BoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixAvatarSpec>>? variants,
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
    return merge(
      RemixAvatarStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  /// Sets background color
  RemixAvatarStyle color(Color value) {
    return merge(
      RemixAvatarStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets border radius
  RemixAvatarStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixAvatarStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: radius,
            shape: BoxShape.rectangle,
          ),
        ),
      ),
    );
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

  /// Sets container alignment
  RemixAvatarStyle alignment(Alignment value) {
    return merge(RemixAvatarStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets decoration
  RemixAvatarStyle decoration(DecorationMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixAvatarStyle constraints(BoxConstraintsMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(constraints: value)));
  }

  /// Sets the clip behavior for the avatar container.
  RemixAvatarStyle clipBehavior(Clip clip) {
    return merge(RemixAvatarStyle(container: BoxStyler(clipBehavior: clip)));
  }

  @override
  RemixAvatarStyle label(TextStyler value) {
    return merge(RemixAvatarStyle(text: value));
  }

  // Instance methods (chainable)

  /// Sets avatar size with width and height
  @override
  RemixAvatarStyle size(double width, double height) {
    return merge(
      RemixAvatarStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
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
    return merge(
      RemixAvatarStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
