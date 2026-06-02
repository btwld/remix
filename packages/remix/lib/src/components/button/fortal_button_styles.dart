part of 'button.dart';

enum FortalButtonSize { size1, size2, size3, size4 }

enum FortalButtonVariant { solid, soft, surface, outline, ghost }

/// Creates a Fortal-themed button style.
RemixButtonStyler fortalButtonStyle({
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

class FortalButton extends StatelessWidget {
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
    required this.onPressed,
    this.focusNode,
  });

  final FortalButtonVariant variant;

  final FortalButtonSize size;

  final String label;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final bool loading;

  final bool enabled;

  final bool enableFeedback;

  final VoidCallback? onPressed;

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

RemixButtonStyler _fortalButtonBaseStyle(FortalButtonSize size) {
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
      .merge(_fortalButtonSizeStyle(size));
}

RemixButtonStyler _fortalButtonSolidStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .color(FortalTokens.accent9())
      .label(.color(FortalTokens.accentContrast()))
      .icon(.color(FortalTokens.accentContrast()))
      .spinner(.indicatorColor(FortalTokens.accentContrast()))
      .onHovered(RemixButtonStyler().color(FortalTokens.accent10()))
      .onPressed(RemixButtonStyler().color(FortalTokens.accent10()))
      .onDisabled(
        RemixButtonStyler()
            .color(FortalTokens.grayA3())
            .label(.color(FortalTokens.gray8()))
            .icon(.color(FortalTokens.gray8()))
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonSoftStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .color(FortalTokens.accent3())
      .label(.color(FortalTokens.accent11()))
      .icon(.color(FortalTokens.accent11()))
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(RemixButtonStyler().color(FortalTokens.accent4()))
      .onPressed(RemixButtonStyler().color(FortalTokens.accent5()))
      .onDisabled(
        RemixButtonStyler()
            .color(FortalTokens.grayA3())
            .label(.color(FortalTokens.gray8()))
            .icon(.color(FortalTokens.gray8()))
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonSurfaceStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .color(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .label(.color(FortalTokens.accent11()))
      .icon(.color(FortalTokens.accent11()))
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixButtonStyler().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixButtonStyler()
            .color(FortalTokens.grayA2())
            .label(.color(FortalTokens.gray8()))
            .icon(.color(FortalTokens.gray8()))
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

RemixButtonStyler _fortalButtonOutlineStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .color(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .label(.color(FortalTokens.accent11()))
      .icon(.color(FortalTokens.accent11()))
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixButtonStyler()
            .color(FortalTokens.accentA2())
            .borderAll(
              color: FortalTokens.accent8(),
              width: FortalTokens.borderWidth1(),
            ),
      )
      .onDisabled(
        RemixButtonStyler()
            .label(.color(FortalTokens.gray8()))
            .icon(.color(FortalTokens.gray8()))
            .borderAll(color: FortalTokens.gray5())
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonGhostStyle([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyle(size)
      .color(Colors.transparent)
      .label(.color(FortalTokens.accent11()))
      .icon(.color(FortalTokens.accent11()))
      .spinner(.indicatorColor(FortalTokens.accent11()))
      .onHovered(RemixButtonStyler().color(FortalTokens.accentA3()))
      .onPressed(RemixButtonStyler().color(FortalTokens.accentA4()))
      .onDisabled(
        RemixButtonStyler()
            .label(.color(FortalTokens.gray8()))
            .icon(.color(FortalTokens.gray8()))
            .spinner(
              .indicatorColor(
                FortalTokens.gray8(),
              ).strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixButtonStyler _fortalButtonSizeStyle(FortalButtonSize size) {
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
