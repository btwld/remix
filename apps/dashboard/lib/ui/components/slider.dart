import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'slider.g.dart';

/// The sizes a slider comes in. Pixel values are at 100% theme scaling.
enum UiSliderSize {
  /// A 5px track with an 18px thumb in a 32px row.
  size1,

  /// A 6px track with a 22px thumb in a 40px row. The default.
  size2,

  /// A 7px track with a 24px thumb in a 44px row.
  size3,
}

/// The looks a slider comes in.
enum UiSliderVariant {
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
    .onPressed(SliderStyler().thumb(BoxStyler().scale(1.16)))
    .thumbMotion(
      AnimationConfig.springDescription(
        stiffness: UiMotion.springSnappy.stiffness,
        damping: UiMotion.springSnappy.damping,
      ),
    )
    .animate(
      AnimationConfig.curve(
        duration: UiSpringCurve.snappy.duration,
        curve: UiSpringCurve.snappy,
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
SliderStyler _base(UiSliderSize size) {
  final (:track, :thumb, :trackRadius, :row) = switch (size) {
    .size1 => (
      track: UiTokens.sliderTrackSize1(),
      thumb: UiTokens.sliderThumbSize1(),
      trackRadius: UiTokens.sliderTrackRadius1(),
      // The 32px row would drop under the touch target; size 1 keeps 40.
      row: UiTokens.touchTargetMin(),
    ),
    .size2 => (
      track: UiTokens.sliderTrackSize2(),
      thumb: UiTokens.sliderThumbSize2(),
      trackRadius: UiTokens.sliderTrackRadius2(),
      row: UiTokens.controlHeight2(),
    ),
    .size3 => (
      track: UiTokens.sliderTrackSize3(),
      thumb: UiTokens.sliderThumbSize3(),
      trackRadius: UiTokens.sliderTrackRadius3(),
      row: UiTokens.controlHeight3(),
    ),
  };
  final radius = BorderRadiusMix.all(trackRadius);

  return SliderStyler()
      .track(.borderRadius(radius).color(UiTokens.controlTrack()))
      .range(.borderRadius(radius))
      .thumb(
        .size(thumb, thumb)
            .borderRadius(BorderRadiusMix.all(UiTokens.radius1OrThumb()))
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadowThumb.mix()),
            )
            // Transparent by default, where the shadow carries the thumb;
            // a contrasting ring under the theme's high contrast.
            .border(
              .all(
                .color(
                  UiTokens.accentThumbRing(),
                ).width(UiTokens.borderWidth2()),
              ),
            ),
      )
      .thumbColor(UiTokens.controlThumb())
      .thickness(track)
      .thumbFocusEffects(uiSliderFocusOutline())
      .wrap(.sizedBox(height: row))
      .wrap(uiTouchTarget());
}

SliderStyler _surface(bool highContrast) => SliderStyler()
    .range(.color(UiTokens.accentRange()))
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
    UiTokens.controlTrack.resolve(c),
    UiTokens.accentRange.resolve(c),
    0.55,
  )!,
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
