import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'slider.g.dart';

/// Fortal slider sizes.
enum FortalSliderSize { size1, size2, size3 }

/// Fortal slider variants.
enum FortalSliderVariant { surface, soft }

/// Fortal slider with Fortal-owned size, variant, and component overrides.
@MixWidget(target: RemixSlider.new)
SliderStyler fortalSliderStyle({
  FortalSliderVariant variant = .surface,
  FortalSliderSize size = .size2,
  bool highContrast = false,
  SliderStyler style = const SliderStyler.create(),
}) {
  final metrics = _fortalSliderMetrics(size);
  final radius = BorderRadiusMix.all(metrics.trackRadius);
  final thumbRadius = BorderRadiusMix.all(FortalTokens.radius1OrThumb());
  final base = SliderStyler()
      .track(.borderRadius(radius))
      .range(.borderRadius(radius))
      .thumb(
        .size(metrics.thumbSize, metrics.thumbSize).borderRadius(thumbRadius),
      )
      .thickness(metrics.trackSize)
      .thumbFocusEffects(fortalFocusOutline());

  final styled = switch (variant) {
    .surface => _fortalSliderSurface(
      base,
      trackRadius: radius,
      thumbRadius: thumbRadius,
      highContrast: highContrast,
    ),
    .soft => _fortalSliderSoft(
      base,
      trackRadius: radius,
      thumbRadius: thumbRadius,
      highContrast: highContrast,
    ),
  };
  return styled
      .onDisabled(
        _fortalSliderDisabled(
          variant,
          trackRadius: radius,
          thumbRadius: thumbRadius,
        ),
      )
      .variant(
        ContextVariant(
          'fortalSliderDisabledDarkBlend',
          (context) => FortalTheme.of(context).isDark,
        ),
        SliderStyler().onDisabled(.blendMode(BlendMode.screen)),
      )
      .wrap(fortalTouchTarget())
      .merge(style);
}

SliderStyler _fortalSliderSurface(
  SliderStyler base, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
  required bool highContrast,
}) => base
    .track(.color(FortalTokens.grayA3()))
    .range(.color(FortalTokens.accentTrack()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      RemixBoxEffectsMix.behindContent(
        fortalInsetSurface(strokes: [FortalTokens.grayA5()]),
      ),
    )
    .rangeEffects(
      RemixBoxEffectsMix.behindContent(
        fortalInsetSurface(strokes: [FortalTokens.grayA5()]).merge(
          RemixBoxEffectLayerMix(
            gradients: _fortalSliderHighContrastGradients(highContrast),
          ),
        ),
      ),
    )
    .thumb(_fortalSliderThumbRing());

SliderStyler _fortalSliderSoft(
  SliderStyler base, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
  required bool highContrast,
}) => base
    .track(.color(FortalTokens.grayA4()))
    .range(.color(FortalTokens.accent6()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      RemixBoxEffectsMix.behindContent(
        RemixBoxEffectLayerMix(
          gradients: [
            RemixLinearGradientMix(
              colors: [FortalTokens.whiteA1(), FortalTokens.whiteA1()],
            ),
          ],
        ),
      ),
    )
    // The range is step 6 alone. Alpha steps reconstruct their tint over the
    // page and can be opaque, so layering accent alpha 5 here would replace
    // step 6 rather than deepen it.
    .rangeEffects(
      RemixBoxEffectsMix.behindContent(
        RemixBoxEffectLayerMix(
          gradients: _fortalSliderHighContrastGradients(highContrast),
        ),
      ),
    )
    .thumb(_fortalSliderThumbRing());

/// The white thumb's ring ([FortalTokens.accentThumbRing]): the range colour
/// where white stands out on it and it keeps 3:1 on the page and panels, the
/// neutral control border where it does not, and a dark ink on bright ranges.
/// The thumb overhangs the track, so the ring and white face carry it.
BoxStyler _fortalSliderThumbRing() => BoxStyler().decoration(
  .border(
    .all(
      .color(FortalTokens.accentThumbRing()).width(FortalTokens.borderWidth2()),
    ),
  ),
);

SliderStyler _fortalSliderDisabled(
  FortalSliderVariant variant, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
}) {
  final track = switch (variant) {
    .surface =>
      SliderStyler()
          .track(.color(FortalTokens.grayA3()))
          .trackEffects(
            RemixBoxEffectsMix.behindContent(
              fortalInsetSurface(strokes: [FortalTokens.grayA4()]),
            ),
          ),
    .soft =>
      SliderStyler()
          .track(.color(FortalTokens.grayA4()))
          .trackEffects(
            RemixBoxEffectsMix.behindContent(
              RemixBoxEffectLayerMix(gradients: const []),
            ),
          ),
  };
  return track
      .range(.color(const Color(0x00000000)))
      .thumbColor(FortalTokens.gray1())
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
            .all(
              .color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()),
            ),
          ),
        ),
      )
      .thumbFocusEffects(
        RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
      )
      .blendMode(BlendMode.multiply);
}

List<RemixLinearGradientMix> _fortalSliderHighContrastGradients(
  bool highContrast,
) => highContrast
    ? [
        RemixLinearGradientMix(
          colors: [
            FortalTokens.sliderHighContrastOverlay(),
            FortalTokens.sliderHighContrastOverlay(),
          ],
        ),
      ]
    : const [];

class _FortalSliderMetrics {
  const _FortalSliderMetrics({
    required this.trackSize,
    required this.thumbSize,
    required this.trackRadius,
  });

  final double trackSize;
  final double thumbSize;
  final Radius trackRadius;
}

_FortalSliderMetrics _fortalSliderMetrics(FortalSliderSize size) =>
    switch (size) {
      .size1 => _FortalSliderMetrics(
        trackSize: FortalTokens.sliderTrackSize1(),
        thumbSize: FortalTokens.sliderThumbSize1(),
        trackRadius: FortalTokens.sliderTrackRadius1(),
      ),
      .size2 => _FortalSliderMetrics(
        trackSize: FortalTokens.space2(),
        thumbSize: FortalTokens.space4(),
        trackRadius: FortalTokens.sliderTrackRadius2(),
      ),
      .size3 => _FortalSliderMetrics(
        trackSize: FortalTokens.sliderTrackSize3(),
        thumbSize: FortalTokens.sliderThumbSize3(),
        trackRadius: FortalTokens.sliderTrackRadius3(),
      ),
    };
