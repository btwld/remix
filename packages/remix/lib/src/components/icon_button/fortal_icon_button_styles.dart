part of 'icon_button.dart';

/// Fortal icon button size presets.
enum FortalIconButtonSize { size1, size2, size3, size4 }

/// Fortal icon button color and emphasis variants.
enum FortalIconButtonVariant { solid, soft, surface, outline, ghost }

/// Creates a Fortal-themed [RemixIconButtonStyle].
@MixWidget()
RemixIconButtonStyle fortalIconButtonStyle({
  FortalIconButtonVariant variant = .solid,
  FortalIconButtonSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalIconButtonSolidStyle(size),
    .soft => _fortalIconButtonSoftStyle(size),
    .surface => _fortalIconButtonSurfaceStyle(size),
    .outline => _fortalIconButtonOutlineStyle(size),
    .ghost => _fortalIconButtonGhostStyle(size),
  };
}

RemixIconButtonStyle _fortalIconButtonBaseStyle(FortalIconButtonSize size) {
  return RemixIconButtonStyle()
      .spinner(
        RemixSpinnerStyle(
          strokeWidth: FortalTokens.borderWidth2(),
          duration: const Duration(milliseconds: 800),
        ),
      )
      .onFocused(
        RemixIconButtonStyle().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalIconButtonSizeStyle(size));
}

RemixIconButtonStyle _fortalIconButtonSolidStyle([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyle(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast())
      .spinner(
        RemixSpinnerStyle().indicatorColor(FortalTokens.accentContrast()),
      )
      .onHovered(
        RemixIconButtonStyle().backgroundColor(FortalTokens.accent10()),
      )
      .onPressed(
        RemixIconButtonStyle().backgroundColor(FortalTokens.accent10()),
      )
      .onDisabled(
        RemixIconButtonStyle()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              RemixSpinnerStyle()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyle _fortalIconButtonSoftStyle([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyle(size)
      .backgroundColor(FortalTokens.accent3())
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
      .onHovered(RemixIconButtonStyle().backgroundColor(FortalTokens.accent4()))
      .onPressed(RemixIconButtonStyle().backgroundColor(FortalTokens.accent5()))
      .onDisabled(
        RemixIconButtonStyle()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              RemixSpinnerStyle()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyle _fortalIconButtonSurfaceStyle([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyle(size)
      .backgroundColor(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyle().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixIconButtonStyle()
            .backgroundColor(FortalTokens.grayA2())
            .foregroundColor(FortalTokens.gray8())
            .borderAll(
              color: FortalTokens.gray5(),
              width: FortalTokens.borderWidth1(),
            )
            .spinner(
              RemixSpinnerStyle()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyle _fortalIconButtonOutlineStyle([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyle(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyle()
            .backgroundColor(FortalTokens.accentA2())
            .borderAll(
              color: FortalTokens.accent8(),
              width: FortalTokens.borderWidth1(),
            ),
      )
      .onDisabled(
        RemixIconButtonStyle()
            .foregroundColor(FortalTokens.gray8())
            .borderAll(color: FortalTokens.gray5())
            .spinner(
              RemixSpinnerStyle()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyle _fortalIconButtonGhostStyle([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyle(size)
      .backgroundColor(Colors.transparent)
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyle().backgroundColor(FortalTokens.accentA3()),
      )
      .onPressed(
        RemixIconButtonStyle().backgroundColor(FortalTokens.accentA4()),
      )
      .onDisabled(
        RemixIconButtonStyle()
            .foregroundColor(FortalTokens.gray8())
            .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.gray8())),
      );
}

RemixIconButtonStyle _fortalIconButtonSizeStyle(FortalIconButtonSize size) {
  final style = RemixIconButtonStyle();

  return switch (size) {
    .size1 =>
      style
          .width(24.0)
          .height(24.0)
          .borderRadiusAll(FortalTokens.radius2())
          .iconSize(12.0)
          .spinner(RemixSpinnerStyle(size: 12.0)),
    .size2 =>
      style
          .width(32.0)
          .height(32.0)
          .borderRadiusAll(FortalTokens.radius3())
          .iconSize(16.0)
          .spinner(RemixSpinnerStyle(size: 16.0)),
    .size3 =>
      style
          .width(40.0)
          .height(40.0)
          .borderRadiusAll(FortalTokens.radius4())
          .iconSize(20.0)
          .spinner(RemixSpinnerStyle(size: 20.0)),
    .size4 =>
      style
          .width(48.0)
          .height(48.0)
          .borderRadiusAll(FortalTokens.radius5())
          .iconSize(24.0)
          .spinner(RemixSpinnerStyle(size: 24.0)),
  };
}
