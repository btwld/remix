part of 'radio.dart';

/// Fortal radio size presets.
enum FortalRadioSize {
  /// Compact radio.
  size1,

  /// Default radio.
  size2,

  /// Large radio.
  size3,
}

/// Fortal radio color variants.
enum FortalRadioVariant {
  /// Surface treatment with neutral border.
  surface,

  /// Soft accent treatment.
  soft,
}

/// Fortal-themed radio style and widget presets.
@MixWidget()
RemixRadioStyle fortalRadioStyle({
  FortalRadioVariant variant = .surface,
  FortalRadioSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalRadioSurfaceStyle(size),
    .soft => _fortalRadioSoftStyle(size),
  };
}

RemixRadioStyle _fortalRadioBaseStyle(FortalRadioSize size) {
  return RemixRadioStyle()
      .onFocused(
        RemixRadioStyle().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalRadioSizeStyle(size));
}

RemixRadioStyle _fortalRadioSurfaceStyle([FortalRadioSize size = .size2]) {
  return _fortalRadioBaseStyle(size)
      .fillColor(FortalTokens.colorSurface())
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radiusFull())
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent9())
            .borderRadiusAll(FortalTokens.radiusFull()),
      )
      .onSelected(
        RemixRadioStyle()
            .fillColor(FortalTokens.accent9())
            .borderAll(
              color: FortalTokens.accent9(),
              width: FortalTokens.borderWidth1(),
            )
            .indicator(BoxStyler().color(Colors.white)),
      )
      .onDisabled(
        RemixRadioStyle()
            .fillColor(FortalTokens.gray3())
            .borderAll(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .indicator(BoxStyler().color(FortalTokens.gray9())),
      );
}

RemixRadioStyle _fortalRadioSoftStyle([FortalRadioSize size = .size2]) {
  return _fortalRadioBaseStyle(size)
      .fillColor(FortalTokens.accentA4())
      .borderRadiusAll(FortalTokens.radiusFull())
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent11())
            .borderRadiusAll(FortalTokens.radiusFull()),
      )
      .onSelected(
        RemixRadioStyle()
            .fillColor(FortalTokens.accentA4())
            .indicator(BoxStyler().color(FortalTokens.accent11())),
      )
      .onDisabled(
        RemixRadioStyle()
            .fillColor(FortalTokens.gray3())
            .indicator(BoxStyler().color(FortalTokens.gray7())),
      );
}

RemixRadioStyle _fortalRadioSizeStyle(FortalRadioSize size) {
  return switch (size) {
    .size1 => RemixRadioStyle(
      container: BoxStyler().width(16.0).height(16.0).alignment(.center),
      indicator: BoxStyler().width(6.0).height(6.0),
    ),
    .size2 => RemixRadioStyle(
      container: BoxStyler().width(20.0).height(20.0).alignment(.center),
      indicator: BoxStyler().width(8.0).height(8.0),
    ),
    .size3 => RemixRadioStyle(
      container: BoxStyler().width(24.0).height(24.0).alignment(.center),
      indicator: BoxStyler().width(10.0).height(10.0),
    ),
  };
}
