part of 'button.dart';

/// Fortal button size presets.
enum FortalButtonSize {
  /// Compact button.
  size1,

  /// Default button.
  size2,

  /// Large button.
  size3,

  /// Extra-large button.
  size4,
}

/// Fortal button color and emphasis variants.
enum FortalButtonVariant {
  /// High-emphasis filled button.
  solid,

  /// Low-emphasis filled button.
  soft,

  /// Subtle surface button with a border.
  surface,

  /// Transparent button with an outline.
  outline,

  /// Transparent button without a persistent border.
  ghost,
}

/// Fortal-themed button style and widget presets.
RemixButtonStyler fortalButtonStyler({
  FortalButtonVariant variant = .solid,
  FortalButtonSize size = .size2,
  bool highContrast = false,
}) {
  return switch (variant) {
    .solid => _fortalButtonSolidStyler(size, highContrast: highContrast),
    .soft => _fortalButtonSoftStyler(size, highContrast: highContrast),
    .surface => _fortalButtonSurfaceStyler(size, highContrast: highContrast),
    .outline => _fortalButtonOutlineStyler(size, highContrast: highContrast),
    .ghost => _fortalButtonGhostStyler(size, highContrast: highContrast),
  };
}

RemixButtonStyler _fortalButtonBaseStyler(FortalButtonSize size) {
  return RemixButtonStyler()
      .label(TextStyler().fontWeight(FortalTokens.fontWeightMedium()))
      .spinner(
        .strokeWidth(
          FortalTokens.borderWidth2(),
        ).duration(const Duration(milliseconds: 800)),
      )
      .onFocused(
        RemixButtonStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalButtonSizeStyler(size));
}

