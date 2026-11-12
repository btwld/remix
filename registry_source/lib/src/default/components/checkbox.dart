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
CheckboxStyler vanillaCheckboxStyle({
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  // Indeterminate is "not unchecked", so it shares the checked surface. The
  // border is repainted rather than removed: dropping it would shrink the box
  // by 2px at the moment of checking.
  final checked = CheckboxStyler()
      .color(VanillaTokens.primary())
      .border(.color(VanillaTokens.primary()))
      .indicator(.color(VanillaTokens.primaryForeground()));

  return CheckboxStyler()
      .animate(VanillaTokens.motion)
      .size(VanillaTokens.icon, VanillaTokens.icon)
      .alignment(.center)
      .borderRadius(.all(_boxRadius()))
      // Transparent, or `input` at 30% in the dark theme.
      .color(vanillaTint(VanillaTokens.input, 0, dark: 0.3)())
      .border(.color(VanillaTokens.input()).width(VanillaTokens.strokeHairline))
      // In the effects layer: the empty box is transparent, and a decoration
      // shadow would show through it.
      .containerEffects(.behindContent(VanillaShadow.xs.effects))
      // Sized for Remix's edge-to-edge 9x9 check path. Remix draws no
      // indicator while unchecked, so only the checked states set its color.
      .indicator(.size(VanillaTokens.s2_5))
      .labelSpacing(VanillaTokens.s3)
      .label(
        .style(
          VanillaTokens.textSm.mix(),
        ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
      )
      // Before the checked fragments, so a checked box keeps its `primary`
      // outline while it also shows the ring.
      .onFocusVisible(
        CheckboxStyler()
            .containerEffects(vanillaFocusRing())
            .border(vanillaFocusBorder()),
      )
      .onSelected(checked)
      .onIndeterminate(checked)
      // Declared last so it wins; the ring is cleared because a disabled
      // control that still rings reads as actionable.
      .onDisabled(
        CheckboxStyler()
            .containerEffects(.outline(.style(.none)))
            .wrap(.opacity(VanillaTokens.disabledOpacity)),
      )
      .merge(style);
}

/// The Checkbox recipe for one option in a `RemixCheckboxGroup`.
///
/// The group has no styler, so each option needs its own adapter. It is the
/// same checkbox as [vanillaCheckboxStyle], so it delegates.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler vanillaCheckboxGroupItemStyle({
  CheckboxStyler style = const CheckboxStyler.create(),
}) => vanillaCheckboxStyle(style: style);

/// The theme's control radius, clamped to 4px: `radiusMd` is authored for
/// 32-40px controls and would round a 16px box into a circle (a radio).
///
/// A top-level final because `ContextToken` equality is resolver identity.
final _boxRadius = ContextToken<Radius>((context) {
  final radius = VanillaTokens.radiusMd.resolve(context);

  return Radius.elliptical(math.min(radius.x, 4), math.min(radius.y, 4));
});
