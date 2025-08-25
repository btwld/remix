part of 'button.dart';

class RemixButtonStyle extends Style<ButtonSpec>
    with
        StyleModifierMixin<RemixButtonStyle, ButtonSpec>,
        StyleVariantMixin<RemixButtonStyle, ButtonSpec> {
  final Prop<ContainerSpec>? $container;
  final Prop<LabelSpec>? $label;
  final Prop<SpinnerSpec>? $spinner;

  const RemixButtonStyle.create({
    Prop<ContainerSpec>? container,
    Prop<LabelSpec>? label,
    Prop<SpinnerSpec>? spinner,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $label = label,
        $spinner = spinner;

  RemixButtonStyle({
    ContainerSpecMix? container,
    RemixLabelStyle? label,
    RemixSpinnerStyle? spinner,
    AnimationConfig? animation,
    List<VariantStyle<ButtonSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          label: label != null ? Prop.mix(label) : null,
          spinner: spinner != null ? Prop.mix(spinner) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixButtonStyle.value(ButtonSpec spec) => RemixButtonStyle(
        container: ContainerSpecMix.maybeValue(spec.container),
        label: RemixLabelStyle.value(spec.label),
        spinner: RemixSpinnerStyle.value(spec.spinner),
      );

  // Factory constructors for common patterns
  factory RemixButtonStyle.label(RemixLabelStyle value) {
    return RemixButtonStyle(label: value);
  }

  factory RemixButtonStyle.spinner(RemixSpinnerStyle value) {
    return RemixButtonStyle(spinner: value);
  }

  /// Factory for background color
  factory RemixButtonStyle.color(Color value) {
    return RemixButtonStyle(container: ContainerSpecMix.color(value));
  }

  /// Factory for padding
  factory RemixButtonStyle.padding(double value) {
    return RemixButtonStyle(
      container: ContainerSpecMix.padding(
        EdgeInsetsGeometryMix.all(value),
      ),
    );
  }

  /// Factory for border radius
  factory RemixButtonStyle.borderRadius(double radius) {
    return RemixButtonStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for width
  factory RemixButtonStyle.width(double value) {
    return RemixButtonStyle(
      container: ContainerSpecMix.constraints(
        BoxConstraintsMix(minWidth: value, maxWidth: value),
      ),
    );
  }

  /// Factory for height
  factory RemixButtonStyle.height(double value) {
    return RemixButtonStyle(
      container: ContainerSpecMix.constraints(
        BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    );
  }

  /// Factory for size (width and height)
  factory RemixButtonStyle.size(double width, double height) {
    return RemixButtonStyle(
      container: ContainerSpecMix.constraints(
        BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    );
  }

  /// Factory for border
  factory RemixButtonStyle.border(BoxBorderMix value) {
    return RemixButtonStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(border: value),
      ),
    );
  }

  // Instance methods for fluent API (return new instances)
  RemixButtonStyle label(RemixLabelStyle value) {
    return merge(RemixButtonStyle.label(value));
  }

  RemixButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixButtonStyle.spinner(value));
  }

  // Instance methods (chainable)

  /// Sets background color
  RemixButtonStyle color(Color value) {
    return merge(RemixButtonStyle.color(value));
  }

  /// Sets padding
  RemixButtonStyle padding(double value) {
    return merge(RemixButtonStyle.padding(value));
  }

  /// Sets border radius
  RemixButtonStyle borderRadius(double radius) {
    return merge(RemixButtonStyle.borderRadius(radius));
  }

  /// Sets width
  RemixButtonStyle width(double value) {
    return merge(RemixButtonStyle.width(value));
  }

  /// Sets height
  RemixButtonStyle height(double value) {
    return merge(RemixButtonStyle.height(value));
  }

  /// Sets size (width and height)
  RemixButtonStyle size(double width, double height) {
    return merge(RemixButtonStyle.size(width, height));
  }

  /// Sets border
  RemixButtonStyle border(BoxBorderMix value) {
    return merge(RemixButtonStyle.border(value));
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

  // Variant support
  @override
  RemixButtonStyle variant(Variant variant, RemixButtonStyle style) {
    return merge(RemixButtonStyle(variants: [VariantStyle(variant, style)]));
  }

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
  ButtonSpec resolve(BuildContext context) {
    return ButtonSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      spinner: MixOps.resolve(context, $spinner),
    );
  }

  @override
  RemixButtonStyle merge(RemixButtonStyle? other) {
    if (other == null) return this;

    return RemixButtonStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      spinner: MixOps.merge($spinner, other.$spinner),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

final DefaultRemixButtonStyle = RemixButtonStyle(
  container: ContainerSpecMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
      color: RemixTokens.primary(),
    ),
    padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
  ),
  label: RemixLabelStyle(
    spacing: RemixTokens.spaceSm(),
    label:
        TextMix.color(RemixTokens.surface()).fontSize(RemixTokens.fontSizeMd()),
    leading:
        IconMix.color(RemixTokens.surface()).size(RemixTokens.iconSizeLg()),
  ),
  spinner: RemixSpinnerStyle(
    size: RemixTokens.iconSizeMd(),
    strokeWidth: 1.5,
    color: RemixTokens.surface(),
    duration: const Duration(milliseconds: 1000),
    style: SpinnerStyle.solid,
  ),
);

extension ButtonVariants on RemixButtonStyle {
  // Primary colors
  static RemixButtonStyle get primary =>
      _createVariant(RemixTokens.primary(), RemixTokens.surface());
  static RemixButtonStyle get secondary =>
      _createVariant(RemixTokens.secondary(), RemixTokens.surface());
  static RemixButtonStyle get success =>
      _createVariant(RemixTokens.success(), RemixTokens.surface());
  static RemixButtonStyle get danger =>
      _createVariant(RemixTokens.danger(), RemixTokens.surface());
  static RemixButtonStyle get warning =>
      _createVariant(RemixTokens.warning(), RemixTokens.surface());

  // Outline variants
  static RemixButtonStyle get primaryOutline =>
      _createOutlineVariant(RemixTokens.primary());
  static RemixButtonStyle get secondaryOutline =>
      _createOutlineVariant(RemixTokens.secondary());
  static RemixButtonStyle get successOutline =>
      _createOutlineVariant(RemixTokens.success());
  static RemixButtonStyle get dangerOutline =>
      _createOutlineVariant(RemixTokens.danger());

  // Ghost variants (no background, no border)
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
        container: ContainerSpecMix(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceXs()),
          constraints: BoxConstraintsMix(minHeight: 32),
        ),
        label: RemixLabelStyle(
          spacing: RemixTokens.spaceXs(),
          label: TextMix.fontSize(RemixTokens.fontSizeSm()),
          leading: IconMix.size(RemixTokens.iconSizeSm()),
        ),
      );

  static RemixButtonStyle get medium => RemixButtonStyle(
        container: ContainerSpecMix(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceSm()),
          constraints: BoxConstraintsMix(minHeight: 40),
        ),
        label: RemixLabelStyle(
          spacing: RemixTokens.spaceSm(),
          label: TextMix.fontSize(RemixTokens.fontSizeMd()),
          leading: IconMix.size(RemixTokens.iconSizeMd()),
        ),
      );

  static RemixButtonStyle get large => RemixButtonStyle(
        container: ContainerSpecMix(
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
          constraints: BoxConstraintsMix(minHeight: 48),
        ),
        label: RemixLabelStyle(
          spacing: RemixTokens.spaceMd(),
          label: TextMix.fontSize(RemixTokens.fontSizeLg()),
          leading: IconMix.size(RemixTokens.iconSizeXl()),
        ),
      );

  // Legacy aliases for backward compatibility
  static RemixButtonStyle get outline => primaryOutline;
  static RemixButtonStyle get ghost => primaryGhost;

  // Helper methods to create variants
  static RemixButtonStyle _createVariant(Color bgColor, Color fgColor) {
    return RemixButtonStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: bgColor,
        ),
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
      ),
      label: RemixLabelStyle(
        spacing: RemixTokens.spaceSm(),
        label: TextMix.color(fgColor).fontSize(RemixTokens.fontSizeMd()),
        leading: IconMix.color(fgColor).size(RemixTokens.iconSizeLg()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(color: _darkenColor(bgColor, 0.1)),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(color: _darkenColor(bgColor, 0.2)),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(
                    color: bgColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        )
        .onDisabled(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                color: RemixTokens.textDisabled(),
              ),
            ),
            label: RemixLabelStyle(
              label: TextMix.color(RemixTokens.textTertiary()),
              leading: IconMix.color(RemixTokens.textTertiary()),
            ),
          ),
        );
  }

  static RemixButtonStyle _createOutlineVariant(Color color) {
    return RemixButtonStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(
          border: BoxBorderMix.all(BorderSideMix(color: color, width: 1)),
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: RemixTokens.surface().withValues(alpha: 0.0),
        ),
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
      ),
      label: RemixLabelStyle(
        spacing: RemixTokens.spaceSm(),
        label: TextMix.color(color).fontSize(RemixTokens.fontSizeMd()),
        leading: IconMix.color(color).size(RemixTokens.iconSizeLg()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                border:
                    BoxBorderMix.all(BorderSideMix(color: color, width: 1.5)),
                color: color.withValues(alpha: 0.05),
              ),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(BorderSideMix(color: color, width: 2)),
                color: color.withValues(alpha: 0.1),
              ),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(BorderSideMix(color: color, width: 2)),
              ),
            ),
          ),
        )
        .onDisabled(
          RemixButtonStyle(
            container: ContainerSpecMix(
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
              label: TextMix.color(RemixTokens.textDisabled()),
              leading: IconMix.color(RemixTokens.textDisabled()),
            ),
          ),
        );
  }

  static RemixButtonStyle _createGhostVariant(Color color) {
    return RemixButtonStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: RemixTokens.surface().withValues(alpha: 0.0),
        ),
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
      ),
      label: RemixLabelStyle(
        spacing: RemixTokens.spaceSm(),
        label: TextMix.color(color).fontSize(RemixTokens.fontSizeMd()),
        leading: IconMix.color(color).size(RemixTokens.iconSizeLg()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration:
                  BoxDecorationMix(color: color.withValues(alpha: 0.08)),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration:
                  BoxDecorationMix(color: color.withValues(alpha: 0.12)),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: color.withValues(alpha: 0.5), width: 2),
                ),
                color: color.withValues(alpha: 0.05),
              ),
            ),
          ),
        )
        .onDisabled(
          RemixButtonStyle(
            label: RemixLabelStyle(
              label: TextMix.color(RemixTokens.textDisabled()),
              leading: IconMix.color(RemixTokens.textDisabled()),
            ),
          ),
        );
  }

  static RemixButtonStyle _createSoftVariant(Color color) {
    return RemixButtonStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
          color: color.withValues(alpha: 0.1),
        ),
        padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceMd()),
      ),
      label: RemixLabelStyle(
        spacing: RemixTokens.spaceSm(),
        label: TextMix.color(color).fontSize(RemixTokens.fontSizeMd()),
        leading: IconMix.color(color).size(RemixTokens.iconSizeLg()),
      ),
    )
        .onHovered(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration:
                  BoxDecorationMix(color: color.withValues(alpha: 0.15)),
            ),
          ),
        )
        .onPressed(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(color: color.withValues(alpha: 0.2)),
            ),
          ),
        )
        .onFocused(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(color: color.withValues(alpha: 0.5), width: 2),
                ),
              ),
            ),
          ),
        )
        .onDisabled(
          RemixButtonStyle(
            container: ContainerSpecMix(
              decoration: BoxDecorationMix(
                color: RemixTokens.textDisabled().withValues(alpha: 0.1),
              ),
            ),
            label: RemixLabelStyle(
              label: TextMix.color(RemixTokens.textDisabled()),
              leading: IconMix.color(RemixTokens.textDisabled()),
            ),
          ),
        );
  }

  // Helper function to darken colors for hover/pressed states
  static Color _darkenColor(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);

    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

// COMMENTED OUT FOR REVIEW - ORIGINAL FROM MAIN BRANCH
// This file was fetched from main branch and commented out for review
// Uncomment and modify as needed for Mix 2.0 migration

/*
part of 'button.dart';

class RemixButtonStyle extends ButtonSpecUtility<ButtonSpecAttribute> {
  RemixButtonStyle() : super((v) => v);

  factory RemixButtonStyle._default() {
    final style = RemixButtonStyle()
      ..container.color.black()
      ..container.padding(10)
      ..container.borderRadius(8)
      ..icon.color.white()
      ..icon.size(18);

    return style;
  }

  @override
  RemixButtonStyle merge(RemixButtonStyle other) {
    return super.merge(other) as RemixButtonStyle;
  }
}
*/
