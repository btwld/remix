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

/// Creates a Fortal-themed button style.
RemixButtonStyle fortalButtonStyle({
  FortalButtonVariant variant = .solid,
  FortalButtonSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalButtonSolidStyle(size),
    .soft => _fortalButtonSoftStyle(size),
    .surface => _fortalButtonSurfaceStyle(size),
    .outline => _fortalButtonOutlineStyle(size),
    .ghost => _fortalButtonGhostStyle(size),
  };
}

/// A [RemixButton] preconfigured with Fortal size and variant presets.
class FortalButton extends StatelessWidget {
  /// Creates a Fortal-themed button.
  const FortalButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.focusNode,
  });

  /// Visual emphasis variant for the button.
  final FortalButtonVariant variant;

  /// Size preset for the button.
  final FortalButtonSize size;

  /// Text displayed in the button.
  final String label;

  /// Icon displayed before the label.
  final IconData? leadingIcon;

  /// Icon displayed after the label.
  final IconData? trailingIcon;

  /// Whether to show the loading spinner and suppress presses.
  final bool loading;

  /// Whether the button can be pressed.
  final bool enabled;

  /// Whether interactions should trigger platform feedback.
  final bool enableFeedback;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Focus node used by the underlying button.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return fortalButtonStyle(variant: variant, size: size).call(
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
    );
  }
}

RemixButtonStyle _fortalButtonBaseStyle(FortalButtonSize size) {
  return RemixButtonStyle()
      .label(TextStyler().fontWeight(FortalTokens.fontWeightMedium()))
      .spinner(
        .strokeWidth(
          FortalTokens.borderWidth2(),
        ).duration(const Duration(milliseconds: 800)),
      )
      .onFocused(
        RemixButtonStyle().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalButtonSizeStyle(size));
}

RemixButtonStyle _fortalButtonSolidStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast())
      .spinner(.indicatorColor(FortalTokens.accentContrast()))
      .onHovered(RemixButtonStyle().backgroundColor(FortalTokens.accent10()))
      .onPressed(RemixButtonStyle().backgroundColor(FortalTokens.accent10()))
      .onDisabled(
        RemixButtonStyle()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyle _fortalButtonSoftStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .backgroundColor(FortalTokens.accent3())
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(RemixButtonStyle().backgroundColor(FortalTokens.accent4()))
      .onPressed(RemixButtonStyle().backgroundColor(FortalTokens.accent5()))
      .onDisabled(
        RemixButtonStyle()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyle _fortalButtonSurfaceStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .backgroundColor(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixButtonStyle().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixButtonStyle()
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

RemixButtonStyle _fortalButtonOutlineStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixButtonStyle()
            .backgroundColor(FortalTokens.accentA2())
            .borderAll(
              color: FortalTokens.accent8(),
              width: FortalTokens.borderWidth1(),
            ),
      )
      .onDisabled(
        RemixButtonStyle()
            .foregroundColor(FortalTokens.gray8())
            .borderAll(color: FortalTokens.gray5())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyle _fortalButtonGhostStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .backgroundColor(Colors.transparent)
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(RemixButtonStyle().backgroundColor(FortalTokens.accentA3()))
      .onPressed(RemixButtonStyle().backgroundColor(FortalTokens.accentA4()))
      .onDisabled(
        RemixButtonStyle()
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyle _fortalButtonSizeStyle(FortalButtonSize size) {
  final style = RemixButtonStyle();

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
