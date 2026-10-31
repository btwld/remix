import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'switch.g.dart';

/// Ui switch size presets.
enum UiSwitchSize {
  /// Compact switch.
  size1,

  /// Default switch.
  size2,

  /// Large switch.
  size3,
}

/// Ui switch color variants.
enum UiSwitchVariant {
  /// Surface treatment with a visible border.
  surface,

  /// Softer accent treatment.
  soft,
}

/// Ui-themed preset for [RemixSwitch].
@MixWidget(target: RemixSwitch.new)
SwitchStyler uiSwitchStyle({
  UiSwitchVariant variant = .surface,
  UiSwitchSize size = .size2,
  bool highContrast = false,
  SwitchStyler style = const SwitchStyler.create(),
}) {
  return (switch (variant) {
    .surface => _uiSwitchSurfaceStyler(size, highContrast: highContrast),
    .soft => _uiSwitchSoftStyler(size, highContrast: highContrast),
  }).wrap(uiTouchTarget()).merge(style);
}

SwitchStyler _uiSwitchBaseStyler(UiSwitchSize size) {
  final metrics = _uiSwitchMetrics(size);
  return SwitchStyler(
        container: .size(
          metrics.width,
          metrics.height,
        ).padding(.all(1)).borderRadius(.all(metrics.radius)),
        thumb: .size(
          metrics.thumbSize,
          metrics.thumbSize,
        ).borderRadius(.all(metrics.radius)),
        trackEffects: RemixBoxEffectsMix(
          behindContent: _uiSwitchLayer(),
          overContent: _uiSwitchLayer(),
        ),
      )
      .thumbColor(const Color(0xFFFFFFFF))
      .onFocusVisible(.trackEffects(uiFocusOutline()));
}

SwitchStyler _uiSwitchSurfaceStyler(
  UiSwitchSize size, {
  required bool highContrast,
}) {
  return _uiSwitchBaseStyler(size)
      .trackColor(UiTokens.grayA3())
      .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer()))
      .trackEffects(
        RemixBoxEffectsMix.overContent(_uiSwitchInsetRing(UiTokens.grayA5())),
      )
      .thumb(_uiSwitchThumbStyler(selected: false, highContrast: highContrast))
      .onSelected(
        SwitchStyler()
            .trackColor(
              highContrast ? UiTokens.accent12() : UiTokens.accentTrack(),
            )
            .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer()))
            .thumb(
              _uiSwitchThumbStyler(selected: true, highContrast: highContrast),
            ),
      )
      .onPressed(
        SwitchStyler()
            .trackColor(UiTokens.grayA4())
            .onSelected(
              SwitchStyler().trackColor(
                highContrast ? UiTokens.accent12() : UiTokens.accent10(),
              ),
            )
            .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer())),
      )
      .onDisabled(_uiSwitchDisabledStyler());
}

SwitchStyler _uiSwitchSoftStyler(
  UiSwitchSize size, {
  required bool highContrast,
}) {
  return _uiSwitchBaseStyler(size)
      .trackColor(UiTokens.grayA3())
      .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer()))
      .thumb(
        _uiSwitchSoftThumbStyler(selected: false, highContrast: highContrast),
      )
      .onSelected(
        SwitchStyler()
            .trackColor(
              highContrast ? UiTokens.accentA6() : UiTokens.accentA4(),
            )
            .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer()))
            .thumb(
              _uiSwitchSoftThumbStyler(
                selected: true,
                highContrast: highContrast,
              ),
            ),
      )
      .onPressed(
        SwitchStyler()
            .trackColor(UiTokens.grayA4())
            .onSelected(
              SwitchStyler().trackColor(
                highContrast ? UiTokens.accentA7() : UiTokens.accentA5(),
              ),
            )
            .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer())),
      )
      .onDisabled(_uiSwitchDisabledStyler(soft: true));
}

({double width, double height, double thumbSize, Radius radius})
_uiSwitchMetrics(UiSwitchSize size) {
  final height = switch (size) {
    .size1 => UiTokens.space4(),
    .size2 => UiTokens.switchHeight2(),
    .size3 => UiTokens.space5(),
  };
  final width = switch (size) {
    .size1 => UiTokens.switchWidth1(),
    .size2 => UiTokens.switchWidth2(),
    .size3 => UiTokens.switchWidth3(),
  };
  final thumbSize = switch (size) {
    .size1 => UiTokens.switchThumbSize1(),
    .size2 => UiTokens.switchThumbSize2(),
    .size3 => UiTokens.switchThumbSize3(),
  };
  final radius = switch (size) {
    .size1 => UiTokens.radius1OrThumb(),
    .size2 || .size3 => UiTokens.radius2OrThumb(),
  };
  return (width: width, height: height, thumbSize: thumbSize, radius: radius);
}

SwitchStyler _uiSwitchDisabledStyler({bool soft = false}) => SwitchStyler()
    .trackColor(soft ? UiTokens.grayA4() : UiTokens.grayA3())
    .thumbColor(UiTokens.gray2())
    .thumb(
      .border(.all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1()))),
    )
    .trackEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

BoxStyler _uiSwitchThumbStyler({
  required bool selected,
  required bool highContrast,
}) => BoxStyler()
    .color(
      selected
          ? (highContrast ? UiTokens.accent1() : UiTokens.accentContrast())
          : const Color(0xFFFFFFFF),
    )
    .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())));

BoxStyler _uiSwitchSoftThumbStyler({
  required bool selected,
  required bool highContrast,
}) => BoxStyler()
    .color(
      selected
          ? (highContrast ? UiTokens.accent12() : UiTokens.accent11())
          : const Color(0xFFFFFFFF),
    )
    .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())));

RemixBoxEffectLayerMix _uiSwitchInsetRing(Color color) => _uiSwitchLayer(
  shadows: [RemixBoxShadowMix(kind: .inset, color: color, spreadRadius: 1)],
);

RemixBoxEffectLayerMix _uiSwitchLayer({
  List<RemixBoxShadowMix>? shadows,
  RemixBoxShadowListToken? shadowToken,
}) => RemixBoxEffectLayerMix(shadows: shadows, shadowToken: shadowToken);
