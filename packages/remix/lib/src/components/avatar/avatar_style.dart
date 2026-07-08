part of 'avatar.dart';

/// Style configuration for [RemixAvatar] container, label, and fallback icon.
@MixableStyler()
class RemixAvatarStyler
    extends RemixContainerStyler<RemixAvatarSpec, RemixAvatarStyler>
    with
        LabelStyleMixin<RemixAvatarStyler>,
        IconStyleMixin<RemixAvatarStyler>,
        Diagnosticable,
        _$RemixAvatarStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixAvatarStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixAvatarStyler({
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
  factory RemixAvatarStyler.foregroundColor(Color value) =>
      RemixAvatarStyler().foregroundColor(value);

  /// Creates a style with the given background color.
  factory RemixAvatarStyler.backgroundColor(Color value) =>
      RemixAvatarStyler().backgroundColor(value);

  /// Creates a style with the given padding.
  factory RemixAvatarStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixAvatarStyler().padding(value);

  /// Creates a style with the given margin.
  factory RemixAvatarStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixAvatarStyler().margin(value);

  /// Creates a style with the given decoration.
  factory RemixAvatarStyler.decoration(DecorationMix value) =>
      RemixAvatarStyler().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixAvatarStyler.alignment(Alignment value) =>
      RemixAvatarStyler().alignment(value);

  /// Creates a style with the given constraints.
  factory RemixAvatarStyler.constraints(BoxConstraintsMix value) =>
      RemixAvatarStyler().constraints(value);

  /// Creates a style with a square size.
  factory RemixAvatarStyler.square(double size) =>
      RemixAvatarStyler().square(size);

  /// Creates a style with the given border radius.
  factory RemixAvatarStyler.borderRadius(BorderRadiusGeometryMix radius) =>
      RemixAvatarStyler().borderRadius(radius);

  /// Creates a style with the given clip behavior.
  factory RemixAvatarStyler.clipBehavior(Clip clip) =>
      RemixAvatarStyler().clipBehavior(clip);

  // -- Instance methods --

  /// Sets the foreground color (text and icon) of the avatar.
  RemixAvatarStyler foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets the background color of the avatar.
  RemixAvatarStyler backgroundColor(Color value) {
    return color(value);
  }

  /// Sets avatar size to a square
  RemixAvatarStyler square(double size) {
    return this.size(size, size);
  }

  /// Sets avatar size with width and height (alias)
  RemixAvatarStyler sizeWH(double width, double height) {
    return merge(
      RemixAvatarStyler(
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
  RemixAvatarStyler color(Color value) {
    return merge(
      RemixAvatarStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets border radius
  RemixAvatarStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixAvatarStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius, shape: .rectangle),
        ),
      ),
    );
  }

  // Additional convenience methods that delegate to container

  /// Sets padding
  RemixAvatarStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAvatarStyler(container: BoxStyler(padding: value)));
  }

  /// Sets margin
  RemixAvatarStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAvatarStyler(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixAvatarStyler alignment(Alignment value) {
    return merge(RemixAvatarStyler(container: BoxStyler(alignment: value)));
  }

  /// Sets decoration
  RemixAvatarStyler decoration(DecorationMix value) {
    return merge(RemixAvatarStyler(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixAvatarStyler constraints(BoxConstraintsMix value) {
    return merge(RemixAvatarStyler(container: BoxStyler(constraints: value)));
  }

  /// Sets the clip behavior for the avatar container.
  RemixAvatarStyler clipBehavior(Clip clip) {
    return merge(RemixAvatarStyler(container: BoxStyler(clipBehavior: clip)));
  }

  @override
  RemixAvatarStyler label(TextStyler value) {
    return merge(RemixAvatarStyler(label: value));
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
  RemixAvatarStyler size(double width, double height) {
    return merge(
      RemixAvatarStyler(
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
  RemixAvatarStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixAvatarStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixAvatarStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixAvatarStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
