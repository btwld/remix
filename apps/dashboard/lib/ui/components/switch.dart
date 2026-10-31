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
        RemixBoxEffectsMix.overContent(
          _uiSwitchInsetRing(UiTokens.controlBorder()),
        ),
      )
      .thumb(_uiSwitchOffThumbStyler())
      .onSelected(
        SwitchStyler()
            .trackColor(
              highContrast ? UiTokens.accent12() : UiTokens.accentTrack(),
            )
            .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer()))
            .trackEffects(
              RemixBoxEffectsMix.overContent(
                _uiSwitchInsetRing(UiTokens.grayA5()),
              ),
            )
            .thumb(_uiSwitchSelectedThumbStyler(highContrast)),
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
      .trackEffects(
        RemixBoxEffectsMix.overContent(
          _uiSwitchInsetRing(UiTokens.controlBorder()),
        ),
      )
      .thumb(_uiSwitchOffThumbStyler())
      .onSelected(
        SwitchStyler()
            .trackColor(
              highContrast ? UiTokens.accentA6() : UiTokens.accentA4(),
            )
            .trackEffects(RemixBoxEffectsMix.behindContent(_uiSwitchLayer()))
            .trackEffects(
              RemixBoxEffectsMix.overContent(_uiSwitchInsetRing(null)),
            )
            .thumb(_uiSwitchSoftSelectedThumbStyler(highContrast)),
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

/// Disabled switches stay muted: the active off-track boundary is replaced by
/// the quiet gray-alpha-5 edge (surface) or removed (soft), whatever the
/// selection, focus or press state.
SwitchStyler _uiSwitchDisabledStyler({bool soft = false}) => SwitchStyler()
    .trackColor(soft ? UiTokens.grayA4() : UiTokens.grayA3())
    .trackEffects(
      RemixBoxEffectsMix.overContent(
        _uiSwitchInsetRing(soft ? null : UiTokens.grayA5()),
      ),
    )
    .thumbColor(UiTokens.gray2())
    .thumb(
      .border(.all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1()))),
    )
    .trackEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)));

/// The off thumb is a light surface; its neutral ring separates it from the
/// off track in light mode, where white alone is too close to the track.
BoxStyler _uiSwitchOffThumbStyler() => BoxStyler()
    .color(const Color(0xFFFFFFFF))
    .border(
      .all(.color(UiTokens.controlBorder()).width(UiTokens.borderWidth1())),
    );

/// The selected surface thumb stays a light surface rather than a disc of ink.
/// Its 2px [UiTokens.accentThumbRing] follows the track wherever white
/// already stands out on it, and carries the contrast on bright tracks. High
/// contrast keeps its deliberate step-1 knockout thumb.
BoxStyler _uiSwitchSelectedThumbStyler(bool highContrast) => highContrast
    ? BoxStyler()
          .color(UiTokens.accent1())
          .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())))
    : BoxStyler()
          .color(const Color(0xFFFFFFFF))
          .border(
            .all(
              .color(UiTokens.accentThumbRing()).width(UiTokens.borderWidth2()),
            ),
          );

/// Selected soft thumbs keep their accent content role on the tinted track.
BoxStyler _uiSwitchSoftSelectedThumbStyler(bool highContrast) => BoxStyler()
    .color(highContrast ? UiTokens.accent12() : UiTokens.accent11())
    .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())));

/// A 1px inset track ring, or none when [color] is null.
RemixBoxEffectLayerMix _uiSwitchInsetRing(Color? color) => _uiSwitchLayer(
  shadows: [
    if (color != null)
      RemixBoxShadowMix(kind: .inset, color: color, spreadRadius: 1),
  ],
);

RemixBoxEffectLayerMix _uiSwitchLayer({
  List<RemixBoxShadowMix>? shadows,
  RemixBoxShadowListToken? shadowToken,
}) => RemixBoxEffectLayerMix(shadows: shadows, shadowToken: shadowToken);
