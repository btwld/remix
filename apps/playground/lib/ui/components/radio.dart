import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
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
///     PlaygroundRadio(value: 'free', semanticLabel: 'Free'),
///     PlaygroundRadio(value: 'pro', semanticLabel: 'Pro'),
///   ]),
/// )
/// ```
///
/// Unlike the checkbox, a radio draws no glyph: the mark is a filled dot
/// inside the ring, which is what tells the two controls apart at a glance
/// even before their shapes register. The ring itself stays `input` whether
/// or not the option is chosen, as shadcn's does; the dot carries the choice.
///
/// There is no hover fragment, as in shadcn: choosing an option is the
/// feedback, and the pointer cursor Remix sets says it can be chosen.
///
/// `RemixRadio` requires a `semanticLabel` because it renders no text of its
/// own — the visible label beside it belongs to the caller's layout.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's chosen dot has to be
/// declared as a selected fragment too (`RadioStyler().onSelected(...)`).
@MixWidget(target: RemixRadio.new)
RadioStyler playgroundRadioStyle({
  RadioStyler style = const RadioStyler.create(),
}) {
  return RadioStyler()
      .animate(PlaygroundMotion.standard)
      .size(PlaygroundSize.icon, PlaygroundSize.icon)
      .alignment(.center)
      .borderRadius(.all(_circular))
      .color(_fill())
      .border(.color(PlaygroundTokens.input()).width(PlaygroundStroke.hairline))
      // In the effects layer rather than the decoration: the ring is
      // transparent, and a decoration shadow would show through it.
      .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
      .indicator(BoxStyler().size(_dot, _dot).borderRadius(.all(_circular)))
      .onFocusVisible(_focusVisibleStyle())
      .onSelected(RadioStyler().indicatorColor(PlaygroundTokens.primary()))
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// A radius that rounds the ring and the dot into circles.
const _circular = Radius.circular(PlaygroundSize.pill);

/// The chosen dot: shadcn's `size-2`.
const _dot = PlaygroundSpace.s2;

/// The ring's fill: transparent, or `dark:bg-input/30`.
final _fill = playgroundTint(PlaygroundTokens.input, 0, dark: _darkFillAlpha);

/// See [_fill].
const _darkFillAlpha = 0.3;

/// The keyboard focus ring: shadcn's 3px `ring` band at half strength, with
/// the circle's own outline turned `ring`.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// circle without taking layout space, so focusing a radio never reflows the
/// row it sits in.
RadioStyler _focusVisibleStyle() => RadioStyler()
    .containerEffects(playgroundFocusRing())
    .border(playgroundFocusBorder());

/// Declared last so it wins over every other state fragment.
///
/// A disabled radio keeps whatever ring its state gives it and simply fades;
/// the focus ring is cleared because a disabled control that still draws a
/// focus ring reads as actionable.
RadioStyler _disabledStyle() => RadioStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(PlaygroundOpacity.disabled));
