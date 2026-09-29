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
enum VanillaIconButtonVariant {
  /// Highest emphasis: a solid `primary` fill.
  primary,

  /// Medium emphasis: a solid `secondary` fill.
  secondary,

  /// Low emphasis with a hairline `border`.
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
enum VanillaIconButtonSize {
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
/// fragments. Every state change settles over 150ms on Tailwind's default curve
/// (`VanillaMotion.standard`). Remix keeps ownership of rendering, pointer and
/// keyboard behavior, accessibility semantics, and the loading/disabled
/// interaction rules — this recipe never reimplements any of that.
///
/// It restates the button's metrics and dimming rather than sharing them.
/// That is deliberate: the two components have separate update stories, and a
/// shared table would make every change to one a change to the other. A
/// five-line record is cheaper to duplicate than to couple.
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
IconButtonStyler vanillaIconButtonStyle({
  VanillaIconButtonVariant variant = .primary,
  VanillaIconButtonSize size = .medium,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  return _base(_metricsFor(size))
      .merge(_variantStyle(variant))
      .onFocusVisible(_focusVisibleStyle(variant))
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// Alpha applied to a variant's own fill while hovered or pressed.
///
/// There is no separate pressed step, as in shadcn: a press lands on the
/// hover fill. A deeper press would also take the destructive fill under the
/// 4.5:1 floor its white label needs.
const _hoverAlpha = 0.9;

/// The dark theme's destructive fills.
///
/// shadcn paints a dark destructive button at 60% (`dark:bg-destructive/60`):
/// its dark `destructive` is a light red that reads as text on the page but
/// cannot carry a white label as a solid fill. Hover moves to 70% rather than
/// shadcn's 90%, which would measure about 3.5:1 against that label.
const _darkDestructiveAlpha = 0.6;
const _darkDestructiveHoverAlpha = 0.7;

final _primaryHoverFill = vanillaTint(VanillaTokens.primary, _hoverAlpha);
final _secondaryHoverFill = vanillaTint(VanillaTokens.secondary, _hoverAlpha);
final _destructiveFill = vanillaTint(
  VanillaTokens.destructive,
  1,
  dark: _darkDestructiveAlpha,
);
final _destructiveHoverFill = vanillaTint(
  VanillaTokens.destructive,
  _hoverAlpha,
  dark: _darkDestructiveHoverAlpha,
);

/// Opacity of the loading spinner, so it reads as secondary to the icon.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// Width of the outline the `outline` variant draws.
const _borderWidth = 1.0;

/// Opacity applied to the whole control while disabled.
const _disabledOpacity = 0.5;

/// A fill that paints nothing, used by `outline` and `ghost`.
const _noFill = Color(0x00000000);

/// Geometry for one [VanillaIconButtonSize].
typedef _VanillaIconButtonMetrics = ({double edge, double iconSize});

_VanillaIconButtonMetrics _metricsFor(VanillaIconButtonSize size) =>
    switch (size) {
      .small => (edge: 32.0, iconSize: 16.0),
      .medium => (edge: 36.0, iconSize: 16.0),
      .large => (edge: 40.0, iconSize: 18.0),
    };

/// Layout and spinner defaults shared by every variant.
///
/// The box is square and centered, so the control's footprint does not change
/// with the glyph inside it.
IconButtonStyler _base(_VanillaIconButtonMetrics metrics) => IconButtonStyler()
    .animate(VanillaMotion.standard)
    .size(metrics.edge, metrics.edge)
    .alignment(.center)
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .icon(.size(metrics.iconSize))
    .spinner(
      .size(
        metrics.iconSize,
      ).opacity(_spinnerOpacity).duration(_spinnerDuration),
    );

IconButtonStyler _variantStyle(VanillaIconButtonVariant variant) =>
    switch (variant) {
      .primary => _filled(
        fill: VanillaTokens.primary(),
        foreground: VanillaTokens.primaryForeground(),
        hoverFill: _primaryHoverFill(),
      ),
      .secondary => _filled(
        fill: VanillaTokens.secondary(),
        foreground: VanillaTokens.secondaryForeground(),
        hoverFill: _secondaryHoverFill(),
      ),
      .destructive => _filled(
        fill: _destructiveFill(),
        foreground: VanillaTokens.destructiveForeground(),
        hoverFill: _destructiveHoverFill(),
      ),
      .outline => _quiet(bordered: true),
      .ghost => _quiet(bordered: false),
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

/// A transparent variant: `accent` is what makes interaction visible.
IconButtonStyler _quiet({required bool bordered}) {
  var style = _content(.color(_noFill), VanillaTokens.foreground());
  if (bordered) {
    style = style.border(.color(VanillaTokens.border()).width(_borderWidth));
  }

  return style
      .onHovered(
        _content(
          .color(VanillaTokens.accent()),
          VanillaTokens.accentForeground(),
        ),
      )
      // Content color is re-applied on press, not only on hover: a touch
      // device never reports hover, so a press that changed the fill alone
      // would paint the accent surface under the default foreground.
      .onPressed(
        _content(
          .color(VanillaTokens.accent()),
          VanillaTokens.accentForeground(),
        ),
      );
}

/// Applies one content color to the icon and the spinner.
IconButtonStyler _content(IconButtonStyler style, Color foreground) =>
    style.icon(.color(foreground)).spinner(.color(foreground));

/// The keyboard focus ring: shadcn's 3px `ring` band at half strength.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// box without taking layout space, so focusing a control never reflows the
/// row it sits in. The outline variant also turns its own border `ring`, and
/// the destructive variant rings in its own red, as shadcn's do.
IconButtonStyler _focusVisibleStyle(VanillaIconButtonVariant variant) =>
    switch (variant) {
      .destructive => IconButtonStyler().containerEffects(
        vanillaFocusRing(
          color: VanillaTokens.destructive,
          alpha: _destructiveRingAlpha,
          dark: _darkDestructiveRingAlpha,
        ),
      ),
      .outline =>
        IconButtonStyler()
            .containerEffects(vanillaFocusRing())
            .border(vanillaFocusBorder()),
      .primary ||
      .secondary ||
      .ghost => IconButtonStyler().containerEffects(vanillaFocusRing()),
    };

/// The destructive focus ring: `ring-destructive/20`, `/40` in the dark.
const _destructiveRingAlpha = 0.2;
const _darkDestructiveRingAlpha = 0.4;

/// Declared last so it wins over every other state fragment.
///
/// A disabled control keeps whatever fill its variant gives it and simply
/// fades; the focus ring is cleared because a disabled button that still
/// draws a focus ring reads as actionable.
IconButtonStyler _disabledStyle() => IconButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(_disabledOpacity));
