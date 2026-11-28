import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'base_button.dart';

part 'icon_button.g.dart';

/// The sizes an icon button comes in.
///
/// Square at the heights the labelled button is tall, so the two line up in a
/// row, with a 16px icon at every size. Pixel values are at 100% theme
/// scaling.
enum UiIconButtonSize {
  /// A 32px square with a 12px corner.
  size1,

  /// A 40px square with a 14px corner. The default.
  size2,

  /// A 44px square with a 16px corner.
  size3,

  /// A 48px square with a 16px corner.
  size4,
}

/// The visual weights an icon button comes in, from most to least emphasis.
///
/// The same five the labelled button offers, so a toolbar can mix the two.
enum UiIconButtonVariant {
  /// An ink fill under a page-colored icon.
  solid,

  /// A muted neutral fill under an ink icon.
  soft,

  /// A surface fill inside a 1px border.
  surface,

  /// No fill inside a 1px border.
  outline,

  /// A secondary icon alone, with a muted fill under the pointer.
  ghost,
}

/// The Fortal IconButton recipe.
///
/// It reads top to bottom: what every icon button shares, then the size, then
/// the variant's look in each state, then focus and disabled. [style] merges
/// last, so a call site can override any part of it.
///
/// The variants restate the labelled button's looks rather than sharing them,
/// so each recipe can be read and edited on its own. Change one and change the
/// other to keep the two a family.
///
/// [highContrast] strengthens a variant: the solid fill moves to accent step
/// 12, borders to the strong border, and the ghost icon to ink.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler uiIconButtonStyle({
  UiIconButtonVariant variant = .solid,
  UiIconButtonSize size = .size2,
  bool highContrast = false,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  final look = switch (variant) {
    .solid => _solid(highContrast),
    .soft => _soft(highContrast),
    .surface => _surface(highContrast),
    .outline => _outline(highContrast),
    .ghost => _ghost(highContrast),
  };

  return _base()
      .merge(_scale(size))
      .merge(look.rest)
      .onHovered(look.hovered)
      .onPressed(look.pressed.scale(_pressedScale))
      .onFocusVisible(.containerEffects(uiFocusOutline()))
      // A disabled icon button never rings: this switches the outline off,
      // whatever color and width the focus fragment gives it.
      .onDisabled(
        look.disabled.containerEffects(.outline(.style(.none))).scale(1),
      )
      .wrap(uiTouchTarget())
      .merge(style);
}

/// How the button scales while held: a little more than the labelled button,
/// because it is smaller.
const _pressedScale = 0.96;

/// How much of a disabled solid icon button shows.
const _solidDisabledOpacity = 0.52;

/// The loading ring: three quarters of a 1.5px circle, one turn per 700ms.
const _spinnerStroke = 0.75;
const _spinnerSweep = 3 * math.pi / 2;
const _spinnerRevolution = Duration(milliseconds: 700);

/// A fill that paints nothing.
const _transparent = Color(0x00000000);

/// Every state change: colors, borders, shadow, opacity and the press scale.
final _motion = AnimationConfig.curve(
  duration: UiMotion.fast,
  curve: UiMotion.easeStandard,
);

/// What every icon button shares, whatever its size or variant.
IconButtonStyler _base() => IconButtonStyler()
    .animate(_motion)
    .alignment(.center)
    .scale(1)
    .icon(.size(UiTokens.space4()))
    .spinner(
      SpinnerStyler()
          .size(UiTokens.space4())
          .strokeWidth(_spinnerStroke)
          .sweepAngle(_spinnerSweep)
          .duration(_spinnerRevolution),
    );

/// The square and corner of each step.
///
/// The corners turn into a circle when the theme radius is `full`.
IconButtonStyler _scale(UiIconButtonSize size) => switch (size) {
  .size1 =>
    IconButtonStyler()
        .size(UiTokens.controlHeight1(), UiTokens.controlHeight1())
        .borderRadius(.all(UiTokens.radius3OrFull())),
  .size2 =>
    IconButtonStyler()
        .size(UiTokens.controlHeight2(), UiTokens.controlHeight2())
        .borderRadius(.all(UiTokens.radius4OrFull())),
  .size3 =>
    IconButtonStyler()
        .size(UiTokens.controlHeight3(), UiTokens.controlHeight3())
        .borderRadius(.all(UiTokens.radius5OrFull())),
  .size4 =>
    IconButtonStyler()
        .size(UiTokens.controlHeight4(), UiTokens.controlHeight4())
        .borderRadius(.all(UiTokens.radius5OrFull())),
};

