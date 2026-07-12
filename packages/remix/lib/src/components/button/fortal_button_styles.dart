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
@MixWidget(name: 'FortalButton')
RemixButtonStyler fortalButtonStyler({
  FortalButtonVariant variant = .solid,
  FortalButtonSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalButtonSolidStyler(size),
    .soft => _fortalButtonSoftStyler(size),
    .surface => _fortalButtonSurfaceStyler(size),
    .outline => _fortalButtonOutlineStyler(size),
    .ghost => _fortalButtonGhostStyler(size),
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

RemixButtonStyler _fortalButtonSolidStyler([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast())
      .spinner(.indicatorColor(FortalTokens.accentContrast()))
      .onHovered(RemixButtonStyler().backgroundColor(FortalTokens.accent10()))
      .onPressed(RemixButtonStyler().backgroundColor(FortalTokens.accent10()))
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

RemixButtonStyler _fortalButtonSoftStyler([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accent3())
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
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

RemixButtonStyler _fortalButtonSurfaceStyler([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
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

RemixButtonStyler _fortalButtonOutlineStyler([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
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

RemixButtonStyler _fortalButtonGhostStyler([FortalButtonSize size = .size2]) {
  return _fortalButtonBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .foregroundColor(FortalTokens.accent11())
      .spinner(.indicatorColor(FortalTokens.accent11()))
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
