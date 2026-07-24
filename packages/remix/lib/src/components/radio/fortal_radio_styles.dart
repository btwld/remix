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

/// Fortal-themed preset for [RemixRadio].
@MixWidget(
  name: 'FortalRadio',
  target: RemixRadio.new,
  factoryParameters: .only({'variant', 'size'}),
)
RemixRadioStyler fortalRadioStyler({
  FortalRadioVariant variant = .surface,
  FortalRadioSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalRadioSurfaceStyler(size),
    .soft => _fortalRadioSoftStyler(size),
  };
}

RemixRadioStyler _fortalRadioBaseStyler(FortalRadioSize size) {
  return RemixRadioStyler()
      .onFocused(
        RemixRadioStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalRadioSizeStyler(size));
}

RemixRadioStyler _fortalRadioSurfaceStyler([FortalRadioSize size = .size2]) {
  return _fortalRadioBaseStyler(size)
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
        RemixRadioStyler()
            .fillColor(FortalTokens.accent9())
            .borderAll(
              color: FortalTokens.accent9(),
              width: FortalTokens.borderWidth1(),
            )
            .indicator(BoxStyler().color(Colors.white)),
      )
      .onDisabled(
        RemixRadioStyler()
            .fillColor(FortalTokens.gray3())
            .borderAll(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .indicator(BoxStyler().color(FortalTokens.gray9())),
      );
}

RemixRadioStyler _fortalRadioSoftStyler([FortalRadioSize size = .size2]) {
  return _fortalRadioBaseStyler(size)
      .fillColor(FortalTokens.accentA4())
      .borderRadiusAll(FortalTokens.radiusFull())
      .indicator(
        BoxStyler()
            .color(FortalTokens.accent11())
            .borderRadiusAll(FortalTokens.radiusFull()),
      )
      .onSelected(
        RemixRadioStyler()
            .fillColor(FortalTokens.accentA4())
            .indicator(BoxStyler().color(FortalTokens.accent11())),
      )
      .onDisabled(
        RemixRadioStyler()
            .fillColor(FortalTokens.gray3())
            .indicator(BoxStyler().color(FortalTokens.gray7())),
      );
}

RemixRadioStyler _fortalRadioSizeStyler(FortalRadioSize size) {
  return switch (size) {
    .size1 => RemixRadioStyler(
      container: BoxStyler().width(16.0).height(16.0).alignment(.center),
      indicator: BoxStyler().width(6.0).height(6.0),
    ),
    .size2 => RemixRadioStyler(
      container: BoxStyler().width(20.0).height(20.0).alignment(.center),
      indicator: BoxStyler().width(8.0).height(8.0),
    ),
    .size3 => RemixRadioStyler(
      container: BoxStyler().width(24.0).height(24.0).alignment(.center),
      indicator: BoxStyler().width(10.0).height(10.0),
    ),
  };
}

/// Fortal-themed preset for [RemixRadio].
