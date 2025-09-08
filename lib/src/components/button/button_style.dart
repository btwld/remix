part of 'button.dart';

// Private per-component constants
const _kFontSizeMd = 14.0;
const _kIconSizeMd = 16.0;
const _kIconSizeLg = 18.0;

class RemixButtonStyle extends Style<ButtonSpec>
    with
        StyleModifierMixin<RemixButtonStyle, ButtonSpec>,
        StyleVariantMixin<RemixButtonStyle, ButtonSpec>,
        ModifierStyleMixin<RemixButtonStyle, ButtonSpec>,
        BorderStyleMixin<RemixButtonStyle>,
        BorderRadiusStyleMixin<RemixButtonStyle>,
        ShadowStyleMixin<RemixButtonStyle>,
        DecorationStyleMixin<RemixButtonStyle>,
        SpacingStyleMixin<RemixButtonStyle>,
        TransformStyleMixin<RemixButtonStyle>,
        ConstraintStyleMixin<RemixButtonStyle>,
        AnimationStyleMixin<ButtonSpec, RemixButtonStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<SpinnerSpec>>? $spinner;

  const RemixButtonStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<SpinnerSpec>>? spinner,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $icon = icon,
        $spinner = spinner;

  RemixButtonStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    RemixSpinnerStyle? spinner,
    AnimationConfig? animation,
    List<VariantStyle<ButtonSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          spinner: Prop.maybeMix(spinner),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods for fluent API (return new instances)
  RemixButtonStyle label(TextStyler value) {
    return merge(RemixButtonStyle(label: value));
  }

  RemixButtonStyle icon(IconStyler value) {
    return merge(RemixButtonStyle(icon: value));
  }

  RemixButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixButtonStyle(spinner: value));
  }

  // Instance methods (chainable)

  /// Sets background color
  RemixButtonStyle color(Color value) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets padding
  RemixButtonStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets border radius
  RemixButtonStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets width
  RemixButtonStyle width(double value) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
      ),
    ));
  }

  /// Sets height
  RemixButtonStyle height(double value) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  /// Sets size (width and height)
  RemixButtonStyle size(double width, double height) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  /// Sets border
  RemixButtonStyle border(BoxBorderMix value) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
    ));
  }

  // Additional convenience methods that delegate to BoxStyler

  /// Sets margin
  RemixButtonStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixButtonStyle decoration(DecorationMix value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixButtonStyle constraints(BoxConstraintsMix value) {
    return merge(
        RemixButtonStyle(container: FlexBoxStyler(constraints: value)));
  }

  // Animate support
  RemixButtonStyle animate(AnimationConfig animation) {
    return merge(RemixButtonStyle(animation: animation));
  }

  RemixButton call({
    required String label,
    IconData? icon,
    bool enabled = true,
    bool loading = false,
    bool enableFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
  }) {
    return RemixButton(
      label: label,
      icon: icon,
      enabled: enabled,
      loading: loading,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      style: this,
    );
  }

  // Abstract method implementations for mixins (only missing ones)

  @override
  RemixButtonStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixButtonStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixButtonStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  // Variant support

  @override
  RemixButtonStyle variants(List<VariantStyle<ButtonSpec>> value) {
    return merge(RemixButtonStyle(variants: value));
  }

  // Modifier support
  @override
  RemixButtonStyle wrap(ModifierConfig value) {
    return merge(RemixButtonStyle(modifier: value));
  }

  @override
  StyleSpec<ButtonSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ButtonSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
        spinner: MixOps.resolve(context, $spinner),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixButtonStyle merge(RemixButtonStyle? other) {
    if (other == null) return this;

    return RemixButtonStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
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
        $label,
        $icon,
        $spinner,
        $variants,
        $animation,
        $modifier,
      ];
}

class RemixButtonStyles {
  /// Base button style - solid design with primary color
  static RemixButtonStyle get baseStyle => RemixButtonStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.primary(),
          ),
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
          spacing: RemixTokens.spaceSm(),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeMd,
          ),
        ),
        icon: IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeLg),
        spinner: RemixSpinnerStyle(
          size: _kIconSizeMd,
          strokeWidth: 1.5,
          color: RemixTokens.onPrimary(),
          duration: const Duration(milliseconds: 1000),
          style: SpinnerType.solid,
        ),
      )
          .onHovered(
            RemixButtonStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.8),
                ),
              ),
            ),
          )
          .onPressed(
            RemixButtonStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.9),
                ),
              ),
            ),
          )
          .onFocused(
            RemixButtonStyle(
              container: FlexBoxStyler(
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
            RemixButtonStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  color: RemixTokens.primary().withValues(alpha: 0.3),
                ),
              ),
              label: TextStyler(
                style: TextStyleMix(
                  color: RemixTokens.onPrimary().withValues(alpha: 0.7),
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
