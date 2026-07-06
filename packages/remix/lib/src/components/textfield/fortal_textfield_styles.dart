part of 'textfield.dart';

/// Fortal text field size presets.
enum FortalTextFieldSize {
  /// Compact text field.
  size1,

  /// Default text field.
  size2,

  /// Large text field.
  size3,
}

/// Fortal text field color variants.
enum FortalTextFieldVariant {
  /// Surface treatment with neutral border and text colors.
  surface,

  /// Soft accent treatment.
  soft,
}

/// Creates a Fortal-themed [RemixTextFieldStyle].
@MixWidget()
RemixTextFieldStyle fortalTextFieldStyle({
  FortalTextFieldVariant variant = .surface,
  FortalTextFieldSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalTextFieldSurfaceStyle(size),
    .soft => _fortalTextFieldSoftStyle(size),
  };
}

RemixTextFieldStyle _fortalTextFieldBaseStyle(FortalTextFieldSize size) {
  return RemixTextFieldStyle(
        hintText: TextStyler().textHeightBehavior(
          TextHeightBehaviorMix()
              .applyHeightToFirstAscent(false)
              .applyHeightToLastDescent(true),
        ),
        cursorWidth: 1.5,
      )
      .spacing(8)
      .wrap(.iconTheme(size: 16.0, color: FortalTokens.gray10()))
      .onFocused(
        RemixTextFieldStyle().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      )
      .merge(_fortalTextFieldSizeStyle(size));
}

RemixTextFieldStyle _fortalTextFieldSurfaceStyle([
  FortalTextFieldSize size = .size2,
]) {
  return _fortalTextFieldBaseStyle(size)
      .merge(
        RemixTextFieldStyle(
          text: TextStyler()
              .color(FortalTokens.gray12())
              .fontWeight(FortalTokens.fontWeightRegular()),
          hintText: TextStyler()
              .color(FortalTokens.gray10())
              .fontWeight(FortalTokens.fontWeightRegular()),
          cursorColor: FortalTokens.gray12(),
          helperText: TextStyler()
              .color(FortalTokens.gray11())
              .fontWeight(FortalTokens.fontWeightRegular()),
          label: TextStyler()
              .color(FortalTokens.gray12())
              .fontWeight(FortalTokens.fontWeightMedium()),
        ),
      )
      .borderAll(
        color: FortalTokens.gray7(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignOutside,
      )
      .color(FortalTokens.gray12())
      .onFocused(
        RemixTextFieldStyle().borderAll(
          color: FortalTokens.accent7(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixTextFieldStyle(
              text: TextStyler().color(FortalTokens.gray10()),
              hintText: TextStyler().color(FortalTokens.gray8()),
            )
            .color(FortalTokens.colorSurface())
            .borderAll(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            ),
      );
}

RemixTextFieldStyle _fortalTextFieldSoftStyle([
  FortalTextFieldSize size = .size2,
]) {
  return _fortalTextFieldBaseStyle(size)
      .merge(
        RemixTextFieldStyle(
          text: TextStyler().fontWeight(FortalTokens.fontWeightRegular()),
          hintText: TextStyler()
              .color(FortalTokens.accentA11())
              .fontWeight(FortalTokens.fontWeightRegular()),
          cursorColor: FortalTokens.accent12(),
          helperText: TextStyler()
              .color(FortalTokens.gray11())
              .fontWeight(FortalTokens.fontWeightRegular()),
          label: TextStyler()
              .color(FortalTokens.gray12())
              .fontWeight(FortalTokens.fontWeightMedium()),
        ),
      )
      .color(FortalTokens.accent12())
      .wrap(.iconTheme(color: FortalTokens.accent10()))
      .backgroundColor(FortalTokens.accent3())
      .borderAll(
        color: FortalTokens.accent3(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignOutside,
      )
      .onDisabled(RemixTextFieldStyle(text: TextStyler().color(Colors.red)));
}

RemixTextFieldStyle _fortalTextFieldSizeStyle(FortalTextFieldSize size) {
  return switch (size) {
    .size1 => RemixTextFieldStyle(
      text: TextStyler().fontSize(12.0),
      hintText: TextStyler().fontSize(12.0),
      helperText: TextStyler().fontSize(11.0),
      label: TextStyler().fontSize(11.0),
    ).borderRadiusAll(FortalTokens.radius2()).paddingAll(8.0),
    .size2 => RemixTextFieldStyle(
      text: TextStyler().fontSize(14.0),
      hintText: TextStyler().fontSize(14.0),
      helperText: TextStyler().fontSize(12.0),
      label: TextStyler().fontSize(13.0),
    ).borderRadiusAll(FortalTokens.radius3()).paddingAll(12.0),
    .size3 => RemixTextFieldStyle(
      text: TextStyler().fontSize(15.0),
      hintText: TextStyler().fontSize(15.0),
      helperText: TextStyler().fontSize(14.0),
      label: TextStyler().fontSize(15.0),
    ).borderRadiusAll(FortalTokens.radius4()).paddingAll(16.0),
  };
}
