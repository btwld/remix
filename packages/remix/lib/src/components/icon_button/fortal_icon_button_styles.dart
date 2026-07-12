part of 'icon_button.dart';

/// Fortal icon button size presets.
enum FortalIconButtonSize { size1, size2, size3, size4 }

/// Fortal icon button color and emphasis variants.
enum FortalIconButtonVariant { solid, soft, surface, outline, ghost }

/// Fortal-themed preset for [RemixIconButton].
@MixWidget(name: 'FortalIconButton')
RemixIconButtonStyler fortalIconButtonStyler({
  FortalIconButtonVariant variant = .solid,
  FortalIconButtonSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalIconButtonSolidStyler(size),
    .soft => _fortalIconButtonSoftStyler(size),
    .surface => _fortalIconButtonSurfaceStyler(size),
    .outline => _fortalIconButtonOutlineStyler(size),
    .ghost => _fortalIconButtonGhostStyler(size),
  };
}

RemixIconButtonStyler _fortalIconButtonBaseStyler(FortalIconButtonSize size) {
  return RemixIconButtonStyler()
      .spinner(
        RemixSpinnerStyler(
          strokeWidth: FortalTokens.borderWidth2(),
          duration: const Duration(milliseconds: 800),
        ),
      )
      .onFocused(
        RemixIconButtonStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalIconButtonSizeStyler(size));
}

RemixIconButtonStyler _fortalIconButtonSolidStyler([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accent9())
      .foregroundColor(FortalTokens.accentContrast())
      .spinner(
        RemixSpinnerStyler().indicatorColor(FortalTokens.accentContrast()),
      )
      .onHovered(
        RemixIconButtonStyler().backgroundColor(FortalTokens.accent10()),
      )
      .onPressed(
        RemixIconButtonStyler().backgroundColor(FortalTokens.accent10()),
      )
      .onDisabled(
        RemixIconButtonStyler()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              RemixSpinnerStyler()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyler _fortalIconButtonSoftStyler([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accent3())
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyler().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyler().backgroundColor(FortalTokens.accent4()),
      )
      .onPressed(
        RemixIconButtonStyler().backgroundColor(FortalTokens.accent5()),
      )
      .onDisabled(
        RemixIconButtonStyler()
            .backgroundColor(FortalTokens.grayA3())
            .foregroundColor(FortalTokens.gray8())
            .spinner(
              RemixSpinnerStyler()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyler _fortalIconButtonSurfaceStyler([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyler(size)
      .backgroundColor(FortalTokens.accentA2())
      .borderAll(
        color: FortalTokens.accent6(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyler().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyler().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixIconButtonStyler()
            .backgroundColor(FortalTokens.grayA2())
            .foregroundColor(FortalTokens.gray8())
            .borderAll(
              color: FortalTokens.gray5(),
              width: FortalTokens.borderWidth1(),
            )
            .spinner(
              RemixSpinnerStyler()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyler _fortalIconButtonOutlineStyler([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .borderAll(
        color: FortalTokens.accent7(),
        width: FortalTokens.borderWidth1(),
      )
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyler().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyler()
            .backgroundColor(FortalTokens.accentA2())
            .borderAll(
              color: FortalTokens.accent8(),
              width: FortalTokens.borderWidth1(),
            ),
      )
      .onDisabled(
        RemixIconButtonStyler()
            .foregroundColor(FortalTokens.gray8())
            .borderAll(color: FortalTokens.gray5())
            .spinner(
              RemixSpinnerStyler()
                  .indicatorColor(FortalTokens.gray8())
                  .strokeWidth(FortalTokens.borderWidth1()),
            ),
      );
}

RemixIconButtonStyler _fortalIconButtonGhostStyler([
  FortalIconButtonSize size = .size2,
]) {
  return _fortalIconButtonBaseStyler(size)
      .backgroundColor(Colors.transparent)
      .foregroundColor(FortalTokens.accent11())
      .spinner(RemixSpinnerStyler().indicatorColor(FortalTokens.accent11()))
      .onHovered(
        RemixIconButtonStyler().backgroundColor(FortalTokens.accentA3()),
      )
      .onPressed(
        RemixIconButtonStyler().backgroundColor(FortalTokens.accentA4()),
      )
      .onDisabled(
        RemixIconButtonStyler()
            .foregroundColor(FortalTokens.gray8())
            .spinner(RemixSpinnerStyler().indicatorColor(FortalTokens.gray8())),
      );
}

RemixIconButtonStyler _fortalIconButtonSizeStyler(FortalIconButtonSize size) {
  final style = RemixIconButtonStyler();

  return switch (size) {
    .size1 =>
      style
          .width(24.0)
          .height(24.0)
          .borderRadiusAll(FortalTokens.radius2())
          .iconSize(12.0)
          .spinner(RemixSpinnerStyler(size: 12.0)),
    .size2 =>
      style
          .width(32.0)
          .height(32.0)
          .borderRadiusAll(FortalTokens.radius3())
          .iconSize(16.0)
          .spinner(RemixSpinnerStyler(size: 16.0)),
    .size3 =>
      style
          .width(40.0)
          .height(40.0)
          .borderRadiusAll(FortalTokens.radius4())
          .iconSize(20.0)
          .spinner(RemixSpinnerStyler(size: 20.0)),
    .size4 =>
      style
          .width(48.0)
          .height(48.0)
          .borderRadiusAll(FortalTokens.radius5())
          .iconSize(24.0)
          .spinner(RemixSpinnerStyler(size: 24.0)),
  };
}
