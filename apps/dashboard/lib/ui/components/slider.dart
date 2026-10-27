import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'slider.g.dart';

/// Radix Themes slider sizes.
enum UiSliderSize { size1, size2, size3 }

/// Radix Themes slider variants.
enum UiSliderVariant { classic, surface, soft }

/// The accent-3 halo between a focused thumb and its ring.
///
/// Radix paints the thumb's focus as `0 0 0 3px accent-3, 0 0 0 5px focus-8`:
/// a 3px halo with the ring on top of it. The ring starts where the halo ends
/// and is [UiTokens.focusRingWidth] wide. The halo is its own 3px, not the
/// 2px `outline-offset` of the other outward rings, so it is not
/// [UiTokens.focusRingOffset].
const _thumbFocusHalo = 3.0;

/// Ui slider with Radix-owned size, variant, and component overrides.
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
      .thumbFocusEffects(
        uiFocusOutline(UiTokens.focus8(), offset: _thumbFocusHalo).overContent(
          RemixBoxEffectLayerMix(
            shadows: [
              RemixBoxShadowMix(
                color: UiTokens.accent3(),
                spreadRadius: _thumbFocusHalo,
              ),
            ],
          ),
        ),
      );

  final styled = switch (variant) {
    .classic => _uiSliderClassic(
      base,
      trackRadius: radius,
      thumbRadius: thumbRadius,
      highContrast: highContrast,
    ),
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
        .boxShadow([BoxShadowMix(color: UiTokens.blackA4(), spreadRadius: 1)]),
      ),
    );

SliderStyler _uiSliderClassic(
  SliderStyler base, {
  required BorderRadiusMix trackRadius,
  required BorderRadiusMix thumbRadius,
  required bool highContrast,
}) => base
    .track(.color(UiTokens.grayA3()))
    .range(.color(UiTokens.accentTrack()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      RemixBoxEffectsMix.overContent(
        RemixBoxEffectLayerMix(shadowToken: UiTokens.shadow1Layers),
      ),
    )
    .rangeEffects(
      RemixBoxEffectsMix.behindContent(
        RemixBoxEffectLayerMix(
          gradients: _uiSliderHighContrastGradients(highContrast),
          shadows: highContrast
              ? [
                  _uiSliderInset(UiTokens.grayA3()),
                  _uiSliderInset(UiTokens.blackA2()),
                  _uiSliderInset(
                    UiTokens.blackA2(),
                    offset: const Offset(0, 1.5),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ]
              : [
                  _uiSliderInset(UiTokens.grayA3()),
                  _uiSliderInset(UiTokens.accentA4()),
                  _uiSliderInset(UiTokens.blackA1()),
                  _uiSliderInset(
                    UiTokens.blackA2(),
                    offset: const Offset(0, 1.5),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
        ),
      ),
    )
    .thumb(
      BoxStyler().decoration(
        .boxShadow([
          BoxShadowMix(color: UiTokens.blackA3(), spreadRadius: 1),
          BoxShadowMix(
            color: UiTokens.blackA1(),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
          BoxShadowMix(
            color: UiTokens.blackA1(),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -1,
          ),
        ]),
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
        .boxShadow([
          BoxShadowMix(color: UiTokens.blackA3(), spreadRadius: 1),
          BoxShadowMix(color: UiTokens.grayA2(), spreadRadius: 1),
          BoxShadowMix(color: UiTokens.accentA2(), spreadRadius: 1),
          BoxShadowMix(
            color: UiTokens.grayA4(),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
          BoxShadowMix(
            color: UiTokens.grayA3(),
            offset: const Offset(0, 1),
            blurRadius: 3,
            spreadRadius: -0.5,
          ),
        ]),
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
    .classic =>
      SliderStyler()
          .track(.color(UiTokens.grayA3()))
          .trackEffects(
            RemixBoxEffectsMix.overContent(
              RemixBoxEffectLayerMix(
                shadowToken: UiTokens.sliderClassicDisabledTrackShadows,
              ),
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
          .boxShadow([
            BoxShadowMix(
              color: switch (variant) {
                .soft => UiTokens.gray5(),
                .classic || .surface => UiTokens.gray6(),
              },
              spreadRadius: 1,
            ),
          ]),
        ),
      )
      .thumbFocusEffects(
        RemixBoxEffectsMix(
          overContent: RemixBoxEffectLayerMix(shadows: const []),
          outline: BorderSideMix(style: BorderStyle.none),
        ),
      )
      .blendMode(BlendMode.multiply);
}

RemixBoxShadowMix _uiSliderInset(
  Color color, {
  Offset offset = Offset.zero,
  double blurRadius = 0,
  double spreadRadius = 1,
}) => RemixBoxShadowMix(
  kind: RemixBoxShadowKind.inset,
  color: color,
  offset: offset,
  blurRadius: blurRadius,
  spreadRadius: spreadRadius,
);

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
    trackSize: UiTokens.sliderTrackSize2(),
    thumbSize: UiTokens.sliderThumbSize2(),
    trackRadius: UiTokens.sliderTrackRadius2(),
  ),
  .size3 => _UiSliderMetrics(
    trackSize: UiTokens.sliderTrackSize3(),
    thumbSize: UiTokens.sliderThumbSize3(),
    trackRadius: UiTokens.sliderTrackRadius3(),
  ),
};
