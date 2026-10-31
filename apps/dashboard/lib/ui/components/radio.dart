import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'radio.g.dart';

/// Ui radio size presets.
enum UiRadioSize {
  /// Compact radio.
  size1,

  /// Default radio.
  size2,

  /// Large radio.
  size3,
}

/// Ui radio color variants.
enum UiRadioVariant {
  /// Surface treatment with neutral border.
  surface,

  /// Soft accent treatment.
  soft,
}

/// Ui-themed preset for [RemixRadio].
@MixWidget(target: RemixRadio.new)
RadioStyler uiRadioStyle({
  UiRadioVariant variant = .surface,
  UiRadioSize size = .size2,
  bool highContrast = false,
  RadioStyler style = const RadioStyler.create(),
}) {
  return (switch (variant) {
        .surface => _uiRadioSurfaceStyler(size, highContrast: highContrast),
        .soft => _uiRadioSoftStyler(size, highContrast: highContrast),
      })
      .wrap(uiTouchTarget())
      .onDisabled(
        RadioStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

RadioStyler _uiRadioBaseStyler(UiRadioSize size) {
  final metrics = _uiRadioMetrics(size);
  return RadioStyler(
    container: .size(
      metrics.size,
      metrics.size,
    ).alignment(.center).borderRadius(.all(UiTokens.radiusCircle())),
    indicator: .size(
      metrics.indicatorSize,
      metrics.indicatorSize,
    ).borderRadius(.all(UiTokens.radiusCircle())),
    containerEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
  ).onFocusVisible(.containerEffects(uiFocusOutline()));
}

RadioStyler _uiRadioSurfaceStyler(
  UiRadioSize size, {
  required bool highContrast,
}) {
  return _uiRadioBaseStyler(size)
      .color(UiTokens.colorSurface())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          uiInsetSurface(strokes: [UiTokens.controlBorder()]),
        ),
      )
      .indicator(
        .color(UiTokens.accent9()).borderRadius(.all(UiTokens.radiusCircle())),
      )
      .onSelected(
        .color(highContrast ? UiTokens.accent12() : UiTokens.accentIndicator())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                RemixBoxEffectLayerMix(shadows: const []),
              ),
            )
            .indicatorColor(
              highContrast
                  ? UiTokens.accent1()
                  : UiTokens.accentIndicatorContrast(),
            ),
      )
      .onDisabled(
        .color(UiTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                uiInsetSurface(strokes: [UiTokens.grayA6()]),
              ),
            )
            .indicatorColor(UiTokens.grayA8()),
      );
}

RadioStyler _uiRadioSoftStyler(UiRadioSize size, {required bool highContrast}) {
  return _uiRadioBaseStyler(size)
      .color(UiTokens.accentA4())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      // The tint alone is too faint to show an empty control; the accent-8
      // ring keeps a 3:1 boundary in every enabled state.
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          uiInsetSurface(strokes: [UiTokens.accentA8()]),
        ),
      )
      .indicator(
        .color(
          highContrast ? UiTokens.accent12() : UiTokens.accent11(),
        ).borderRadius(.all(UiTokens.radiusCircle())),
      )
      .onSelected(
        .color(UiTokens.accentA4())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .indicator(
              .color(highContrast ? UiTokens.accent12() : UiTokens.accent11()),
            ),
      )
      .onDisabled(
        .color(UiTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                RemixBoxEffectLayerMix(shadows: const []),
              ),
            )
            .indicatorColor(UiTokens.grayA8()),
      );
}

({double size, double indicatorSize}) _uiRadioMetrics(UiRadioSize size) =>
    switch (size) {
      .size1 => (
        size: UiTokens.checkboxSize1(),
        indicatorSize: UiTokens.radioIndicatorSize1(),
      ),
      .size2 => (
        size: UiTokens.space4(),
        indicatorSize: UiTokens.radioIndicatorSize2(),
      ),
      .size3 => (
        size: UiTokens.checkboxSize3(),
        indicatorSize: UiTokens.space2(),
      ),
    };
