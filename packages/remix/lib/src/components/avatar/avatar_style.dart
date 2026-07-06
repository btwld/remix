part of 'avatar.dart';

/// Style configuration for [RemixAvatar] container, label, and fallback icon.
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
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixAvatarStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixAvatarStyle({
    BoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixAvatarSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  // -- Factory constructors for convenience --

  /// Creates a style with the given foreground color (text and icon).
  factory RemixAvatarStyle.foregroundColor(Color value) =>
      RemixAvatarStyle().foregroundColor(value);

  /// Creates a style with the given background color.
  factory RemixAvatarStyle.backgroundColor(Color value) =>
      RemixAvatarStyle().backgroundColor(value);

  /// Creates a style with the given padding.
  factory RemixAvatarStyle.padding(EdgeInsetsGeometryMix value) =>
      RemixAvatarStyle().padding(value);

  /// Creates a style with the given margin.
  factory RemixAvatarStyle.margin(EdgeInsetsGeometryMix value) =>
      RemixAvatarStyle().margin(value);

  /// Creates a style with the given decoration.
  factory RemixAvatarStyle.decoration(DecorationMix value) =>
      RemixAvatarStyle().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixAvatarStyle.alignment(Alignment value) =>
      RemixAvatarStyle().alignment(value);

  /// Creates a style with the given constraints.
  factory RemixAvatarStyle.constraints(BoxConstraintsMix value) =>
      RemixAvatarStyle().constraints(value);

  /// Creates a style with a square size.
  factory RemixAvatarStyle.square(double size) =>
      RemixAvatarStyle().square(size);

  /// Creates a style with the given border radius.
  factory RemixAvatarStyle.borderRadius(BorderRadiusGeometryMix radius) =>
      RemixAvatarStyle().borderRadius(radius);

  /// Creates a style with the given clip behavior.
  factory RemixAvatarStyle.clipBehavior(Clip clip) =>
      RemixAvatarStyle().clipBehavior(clip);

  // -- Instance methods --

  /// Sets the foreground color (text and icon) of the avatar.
  RemixAvatarStyle foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets the background color of the avatar.
  RemixAvatarStyle backgroundColor(Color value) {
    return color(value);
  }

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
          decoration: BoxDecorationMix(borderRadius: radius, shape: .rectangle),
        ),
      ),
    );
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
    return merge(RemixAvatarStyle(label: value));
  }

  /// Creates a [RemixAvatar] widget with this style applied.
  RemixAvatar call({
    Key? key,
    ImageProvider? backgroundImage,
    ImageProvider? foregroundImage,
    ImageErrorListener? onBackgroundImageError,
    ImageErrorListener? onForegroundImageError,
    Widget? child,
    String? label,
    RemixAvatarLabelBuilder? labelBuilder,
    IconData? icon,
    RemixAvatarIconBuilder? iconBuilder,
  }) {
    return RemixAvatar(
      key: key,
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      onBackgroundImageError: onBackgroundImageError,
      onForegroundImageError: onForegroundImageError,
      child: child,
      label: label,
      labelBuilder: labelBuilder,
      icon: icon,
      iconBuilder: iconBuilder,
      style: this,
    );
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
