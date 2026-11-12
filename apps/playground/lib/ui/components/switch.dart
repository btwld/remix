import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'switch.g.dart';

/// The application's Switch recipe.
///
/// A 32px by 18.4px track and a 16px thumb. The height is off the 4px grid on
/// purpose: the thumb, a 1px outline above and below, and 0.2px of air on each
/// side. Remix owns the thumb's travel. The label is a form label, `textSm` at
/// medium weight; a switch without one needs a `semanticLabel`.
@MixWidget(target: RemixSwitch.new)
SwitchStyler playgroundSwitchStyle({
  SwitchStyler style = const SwitchStyler.create(),
}) {
  return SwitchStyler()
      .animate(PlaygroundTokens.motion)
      .size(
        PlaygroundTokens.s8,
        PlaygroundTokens.icon + 2 * (PlaygroundTokens.strokeHairline + 0.2),
      )
      .borderRadius(.all(_pill))
      // `input`, at 80% in the dark theme.
      .trackColor(playgroundTint(PlaygroundTokens.input, 1, dark: 0.8)())
      // A transparent outline holds the pixel the focus fragment turns `ring`,
      // so focusing never changes the size.
      .border(.color(_transparent).width(PlaygroundTokens.strokeHairline))
      // In the effects layer: the dark off-track is translucent, and a
      // decoration shadow would show through it.
      .trackEffects(
        RemixBoxEffectsMix(behindContent: PlaygroundShadow.xs.effects),
      )
      .thumb(
        BoxStyler()
            .size(PlaygroundTokens.icon, PlaygroundTokens.icon)
            .borderRadius(.all(_pill))
            // The page color, except in the dark theme, where it would vanish
            // into the track.
            .color(
              playgroundByBrightness(
                light: PlaygroundTokens.background,
                dark: PlaygroundTokens.foreground,
              )(),
            ),
      )
      .labelSpacing(PlaygroundTokens.s2)
      .label(
        .style(
          PlaygroundTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
      )
      .onSelected(
        SwitchStyler()
            .trackColor(PlaygroundTokens.primary())
            // `primaryForeground` in the dark theme, where `primary` is light.
            .thumbColor(
              playgroundByBrightness(
                light: PlaygroundTokens.background,
                dark: PlaygroundTokens.primaryForeground,
              )(),
            ),
      )
      .onFocusVisible(
        SwitchStyler()
            .trackEffects(playgroundFocusRing())
            .border(playgroundFocusBorder()),
      )
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        SwitchStyler()
            .trackEffects(RemixBoxEffectsMix.outline(.style(.none)))
            .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
      )
      .merge(style);
}

const _transparent = Color(0x00000000);
const _pill = Radius.circular(PlaygroundTokens.pill);
