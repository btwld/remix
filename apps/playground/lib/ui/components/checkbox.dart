import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'checkbox.g.dart';

/// The application's Checkbox recipe.
///
/// A 16px box with 4px corners, an `input` outline and a 10px check. It has no
/// hover or pressed fragment: a checkbox flips its own state, and that is the
/// feedback. The label is a form label, `textSm` at medium weight.
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler playgroundCheckboxStyle({
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  // Indeterminate is "not unchecked", so it shares the checked surface. The
  // border is repainted rather than removed: dropping it would shrink the box
  // by 2px at the moment of checking.
  final checked = CheckboxStyler()
      .color(PlaygroundTokens.primary())
      .border(.color(PlaygroundTokens.primary()))
      .indicator(.color(PlaygroundTokens.primaryForeground()));

  return CheckboxStyler()
      .animate(PlaygroundTokens.motion)
      .size(PlaygroundTokens.icon, PlaygroundTokens.icon)
      .alignment(.center)
      .borderRadius(.all(_boxRadius()))
      // Transparent, or `input` at 30% in the dark theme.
      .color(playgroundTint(PlaygroundTokens.input, 0, dark: 0.3)())
      .border(
        .color(PlaygroundTokens.input()).width(PlaygroundTokens.strokeHairline),
      )
      // In the effects layer: the empty box is transparent, and a decoration
      // shadow would show through it.
      .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
      // Sized for Remix's edge-to-edge 9x9 check path. Remix draws no
      // indicator while unchecked, so only the checked states set its color.
      .indicator(.size(PlaygroundTokens.s2_5))
      .labelSpacing(PlaygroundTokens.s3)
      .label(
        .style(
          PlaygroundTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
      )
      // Before the checked fragments, so a checked box keeps its `primary`
      // outline while it also shows the ring.
      .onFocusVisible(
        CheckboxStyler()
            .containerEffects(playgroundFocusRing())
            .border(playgroundFocusBorder()),
      )
      .onSelected(checked)
      .onIndeterminate(checked)
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        CheckboxStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
      )
      .merge(style);
}

/// The Checkbox recipe for one option in a `RemixCheckboxGroup`.
///
/// The group has no styler, so each option needs its own adapter. It is the
/// same checkbox as [playgroundCheckboxStyle], so it delegates.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler playgroundCheckboxGroupItemStyle({
  CheckboxStyler style = const CheckboxStyler.create(),
}) => playgroundCheckboxStyle(style: style);

/// The theme's control radius, clamped to 4px: `radiusMd` is authored for
/// 32-40px controls and would round a 16px box into a circle (a radio).
///
/// A top-level final because `ContextToken` equality is resolver identity.
final _boxRadius = ContextToken<Radius>((context) {
  final radius = PlaygroundTokens.radiusMd.resolve(context);

  return Radius.elliptical(math.min(radius.x, 4), math.min(radius.y, 4));
});
