import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'icon_button.g.dart';

/// The visual weights this application offers for an icon button.
///
/// The same five the labelled button offers, so a toolbar can mix the two
/// without the icon-only control looking like a different family.
enum PlaygroundIconButtonVariant {
  /// Highest emphasis: a solid `primary` fill.
  primary,

  /// Medium emphasis: a solid `secondary` fill.
  secondary,

  /// Low emphasis: a quiet fill inside an `input` outline, with a slight
  /// lift.
  outline,

  /// Low emphasis with no fill and no border.
  ghost,

  /// Highest emphasis for irreversible actions.
  destructive,
}

/// The control densities this application offers for an icon button.
///
/// Square at the same 32/36/40px the labelled button is tall, so the two line
/// up in a row. These are compact, web-oriented defaults; a touch-first
/// application should raise them to meet platform hit-target guidance.
enum PlaygroundIconButtonSize {
  /// A 32px square.
  small,

  /// A 36px square. The default.
  medium,

  /// A 40px square.
  large,
}

/// The application's IconButton recipe.
///
/// Everything visual about an icon button lives in this function: geometry, the
/// five variants, hover and press motion, and the hover/pressed/focus/disabled
/// fragments. Every state change settles over 150ms on the shared curve
/// (`PlaygroundMotion.standard`). Remix keeps ownership of rendering, pointer and
/// keyboard behavior, accessibility semantics, and the loading/disabled
/// interaction rules — this recipe never reimplements any of that.
///
/// It restates the button's fills rather than sharing them. That is
/// deliberate: the two components have separate update stories, and a shared
/// table would make every change to one a change to the other. The scale and
/// the tints they draw on are shared, through `PlaygroundSize` and `playgroundTint`.
///
/// `RemixIconButton` requires a `semanticLabel` because an icon has no
/// accessible name of its own. That is a Remix rule, not a recipe choice, and
/// it is why the generated widget has one required named argument beyond the
/// icon.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value.
///
/// State fragments merge by state, not by depth: an override that must beat
/// the recipe's hover fill has to be declared as a hover fragment too
/// (`IconButtonStyler().onHovered(...)`).
@MixWidget(target: RemixIconButton.new)
IconButtonStyler playgroundIconButtonStyle({
  PlaygroundIconButtonVariant variant = .primary,
  PlaygroundIconButtonSize size = .medium,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  return _base(_edgeFor(size))
      .merge(_variantStyle(variant))
      .onFocusVisible(_focusVisibleStyle(variant))
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// Alpha applied to the primary and destructive fills while hovered or pressed:
/// the fill at 90%.
///
/// There is no separate pressed step: a press lands on the hover fill. A deeper
/// press would also take the destructive fill under the 4.5:1 floor its white
/// glyph needs.
const _hoverAlpha = 0.9;

/// Alpha applied to the secondary fill while hovered: the fill at 80%.
const _secondaryHoverAlpha = 0.8;

/// The dark theme's destructive fills, at 60% and a 70% hover. See the button
/// recipe for why the hover stops short of 90%.
const _darkDestructiveAlpha = 0.6;
const _darkDestructiveHoverAlpha = 0.7;

/// The dark ghost hover, `accent` at 50%.
const _darkGhostHoverAlpha = 0.5;

final _primaryHoverFill = playgroundTint(PlaygroundTokens.primary, _hoverAlpha);
final _secondaryHoverFill = playgroundTint(
  PlaygroundTokens.secondary,
  _secondaryHoverAlpha,
);
final _destructiveFill = playgroundTint(
  PlaygroundTokens.destructive,
  1,
  dark: _darkDestructiveAlpha,
);
final _destructiveHoverFill = playgroundTint(
  PlaygroundTokens.destructive,
  _hoverAlpha,
  dark: _darkDestructiveHoverAlpha,
);
final _ghostHoverFill = playgroundTint(
  PlaygroundTokens.accent,
  1,
  dark: _darkGhostHoverAlpha,
);

/// The outline variant's fill: the page color on a light page, and `input` at
/// 30% on a dark one, so a dark outline control on a raised surface reads as
/// part of that surface rather than as a hole cut through it.
final _outlineFill = playgroundByBrightness(
  light: PlaygroundTokens.background,
  dark: playgroundTint(PlaygroundTokens.input, _darkOutlineFillAlpha),
);

/// The outline variant under the pointer: `accent`, or `input` at 50% on a
/// dark page.
final _outlineHoverFill = playgroundByBrightness(
  light: PlaygroundTokens.accent,
  dark: playgroundTint(PlaygroundTokens.input, _darkOutlineHoverAlpha),
);

/// See [_outlineFill] and [_outlineHoverFill].
const _darkOutlineFillAlpha = 0.3;
const _darkOutlineHoverAlpha = 0.5;

/// Opacity of the loading spinner, so it reads as secondary to the icon.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// A fill that paints nothing, used by `ghost`.
const _noFill = Color(0x00000000);

/// The square's edge for one [PlaygroundIconButtonSize]: 32, 36, or 40px, the
/// button's heights. The glyph stays at 16 in every size.
double _edgeFor(PlaygroundIconButtonSize size) => switch (size) {
  .small => PlaygroundSize.controlSm,
  .medium => PlaygroundSize.controlMd,
  .large => PlaygroundSize.controlLg,
};

/// Layout and spinner defaults shared by every variant.
///
/// The box is square and centered, so the control's footprint does not change
/// with the glyph inside it.
IconButtonStyler _base(double edge) => IconButtonStyler()
    .animate(PlaygroundMotion.standard)
    .size(edge, edge)
    .alignment(.center)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .icon(.size(PlaygroundSize.icon))
    .spinner(
      .size(
        PlaygroundSize.icon,
      ).opacity(_spinnerOpacity).duration(_spinnerDuration),
    );

IconButtonStyler _variantStyle(PlaygroundIconButtonVariant variant) =>
    switch (variant) {
      .primary => _filled(
        fill: PlaygroundTokens.primary(),
        foreground: PlaygroundTokens.primaryForeground(),
        hoverFill: _primaryHoverFill(),
      ),
      .secondary => _filled(
        fill: PlaygroundTokens.secondary(),
        foreground: PlaygroundTokens.secondaryForeground(),
        hoverFill: _secondaryHoverFill(),
      ),
      .destructive => _filled(
        fill: _destructiveFill(),
        foreground: PlaygroundTokens.destructiveForeground(),
        hoverFill: _destructiveHoverFill(),
      ),
      .outline =>
        _quiet(fill: _outlineFill(), hoverFill: _outlineHoverFill())
            .border(
              .color(PlaygroundTokens.input()).width(PlaygroundStroke.hairline),
            )
            // In the effects layer rather than the decoration: the dark fill
            // is translucent, and a decoration shadow would show through it.
            .containerEffects(.behindContent(PlaygroundShadow.xs.effects)),
      .ghost => _quiet(fill: _noFill, hoverFill: _ghostHoverFill()),
    };

/// A solid variant: its own fill, dimmed while hovered or pressed.
IconButtonStyler _filled({
  required Color fill,
  required Color foreground,
  required Color hoverFill,
}) => _content(
  .color(fill),
  foreground,
).onHovered(.color(hoverFill)).onPressed(.color(hoverFill));

/// A quiet variant: `accent` under the pointer is what makes it interactive.
IconButtonStyler _quiet({required Color fill, required Color hoverFill}) {
  final highlighted = _content(
    .color(hoverFill),
    PlaygroundTokens.accentForeground(),
  );

  return _content(.color(fill), PlaygroundTokens.foreground())
      .onHovered(highlighted)
      // Content color is re-applied on press, not only on hover: a touch
      // device never reports hover, so a press that changed the fill alone
      // would paint the accent surface under the default foreground.
      .onPressed(highlighted);
}

/// Applies one content color to the icon and the spinner.
IconButtonStyler _content(IconButtonStyler style, Color foreground) =>
    style.icon(.color(foreground)).spinner(.color(foreground));

/// The keyboard focus ring: a 3px band of `ring` at half strength.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the box
/// without taking layout space, so focusing a control never reflows the row it
/// sits in. The outline variant also turns its own border `ring`, and the
/// destructive variant rings in its own red.
IconButtonStyler _focusVisibleStyle(PlaygroundIconButtonVariant variant) =>
    switch (variant) {
      .destructive => IconButtonStyler().containerEffects(
        playgroundFocusRing(
          color: PlaygroundTokens.destructive,
          alpha: _destructiveRingAlpha,
          dark: _darkDestructiveRingAlpha,
        ),
      ),
      .outline =>
        IconButtonStyler()
            .containerEffects(playgroundFocusRing())
            .border(playgroundFocusBorder()),
      .primary ||
      .secondary ||
      .ghost => IconButtonStyler().containerEffects(playgroundFocusRing()),
    };

/// The destructive focus ring: `destructive` at 20%, 40% in the dark.
const _destructiveRingAlpha = 0.2;
const _darkDestructiveRingAlpha = 0.4;

/// Declared last so it wins over every other state fragment.
///
/// A disabled control keeps whatever fill its variant gives it and simply
/// fades; the focus ring is cleared because a disabled button that still
/// draws a focus ring reads as actionable.
IconButtonStyler _disabledStyle() => IconButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(PlaygroundOpacity.disabled));
