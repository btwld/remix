import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'checkbox.g.dart';

/// The application's Checkbox recipe.
///
/// Everything visual about a checkbox lives in this function: the box
/// geometry, the indicator, the label, and the
/// checked/indeterminate/focus/disabled fragments. Remix keeps
/// ownership of rendering, the tristate transition, pointer and keyboard
/// behavior, the minimum tap target, and the checkbox accessibility
/// semantics — this recipe never reimplements any of that.
///
/// `@MixWidget(target: RemixCheckbox.new)` generates `VanillaCheckbox`
/// into `checkbox.g.dart`: an adapter whose constructor is this function's
/// parameters plus every safe `RemixCheckbox` parameter, and whose `build`
/// calls `RemixCheckbox(style: vanillaCheckboxStyle(...), ...)`. Unlike
/// Button there is no `variant` parameter, so the generator emits no named
/// constructors: a checkbox has one look, and its meaningful axes are the
/// runtime states below.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// VanillaCheckbox(
///   selected: subscribed,
///   label: 'Email me',
///   style: CheckboxStyler().onSelected(
///     CheckboxStyler().color(const Color(0xFF7C3AED)),
///   ),
///   onChanged: (value) => setState(() => subscribed = value),
/// )
/// ```
///
/// State fragments merge by state, not by depth: an override that must beat
/// the recipe's checked fill has to be declared as a selected fragment too
/// (`CheckboxStyler().onSelected(...)`).
///
/// There is deliberately no hover or pressed fragment. A button needs them
/// because nothing else about it changes on tap; a checkbox flips its own
/// state, and that is the feedback. The pointer cursor Remix sets says it can
/// be clicked.
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler vanillaCheckboxStyle({
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  // Built once and used for both fragments: an indeterminate checkbox is a
  // checkbox that is *not unchecked*, so it carries the checked surface and
  // only its glyph differs. Reusing the value also keeps the two fragments
  // equal, which matters because stylers compare by value.
  final checked = _checkedStyle();

  return _base()
      // Before the checked fragments, so a checked box keeps its `primary`
      // outline while it also shows the ring.
      .onFocusVisible(_focusVisibleStyle())
      .onSelected(checked)
      .onIndeterminate(checked)
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// The application's Checkbox recipe for one option in a checkbox group.
///
/// `RemixCheckboxGroup` is behavioral: it owns the selected set and the
/// group-wide enabled and required configuration, and carries no styler of
/// its own. Without this second adapter every option in a group would need
/// the recipe attached by hand, and one missed option in a loop would render
/// unstyled beside its styled siblings.
///
/// It delegates to [vanillaCheckboxStyle] rather than restating it:
/// a group option is the same checkbox, so editing the recipe above restyles
/// both.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler vanillaCheckboxGroupItemStyle({
  CheckboxStyler style = const CheckboxStyler.create(),
}) => vanillaCheckboxStyle(style: style);

/// The largest corner radius a checkbox box may take: 4px.
///
/// `VanillaTokens.radiusMd` is authored for 32-40px controls. Applied
/// unclamped to a 16px box, a pill radius draws a circle, which reads as a
/// radio button. Clamping rather than hardcoding keeps the theme in charge in
/// the other direction, so `radius: Radius.zero` still yields square
/// checkboxes.
const _maxBoxRadius = 4.0;

/// The theme's control radius, clamped to [_maxBoxRadius].
///
/// Declared as a top-level final because `ContextToken` equality is resolver
/// identity: rebuilding one per call would make two identical recipes compare
/// unequal.
final _boxRadius = ContextToken<Radius>((context) {
  final radius = VanillaTokens.radiusMd.resolve(context);

  return Radius.elliptical(
    math.min(radius.x, _maxBoxRadius),
    math.min(radius.y, _maxBoxRadius),
  );
});

/// The unchecked box's fill: transparent, or `input` at 30% in the dark.
final _fill = vanillaTint(VanillaTokens.input, 0, dark: _darkFillAlpha);

/// See [_fill].
const _darkFillAlpha = 0.3;

/// The unchecked box, the indicator geometry, and the label: a 16px box with
/// 4px corners, an `input` outline, and the `xs` shadow, and a 14px check.
///
/// The indicator gets a size but no color here: Remix renders no indicator at
/// all while unchecked, so the only states that can show one set their own
/// content color.
///
/// The label is a form label, set like the text field's: `textSm` at medium
/// weight, 12px from the box.
CheckboxStyler _base() => CheckboxStyler()
    .animate(VanillaMotion.standard)
    .size(VanillaSize.icon, VanillaSize.icon)
    .alignment(.center)
    .borderRadius(.all(_boxRadius()))
    .color(_fill())
    .border(.color(VanillaTokens.input()).width(VanillaStroke.hairline))
    // In the effects layer rather than the decoration: the empty box is
    // transparent, and a decoration shadow would show through it.
    .containerEffects(.behindContent(VanillaShadow.xs.effects))
    .indicator(.size(VanillaSize.iconSm))
    .labelSpacing(VanillaSpace.s3)
    .label(
      .style(
        VanillaTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
    );

/// The checked and indeterminate surface: `primary`, outline and all.
///
/// The border is repainted in the fill color rather than removed: dropping it
/// would shrink the painted box by two logical pixels at the moment of
/// checking, so the control would visibly twitch.
CheckboxStyler _checkedStyle() => CheckboxStyler()
    .color(VanillaTokens.primary())
    .border(.color(VanillaTokens.primary()))
    .indicator(.color(VanillaTokens.primaryForeground()));

/// The keyboard focus ring: a 3px band of `ring` at half strength, with
/// the box's own outline turned `ring`.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// box without taking layout space, so focusing a checkbox never reflows the
/// row it sits in.
CheckboxStyler _focusVisibleStyle() => CheckboxStyler()
    .containerEffects(vanillaFocusRing())
    .border(vanillaFocusBorder());

/// Declared last so it wins over every other state fragment.
///
/// A disabled checkbox keeps whatever surface its state gives it and simply
/// fades; the focus ring is cleared because a disabled control that still
/// draws a focus ring reads as actionable.
CheckboxStyler _disabledStyle() => CheckboxStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaOpacity.disabled));
