import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'button.g.dart';

/// The visual weights this application offers for a button.
enum VanillaButtonVariant {
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

/// The control densities this application offers for a button.
///
/// The 32/36/40px heights are compact, web-oriented defaults. A touch-first
/// application should raise them to meet platform hit-target guidance.
enum VanillaButtonSize {
  /// 32px minimum height.
  small,

  /// 36px minimum height. The default.
  medium,

  /// 40px minimum height.
  large,
}

/// The application's Button recipe.
///
/// It reads top to bottom: what every button shares, the size, then each
/// variant's colors at rest, under the pointer and on focus, then disabled.
/// Remix owns rendering, input, semantics, and the loading and disabled rules.
///
/// `@MixWidget` generates `VanillaButton` into `button.g.dart`, with one named
/// constructor per variant. Renaming this function renames the widget.
///
/// [style] merges last, so one call site can override any part:
///
/// ```dart
/// VanillaButton.primary(
///   label: 'Publish',
///   style: ButtonStyler().color(const Color(0xFF7C3AED)),
///   onPressed: publish,
/// )
/// ```
///
/// An override that must beat a hover fill has to be a hover fragment too:
/// `ButtonStyler().onHovered(...)`.
@MixWidget(target: RemixButton.new)
ButtonStyler vanillaButtonStyle({
  VanillaButtonVariant variant = .primary,
  VanillaButtonSize size = .medium,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  return _base(
    _metricsFor(size),
  ).merge(_variantStyle(variant)).onDisabled(_disabledStyle()).merge(style);
}

/// Opacity of the loading spinner, so it reads as secondary to the label.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// A fill that paints nothing.
const _transparent = Color(0x00000000);

/// Geometry for one [VanillaButtonSize].
///
/// The label and the icon do not grow with the control: every size sets its
/// label in `textSm` and its icon at 16, so a row of mixed sizes still reads
/// as one typeface at one size.
typedef _VanillaButtonMetrics = ({
  double minHeight,
  double paddingX,
  double gap,
});

_VanillaButtonMetrics _metricsFor(VanillaButtonSize size) => switch (size) {
  .small => (
    minHeight: VanillaTokens.controlSm,
    paddingX: VanillaTokens.s3,
    gap: VanillaTokens.s1_5,
  ),
  .medium => (
    minHeight: VanillaTokens.controlMd,
    paddingX: VanillaTokens.s4,
    gap: VanillaTokens.s2,
  ),
  .large => (
    minHeight: VanillaTokens.controlLg,
    paddingX: VanillaTokens.s6,
    gap: VanillaTokens.s2,
  ),
};

/// What every button shares: layout, typography, and the spinner.
ButtonStyler _base(_VanillaButtonMetrics metrics) => ButtonStyler()
    .animate(VanillaTokens.motion)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .minHeight(metrics.minHeight)
    .padding(.horizontal(metrics.paddingX))
    .spacing(metrics.gap)
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .label(.style(VanillaTokens.textSm.mix()).fontWeight(FontWeight.w500))
    .icon(.size(VanillaTokens.icon))
    .spinner(
      SpinnerStyler()
          .size(VanillaTokens.icon)
          .opacity(_spinnerOpacity)
          .duration(_spinnerDuration),
    );

ButtonStyler _variantStyle(VanillaButtonVariant variant) => switch (variant) {
  .primary => _primary(),
  .secondary => _secondary(),
  .outline => _outline(),
  .ghost => _ghost(),
  .destructive => _destructive(),
};

/// Primary: a solid `primary` fill, at 90% under the pointer.
///
/// A press lands on the hover fill. There is no deeper pressed step.
ButtonStyler _primary() {
  final hover = vanillaTint(VanillaTokens.primary, 0.9)();

  return _content(VanillaTokens.primaryForeground())
      .color(VanillaTokens.primary())
      .onHovered(.color(hover))
      .onPressed(.color(hover))
      .onFocusVisible(.containerEffects(vanillaFocusRing()));
}

/// Secondary: a solid `secondary` fill, at 80% under the pointer.
ButtonStyler _secondary() {
  final hover = vanillaTint(VanillaTokens.secondary, 0.8)();

  return _content(VanillaTokens.secondaryForeground())
      .color(VanillaTokens.secondary())
      .onHovered(.color(hover))
      .onPressed(.color(hover))
      .onFocusVisible(.containerEffects(vanillaFocusRing()));
}

/// Outline: a quiet fill inside an `input` border, with a slight lift.
///
/// The fill is the page color in the light theme and `input` at 30% in the
/// dark one, where it reads as part of a raised surface rather than a hole cut
/// through it. Under the pointer it is `accent`, or `input` at 50% in the dark.
ButtonStyler _outline() {
  final fill = vanillaByBrightness(
    light: VanillaTokens.background,
    dark: vanillaTint(VanillaTokens.input, 0.3),
  )();
  final hover = vanillaByBrightness(
    light: VanillaTokens.accent,
    dark: vanillaTint(VanillaTokens.input, 0.5),
  )();
  final highlighted = _content(VanillaTokens.accentForeground()).color(hover);

  return _content(VanillaTokens.foreground())
      .color(fill)
      .border(.color(VanillaTokens.input()).width(VanillaTokens.strokeHairline))
      // In the effects layer rather than the decoration: the dark fill is
      // translucent, and a decoration shadow would show through it.
      .containerEffects(.behindContent(VanillaShadow.xs.effects))
      .onHovered(highlighted)
      // Press repeats the hover content color: a touch device never reports
      // hover, so a press with the fill alone would keep the rest foreground.
      .onPressed(highlighted)
      // The border turns `ring` along with the focus ring.
      .onFocusVisible(
        ButtonStyler()
            .containerEffects(vanillaFocusRing())
            .border(vanillaFocusBorder()),
      );
}

/// Ghost: no fill and no border until the pointer arrives.
///
/// The hover fill is `accent`, at 50% in the dark theme, where full strength
/// would read as a raised control rather than a highlight.
ButtonStyler _ghost() {
  final hover = vanillaTint(VanillaTokens.accent, 1, dark: 0.5)();
  final highlighted = _content(VanillaTokens.accentForeground()).color(hover);

  return _content(VanillaTokens.foreground())
      .color(_transparent)
      .onHovered(highlighted)
      // Press repeats the hover content color: a touch device never reports
      // hover, so a press with the fill alone would keep the rest foreground.
      .onPressed(highlighted)
      .onFocusVisible(.containerEffects(vanillaFocusRing()));
}

/// Destructive: a solid `destructive` fill for irreversible actions.
///
/// The dark theme's `destructive` is a light red that cannot carry a white
/// label as a solid fill, so it paints at 60% there and hovers at 70%. Hover
/// in the light theme is 90%, as on the primary button.
ButtonStyler _destructive() {
  final fill = vanillaTint(VanillaTokens.destructive, 1, dark: 0.6)();
  final hover = vanillaTint(VanillaTokens.destructive, 0.9, dark: 0.7)();

  return _content(VanillaTokens.destructiveForeground())
      .color(fill)
      .onHovered(.color(hover))
      .onPressed(.color(hover))
      // Rings in its own red: `destructive` at 20%, 40% in the dark.
      .onFocusVisible(
        .containerEffects(
          vanillaFocusRing(
            color: VanillaTokens.destructive,
            alpha: 0.2,
            dark: 0.4,
          ),
        ),
      );
}

/// One color for the label, the icons, and the spinner.
ButtonStyler _content(Color color) => ButtonStyler()
    .label(.color(color))
    .icon(.color(color))
    .spinner(.color(color));

/// A disabled button keeps its variant's colors and fades.
///
/// It also clears the focus ring, because a disabled button that still rings
/// reads as actionable. Declared last, so it wins over every other state.
ButtonStyler _disabledStyle() => ButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaTokens.disabledOpacity));