/// One variant's look at rest and in each state. Hover and press merge over
/// rest; disabled replaces what it names.
typedef _Look = ({
  IconButtonStyler rest,
  IconButtonStyler hovered,
  IconButtonStyler pressed,
  IconButtonStyler disabled,
});

/// Solid: an ink fill. Hover and press thin the whole button and lift it with
/// the resting shadow; disabled thins it further. At high contrast the fill
/// moves to accent step 12 and recolors instead of thinning.
_Look _solid(bool highContrast) {
  final lifted = IconButtonStyler().decoration(
    BoxDecorationMix.create(boxShadow: UiTokens.shadow1.mix()),
  );
  final rest = highContrast
      ? _content(UiTokens.gray1()).color(UiTokens.accent12())
      : _content(UiTokens.accentContrast()).color(UiTokens.accentSolid());

  return (
    rest: rest.wrap(.opacity(1)),
    hovered: highContrast
        ? lifted.color(uiHighContrastHoverFill())
        : lifted
              .color(uiSolidHoveredFill())
              .wrap(.opacity(uiSolidHoveredOpacity())),
    pressed: highContrast
        ? lifted.color(uiHighContrastPressedFill())
        : lifted
              .color(uiSolidPressedInk())
              .wrap(.opacity(uiSolidPressedOpacity())),
    // A disabled solid button also drops any filter the caller added.
    disabled: rest.wrap(.opacity(_solidDisabledOpacity)).wrap(uiClearFilter()),
  );
}

/// Soft: a muted fill that deepens a step under the pointer.
_Look _soft(bool highContrast) => (
  rest: _content(UiTokens.gray12()).color(UiTokens.gray3()),
  hovered: IconButtonStyler().color(UiTokens.gray4()),
  pressed: IconButtonStyler().color(UiTokens.gray4()),
  disabled: _content(UiTokens.gray10()).color(UiTokens.gray3()),
);

/// Surface: the surface fill inside a border. Hover mutes the fill and lifts
/// the button with the resting shadow; press mutes it a step further.
_Look _surface(bool highContrast) =>
    _framed(fill: UiTokens.gray2(), highContrast: highContrast);

/// Outline: a border with no fill, hovered and pressed like surface.
_Look _outline(bool highContrast) =>
    _framed(fill: _transparent, highContrast: highContrast);

_Look _framed({required Color fill, required bool highContrast}) {
  final frame = _frame(highContrast ? UiTokens.gray8() : UiTokens.gray7());

  return (
    rest: _content(UiTokens.gray12()).color(fill).containerEffects(frame),
    hovered: IconButtonStyler()
        .color(UiTokens.gray3())
        .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow1.mix())),
    pressed: IconButtonStyler().color(UiTokens.gray4()),
    disabled: _content(UiTokens.gray10()).color(UiTokens.gray3()),
  );
}

/// Ghost: a secondary icon in the full square, with a muted fill and an ink
/// icon under the pointer.
_Look _ghost(bool highContrast) {
  final hovered = _content(UiTokens.gray12()).color(UiTokens.gray3());

  return (
    rest: _content(
      highContrast ? UiTokens.gray12() : UiTokens.gray11(),
    ).color(_transparent),
    hovered: hovered,
    pressed: hovered,
    disabled: _content(UiTokens.gray10()).color(_transparent),
  );
}

/// One color for the icon and the spinner.
IconButtonStyler _content(Color color) =>
    IconButtonStyler().icon(.color(color)).spinner(.indicatorColor(color));

/// A crisp 1px line just inside the button's edge.
RemixBoxEffectsMix _frame(Color color) =>
    .behindContent(uiInsetSurface(strokes: [color]));
