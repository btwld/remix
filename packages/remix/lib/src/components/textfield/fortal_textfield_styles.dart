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

/// Fortal-themed preset for [RemixTextField].
@MixWidget(
  name: 'FortalTextField',
  target: RemixTextField.new,
  factoryParameters: .only({'variant', 'size'}),
)
RemixTextFieldStyler fortalTextFieldStyler({
  FortalTextFieldVariant variant = .surface,
  FortalTextFieldSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalTextFieldSurfaceStyler(size),
    .soft => _fortalTextFieldSoftStyler(size),
  };
}

RemixTextFieldStyler _fortalTextFieldBaseStyler(FortalTextFieldSize size) {
  return RemixTextFieldStyler(
        hintText: TextStyler().textHeightBehavior(
          TextHeightBehaviorMix()
              .applyHeightToFirstAscent(false)
              .applyHeightToLastDescent(true),
        ),
        cursorWidth: 1.5,
      )
      .spacing(8)
      .wrap(.iconTheme(color: FortalTokens.gray10(), size: 16.0))
      .onFocused(
        RemixTextFieldStyler().borderAll(
          color: FortalTokens.accent8(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      )
      .merge(_fortalTextFieldSizeStyler(size));
}

RemixTextFieldStyler _fortalTextFieldSurfaceStyler([
  FortalTextFieldSize size = .size2,
]) {
  return _fortalTextFieldBaseStyler(size)
      .merge(
        RemixTextFieldStyler(
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
      .textColor(FortalTokens.gray12())
      .onFocused(
        RemixTextFieldStyler().borderAll(
          color: FortalTokens.accent7(),
          width: FortalTokens.borderWidth1(),
        ),
      )
      .onDisabled(
        RemixTextFieldStyler(
              text: TextStyler().color(FortalTokens.gray10()),
              hintText: TextStyler().color(FortalTokens.gray8()),
            )
            .backgroundColor(FortalTokens.colorSurface())
            .borderAll(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            ),
      );
}

RemixTextFieldStyler _fortalTextFieldSoftStyler([
  FortalTextFieldSize size = .size2,
]) {
  return _fortalTextFieldBaseStyler(size)
      .merge(
        RemixTextFieldStyler(
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
      .textColor(FortalTokens.accent12())
      .wrap(.iconTheme(color: FortalTokens.accent10()))
      .backgroundColor(FortalTokens.accent3())
      .borderAll(
        color: FortalTokens.accent3(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignOutside,
      )
      .onDisabled(
        RemixTextFieldStyler(
              text: TextStyler().color(FortalTokens.accentA8()),
              hintText: TextStyler().color(FortalTokens.accentA7()),
            )
            .backgroundColor(FortalTokens.accentA3())
            .borderAll(
              color: FortalTokens.accentA4(),
              width: FortalTokens.borderWidth1(),
            ),
      );
}

RemixTextFieldStyler _fortalTextFieldSizeStyler(FortalTextFieldSize size) {
  return switch (size) {
    .size1 => RemixTextFieldStyler(
      text: TextStyler().fontSize(12.0),
      hintText: TextStyler().fontSize(12.0),
      helperText: TextStyler().fontSize(11.0),
      label: TextStyler().fontSize(11.0),
    ).borderRadiusAll(FortalTokens.radius2()).paddingAll(8.0),
    .size2 => RemixTextFieldStyler(
      text: TextStyler().fontSize(14.0),
      hintText: TextStyler().fontSize(14.0),
      helperText: TextStyler().fontSize(12.0),
      label: TextStyler().fontSize(13.0),
    ).borderRadiusAll(FortalTokens.radius3()).paddingAll(12.0),
    .size3 => RemixTextFieldStyler(
      text: TextStyler().fontSize(15.0),
      hintText: TextStyler().fontSize(15.0),
      helperText: TextStyler().fontSize(14.0),
      label: TextStyler().fontSize(15.0),
    ).borderRadiusAll(FortalTokens.radius4()).paddingAll(16.0),
  };
}

/// Fortal-themed preset for [RemixTextField].
