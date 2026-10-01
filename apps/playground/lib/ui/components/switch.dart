import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'switch.g.dart';

/// The application's Switch recipe.
///
/// Remix owns the rendering, the toggle behavior, the switch accessibility
/// role, and — importantly — the thumb's travel: it aligns the thumb to the
/// leading edge when off and the trailing edge when on. This recipe supplies
/// only the two boxes' geometry and their colors.
///
/// `RemixSwitch` requires a `semanticLabel` because a switch has no visible
/// text of its own. That is a Remix rule, not a recipe choice.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's on-track has to be
/// declared as a selected fragment too (`SwitchStyler().onSelected(...)`).
@MixWidget(target: RemixSwitch.new)
SwitchStyler playgroundSwitchStyle({
  SwitchStyler style = const SwitchStyler.create(),
}) {
  return SwitchStyler()
      .animate(PlaygroundMotion.standard)
      .size(_trackWidth, _trackHeight)
      .borderRadius(.all(_pill))
      .trackColor(_offTrack())
      // A transparent outline: it holds the pixel the focus fragment turns
      // `ring`, so focusing a switch never changes its size.
      .border(.color(_noEdge).width(PlaygroundStroke.hairline))
      // In the effects layer rather than the decoration: the dark off-track
      // is translucent, and a decoration shadow would show through it.
      .trackEffects(
        RemixBoxEffectsMix(behindContent: PlaygroundShadow.xs.effects),
      )
      .thumb(
        BoxStyler()
            .size(PlaygroundSize.icon, PlaygroundSize.icon)
            .borderRadius(.all(_pill))
            .color(_offThumb()),
      )
      .onSelected(
        SwitchStyler()
            .trackColor(PlaygroundTokens.primary())
            .thumbColor(_onThumb()),
      )
      .onFocusVisible(_focusVisibleStyle())
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// The track: 32 by 18.4.
///
/// The height is off the four-pixel grid on purpose: it is the 16px thumb, the
/// 1px outline above and below it, and a fifth of a pixel of air on each side,
/// so the thumb reads as filling the track. The thumb's travel is the track's
/// inner width less its own, 14px.
const _trackWidth = PlaygroundSpace.s8;
const _trackHeight =
    PlaygroundSize.icon + 2 * (PlaygroundStroke.hairline + _thumbAir);

/// See [_trackHeight].
const _thumbAir = 0.2;

/// A radius large enough to round the track and the thumb.
const _pill = Radius.circular(PlaygroundSize.pill);

/// A color that paints nothing, for the resting outline.
const _noEdge = Color(0x00000000);

/// The off track: `input`, at 80% in the dark theme.
final _offTrack = playgroundTint(
  PlaygroundTokens.input,
  1,
  dark: _darkOffTrackAlpha,
);

/// See [_offTrack].
const _darkOffTrackAlpha = 0.8;

/// The thumb while off: the page color on a light page, and `foreground` on a
/// dark one, where a page-colored thumb would vanish into the track.
final _offThumb = playgroundByBrightness(
  light: PlaygroundTokens.background,
  dark: PlaygroundTokens.foreground,
);

/// The thumb while on: the page color on a light page, and
/// `primaryForeground` on a dark one, the color that reads on the light dark
/// `primary` track.
final _onThumb = playgroundByBrightness(
  light: PlaygroundTokens.background,
  dark: PlaygroundTokens.primaryForeground,
);

/// The keyboard focus ring: a 3px band of `ring` at half strength, with
/// the track's own outline turned `ring`.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// track without taking layout space, so focusing a switch never reflows the
/// row it sits in.
SwitchStyler _focusVisibleStyle() => SwitchStyler()
    .trackEffects(playgroundFocusRing())
    .border(playgroundFocusBorder());

/// Declared last so it wins over every other state fragment.
///
/// A disabled switch keeps whatever track its state gives it and simply
/// fades; the focus ring is cleared because a disabled control that still
/// draws a focus ring reads as actionable.
SwitchStyler _disabledStyle() => SwitchStyler()
    .trackEffects(RemixBoxEffectsMix.outline(.style(.none)))
    .wrap(.opacity(PlaygroundOpacity.disabled));
