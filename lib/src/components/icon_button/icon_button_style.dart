part of 'icon_button.dart';

// Private per-component constants
const _kIconSizeMd = 16.0;
const _kIconButtonSize = 40.0;

class RemixIconButtonStyle extends Style<IconButtonSpec>
    with
        StyleModifierMixin<RemixIconButtonStyle, IconButtonSpec>,
        StyleVariantMixin<RemixIconButtonStyle, IconButtonSpec>,
        ModifierStyleMixin<RemixIconButtonStyle, IconButtonSpec>,
        BorderStyleMixin<RemixIconButtonStyle>,
        BorderRadiusStyleMixin<RemixIconButtonStyle>,
        ShadowStyleMixin<RemixIconButtonStyle>,
        DecorationStyleMixin<RemixIconButtonStyle>,
        SpacingStyleMixin<RemixIconButtonStyle>,
        TransformStyleMixin<RemixIconButtonStyle>,
        AnimationStyleMixin<IconButtonSpec, RemixIconButtonStyle> {
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
    ModifierConfig? modifier,
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
        RemixIconButtonStyle(container: BoxStyler(constraints: value)));
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
  RemixIconButtonStyle variants(List<VariantStyle<IconButtonSpec>> value) {
    return merge(RemixIconButtonStyle(variants: value));
  }

  // Modifier support
  @override
  RemixIconButtonStyle wrap(ModifierConfig value) {
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

class RemixIconButtonStyles {
  /// Base icon button style - square design with centered icon
  static RemixIconButtonStyle get baseStyle => RemixIconButtonStyle(
        container: BoxStyler(
          alignment: Alignment.center, // Center the icon
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceSm()),
          constraints: BoxConstraintsMix(
            minWidth: _kIconButtonSize,
            maxWidth: _kIconButtonSize,
            minHeight: _kIconButtonSize,
            maxHeight: _kIconButtonSize,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.primary(),
          ),
        ),
        icon: IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeMd),
        spinner: RemixSpinnerStyle(
          size: _kIconSizeMd,
          strokeWidth: 1.5,
          color: RemixTokens.onPrimary(),
          duration: const Duration(milliseconds: 1000),
          style: SpinnerType.solid,
        ),
      )
          .onHovered(
            RemixIconButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.8),
                ),
              ),
            ),
          )
          .onPressed(
            RemixIconButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.9),
                ),
              ),
            ),
          )
          .onFocused(
            RemixIconButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: RemixTokens.primary().withValues(alpha: 0.40),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          )
          .onDisabled(
            RemixIconButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.3),
                ),
              ),
              icon: IconStyler(
                color: RemixTokens.onPrimary().withValues(alpha: 0.7),
              ),
              spinner: RemixSpinnerStyle(
                color: RemixTokens.onPrimary().withValues(alpha: 0.7),
              ),
            ),
          );
}