RemixButtonStyler _fortalButtonSolidStyler(
  FortalButtonSize size, {
  bool highContrast = false,
}) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent9(),
      )
      .foregroundColor(
        highContrast ? FortalTokens.accent1() : FortalTokens.accentContrast(),
      )
      .spinner(
        .indicatorColor(
          highContrast ? FortalTokens.accent1() : FortalTokens.accentContrast(),
        ),
      )
      .onHovered(
        RemixButtonStyler().backgroundColor(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent10(),
        ),
      )
      .onPressed(
        RemixButtonStyler().backgroundColor(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent10(),
        ),
      )
      .onDisabled(
        RemixButtonStyler()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonSoftStyler(
  FortalButtonSize size, {
  bool highContrast = false,
}) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accent3())
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      )
      .spinner(
        .indicatorColor(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
        ),
      )
      .onHovered(RemixButtonStyler().backgroundColor(FortalTokens.accent4()))
      .onPressed(RemixButtonStyler().backgroundColor(FortalTokens.accent5()))
      .onDisabled(
        RemixButtonStyler()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonSurfaceStyler(
  FortalButtonSize size, {
  bool highContrast = false,
}) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      )
      .spinner(
        .indicatorColor(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
        ),
      )
      .onHovered(
        RemixButtonStyler().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixButtonStyler()
            .backgroundColor(FortalTokens.grayA2())
            .foregroundColor(FortalTokens.gray8())
            .borderAll(
              color: FortalTokens.gray5(),
              width: FortalTokens.borderWidth1(),
            )
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonOutlineStyler(
  FortalButtonSize size, {
  bool highContrast = false,
}) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      )
      .spinner(
        .indicatorColor(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
        ),
      )
      .onHovered(
        RemixButtonStyler()
            .backgroundColor(FortalTokens.accentA2())
            .borderAll(
              color: FortalTokens.accent8(),
              width: FortalTokens.borderWidth1(),
            ),
      )
      .onDisabled(
        RemixButtonStyler()
            .foregroundColor(FortalTokens.gray8())
            .borderAll(color: FortalTokens.gray5())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonGhostStyler(
  FortalButtonSize size, {
  bool highContrast = false,
}) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .foregroundColor(
        highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
      )
      .spinner(
        .indicatorColor(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
        ),
      )
      .onHovered(RemixButtonStyler().backgroundColor(FortalTokens.accentA3()))
      .onPressed(RemixButtonStyler().backgroundColor(FortalTokens.accentA4()))
      .onDisabled(
        RemixButtonStyler()
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonSizeStyler(FortalButtonSize size) {
  final style = RemixButtonStyler();

  return switch (size) {
    .size1 =>
      style
          .paddingX(FortalTokens.space2())
          .paddingY(FortalTokens.space1())
          .spacing(FortalTokens.space1())
          .borderRadiusAll(FortalTokens.radius2())
          .label(
            TextStyler()
                .fontSize(12.0)
                .height(16.0 / 12.0)
                .letterSpacing(0.0025),
          )
          .icon(.size(12.0))
          .spinner(.size(12.0)),
    .size2 =>
      style
          .paddingX(FortalTokens.space3())
          .paddingY(FortalTokens.space2())
          .spacing(FortalTokens.space2())
          .borderRadiusAll(FortalTokens.radius3())
          .label(
            TextStyler().fontSize(14.0).height(20.0 / 14.0).letterSpacing(0.0),
          )
          .icon(.size(16.0))
          .spinner(.size(16.0)),
    .size3 =>
      style
          .paddingX(FortalTokens.space4())
          .paddingY(FortalTokens.space3())
          .spacing(FortalTokens.space3())
          .borderRadiusAll(FortalTokens.radius4())
          .label(
            TextStyler().fontSize(16.0).height(24.0 / 16.0).letterSpacing(0.0),
          )
          .icon(.size(20.0))
          .spinner(.size(20.0)),
    .size4 =>
      style
          .paddingX(FortalTokens.space5())
          .paddingY(FortalTokens.space4())
          .spacing(FortalTokens.space4())
          .borderRadiusAll(FortalTokens.radius5())
          .label(
            TextStyler()
                .fontSize(18.0)
                .height(26.0 / 18.0)
                .letterSpacing(-0.0025),
          )
          .icon(.size(24.0))
          .spinner(.size(24.0)),
  };
}

/// Fortal-themed button style and widget presets.
class FortalButton extends StatelessWidget {
  const FortalButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// High-emphasis filled button.
  const FortalButton.solid({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalButtonVariant.solid;

  /// Low-emphasis filled button.
  const FortalButton.soft({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalButtonVariant.soft;

  /// Subtle surface button with a border.
  const FortalButton.surface({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalButtonVariant.surface;

  /// Transparent button with an outline.
  const FortalButton.outline({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalButtonVariant.outline;

  /// Transparent button without a persistent border.
  const FortalButton.ghost({
    super.key,
    this.size = .size2,
    this.color,
    this.radius,
    this.highContrast = false,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalButtonVariant.ghost;

  final FortalButtonVariant variant;

  final FortalButtonSize size;

  /// Optional accent color override for this button subtree.
  final FortalAccentColor? color;

  /// Optional radius override for this button subtree.
  final FortalRadius? radius;

  /// Whether to use higher-contrast accent colors.
  final bool highContrast;

  final String label;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final RemixButtonTextBuilder? textBuilder;

  final RemixButtonIconBuilder? leadingIconBuilder;

  final RemixButtonIconBuilder? trailingIconBuilder;

  final RemixButtonLoadingBuilder? loadingBuilder;

  final bool loading;

  final bool enabled;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return FortalOverride(
      color: this.color,
      radius: this.radius,
      child:
          fortalButtonStyler(
            variant: this.variant,
            size: this.size,
            highContrast: this.highContrast,
          ).call(
            key: this.key,
            label: this.label,
            leadingIcon: this.leadingIcon,
            trailingIcon: this.trailingIcon,
            textBuilder: this.textBuilder,
            leadingIconBuilder: this.leadingIconBuilder,
            trailingIconBuilder: this.trailingIconBuilder,
            loadingBuilder: this.loadingBuilder,
            loading: this.loading,
            enabled: this.enabled,
            onPressed: this.onPressed,
            onLongPress: this.onLongPress,
            focusNode: this.focusNode,
            autofocus: this.autofocus,
            enableFeedback: this.enableFeedback,
            semanticLabel: this.semanticLabel,
            semanticHint: this.semanticHint,
            excludeSemantics: this.excludeSemantics,
            mouseCursor: this.mouseCursor,
          ),
    );
  }
}
