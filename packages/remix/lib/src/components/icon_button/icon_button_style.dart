part of 'icon_button.dart';

/// Style configuration for [RemixIconButton] container, icon, and loading spinner.
@MixableStyler()
class RemixIconButtonStyler
    extends RemixContainerStyler<RemixIconButtonSpec, RemixIconButtonStyler>
    with
        IconStyleMixin<RemixIconButtonStyler>,
        Diagnosticable,
        _$RemixIconButtonStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;
  @MixableField(setterType: RemixSpinnerStyler)
  final Prop<StyleSpec<RemixSpinnerSpec>>? $spinner;

  const RemixIconButtonStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<RemixSpinnerSpec>>? spinner,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $icon = icon,
       $spinner = spinner;

  RemixIconButtonStyler({
    BoxStyler? container,
    IconStyler? icon,
    RemixSpinnerStyler? spinner,
    AnimationConfig? animation,
    List<VariantStyle<RemixIconButtonSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         icon: Prop.maybeMix(icon),
         spinner: Prop.maybeMix(spinner),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  // Instance methods (chainable)

  /// Sets background color
  RemixIconButtonStyler color(Color value) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the background color of the icon button container.
  RemixIconButtonStyler backgroundColor(Color value) {
    return color(value);
  }

  /// Sets the foreground color (icon color) of the icon button.
  RemixIconButtonStyler foregroundColor(Color value) {
    return iconColor(value);
  }

  /// Sets padding
  RemixIconButtonStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixIconButtonStyler(container: BoxStyler(padding: value)));
  }

  /// Sets border radius
  RemixIconButtonStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets size (width and height - icon buttons are square)
  RemixIconButtonStyler iconButtonSize(double size) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: size,
            maxWidth: size,
            minHeight: size,
            maxHeight: size,
          ),
        ),
      ),
    );
  }

  /// Sets border
  RemixIconButtonStyler border(BoxBorderMix value) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(decoration: BoxDecorationMix(border: value)),
      ),
    );
  }

  /// Sets the minimum size of the icon button.
  RemixIconButtonStyler minimumSize(Size value) {
    return merge(
      RemixIconButtonStyler().constraintsOnly(
        minWidth: value.width,
        minHeight: value.height,
      ),
    );
  }

  /// Sets the maximum size of the icon button.
  RemixIconButtonStyler maximumSize(Size value) {
    return merge(
      RemixIconButtonStyler().constraintsOnly(
        maxWidth: value.width,
        maxHeight: value.height,
      ),
    );
  }

  /// Sets the shape of the icon button.
  RemixIconButtonStyler shape(ShapeBorderMix value) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  // Additional convenience methods

  /// Sets margin
  RemixIconButtonStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixIconButtonStyler(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixIconButtonStyler alignment(Alignment value) {
    return merge(RemixIconButtonStyler(container: BoxStyler(alignment: value)));
  }

  /// Sets decoration
  RemixIconButtonStyler decoration(DecorationMix value) {
    return merge(
      RemixIconButtonStyler(container: BoxStyler(decoration: value)),
    );
  }

  /// Sets icon color
  RemixIconButtonStyler iconColor(Color value) {
    return icon(IconStyler(color: value));
  }

  /// Sets icon size
  RemixIconButtonStyler iconSize(double value) {
    return merge(RemixIconButtonStyler(icon: IconStyler(size: value)));
  }

  /// Sets width
  RemixIconButtonStyler width(double value) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets height
  RemixIconButtonStyler height(double value) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  RemixIconButton call({
    Key? key,
    required IconData icon,
    RemixIconButtonIconBuilder? iconBuilder,
    RemixIconButtonLoadingBuilder? loadingBuilder,
    bool loading = false,
    bool enabled = true,
    bool enableFeedback = true,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    String? semanticHint,
    bool excludeSemantics = false,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixIconButton(
      key: key,
      icon: icon,
      iconBuilder: iconBuilder,
      loadingBuilder: loadingBuilder,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      onLongPress: onLongPress,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
      style: this,
    );
  }

  /// Sets the shadow of the icon button.
  @override
  RemixIconButtonStyler shadow(BoxShadowMix value) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(decoration: BoxDecorationMix(boxShadow: [value])),
      ),
    );
  }

  /// Sets constraints
  @override
  RemixIconButtonStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixIconButtonStyler(container: BoxStyler(constraints: value)),
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixIconButtonStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixIconButtonStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixIconButtonStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixIconButtonStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
