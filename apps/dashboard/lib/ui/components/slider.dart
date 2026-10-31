import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'slider.g.dart';

/// Ui slider sizes.
enum UiSliderSize { size1, size2, size3 }

/// Ui slider variants.
enum UiSliderVariant { surface, soft }

/// Ui slider with Ui-owned size, variant, and component overrides.
@MixWidget(target: RemixSlider.new)
SliderStyler uiSliderStyle({
  UiSliderVariant variant = .surface,
  UiSliderSize size = .size2,
  bool highContrast = false,
  SliderStyler style = const SliderStyler.create(),
}) {
  final metrics = _uiSliderMetrics(size);
  final radius = BorderRadiusMix.all(metrics.trackRadius);
  final thumbRadius = BorderRadiusMix.all(UiTokens.radius1OrThumb());
  final base = SliderStyler()
      .track(.borderRadius(radius))
      .range(.borderRadius(radius))
      .thumb(
        .size(metrics.thumbSize, metrics.thumbSize).borderRadius(thumbRadius),
      )
      .thickness(metrics.trackSize)
      .thumbFocusEffects(uiFocusOutline());

  final styled = switch (variant) {
    .surface => _uiSliderSurface(
      base,
      trackRadius: radius,
      thumbRadius: thumbRadius,
      highContrast: highContrast,
    ),
    .soft => _uiSliderSoft(
      base,
      trackRadius: radius,
      thumbRadius: thumbRadius,
      highContrast: highContrast,
    ),
  };
  return styled
      .onDisabled(
        _uiSliderDisabled(
          variant,
          trackRadius: radius,
          thumbRadius: thumbRadius,
        ),
      )
      .variant(
        ContextVariant(
          'uiSliderDisabledDarkBlend',
          (context) => UiTheme.of(context).isDark,
        ),
        SliderStyler().onDisabled(.blendMode(BlendMode.screen)),
      )
      .wrap(uiTouchTarget())
      .merge(style);
}

SliderStyler _uiSliderSurface(
  SliderStyler base, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
  required bool highContrast,
}) => base
    .track(.color(UiTokens.grayA3()))
    .range(.color(UiTokens.accentTrack()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      RemixBoxEffectsMix.behindContent(
        uiInsetSurface(strokes: [UiTokens.grayA5()]),
      ),
    )
    .rangeEffects(
      RemixBoxEffectsMix.behindContent(
        uiInsetSurface(strokes: [UiTokens.grayA5()]).merge(
          RemixBoxEffectLayerMix(
            gradients: _uiSliderHighContrastGradients(highContrast),
          ),
        ),
      ),
    )
    .thumb(
      BoxStyler().decoration(
        .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1()))),
      ),
    );

SliderStyler _uiSliderSoft(
  SliderStyler base, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
  required bool highContrast,
}) => base
    .track(.color(UiTokens.grayA4()))
    .range(.color(UiTokens.accent6()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      RemixBoxEffectsMix.behindContent(
        RemixBoxEffectLayerMix(
          gradients: [
            RemixLinearGradientMix(
              colors: [UiTokens.whiteA1(), UiTokens.whiteA1()],
            ),
          ],
        ),
      ),
    )
    .rangeEffects(
      RemixBoxEffectsMix.behindContent(
        RemixBoxEffectLayerMix(
          gradients: [
            RemixLinearGradientMix(
              colors: [UiTokens.accentA5(), UiTokens.accentA5()],
            ),
            ..._uiSliderHighContrastGradients(highContrast),
          ],
        ),
      ),
    )
    .thumb(
      BoxStyler().decoration(
        .border(.all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1()))),
      ),
    );

SliderStyler _uiSliderDisabled(
  UiSliderVariant variant, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
}) {
  final track = switch (variant) {
    .surface =>
      SliderStyler()
          .track(.color(UiTokens.grayA3()))
          .trackEffects(
            RemixBoxEffectsMix.behindContent(
              uiInsetSurface(strokes: [UiTokens.grayA4()]),
            ),
          ),
    .soft =>
      SliderStyler()
          .track(.color(UiTokens.grayA4()))
          .trackEffects(
            RemixBoxEffectsMix.behindContent(
              RemixBoxEffectLayerMix(gradients: const []),
            ),
          ),
  };
  return track
      .range(.color(const Color(0x00000000)))
      .thumbColor(UiTokens.gray1())
      .rangeEffects(
        RemixBoxEffectsMix.behindContent(
          RemixBoxEffectLayerMix(gradients: const [], shadows: const []),
        ),
      )
      .rangeEffects(
        RemixBoxEffectsMix.overContent(
          RemixBoxEffectLayerMix(gradients: const [], shadows: const []),
        ),
      )
      .thumb(
        BoxStyler().decoration(
          .border(
            .all(.color(UiTokens.gray7()).width(UiTokens.borderWidth1())),
          ),
        ),
      )
      .thumbFocusEffects(
        RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
      )
      .blendMode(BlendMode.multiply);
}

List<RemixLinearGradientMix> _uiSliderHighContrastGradients(
  bool highContrast,
) => highContrast
    ? [
        RemixLinearGradientMix(
          colors: [
            UiTokens.sliderHighContrastOverlay(),
            UiTokens.sliderHighContrastOverlay(),
          ],
        ),
      ]
    : const [];

class _UiSliderMetrics {
  const _UiSliderMetrics({
    required this.trackSize,
    required this.thumbSize,
    required this.trackRadius,
  });

  final double trackSize;
  final double thumbSize;
  final Radius trackRadius;
}

_UiSliderMetrics _uiSliderMetrics(UiSliderSize size) => switch (size) {
  .size1 => _UiSliderMetrics(
    trackSize: UiTokens.sliderTrackSize1(),
    thumbSize: UiTokens.sliderThumbSize1(),
    trackRadius: UiTokens.sliderTrackRadius1(),
  ),
  .size2 => _UiSliderMetrics(
    trackSize: UiTokens.space2(),
    thumbSize: UiTokens.space4(),
    trackRadius: UiTokens.sliderTrackRadius2(),
  ),
  .size3 => _UiSliderMetrics(
    trackSize: UiTokens.sliderTrackSize3(),
    thumbSize: UiTokens.sliderThumbSize3(),
    trackRadius: UiTokens.sliderTrackRadius3(),
  ),
};
