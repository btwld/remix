part of 'button.dart';

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
  // Helper methods to create variants
  static RemixButtonStyle _createVariant(Color bgColor, Color fgColor) {
    return RemixButtonStyle(
      container: BoxStyler(
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: bgColor,
        ),
      ),
      label: RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix.color(fgColor).fontSize(RemixTokens.fontSizeMd()),
        ),
        icon: IconStyler(color: fgColor, size: RemixTokens.iconSizeLg()),
        flex: FlexStyler(spacing: RemixTokens.spaceSm()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(color: _darkenColor(bgColor, 0.1)),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(color: _darkenColor(bgColor, 0.2)),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle().border(
            BoxBorderMix.all(
              BorderSideMix(color: bgColor.withValues(alpha: 0.5), width: 2),
            ),
          ),
        )
        .onDisabled(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                color: RemixTokens.textDisabled(),
              ),
            ),
            label: RemixLabelStyle(
              label: TextStyler(
                style: TextStyleMix.color(RemixTokens.textTertiary()),
              ),
              icon: IconStyler(color: RemixTokens.textTertiary()),
            ),
          ),
        );
  }

  static RemixButtonStyle _createOutlineVariant(Color color) {
    return RemixButtonStyle(
      container: BoxStyler(
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
        decoration: BoxDecorationMix(
          border: BoxBorderMix.all(BorderSideMix(color: color, width: 1)),
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: RemixTokens.surface().withValues(alpha: 0.0),
        ),
      ),
      label: RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix.color(color).fontSize(RemixTokens.fontSizeMd()),
        ),
        icon: IconStyler(color: color, size: RemixTokens.iconSizeLg()),
        flex: FlexStyler(spacing: RemixTokens.spaceSm()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: color, width: 1.5),
                ),
                color: color.withValues(alpha: 0.05),
              ),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(BorderSideMix(color: color, width: 2)),
                color: color.withValues(alpha: 0.1),
              ),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(BorderSideMix(color: color, width: 2)),
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
                    color: RemixTokens.textDisabled().withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
            label: RemixLabelStyle(
              label: TextStyler(
                style: TextStyleMix.color(RemixTokens.textDisabled()),
              ),
              icon: IconStyler(color: RemixTokens.textDisabled()),
            ),
          ),
        );
  }

  static RemixButtonStyle _createGhostVariant(Color color) {
    return RemixButtonStyle(
      container: BoxStyler(
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: RemixTokens.surface().withValues(alpha: 0.0),
        ),
      ),
      label: RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix.color(color).fontSize(RemixTokens.fontSizeMd()),
        ),
        icon: IconStyler(color: color, size: RemixTokens.iconSizeLg()),
        flex: FlexStyler(spacing: RemixTokens.spaceSm()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: BoxStyler(
              decoration:
                  BoxDecorationMix(color: color.withValues(alpha: 0.08)),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: BoxStyler(
              decoration:
                  BoxDecorationMix(color: color.withValues(alpha: 0.12)),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(
                    color: color.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                color: color.withValues(alpha: 0.05),
              ),
            ),
          ),
        )
        .onDisabled(
          RemixButtonStyle(
            label: RemixLabelStyle(
              label: TextStyler(
                style: TextStyleMix.color(RemixTokens.textDisabled()),
              ),
              icon: IconStyler(color: RemixTokens.textDisabled()),
            ),
          ),
        );
  }

  static RemixButtonStyle _createSoftVariant(Color color) {
    return RemixButtonStyle(
      container: BoxStyler(
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: color.withValues(alpha: 0.1),
        ),
      ),
      label: RemixLabelStyle(
        label: TextStyler(
          style: TextStyleMix.color(color).fontSize(RemixTokens.fontSizeMd()),
        ),
        icon: IconStyler(color: color, size: RemixTokens.iconSizeLg()),
        flex: FlexStyler(spacing: RemixTokens.spaceSm()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: BoxStyler(
              decoration:
                  BoxDecorationMix(color: color.withValues(alpha: 0.15)),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(color: color.withValues(alpha: 0.2)),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(
                    color: color.withValues(alpha: 0.5),
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
              decoration: BoxDecorationMix(
                color: RemixTokens.textDisabled().withValues(alpha: 0.1),
              ),
            ),
            label: RemixLabelStyle(
              label: TextStyler(
                style: TextStyleMix.color(RemixTokens.textDisabled()),
              ),
              icon: IconStyler(color: RemixTokens.textDisabled()),
            ),
          ),
        );
  } // Helper function to darken colors for hover/pressed states

  static Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);

    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Default button style
  static RemixButtonStyle get defaultStyle => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.primary(),
          ),
        ),
        label: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix.color(RemixTokens.surface())
                .fontSize(RemixTokens.fontSizeMd()),
          ),
          icon: IconStyler(
            color: RemixTokens.surface(),
            size: RemixTokens.iconSizeLg(),
          ),
          flex: FlexStyler(spacing: RemixTokens.spaceSm()),
        ),
        spinner: RemixSpinnerStyle(
          size: RemixTokens.iconSizeMd(),
          strokeWidth: 1.5,
          color: RemixTokens.surface(),
          duration: const Duration(milliseconds: 1000),
          style: SpinnerType.solid,
        ),
      );

  // Primary colors
  static RemixButtonStyle get primary =>
      _createVariant(RemixTokens.primary(), RemixTokens.surface());
  static RemixButtonStyle get secondary =>
      _createVariant(RemixTokens.secondary(), RemixTokens.surface());
  static RemixButtonStyle get success =>
      _createVariant(RemixTokens.success(), RemixTokens.surface());
  static RemixButtonStyle get danger =>
      _createVariant(RemixTokens.danger(), RemixTokens.surface());

  static RemixButtonStyle get warning => _createVariant(
        RemixTokens.warning(),
        RemixTokens.surface(),
      ); // Outline variants
  static RemixButtonStyle get primaryOutline =>
      _createOutlineVariant(RemixTokens.primary());
  static RemixButtonStyle get secondaryOutline =>
      _createOutlineVariant(RemixTokens.secondary());
  static RemixButtonStyle get successOutline =>
      _createOutlineVariant(RemixTokens.success());

  static RemixButtonStyle get dangerOutline => _createOutlineVariant(
        RemixTokens.danger(),
      ); // Ghost variants (no background, no border)
  static RemixButtonStyle get primaryGhost =>
      _createGhostVariant(RemixTokens.primary());
  static RemixButtonStyle get secondaryGhost =>
      _createGhostVariant(RemixTokens.secondary());
  static RemixButtonStyle get successGhost =>
      _createGhostVariant(RemixTokens.success());

  static RemixButtonStyle get dangerGhost =>
      _createGhostVariant(RemixTokens.danger());

  // Soft variants (subtle background)
  static RemixButtonStyle get primarySoft =>
      _createSoftVariant(RemixTokens.primary());

  static RemixButtonStyle get secondarySoft =>
      _createSoftVariant(RemixTokens.secondary());

  static RemixButtonStyle get successSoft =>
      _createSoftVariant(RemixTokens.success());
  static RemixButtonStyle get dangerSoft =>
      _createSoftVariant(RemixTokens.danger());

  // Size variants
  static RemixButtonStyle get small => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceXs()),
          constraints: BoxConstraintsMix(minHeight: 32),
        ),
        label: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix.fontSize(RemixTokens.fontSizeSm()),
          ),
          icon: IconStyler(size: RemixTokens.iconSizeSm()),
          flex: FlexStyler(spacing: RemixTokens.spaceXs()),
        ),
      );

  static RemixButtonStyle get medium => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceSm()),
          constraints: BoxConstraintsMix(minHeight: 40),
        ),
        label: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix.fontSize(RemixTokens.fontSizeMd()),
          ),
          icon: IconStyler(size: RemixTokens.iconSizeMd()),
          flex: FlexStyler(spacing: RemixTokens.spaceSm()),
        ),
      );

  static RemixButtonStyle get large => RemixButtonStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
          constraints: BoxConstraintsMix(minHeight: 48),
        ),
        label: RemixLabelStyle(
          label: TextStyler(
            style: TextStyleMix.fontSize(RemixTokens.fontSizeLg()),
          ),
          icon: IconStyler(size: RemixTokens.iconSizeXl()),
          flex: FlexStyler(spacing: RemixTokens.spaceMd()),
        ),
      );

  // Legacy aliases for backward compatibility
  static RemixButtonStyle get outline => primaryOutline;

  static RemixButtonStyle get ghost => primaryGhost;
}
