part of 'switch.dart';

/// Fortal switch size presets.
enum FortalSwitchSize {
  /// Compact switch.
  size1,

  /// Default switch.
  size2,

  /// Large switch.
  size3,
}

/// Fortal switch color variants.
enum FortalSwitchVariant {
  /// Surface treatment with a visible border.
  surface,

  /// Softer accent treatment.
  soft,
}

/// Fortal-themed preset for [RemixSwitch].
@MixWidget(
  name: 'FortalSwitch',
  target: RemixSwitch.new,
  factoryParameters: .only({'variant', 'size'}),
)
RemixSwitchStyler fortalSwitchStyler({
  FortalSwitchVariant variant = .surface,
  FortalSwitchSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalSwitchSurfaceStyler(size),
    .soft => _fortalSwitchSoftStyler(size),
  };
}

RemixSwitchStyler _fortalSwitchBaseStyler(FortalSwitchSize size) {
  return RemixSwitchStyler()
      .thumbColor(Colors.white)
      .thumb(
        BoxStyler().shapeCircle().shadow(
          BoxShadowMix()
              .color(FortalTokens.grayA7())
              .offset(x: 0, y: 2)
              .blurRadius(3),
        ),
      )
      .onFocused(
        RemixSwitchStyler().borderAll(
          color: FortalTokens.focusA8(),
          width: FortalTokens.focusRingWidth(),
        ),
      )
      .merge(_fortalSwitchSizeStyler(size));
}

RemixSwitchStyler _fortalSwitchSurfaceStyler([FortalSwitchSize size = .size2]) {
  return _fortalSwitchBaseStyler(size)
      .trackColor(FortalTokens.gray5())
      .borderRadius(BorderRadiusMix.circular(999))
      .borderAll(
        color: FortalTokens.gray8(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignCenter,
      )
      .onSelected(
        RemixSwitchStyler()
            .trackColor(FortalTokens.accentTrack())
            .borderAll(color: FortalTokens.accent9()),
      )
      .onDisabled(
        RemixSwitchStyler()
            .trackColor(FortalTokens.grayA3())
            .borderAll(color: FortalTokens.gray5())
            .thumbColor(FortalTokens.gray2()),
      );
}

RemixSwitchStyler _fortalSwitchSoftStyler([FortalSwitchSize size = .size2]) {
  return _fortalSwitchBaseStyler(size)
      .trackColor(FortalTokens.gray5())
      .borderRadius(BorderRadiusMix.circular(999))
      .borderAll(
        color: FortalTokens.gray5(),
        width: FortalTokens.borderWidth1(),
        strokeAlign: BorderSide.strokeAlignCenter,
      )
      .onSelected(
        RemixSwitchStyler()
            .trackColor(FortalTokens.accentA7())
            .borderAll(color: FortalTokens.accent7()),
      )
      .onDisabled(
        RemixSwitchStyler()
            .trackColor(FortalTokens.gray5())
            .borderAll(color: FortalTokens.gray5())
            .shadow(BoxShadowMix())
            .thumbColor(FortalTokens.gray2()),
      );
}

RemixSwitchStyler _fortalSwitchSizeStyler(FortalSwitchSize size) {
  return switch (size) {
    .size1 => RemixSwitchStyler(
      container: BoxStyler().width(28.0).height(16.0),
      thumb: BoxStyler().width(16.0).height(16.0),
    ),
    .size2 => RemixSwitchStyler(
      container: BoxStyler().width(35.0).height(20.0),
      thumb: BoxStyler().size(20.0, 20.0),
    ),
    .size3 => RemixSwitchStyler(
      container: BoxStyler().width(42.0).height(24.0),
      thumb: BoxStyler().size(24.0, 24.0),
    ),
  };
}

/// Fortal-themed preset for [RemixSwitch].
