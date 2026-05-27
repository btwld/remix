part of 'checkbox.dart';

enum FortalCheckboxSize { size1, size2, size3 }

enum FortalCheckboxVariant { surface, soft }

@MixWidget()
RemixCheckboxStyle fortalCheckboxStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalCheckboxSurfaceStyle(size),
    .soft => _fortalCheckboxSoftStyle(size),
  };
}

RemixCheckboxStyle _fortalCheckboxBaseStyle(FortalCheckboxSize size) {
  return RemixCheckboxStyle()
      .onFocused(
        RemixCheckboxStyle().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalCheckboxSizeStyle(size));
}

RemixCheckboxStyle _fortalCheckboxSurfaceStyle([
  FortalCheckboxSize size = .size2,
]) {
  return _fortalCheckboxBaseStyle(size)
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius2())
      .indicatorColor(FortalTokens.accent9())
      .onSelected(
        RemixCheckboxStyle()
            .fillColor(FortalTokens.accent9())
            .borderAll(
              color: FortalTokens.accent9(),
              width: FortalTokens.borderWidth1(),
            )
            .indicatorColor(FortalTokens.accentContrast()),
      )
      .onDisabled(
        RemixCheckboxStyle()
            .fillColor(FortalTokens.grayA3())
            .borderAll(
              color: FortalTokens.gray7(),
              width: FortalTokens.borderWidth1(),
            )
            .indicatorColor(FortalTokens.gray8()),
      );
}

RemixCheckboxStyle _fortalCheckboxSoftStyle([
  FortalCheckboxSize size = .size2,
]) {
  return _fortalCheckboxBaseStyle(size)
      .fillColor(FortalTokens.accentA4())
      .borderRadiusAll(FortalTokens.radius2())
      .onSelected(RemixCheckboxStyle().indicatorColor(FortalTokens.accentA11()))
      .onDisabled(
        RemixCheckboxStyle()
            .fillColor(FortalTokens.grayA3())
            .indicatorColor(FortalTokens.gray8()),
      );
}

RemixCheckboxStyle _fortalCheckboxSizeStyle(FortalCheckboxSize size) {
  return switch (size) {
    .size1 => RemixCheckboxStyle(
      container: BoxStyler()
          .width(FortalTokens.space4())
          .height(FortalTokens.space4()),
      indicator: IconStyler().size(FortalTokens.space3()),
    ),
    .size2 => RemixCheckboxStyle(
      container: BoxStyler()
          .width(FortalTokens.space5())
          .height(FortalTokens.space5()),
      indicator: IconStyler().size(FortalTokens.space4()),
    ),
    .size3 => RemixCheckboxStyle(
      container: BoxStyler()
          .width(FortalTokens.space6())
          .height(FortalTokens.space6()),
      indicator: IconStyler().size(FortalTokens.space5()),
    ),
  };
}
