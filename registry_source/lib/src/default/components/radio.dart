import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'radio.g.dart';

/// The application's Radio recipe.
///
/// Remix owns the rendering, the single-selection behavior, arrow-key
/// traversal within the group, and the radio accessibility role; this recipe
/// supplies the circle, the dot, and the state fragments.
///
/// `RemixRadioGroup` — the behavioral coordinator that owns `groupValue` and
/// the change callback — carries no styler and therefore no recipe. Compose it
/// directly around these:
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
///
/// Unlike the checkbox, a radio draws no glyph: the mark is a filled dot inside
/// the ring, which is what tells the two controls apart at a glance even before
/// their shapes register. The ring itself stays `input` whether or not the
/// option is chosen; the dot carries the choice.
///
/// There is no hover fragment: choosing an option is the feedback, and the
/// pointer cursor Remix sets says it can be chosen.
///
/// A radio takes a `label`, drawn beside the circle inside the radio's own tap,
/// focus, and semantics target, and set like the checkbox's: `textSm` at medium
/// weight, 12px from the circle. A radio without one needs a `semanticLabel`.
@MixWidget(target: RemixRadio.new)
RadioStyler vanillaRadioStyle({
  RadioStyler style = const RadioStyler.create(),
}) {
  return RadioStyler()
      .animate(VanillaTokens.motion)
      .size(VanillaTokens.icon, VanillaTokens.icon)
      .alignment(.center)
      .borderRadius(.all(_circular))
      .color(_fill())
      .border(.color(VanillaTokens.input()).width(VanillaTokens.strokeHairline))
      // In the effects layer rather than the decoration: the ring is
      // transparent, and a decoration shadow would show through it.
      .containerEffects(.behindContent(VanillaShadow.xs.effects))
      .indicator(BoxStyler().size(_dot, _dot).borderRadius(.all(_circular)))
      .labelSpacing(VanillaTokens.s3)
      .label(
        .style(
          VanillaTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
      )
      .onFocusVisible(_focusVisibleStyle())
      .onSelected(RadioStyler().indicatorColor(VanillaTokens.primary()))
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// A radius that rounds the ring and the dot into circles.
const _circular = Radius.circular(VanillaTokens.pill);

/// The chosen dot: 8px across.
const _dot = VanillaTokens.s2;

/// The ring's fill: transparent, or `input` at 30% in the dark.
final _fill = vanillaTint(VanillaTokens.input, 0, dark: _darkFillAlpha);

/// See [_fill].
const _darkFillAlpha = 0.3;

/// The keyboard focus ring: a 3px band of `ring` at half strength, with
/// the circle's own outline turned `ring`.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// circle without taking layout space, so focusing a radio never reflows the
/// row it sits in.
RadioStyler _focusVisibleStyle() => RadioStyler()
    .containerEffects(vanillaFocusRing())
    .border(vanillaFocusBorder());

/// Declared last so it wins over every other state fragment.
///
/// A disabled radio keeps whatever ring its state gives it and simply fades;
/// the focus ring is cleared because a disabled control that still draws a
/// focus ring reads as actionable.
RadioStyler _disabledStyle() => RadioStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaTokens.disabledOpacity));
