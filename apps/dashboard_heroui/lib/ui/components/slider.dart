import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'slider.g.dart';

/// HeroUI recipe for [RemixSlider]: a pill track and fill with a ringed thumb.
///
/// The label and value output beside the track are the app's composition.
@MixWidget(target: RemixSlider.new)
SliderStyler uiSliderStyle({
  SliderStyler style = const SliderStyler.create(),
}) => SliderStyler()
    .thickness(_track)
    .trackColor(UiTokens.defaultColor())
    .rangeColor(UiTokens.accent())
    .track(.borderRadius(.all(UiTokens.radiusXl())))
    .range(.borderRadius(.all(UiTokens.radiusXl())))
    // The accent `.slider__thumb` holds a `bg-accent-foreground` pill: the
    // ring is the thumb's border.
    .thumb(
      BoxStyler()
          .size(_thumbWidth, _track)
          .color(UiTokens.accentForeground())
          .border(.all(.color(UiTokens.accent()).width(_thumbRing)))
          .borderRadius(.all(UiTokens.radiusXl())),
    )
    .thumbEffects(uiSurfaceEffects())
    .thumbFocusEffects(uiFocusRing())
    .onPressed(SliderStyler().thumb(BoxStyler().scale(_dragScale)))
    .animate(_thumbMotion)
    .onDisabled(SliderStyler().wrap(.opacity(UiTokens.disabledOpacity)))
    .merge(style);

/// Horizontal `.slider__track` `h-5`; the thumb is `calc(1.5rem + 0.25rem)`
/// wide and as tall as the track.
const _track = 20.0;
const _thumbWidth = 28.0;

/// The thumb's accent rim: the 24x16 pill inside the 28x20 thumb.
const _thumbRing = 2.0;

/// `data-dragging` `scale-[0.9]`.
const _dragScale = 0.9;

/// `transform 250ms var(--ease-out)`.
const _thumbMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 250),
  curve: UiTokens.easeOut,
);
