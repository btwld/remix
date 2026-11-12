import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'radio.g.dart';

/// The application's Radio recipe.
///
/// A 16px ring with an 8px dot. The ring stays `input` whether or not the
/// option is chosen; the dot carries the choice. There is no hover fragment:
/// choosing is the feedback. The label is set like the checkbox's.
///
/// `RemixRadioGroup`, which owns `groupValue` and the change callback, has no
/// styler and no recipe. Wrap the options in it directly:
///
/// ```dart
/// RemixRadioGroup<String>(
///   groupValue: plan,
///   onChanged: (value) => setState(() => plan = value),
///   child: Column(children: const [
///     VanillaRadio(value: 'free', label: 'Free'),
///     VanillaRadio(value: 'pro', label: 'Pro'),
///   ]),
/// )
/// ```
@MixWidget(target: RemixRadio.new)
RadioStyler vanillaRadioStyle({
  RadioStyler style = const RadioStyler.create(),
}) {
  return RadioStyler()
      .animate(VanillaTokens.motion)
      .size(VanillaTokens.icon, VanillaTokens.icon)
      .alignment(.center)
      .borderRadius(.all(_circular))
      // Transparent, or `input` at 30% in the dark theme.
      .color(vanillaTint(VanillaTokens.input, 0, dark: 0.3)())
      .border(.color(VanillaTokens.input()).width(VanillaTokens.strokeHairline))
      // In the effects layer: the ring is transparent, and a decoration shadow
      // would show through it.
      .containerEffects(.behindContent(VanillaShadow.xs.effects))
      .indicator(
        BoxStyler()
            .size(VanillaTokens.s2, VanillaTokens.s2)
            .borderRadius(.all(_circular)),
      )
      .labelSpacing(VanillaTokens.s3)
      .label(
        .style(
          VanillaTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
      )
      .onFocusVisible(
        RadioStyler()
            .containerEffects(vanillaFocusRing())
            .border(vanillaFocusBorder()),
      )
      .onSelected(RadioStyler().indicatorColor(VanillaTokens.primary()))
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        RadioStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(VanillaTokens.disabledOpacity)),
      )
      .merge(style);
}

/// Rounds the ring and the dot into circles.
const _circular = Radius.circular(VanillaTokens.pill);
