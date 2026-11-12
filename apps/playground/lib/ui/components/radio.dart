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
///     PlaygroundRadio(value: 'free', label: 'Free'),
///     PlaygroundRadio(value: 'pro', label: 'Pro'),
///   ]),
/// )
/// ```
@MixWidget(target: RemixRadio.new)
RadioStyler playgroundRadioStyle({
  RadioStyler style = const RadioStyler.create(),
}) {
  return RadioStyler()
      .animate(PlaygroundTokens.motion)
      .size(PlaygroundTokens.icon, PlaygroundTokens.icon)
      .alignment(.center)
      .borderRadius(.all(_circular))
      // Transparent, or `input` at 30% in the dark theme.
      .color(playgroundTint(PlaygroundTokens.input, 0, dark: 0.3)())
      .border(
        .color(PlaygroundTokens.input()).width(PlaygroundTokens.strokeHairline),
      )
      // In the effects layer: the ring is transparent, and a decoration shadow
      // would show through it.
      .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
      .indicator(
        BoxStyler()
            .size(PlaygroundTokens.s2, PlaygroundTokens.s2)
            .borderRadius(.all(_circular)),
      )
      .labelSpacing(PlaygroundTokens.s3)
      .label(
        .style(
          PlaygroundTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
      )
      .onFocusVisible(
        RadioStyler()
            .containerEffects(playgroundFocusRing())
            .border(playgroundFocusBorder()),
      )
      .onSelected(RadioStyler().indicatorColor(PlaygroundTokens.primary()))
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        RadioStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
      )
      .merge(style);
}

/// Rounds the ring and the dot into circles.
const _circular = Radius.circular(PlaygroundTokens.pill);
