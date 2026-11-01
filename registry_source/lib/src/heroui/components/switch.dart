import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'switch.g.dart';

/// HeroUI switch sizes, with the track width of each (`w-8`, `w-10`, `w-12`).
enum HeroUiSwitchSize {
  sm(trackWidth: 32),
  md(trackWidth: 40),
  lg(trackWidth: 48);

  const HeroUiSwitchSize({required this.trackWidth});

  final double trackWidth;
}

/// HeroUI recipe for [RemixSwitch], the bare control.
///
/// Labels and descriptions are the app's composition; see `HeroUiSwitchGroup`.
@MixWidget(target: RemixSwitch.new)
SwitchStyler heroUiSwitchStyle({
  HeroUiSwitchSize size = .md,
  SwitchStyler style = const SwitchStyler.create(),
}) {
  final metrics = _metricsFor(size);
  return SwitchStyler(
        container: BoxStyler()
            .size(size.trackWidth, metrics.trackHeight)
            .padding(.all(_inset))
            .borderRadius(.all(metrics.trackRadius())),
        thumb: BoxStyler()
            .size(metrics.thumbWidth, metrics.thumbHeight)
            .borderRadius(.all(metrics.thumbRadius())),
        thumbEffects: heroUiSurfaceEffects(),
      )
      .trackColor(HeroUiTokens.defaultColor())
      .thumbColor(HeroUiTokens.white())
      .onSelected(
        SwitchStyler()
            .trackColor(HeroUiTokens.accent())
            .thumbColor(HeroUiTokens.accentForeground())
            .thumbEffects(_selectedThumbShadow),
      )
      // Remix's switch declares its own selected variant first, so it resolves
      // before these two; each carries its selected color.
      .onHovered(_hoveredTrack)
      .onPressed(_hoveredTrack)
      .onFocusVisible(.trackEffects(heroUiFocusRing()))
      .onDisabled(
        // The thumb dims again: `bg-default-foreground/20`, or `opacity: 0.4`
        // once selected.
        SwitchStyler()
            .thumbColor(_disabledThumb())
            .onSelected(
              SwitchStyler()
                  .thumbColor(HeroUiTokens.accentForeground())
                  .thumb(BoxStyler().wrap(.opacity(_disabledSelectedThumb))),
            )
            .wrap(.opacity(HeroUiTokens.disabledOpacity)),
      )
      .animate(_motion)
      .merge(style);
}

/// The track while hovered or pressed: `--switch-control-bg-hover`, and
/// `--switch-control-bg-checked-hover` once selected.
final _hoveredTrack = SwitchStyler()
    .trackColor(_trackHover())
    .onSelected(SwitchStyler().trackColor(HeroUiTokens.accentHover()));

typedef _Metrics = ({
  double trackHeight,
  RadiusToken trackRadius,
  double thumbWidth,
  double thumbHeight,
  RadiusToken thumbRadius,
});

/// `.switch__control` and `.switch__thumb` per size, in rem at 16px.
_Metrics _metricsFor(HeroUiSwitchSize size) => switch (size) {
  .sm => (
    trackHeight: 16,
    trackRadius: HeroUiTokens.radiusLg,
    thumbWidth: 16.5,
    thumbHeight: 12,
    thumbRadius: HeroUiTokens.radiusMd,
  ),
  .md => (
    trackHeight: 20,
    trackRadius: HeroUiTokens.radiusXl,
    thumbWidth: 22,
    thumbHeight: 16,
    thumbRadius: HeroUiTokens.radiusLg,
  ),
  .lg => (
    trackHeight: 24,
    trackRadius: HeroUiTokens.radiusXl,
    thumbWidth: 27.5,
    thumbHeight: 20,
    thumbRadius: HeroUiTokens.radiusXl,
  ),
};

/// The thumb's `ms-0.5`, mirrored on the far side once selected.
const _inset = 2.0;

/// `.switch[data-disabled][data-selected] .switch__thumb`.
const _disabledSelectedThumb = 0.4;

/// `--switch-control-bg-hover`: `color-mix(in oklab, var(--default), transparent 20%)`.
final _trackHover = heroUiAlpha(HeroUiTokens.defaultColor, 0.8);

/// `bg-default-foreground/20`.
final _disabledThumb = heroUiAlpha(HeroUiTokens.defaultForeground, 0.2);

/// `.switch__thumb` selected `box-shadow` (switch.css:186-189), measured by
/// `switch-md-selected-thumb`.
final _selectedThumbShadow = RemixBoxEffectsMix.behindContent(
  RemixBoxEffectLayerMix(
    shadows: [
      RemixBoxShadowMix(
        color: const Color.fromRGBO(0, 0, 0, .02),
        blurRadius: 5,
      ),
      RemixBoxShadowMix(
        color: const Color.fromRGBO(0, 0, 0, .06),
        offset: const Offset(0, 2),
        blurRadius: 10,
      ),
      RemixBoxShadowMix(
        color: const Color.fromRGBO(0, 0, 0, .3),
        blurRadius: 1,
      ),
    ],
  ),
);

/// `margin 300ms var(--ease-out-fluid)` moves the thumb; the track fades over
/// `background-color 250ms var(--ease-smooth)`.
const _motion = CurveAnimationConfig(
  duration: Duration(milliseconds: 300),
  curve: HeroUiTokens.easeOutFluid,
);
