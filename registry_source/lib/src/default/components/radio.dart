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
///     VanillaRadio(value: 'free', semanticLabel: 'Free'),
///     VanillaRadio(value: 'pro', semanticLabel: 'Pro'),
///   ]),
/// )
/// ```
///
/// Unlike the checkbox, a radio draws no glyph: the mark is a filled dot
/// inside the ring, which is what tells the two controls apart at a glance
/// even before their shapes register.
///
/// `RemixRadio` requires a `semanticLabel` because it renders no text of its
/// own — the visible label beside it belongs to the caller's layout.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's selected ring has to be
/// declared as a selected fragment too (`RadioStyler().onSelected(...)`).
@MixWidget(target: RemixRadio.new)
RadioStyler vanillaRadioStyle({
  RadioStyler style = const RadioStyler.create(),
}) {
  return RadioStyler()
      .animate(VanillaMotion.standard)
      .size(_diameter, _diameter)
      .alignment(.center)
      .borderRadius(.all(_circular))
      .color(VanillaTokens.background())
      .border(.color(VanillaTokens.border()).width(_borderWidth))
      .indicator(BoxStyler().size(_dot, _dot).borderRadius(.all(_circular)))
      // The ring has to survive the hover fill. `accent` on `border` is
      // 1.09:1 in the shipped light theme, so tinting the disc alone erased
      // the outline and left a hovered empty radio reading as a filled one —
      // the opposite of what it means. Darkening the ring is what keeps the
      // circle a circle.
      .onHovered(
        RadioStyler()
            .color(VanillaTokens.accent())
            .border(
              .color(VanillaTokens.mutedForeground()).width(_borderWidth),
            ),
      )
      // Before the selected fragment, so a chosen radio keeps its ring color
      // while it also shows the focus ring.
      .onFocusVisible(_focusVisibleStyle())
      .onSelected(_selectedStyle())
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// Alpha applied to the selected ring while hovered.
const _hoverAlpha = 0.9;

/// The selected ring color, dimmed. See `vanillaTint` for why this is a token
/// rather than a color with an alpha directive.
final _primaryHover = vanillaTint(VanillaTokens.primary, _hoverAlpha);

/// A radius large enough to round any radio in this scale into a circle.
const _circular = Radius.circular(999);

/// Width of the ring, in every state.
const _borderWidth = 1.0;

/// Width of the ring once the option is chosen.
///
/// Thicker than the resting ring so a selected radio reads at a glance even
/// where the dot is small.
const _selectedBorderWidth = 1.5;

/// Opacity applied to the whole control while disabled.
const _disabledOpacity = 0.5;

/// The circle's diameter, matching shadcn's `h-4 w-4` and the checkbox beside
/// it — the two are chosen from the same list and must not differ in weight.
const _diameter = 16.0;

/// The chosen dot.
const _dot = 6.0;

/// The chosen option: a `primary` ring around a `primary` dot.
///
/// The surface stays `background` rather than filling with `primary`. A filled
/// circle would be a checkbox's mark; leaving the middle open is what makes
/// the dot the thing the eye lands on.
RadioStyler _selectedStyle() => RadioStyler()
    .border(.color(VanillaTokens.primary()).width(_selectedBorderWidth))
    .indicatorColor(VanillaTokens.primary())
    // Declared inside the selected fragment so a hovered, chosen radio dims
    // its own ring. The top-level hover fragment tints the *surface*, which is
    // the right feedback while unchosen and the wrong one once the ring is
    // carrying the meaning.
    .onHovered(
      RadioStyler()
          .border(.color(_primaryHover()).width(_selectedBorderWidth))
          .indicatorColor(_primaryHover()),
    );

/// The keyboard focus ring: shadcn's 3px `ring` band at half strength, with
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
    .wrap(.opacity(_disabledOpacity));
