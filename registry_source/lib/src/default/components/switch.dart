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
SwitchStyler vanillaSwitchStyle({
  SwitchStyler style = const SwitchStyler.create(),
}) {
  return SwitchStyler()
      .animate(VanillaTokens.motion)
      .size(
        VanillaTokens.s8,
        VanillaTokens.icon + 2 * (VanillaTokens.strokeHairline + 0.2),
      )
      .borderRadius(.all(_pill))
      // `input`, at 80% in the dark theme.
      .trackColor(vanillaTint(VanillaTokens.input, 1, dark: 0.8)())
      // A transparent outline holds the pixel the focus fragment turns `ring`,
      // so focusing never changes the size.
      .border(.color(_transparent).width(VanillaTokens.strokeHairline))
      // In the effects layer: the dark off-track is translucent, and a
      // decoration shadow would show through it.
      .trackEffects(RemixBoxEffectsMix(behindContent: VanillaShadow.xs.effects))
      .thumb(
        BoxStyler()
            .size(VanillaTokens.icon, VanillaTokens.icon)
            .borderRadius(.all(_pill))
            // The page color, except in the dark theme, where it would vanish
            // into the track.
            .color(
              vanillaByBrightness(
                light: VanillaTokens.background,
                dark: VanillaTokens.foreground,
              )(),
            ),
      )
      .labelSpacing(VanillaTokens.s2)
      .label(
        .style(
          VanillaTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
      )
      .onSelected(
        SwitchStyler()
            .trackColor(VanillaTokens.primary())
            // `primaryForeground` in the dark theme, where `primary` is light.
            .thumbColor(
              vanillaByBrightness(
                light: VanillaTokens.background,
                dark: VanillaTokens.primaryForeground,
              )(),
            ),
      )
      .onFocusVisible(
        SwitchStyler()
            .trackEffects(vanillaFocusRing())
            .border(vanillaFocusBorder()),
      )
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        SwitchStyler()
            .trackEffects(RemixBoxEffectsMix.outline(.style(.none)))
            .wrap(.opacity(VanillaTokens.disabledOpacity)),
      )
      .merge(style);
}

const _transparent = Color(0x00000000);
const _pill = Radius.circular(VanillaTokens.pill);
