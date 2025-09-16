part of 'icon_button.dart';



class RemixIconButtonStyle
    extends RemixContainerStyle<IconButtonSpec, RemixIconButtonStyle>
    with IconStyleMixin<RemixIconButtonStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<SpinnerSpec>>? $spinner;

  const RemixIconButtonStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<SpinnerSpec>>? spinner,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $icon = icon,
        $spinner = spinner;

  RemixIconButtonStyle({
    BoxStyler? container,
    IconStyler? icon,
    RemixSpinnerStyle? spinner,
    AnimationConfig? animation,
    List<VariantStyle<IconButtonSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          icon: Prop.maybeMix(icon),
          spinner: Prop.maybeMix(spinner),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods for fluent API
  RemixIconButtonStyle icon(IconStyler value) {
    return merge(RemixIconButtonStyle(icon: value));
  }

  RemixIconButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixIconButtonStyle(spinner: value));
  }

  // Instance methods (chainable)

  /// Sets background color
  RemixIconButtonStyle color(Color value) {
    return merge(RemixIconButtonStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets padding
  RemixIconButtonStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(padding: value)));
  }

  /// Sets border radius
  RemixIconButtonStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixIconButtonStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets size (width and height - icon buttons are square)
  RemixIconButtonStyle iconButtonSize(double size) {
    return merge(RemixIconButtonStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: size,
          maxWidth: size,
          minHeight: size,
          maxHeight: size,
        ),
      ),
    ));
  }

  /// Sets border
  RemixIconButtonStyle border(BoxBorderMix value) {
    return merge(RemixIconButtonStyle(
      container: BoxStyler(decoration: BoxDecorationMix(border: value)),
    ));
  }

  // Additional convenience methods

  /// Sets margin
  RemixIconButtonStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixIconButtonStyle decoration(DecorationMix value) {
    return merge(RemixIconButtonStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixIconButtonStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixIconButtonStyle(container: BoxStyler(constraints: value)),
    );
  }

  /// Sets icon color
  RemixIconButtonStyle iconColor(Color value) {
    return merge(RemixIconButtonStyle(icon: IconStyler(color: value)));
  }

  /// Sets icon size
  RemixIconButtonStyle iconSize(double value) {
    return merge(RemixIconButtonStyle(icon: IconStyler(size: value)));
  }

  /// Sets width
  RemixIconButtonStyle width(double value) {
    return merge(RemixIconButtonStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
      ),
    ));
  }

  /// Sets height
  RemixIconButtonStyle height(double value) {
    return merge(RemixIconButtonStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  // Animation support
  RemixIconButtonStyle animate(AnimationConfig animation) {
    return merge(RemixIconButtonStyle(animation: animation));
  }

  RemixIconButton call({
    required IconData icon,
    bool enabled = true,
    bool loading = false,
    bool enableFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
  }) {
    return RemixIconButton(
      icon: icon,
      enabled: enabled,
      loading: loading,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      style: this,
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
    return merge(RemixIconButtonStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  // Variant support

  @override
  RemixIconButtonStyle withVariants(List<VariantStyle<IconButtonSpec>> value) {
    return merge(RemixIconButtonStyle(variants: value));
  }

  // Modifier support
  @override
  RemixIconButtonStyle wrap(WidgetModifierConfig value) {
    return merge(RemixIconButtonStyle(modifier: value));
  }

  @override
  StyleSpec<IconButtonSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: IconButtonSpec(
        container: MixOps.resolve(context, $container),
        icon: MixOps.resolve(context, $icon),
        spinner: MixOps.resolve(context, $spinner),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixIconButtonStyle merge(RemixIconButtonStyle? other) {
    if (other == null) return this;

    return RemixIconButtonStyle.create(
      container: MixOps.merge($container, other.$container),
      icon: MixOps.merge($icon, other.$icon),
      spinner: MixOps.merge($spinner, other.$spinner),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $icon,
        $spinner,
        $variants,
        $animation,
        $modifier,
      ];
}


