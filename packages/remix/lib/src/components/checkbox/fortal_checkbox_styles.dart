part of 'checkbox.dart';

/// Fortal checkbox size presets.
enum FortalCheckboxSize {
  /// Compact checkbox.
  size1,

  /// Default checkbox.
  size2,

  /// Large checkbox.
  size3,
}

/// Fortal checkbox color variants.
enum FortalCheckboxVariant {
  /// Surface treatment with neutral border.
  surface,

  /// Soft accent treatment.
  soft,
}

/// Fortal-themed preset for [RemixCheckbox].
@MixWidget(name: 'FortalCheckbox')
RemixCheckboxStyler fortalCheckboxStyler({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalCheckboxSurfaceStyler(size),
    .soft => _fortalCheckboxSoftStyler(size),
  };
}

RemixCheckboxStyler _fortalCheckboxBaseStyler(FortalCheckboxSize size) {
  return RemixCheckboxStyler()
      .onFocused(
        RemixCheckboxStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalCheckboxSizeStyler(size));
}

RemixCheckboxStyler _fortalCheckboxSurfaceStyler([
  FortalCheckboxSize size = .size2,
]) {
  return _fortalCheckboxBaseStyler(size)
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius2())
      .indicatorColor(FortalTokens.accent9())
      .onSelected(
        RemixCheckboxStyler()
            .fillColor(FortalTokens.accent9())
            .borderAll(
              color: FortalTokens.accent9(),
              width: FortalTokens.borderWidth1(),
            )
            .indicatorColor(FortalTokens.accentContrast()),
      )
      .onDisabled(
        RemixCheckboxStyler()
            .fillColor(FortalTokens.grayA3())
            .borderAll(
              color: FortalTokens.gray7(),
              width: FortalTokens.borderWidth1(),
            )
            .indicatorColor(FortalTokens.gray8()),
      );
}

RemixCheckboxStyler _fortalCheckboxSoftStyler([
  FortalCheckboxSize size = .size2,
]) {
  return _fortalCheckboxBaseStyler(size)
      .fillColor(FortalTokens.accentA4())
      .borderRadiusAll(FortalTokens.radius2())
      .onSelected(
        RemixCheckboxStyler().indicatorColor(FortalTokens.accentA11()),
      )
      .onDisabled(
        RemixCheckboxStyler()
            .fillColor(FortalTokens.grayA3())
            .indicatorColor(FortalTokens.gray8()),
      );
}

RemixCheckboxStyler _fortalCheckboxSizeStyler(FortalCheckboxSize size) {
  return switch (size) {
    .size1 => RemixCheckboxStyler(
      container: BoxStyler()
          .width(FortalTokens.space4())
          .height(FortalTokens.space4()),
      indicator: IconStyler().size(FortalTokens.space3()),
    ),
    .size2 => RemixCheckboxStyler(
      container: BoxStyler()
          .width(FortalTokens.space5())
          .height(FortalTokens.space5()),
      indicator: IconStyler().size(FortalTokens.space4()),
    ),
    .size3 => RemixCheckboxStyler(
      container: BoxStyler()
          .width(FortalTokens.space6())
          .height(FortalTokens.space6()),
      indicator: IconStyler().size(FortalTokens.space5()),
    ),
  };
}
