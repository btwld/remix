import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'slider.g.dart';

/// The sizes a slider comes in. Pixel values are at 100% theme scaling.
enum FortalSliderSize {
  /// A 6px track with a 13px thumb.
  size1,

  /// An 8px track with a 16px thumb. The default.
  size2,

  /// A 10px track with a 19px thumb.
  size3,
}

/// The looks a slider comes in.
enum FortalSliderVariant {
  /// A gray track and a solid accent range.
  surface,

  /// A gray track and a softer accent range.
  soft,
}

/// The Fortal Slider recipe.
///
/// It reads top to bottom: the track and thumb sizes, then the variant's
/// colors, then the dark-mode thumb edge, hover, press and disabled.
///
/// [highContrast] darkens the range with an overlay.
@MixWidget(target: RemixSlider.new)
SliderStyler fortalSliderStyle({
  FortalSliderVariant variant = .surface,
  FortalSliderSize size = .size2,
  bool highContrast = false,
  SliderStyler style = const SliderStyler.create(),
}) => _base(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .variant(
      ContextVariant(
        'fortalSliderDark',
        (context) => FortalTheme.of(context).isDark,
      ),
      SliderStyler().thumb(
        .border(
          .all(.color(FortalTokens.gray3()).width(FortalTokens.borderWidth2())),
        ),
      ),
    )
    .onHovered(
      SliderStyler().thumbEffects(
        RemixBoxEffectsMix(
          outline: .color(
            FortalTokens.accentA7(),
          ).width(FortalTokens.borderWidth2()),
        ),
      ),
    )
    .onPressed(
      SliderStyler()
          .thumbEffects(
            RemixBoxEffectsMix(
              outline: .color(
                FortalTokens.accentA6(),
              ).width(FortalTokens.space1()),
            ),
          )
          .thumb(
            .border(
              .all(
                .color(
                  FortalTokens.accent12(),
                ).width(FortalTokens.borderWidth2()),
              ),
            ),
          ),
    )
    .onDisabled(_disabled(variant))
    .wrap(.sizedBox(height: FortalTokens.space8()))
    .wrap(fortalTouchTarget())
    .merge(style);

/// The track and thumb sizes of each step, and the focus ring.
SliderStyler _base(FortalSliderSize size) {
  final (:track, :thumb, :trackRadius) = switch (size) {
    .size1 => (
      track: FortalTokens.sliderTrackSize1(),
      thumb: FortalTokens.sliderThumbSize1(),
      trackRadius: FortalTokens.sliderTrackRadius1(),
    ),
    .size2 => (
      track: FortalTokens.space2(),
      thumb: FortalTokens.space4(),
      trackRadius: FortalTokens.sliderTrackRadius2(),
    ),
    .size3 => (
      track: FortalTokens.sliderTrackSize3(),
      thumb: FortalTokens.sliderThumbSize3(),
      trackRadius: FortalTokens.sliderTrackRadius3(),
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
        ).borderRadius(BorderRadiusMix.all(FortalTokens.radius1OrThumb())),
      )
      .thickness(track)
      .thumbFocusEffects(fortalSliderFocusOutline());
}

SliderStyler _surface(bool highContrast) => SliderStyler()
    .track(.color(FortalTokens.grayA3()))
    .range(.color(FortalTokens.accentTrack()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      .behindContent(fortalInsetSurface(strokes: [FortalTokens.grayA5()])),
    )
    .rangeEffects(
      .behindContent(
        fortalInsetSurface(
          strokes: [FortalTokens.grayA5()],
        ).merge(RemixBoxEffectLayerMix(gradients: _overlay(highContrast))),
      ),
    )
    .thumb(_thumbRing());

SliderStyler _soft(bool highContrast) => SliderStyler()
    .track(.color(FortalTokens.grayA4()))
    .range(.color(FortalTokens.accent6()))
    .thumbColor(const Color(0xFFFFFFFF))
    .trackEffects(
      .behindContent(
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
      .behindContent(RemixBoxEffectLayerMix(gradients: _overlay(highContrast))),
    )
    .thumb(_thumbRing());

/// The white thumb's ring ([FortalTokens.accentThumbRing]): the range color
/// where white stands out on it and it keeps 3:1 on the page and panels, the
/// neutral control border where it does not, and a dark ink on bright ranges.
/// The thumb overhangs the track, so the ring and white face carry it.
BoxStyler _thumbRing() => BoxStyler().decoration(
  .border(
    .all(
      .color(FortalTokens.accentThumbRing()).width(FortalTokens.borderWidth2()),
    ),
  ),
);

/// The overlay that darkens the range under [highContrast], and nothing
/// otherwise.
List<RemixLinearGradientMix> _overlay(bool highContrast) => highContrast
    ? [
        RemixLinearGradientMix(
          colors: [
            FortalTokens.sliderHighContrastOverlay(),
            FortalTokens.sliderHighContrastOverlay(),
          ],
        ),
      ]
    : const [];

/// Gray track, range and thumb, with no ring and no overlay, whatever the
/// variant's colors were.
SliderStyler _disabled(FortalSliderVariant variant) {
  final track = switch (variant) {
    .surface =>
      SliderStyler()
          .track(.color(FortalTokens.grayA3()))
          .trackEffects(
            .behindContent(
              fortalInsetSurface(strokes: [FortalTokens.grayA4()]),
            ),
          ),
    .soft =>
      SliderStyler()
          .track(.color(FortalTokens.grayA4()))
          .trackEffects(
            .behindContent(RemixBoxEffectLayerMix(gradients: const [])),
          ),
  };

  return track
      .track(.color(FortalTokens.gray5()))
      .range(.color(FortalTokens.gray8()))
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
            .all(
              .color(FortalTokens.gray9()).width(FortalTokens.borderWidth1()),
            ),
          ),
        ),
      )
      .thumbFocusEffects(.outline(.style(.none)))
      .blendMode(BlendMode.srcOver);
}

// Resolved inside the disabled fragment, whose priority is higher than dark
// mode.
final _disabledThumbFill = ContextToken<Color>(
  (context) =>
      (FortalTheme.of(context).isDark ? FortalTokens.gray9 : FortalTokens.gray4)
          .resolve(context),
);
