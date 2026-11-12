import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'slider.g.dart';

/// The sizes a slider comes in. Pixel values are at 100% theme scaling.
enum UiSliderSize {
  /// A 6px track with a 13px thumb.
  size1,

  /// An 8px track with a 16px thumb. The default.
  size2,

  /// A 10px track with a 19px thumb.
  size3,
}

/// The looks a slider comes in.
enum UiSliderVariant {
  /// A gray track and a solid accent range.
  surface,

  /// A gray track and a softer accent range.
  soft,
}

/// The Ui Slider recipe.
///
/// It reads top to bottom: the track and thumb sizes, then the variant's
/// colors, then the dark-mode thumb edge, hover, press and disabled.
///
/// [highContrast] darkens the range with an overlay.
@MixWidget(target: RemixSlider.new)
SliderStyler uiSliderStyle({
  UiSliderVariant variant = .surface,
  UiSliderSize size = .size2,
  bool highContrast = false,
  SliderStyler style = const SliderStyler.create(),
}) => _base(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .variant(
      ContextVariant('uiSliderDark', (context) => UiTheme.of(context).isDark),
      SliderStyler().thumb(
        .border(.all(.color(UiTokens.gray3()).width(UiTokens.borderWidth2()))),
      ),
    )
    .onHovered(
      SliderStyler().thumbEffects(
        RemixBoxEffectsMix(
          outline: .color(UiTokens.accentA7()).width(UiTokens.borderWidth2()),
        ),
      ),
    )
    .onPressed(
      SliderStyler()
          .thumbEffects(
            RemixBoxEffectsMix(
              outline: .color(UiTokens.accentA6()).width(UiTokens.space1()),
            ),
          )
          .thumb(
            .border(
              .all(.color(UiTokens.accent12()).width(UiTokens.borderWidth2())),
            ),
          ),
    )
    .onDisabled(_disabled(variant))
    .wrap(.sizedBox(height: UiTokens.space8()))
    .wrap(uiTouchTarget())
    .merge(style);

/// The track and thumb sizes of each step, and the focus ring.
SliderStyler _base(UiSliderSize size) {
  final (:track, :thumb, :trackRadius) = switch (size) {
    .size1 => (
      track: UiTokens.sliderTrackSize1(),
      thumb: UiTokens.sliderThumbSize1(),
      trackRadius: UiTokens.sliderTrackRadius1(),
    ),
    .size2 => (
      track: UiTokens.space2(),
      thumb: UiTokens.space4(),
      trackRadius: UiTokens.sliderTrackRadius2(),
    ),
    .size3 => (
      track: UiTokens.sliderTrackSize3(),
      thumb: UiTokens.sliderThumbSize3(),
      trackRadius: UiTokens.sliderTrackRadius3(),
    ),
  };
  final radius = BorderRadiusMix.all(trackRadius);

  return SliderStyler()
      .track(.borderRadius(radius))
      .range(.borderRadius(radius))
      .thumb(
        .size(
          thumb,
          thumb,
        ).borderRadius(BorderRadiusMix.all(UiTokens.radius1OrThumb())),
      )
      .thickness(track)
      .thumbFocusEffects(uiSliderFocusOutline());
}

SliderStyler _surface(bool highContrast) => SliderStyler()
    .track(.color(UiTokens.grayA3()))
    .range(.color(UiTokens.accentTrack()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(.behindContent(uiInsetSurface(strokes: [UiTokens.grayA5()])))
    .rangeEffects(
      .behindContent(
        uiInsetSurface(
          strokes: [UiTokens.grayA5()],
        ).merge(RemixBoxEffectLayerMix(gradients: _overlay(highContrast))),
      ),
    )
    .thumb(_thumbRing());

SliderStyler _soft(bool highContrast) => SliderStyler()
    .track(.color(UiTokens.grayA4()))
    .range(.color(UiTokens.accent6()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      .behindContent(
        RemixBoxEffectLayerMix(
          gradients: [
            RemixLinearGradientMix(
              colors: [UiTokens.whiteA1(), UiTokens.whiteA1()],
            ),
          ],
        ),
      ),
    )
    // The range is step 6 alone. Alpha steps reconstruct their tint over the
    // page and can be opaque, so layering accent alpha 5 here would replace
    // step 6 rather than deepen it.
    .rangeEffects(
      .behindContent(RemixBoxEffectLayerMix(gradients: _overlay(highContrast))),
    )
    .thumb(_thumbRing());

/// The white thumb's ring ([UiTokens.accentThumbRing]): the range color
/// where white stands out on it and it keeps 3:1 on the page and panels, the
/// neutral control border where it does not, and a dark ink on bright ranges.
/// The thumb overhangs the track, so the ring and white face carry it.
BoxStyler _thumbRing() => BoxStyler().decoration(
  .border(
    .all(.color(UiTokens.accentThumbRing()).width(UiTokens.borderWidth2())),
  ),
);

/// The overlay that darkens the range under [highContrast], and nothing
/// otherwise.
List<RemixLinearGradientMix> _overlay(bool highContrast) => highContrast
    ? [
        RemixLinearGradientMix(
          colors: [
            UiTokens.sliderHighContrastOverlay(),
            UiTokens.sliderHighContrastOverlay(),
          ],
        ),
      ]
    : const [];

/// Gray track, range and thumb, with no ring and no overlay, whatever the
/// variant's colors were.
SliderStyler _disabled(UiSliderVariant variant) {
  final track = switch (variant) {
    .surface =>
      SliderStyler()
          .track(.color(UiTokens.grayA3()))
          .trackEffects(
            .behindContent(uiInsetSurface(strokes: [UiTokens.grayA4()])),
          ),
    .soft =>
      SliderStyler()
          .track(.color(UiTokens.grayA4()))
          .trackEffects(
            .behindContent(RemixBoxEffectLayerMix(gradients: const [])),
          ),
  };

  return track
      .track(.color(UiTokens.gray5()))
      .range(.color(UiTokens.gray8()))
      .thumbColor(_disabledThumbFill())
      .thumbEffects(.outline(.style(.none)))
      .rangeEffects(
        .behindContent(
          RemixBoxEffectLayerMix(gradients: const [], shadows: const []),
        ),
      )
      .rangeEffects(
        .overContent(
          RemixBoxEffectLayerMix(gradients: const [], shadows: const []),
        ),
      )
      .thumb(
        BoxStyler().decoration(
          .border(
            .all(.color(UiTokens.gray9()).width(UiTokens.borderWidth1())),
          ),
        ),
      )
      .thumbFocusEffects(.outline(.style(.none)))
      .blendMode(BlendMode.srcOver);
}

// Resolved inside the disabled fragment, whose priority is higher than dark
// mode.
final _disabledThumbFill = ContextToken<Color>(
  (context) => (UiTheme.of(context).isDark ? UiTokens.gray9 : UiTokens.gray4)
      .resolve(context),
);
