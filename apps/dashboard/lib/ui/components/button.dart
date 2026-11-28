import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'base_button.dart';

part 'button.g.dart';

/// The sizes a button comes in.
///
/// Height, corner and side padding step with the size; the label is 13px
/// medium and icons are 16px at every size. Pixel values are at 100% theme
/// scaling.
enum UiButtonSize {
  /// 32px tall, with a 12px corner.
  size1,

  /// 40px tall, with a 14px corner. The default.
  size2,

  /// 44px tall, with a 16px corner.
  size3,

  /// 48px tall, with a 16px corner.
  size4,
}

/// The visual weights a button comes in, from most to least emphasis.
///
/// Every weight is drawn in ink and neutral tones whatever the accent; the
/// accent shows in the focus ring.
enum UiButtonVariant {
  /// An ink fill under a page-colored label.
  solid,

  /// A muted neutral fill under ink text.
  soft,

  /// A surface fill inside a 1px border.
  surface,

  /// No fill inside a 1px border.
  outline,

  /// Secondary text alone, with a muted fill under the pointer.
  ghost,
}

/// The Fortal Button recipe.
///
/// It reads top to bottom: what every button shares, then the size, then the
/// variant's look in each state, then focus and disabled. [style] merges last,
/// so a call site can override any part of it.
///
/// [highContrast] strengthens a variant: the solid fill moves to accent step
/// 12, borders to the strong border, and ghost text to ink.
///
/// An icon takes the size's icon size rather than the ambient `IconTheme`. An
/// icon size in [style] overrides it.
@MixWidget(target: RemixButton.new)
ButtonStyler uiButtonStyle({
  UiButtonVariant variant = .solid,
  UiButtonSize size = .size2,
  bool highContrast = false,
  ButtonStyler style = const ButtonStyler.create(),
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
      // A disabled button never rings: this switches the outline off,
      // whatever color and width the focus fragment gives it.
      .onDisabled(
        look.disabled.containerEffects(.outline(.style(.none))).scale(1),
      )
      // Loading keeps the resting look; only the label gives way to the
      // spinner. Declared after `onDisabled` so it wins over it.
      .onLoading(look.rest.scale(1))
      .wrap(uiTouchTarget())
      .merge(style);
}

/// How the button scales while held.
const _pressedScale = 0.97;

/// How much of a disabled solid button shows.
const _solidDisabledOpacity = 0.52;

/// The loading ring: three quarters of a 1.5px circle, one turn per 700ms.
const _spinnerStroke = 0.75;
const _spinnerSweep = 3 * math.pi / 2;
const _spinnerRevolution = Duration(milliseconds: 700);

/// The spinner grows in from 70% as loading starts and shrinks toward 80% as
/// it ends.
const _spinnerEnterScale = 0.7;
const _spinnerExitScale = 0.8;

/// A fill that paints nothing.
const _transparent = Color(0x00000000);

/// Every state change: colors, borders, shadow, opacity and the press scale.
final _motion = AnimationConfig.curve(
  duration: UiMotion.fast,
  curve: UiMotion.easeStandard,
);

/// The label fades out and the spinner grows in as loading starts.
const _loading = RemixLoadingTransition(
  duration: UiMotion.fast,
  reverseDuration: UiMotion.instant,
  spinnerBuilder: _spinnerTransition,
);

Widget _spinnerTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => AnimatedBuilder(
  animation: animation,
  child: child,
  builder: (context, child) {
    final ending = animation.status == AnimationStatus.reverse;
    final t = ending
        ? UiMotion.easeStandard.transform(animation.value)
        : UiMotion.easeEnter.transform(animation.value);
    final from = ending ? _spinnerExitScale : _spinnerEnterScale;

    return Opacity(
      opacity: t,
      child: Transform.scale(scale: from + (1 - from) * t, child: child),
    );
  },
);

/// What every button shares, whatever its size or variant.
ButtonStyler _base() => ButtonStyler()
    .animate(_motion)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .spacing(UiTokens.space2())
    .scale(1)
    .label(.style(UiTokens.text2.mix()).fontWeight(UiTokens.fontWeightMedium()))
    .icon(.size(UiTokens.space4()))
    .spinner(
      SpinnerStyler()
          .size(UiTokens.space4())
          .strokeWidth(_spinnerStroke)
          .sweepAngle(_spinnerSweep)
          .duration(_spinnerRevolution),
    )
    .loadingTransition(_loading);

/// The height, side padding and corner of each step.
///
/// The corners turn into a pill when the theme radius is `full`.
ButtonStyler _scale(UiButtonSize size) => switch (size) {
  .size1 =>
    ButtonStyler()
        .minHeight(UiTokens.controlHeight1())
        .padding(.horizontal(uiButtonInline1()))
        .borderRadius(.all(UiTokens.radius3OrFull())),
  .size2 =>
    ButtonStyler()
        .minHeight(UiTokens.controlHeight2())
        .padding(.horizontal(uiButtonInline2()))
        .borderRadius(.all(UiTokens.radius4OrFull())),
  .size3 =>
    ButtonStyler()
        .minHeight(UiTokens.controlHeight3())
        .padding(.horizontal(uiButtonInline3()))
        .borderRadius(.all(UiTokens.radius5OrFull())),
  .size4 =>
    ButtonStyler()
        .minHeight(UiTokens.controlHeight4())
        .padding(.horizontal(uiButtonInline4()))
        .borderRadius(.all(UiTokens.radius5OrFull())),
};

/// One variant's look at rest and in each state. Hover and press merge over
/// rest; disabled replaces what it names.
typedef _Look = ({
  ButtonStyler rest,
  ButtonStyler hovered,
  ButtonStyler pressed,
  ButtonStyler disabled,
});

/// Solid: an ink fill. Hover and press thin the whole button and lift it with
/// the resting shadow; disabled thins it further. At high contrast the fill
/// moves to accent step 12 and recolors instead of thinning.
_Look _solid(bool highContrast) {
  final lifted = ButtonStyler().decoration(
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
  hovered: ButtonStyler().color(UiTokens.gray4()),
  pressed: ButtonStyler().color(UiTokens.gray4()),
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
    hovered: ButtonStyler()
        .color(UiTokens.gray3())
        .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow1.mix())),
    pressed: ButtonStyler().color(UiTokens.gray4()),
    disabled: _content(UiTokens.gray10()).color(UiTokens.gray3()),
  );
}

/// Ghost: secondary text in the full control box, with a muted fill and ink
/// text under the pointer.
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

/// One color for the label, the icons and the spinner.
ButtonStyler _content(Color color) => ButtonStyler()
    .label(.color(color))
    .icon(.color(color))
    .spinner(.indicatorColor(color));

/// A crisp 1px line just inside the button's edge.
RemixBoxEffectsMix _frame(Color color) =>
    .behindContent(uiInsetSurface(strokes: [color]));
