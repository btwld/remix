import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'radio.g.dart';

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
@MixWidget(target: RemixRadio.new)
RadioStyler fortalRadioStyle({
  FortalRadioVariant variant = .surface,
  FortalRadioSize size = .size2,
  bool highContrast = false,
  RadioStyler style = const RadioStyler.create(),
}) {
  return (switch (variant) {
        .surface => _fortalRadioSurfaceStyler(size, highContrast: highContrast),
        .soft => _fortalRadioSoftStyler(size, highContrast: highContrast),
      })
      .wrap(fortalTouchTarget())
      .onDisabled(
        RadioStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

RadioStyler _fortalRadioBaseStyler(FortalRadioSize size) {
  final metrics = _fortalRadioMetrics(size);
  return RadioStyler(
    container: .size(
      metrics.size,
      metrics.size,
    ).alignment(.center).borderRadius(.all(FortalTokens.radiusCircle())),
    indicator: .size(
      metrics.indicatorSize,
      metrics.indicatorSize,
    ).borderRadius(.all(FortalTokens.radiusCircle())),
    containerEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
  ).onFocusVisible(.containerEffects(fortalFocusOutline()));
}

RadioStyler _fortalRadioSurfaceStyler(
  FortalRadioSize size, {
  required bool highContrast,
}) {
  return _fortalRadioBaseStyler(size)
      .color(FortalTokens.colorSurface())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          fortalInsetSurface(strokes: [FortalTokens.controlBorder()]),
        ),
      )
      .indicator(
        .color(
          FortalTokens.accent9(),
        ).borderRadius(.all(FortalTokens.radiusCircle())),
      )
      .onSelected(
        .color(
              highContrast
                  ? FortalTokens.accent12()
                  : FortalTokens.accentIndicator(),
            )
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
                  ? FortalTokens.accent1()
                  : FortalTokens.accentIndicatorContrast(),
            ),
      )
      .onDisabled(
        .color(FortalTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                fortalInsetSurface(strokes: [FortalTokens.grayA6()]),
              ),
            )
            .indicatorColor(FortalTokens.grayA8()),
      );
}

RadioStyler _fortalRadioSoftStyler(
  FortalRadioSize size, {
  required bool highContrast,
}) {
  return _fortalRadioBaseStyler(size)
      .color(FortalTokens.accentA4())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      // The tint alone is too faint to show an empty control; the accent-8
      // ring keeps a 3:1 boundary in every enabled state.
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          fortalInsetSurface(strokes: [FortalTokens.accentA8()]),
        ),
      )
      .indicator(
        .color(
          highContrast ? FortalTokens.accent12() : FortalTokens.accent11(),
        ).borderRadius(.all(FortalTokens.radiusCircle())),
      )
      .onSelected(
        .color(FortalTokens.accentA4())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .indicator(
              .color(
                highContrast
                    ? FortalTokens.accent12()
                    : FortalTokens.accent11(),
              ),
            ),
      )
      .onDisabled(
        .color(FortalTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                RemixBoxEffectLayerMix(shadows: const []),
              ),
            )
            .indicatorColor(FortalTokens.grayA8()),
      );
}

({double size, double indicatorSize}) _fortalRadioMetrics(
  FortalRadioSize size,
) => switch (size) {
  .size1 => (
    size: FortalTokens.checkboxSize1(),
    indicatorSize: FortalTokens.radioIndicatorSize1(),
  ),
  .size2 => (
    size: FortalTokens.space4(),
    indicatorSize: FortalTokens.radioIndicatorSize2(),
  ),
  .size3 => (
    size: FortalTokens.checkboxSize3(),
    indicatorSize: FortalTokens.space2(),
  ),
};
