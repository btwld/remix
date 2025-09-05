part of 'button.dart';

// Private per-component constants (no shared tokens)
const _kBlack = Color(0xFF000000);
const _kWhite = Color(0xFFFFFFFF);
const _kDisabled = Color(0xFF9E9E9E);

const _kSpaceXs = 4.0;
const _kSpaceSm = 8.0;
const _kSpaceMd = 12.0;
const _kSpaceLg = 16.0;

const _kRadiusLg = 8.0;

const _kFontSizeSm = 12.0;
const _kFontSizeMd = 14.0;
const _kFontSizeLg = 16.0;

const _kIconSizeSm = 14.0;
const _kIconSizeMd = 16.0;
const _kIconSizeLg = 18.0;
const _kIconSizeXl = 20.0;

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
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<LabelSpec>>? $label;
  final Prop<StyleSpec<SpinnerSpec>>? $spinner;

  const RemixButtonStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<LabelSpec>>? label,
    Prop<StyleSpec<SpinnerSpec>>? spinner,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $spinner = spinner;

  RemixButtonStyle({
    BoxStyler? container,
    RemixLabelStyle? label,
    RemixSpinnerStyle? spinner,
    AnimationConfig? animation,
    List<VariantStyle<ButtonSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          spinner: Prop.maybeMix(spinner),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods for fluent API (return new instances)
  RemixButtonStyle label(RemixLabelStyle value) {
    return merge(RemixButtonStyle(label: value));
  }

  RemixButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixButtonStyle(spinner: value));
  }

  // Instance methods (chainable)

  /// Sets background color
  RemixButtonStyle color(Color value) {
    return merge(RemixButtonStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets padding
  RemixButtonStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixButtonStyle(container: BoxStyler(padding: value)));
  }

  /// Sets border radius
  RemixButtonStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixButtonStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets width
  RemixButtonStyle width(double value) {
    return merge(RemixButtonStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
      ),
    ));
  }

  /// Sets height
  RemixButtonStyle height(double value) {
    return merge(RemixButtonStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  /// Sets size (width and height)
  RemixButtonStyle size(double width, double height) {
    return merge(RemixButtonStyle(
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

  /// Sets border
  RemixButtonStyle border(BoxBorderMix value) {
    return merge(RemixButtonStyle(
      container: BoxStyler(decoration: BoxDecorationMix(border: value)),
    ));
  }

  // Additional convenience methods that delegate to BoxStyler

  /// Sets margin
  RemixButtonStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixButtonStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixButtonStyle decoration(DecorationMix value) {
    return merge(RemixButtonStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixButtonStyle constraints(BoxConstraintsMix value) {
    return merge(RemixButtonStyle(container: BoxStyler(constraints: value)));
  }

  // Icon control methods

  /// Sets base icon styling for the label's icon
  RemixButtonStyle icon(IconStyler value) {
    return merge(RemixButtonStyle(label: RemixLabelStyle(icon: value)));
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
      RemixButtonStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixButtonStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixButtonStyle(
      container: BoxStyler(alignment: alignment, transform: value),
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
        $spinner,
        $variants,
        $animation,
        $modifier,
      ];
}

class RemixButtonStyles {
  /// Large size variant
  static RemixButtonStyle get large => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceLg),
          constraints: BoxConstraintsMix(minHeight: 48),
        ),
        label: RemixLabelStyle(
          label: TextStyler(style: TextStyleMix(fontSize: _kFontSizeLg)),
          icon: IconStyler(size: _kIconSizeXl),
          flex: FlexStyler(spacing: _kSpaceMd),
        ),
      );

  /// Small size variant
  static RemixButtonStyle get small => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceXs),
          constraints: BoxConstraintsMix(minHeight: 32),
        ),
        label: RemixLabelStyle(
          label: TextStyler(style: TextStyleMix(fontSize: _kFontSizeSm)),
          icon: IconStyler(size: _kIconSizeSm),
          flex: FlexStyler(spacing: _kSpaceXs),
        ),
      );

  /// Outline button style - white background with black border and black text/icon
  static RemixButtonStyle get outline => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceMd),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 1)),
            borderRadius: BorderRadiusMix.circular(_kRadiusLg),
            color: _kWhite.withValues(alpha: 0.0),
          ),
        ),
        label: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(color: _kBlack, fontSize: _kFontSizeMd),
          ),
          icon: IconStyler(color: _kBlack, size: _kIconSizeLg),
          flex: FlexStyler(spacing: _kSpaceSm),
        ),
        spinner: RemixSpinnerStyle(
          size: _kIconSizeMd,
          strokeWidth: 1.5,
          color: _kBlack,
          duration: const Duration(milliseconds: 1000),
          style: SpinnerType.solid,
        ),
      )
          .onHovered(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(color: _kBlack, width: 1.5),
                  ),
                  color: _kBlack.withValues(alpha: 0.05),
                ),
              ),
            ),
          )
          .onPressed(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border:
                      BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 2)),
                  color: _kBlack.withValues(alpha: 0.1),
                ),
              ),
            ),
          )
          .onFocused(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border:
                      BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 2)),
                ),
              ),
            ),
          )
          .onDisabled(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: _kDisabled.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
              label: RemixLabelStyle(
                label: TextStyler(style: TextStyleMix(color: _kDisabled)),
                icon: IconStyler(color: _kDisabled),
              ),
              spinner: RemixSpinnerStyle(color: _kDisabled),
            ),
          );

  /// Solid button style (default) - black background with white text/icon
  static RemixButtonStyle get solid => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceMd),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusLg),
            color: _kBlack,
          ),
        ),
        label: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix(color: _kWhite, fontSize: _kFontSizeMd),
          ),
          icon: IconStyler(color: _kWhite, size: _kIconSizeLg),
          flex: FlexStyler(spacing: _kSpaceSm),
        ),
        spinner: RemixSpinnerStyle(
          size: _kIconSizeMd,
          strokeWidth: 1.5,
          color: _kWhite,
          duration: const Duration(milliseconds: 1000),
          style: SpinnerType.solid,
        ),
      )
          .onHovered(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: _kBlack.withValues(alpha: 0.8),
                ),
              ),
            ),
          )
          .onPressed(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  color: _kBlack.withValues(alpha: 0.9),
                ),
              ),
            ),
          )
          .onFocused(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(
                  border: BoxBorderMix.all(
                    BorderSideMix(
                      color: _kBlack.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          )
          .onDisabled(
            RemixButtonStyle(
              container: BoxStyler(
                decoration: BoxDecorationMix(color: _kDisabled),
              ),
              label: RemixLabelStyle(
                label: TextStyler(
                  style: TextStyleMix(color: _kWhite.withValues(alpha: 0.7)),
                ),
                icon: IconStyler(color: _kWhite.withValues(alpha: 0.7)),
              ),
              spinner: RemixSpinnerStyle(
                color: _kWhite.withValues(alpha: 0.7),
              ),
            ),
          );

  /// Medium size variant
  static RemixButtonStyle get medium => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceSm),
          constraints: BoxConstraintsMix(minHeight: 40),
        ),
        label: RemixLabelStyle(
          label: TextStyler(style: TextStyleMix(fontSize: _kFontSizeMd)),
          icon: IconStyler(size: _kIconSizeMd),
          flex: FlexStyler(spacing: _kSpaceSm),
        ),
      );

  /// Default button style alias
  static RemixButtonStyle get defaultStyle => solid;
}
