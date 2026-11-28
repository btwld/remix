import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'slider.g.dart';

/// The sizes a slider comes in. Pixel values are at 100% theme scaling.
enum FortalSliderSize {
  /// A 5px track with an 18px thumb in a 32px row.
  size1,

  /// A 6px track with a 22px thumb in a 40px row. The default.
  size2,

  /// A 7px track with a 24px thumb in a 44px row.
  size3,
}

/// The looks a slider comes in.
enum FortalSliderVariant {
  /// The control track and a control-ink range.
  surface,

  /// The control track and a range mixed 55% from the control ink toward the
  /// track.
  soft,
}

/// The Fortal Slider recipe.
///
/// It reads top to bottom: the track, thumb and row sizes, then the
/// variant's colours, then the thumb lift, motion and disabled. Thumbs are
/// the light control thumb under the three-layer thumb shadow; a held thumb
/// lifts to 116%, and keys, track presses and new values glide the thumb on
/// the snappy spring while a dragged thumb follows the pointer.
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
    .onPressed(SliderStyler().thumb(BoxStyler().scale(1.16)))
    .thumbMotion(
      AnimationConfig.springDescription(
        stiffness: FortalMotion.springSnappy.stiffness,
        damping: FortalMotion.springSnappy.damping,
      ),
    )
    .animate(
      AnimationConfig.curve(
        duration: FortalSpringCurve.snappy.duration,
        curve: FortalSpringCurve.snappy,
      ),
    )
    .onDisabled(
      SliderStyler()
          .wrap(.opacity(0.5))
          .thumbFocusEffects(.outline(.style(.none))),
    )
    .merge(style);

/// The track, thumb and row of each step, the thumb's shadow and its ring,
/// and the focus ring.
SliderStyler _base(FortalSliderSize size) {
  final (:track, :thumb, :trackRadius, :row) = switch (size) {
    .size1 => (
      track: FortalTokens.sliderTrackSize1(),
      thumb: FortalTokens.sliderThumbSize1(),
      trackRadius: FortalTokens.sliderTrackRadius1(),
      // The 32px row would drop under the touch target; size 1 keeps 40.
      row: FortalTokens.touchTargetMin(),
    ),
    .size2 => (
      track: FortalTokens.sliderTrackSize2(),
      thumb: FortalTokens.sliderThumbSize2(),
      trackRadius: FortalTokens.sliderTrackRadius2(),
      row: FortalTokens.controlHeight2(),
    ),
    .size3 => (
      track: FortalTokens.sliderTrackSize3(),
      thumb: FortalTokens.sliderThumbSize3(),
      trackRadius: FortalTokens.sliderTrackRadius3(),
      row: FortalTokens.controlHeight3(),
    ),
  };
  final radius = BorderRadiusMix.all(trackRadius);

  return SliderStyler()
      .track(.borderRadius(radius).color(FortalTokens.controlTrack()))
      .range(.borderRadius(radius))
      .thumb(
        .size(thumb, thumb)
            .borderRadius(BorderRadiusMix.all(FortalTokens.radius1OrThumb()))
            .decoration(
              BoxDecorationMix.create(
                boxShadow: FortalTokens.shadowThumb.mix(),
              ),
            )
            // Transparent by default, where the shadow carries the thumb;
            // a contrasting ring under the theme's high contrast.
            .border(
              .all(
                .color(
                  FortalTokens.accentThumbRing(),
                ).width(FortalTokens.borderWidth2()),
              ),
            ),
      )
      .thumbColor(FortalTokens.controlThumb())
      .thickness(track)
      .thumbFocusEffects(fortalSliderFocusOutline())
      .wrap(.sizedBox(height: row))
      .wrap(fortalTouchTarget());
}

SliderStyler _surface(bool highContrast) => SliderStyler()
    .range(.color(FortalTokens.accentRange()))
    .rangeEffects(
      .behindContent(RemixBoxEffectLayerMix(gradients: _overlay(highContrast))),
    );

SliderStyler _soft(bool highContrast) => SliderStyler()
    .range(.color(_softRange()))
    .rangeEffects(
      .behindContent(RemixBoxEffectLayerMix(gradients: _overlay(highContrast))),
    );

/// The control ink mixed 55% toward the track.
final _softRange = ContextToken<Color>(
  (c) => Color.lerp(
    FortalTokens.controlTrack.resolve(c),
    FortalTokens.accentRange.resolve(c),
    0.55,
  )!,
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
