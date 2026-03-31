part of 'icon_button.dart';

@MixableStyler()
class RemixIconButtonStyle
    extends RemixContainerStyle<RemixIconButtonSpec, RemixIconButtonStyle>
    with
        IconStyleMixin<RemixIconButtonStyle>,
        Diagnosticable,
        _$RemixIconButtonStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;
  @MixableField(setterType: RemixSpinnerStyle)
  final Prop<StyleSpec<RemixSpinnerSpec>>? $spinner;

  const RemixIconButtonStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<RemixSpinnerSpec>>? spinner,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $icon = icon,
       $spinner = spinner;

  RemixIconButtonStyle({
    BoxStyler? container,
    IconStyler? icon,
    RemixSpinnerStyle? spinner,
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
  RemixIconButtonStyle color(Color value) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the background color of the icon button container.
  RemixIconButtonStyle backgroundColor(Color value) {
    return color(value);
  }

  /// Sets the foreground color (icon color) of the icon button.
  RemixIconButtonStyle foregroundColor(Color value) {
    return iconColor(value);
  }

  /// Sets padding
  RemixIconButtonStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(padding: value)));
  }

  /// Sets border radius
  RemixIconButtonStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets size (width and height - icon buttons are square)
  RemixIconButtonStyle iconButtonSize(double size) {
    return merge(
      RemixIconButtonStyle(
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
  RemixIconButtonStyle border(BoxBorderMix value) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(decoration: BoxDecorationMix(border: value)),
      ),
    );
  }

  /// Sets the minimum size of the icon button.
  RemixIconButtonStyle minimumSize(Size value) {
    return merge(
      RemixIconButtonStyle().constraintsOnly(
        minHeight: value.height,
        minWidth: value.width,
      ),
    );
  }

  /// Sets the maximum size of the icon button.
  RemixIconButtonStyle maximumSize(Size value) {
    return merge(
      RemixIconButtonStyle().constraintsOnly(
        maxHeight: value.height,
        maxWidth: value.width,
      ),
    );
  }

  /// Sets the shape of the icon button.
  RemixIconButtonStyle shape(ShapeBorderMix value) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Sets the shadow of the icon button.
  @override
  RemixIconButtonStyle shadow(BoxShadowMix value) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(boxShadow: [value]),
        ),
      ),
    );
  }

  // Additional convenience methods

  /// Sets margin
  RemixIconButtonStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixIconButtonStyle alignment(Alignment value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets decoration
  RemixIconButtonStyle decoration(DecorationMix value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  @override
  RemixIconButtonStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixIconButtonStyle(container: BoxStyler(constraints: value)),
    );
  }

  /// Sets icon color
  RemixIconButtonStyle iconColor(Color value) {
    return icon(IconStyler(color: value));
  }

  /// Sets icon size
  RemixIconButtonStyle iconSize(double value) {
    return merge(RemixIconButtonStyle(icon: IconStyler(size: value)));
  }

  /// Sets width
  RemixIconButtonStyle width(double value) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets height
  RemixIconButtonStyle height(double value) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  RemixIconButton call({
    required IconData icon,
    required VoidCallback? onPressed,
    bool loading = false,
    bool enableFeedback = true,
    FocusNode? focusNode,
  }) {
    return RemixIconButton(
      style: this,
      icon: icon,
      loading: loading,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixIconButtonStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixIconButtonStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixIconButtonStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixIconButtonStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
