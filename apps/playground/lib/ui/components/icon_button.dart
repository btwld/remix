import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
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
/// It reads top to bottom: what every icon button shares, the size, then each
/// variant's colors at rest, under the pointer and on focus, then disabled.
/// Remix owns rendering, input, semantics, and the loading and disabled rules.
///
/// The variants restate the labelled button's colors rather than sharing
/// them, so each recipe can be read and edited on its own. Change one and
/// change the other to keep the two a family.
///
/// `RemixIconButton` requires a `semanticLabel`, because an icon has no
/// accessible name of its own. That is why the generated widget has one
/// required named argument beyond the icon.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler playgroundIconButtonStyle({
  PlaygroundIconButtonVariant variant = .primary,
  PlaygroundIconButtonSize size = .medium,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  return _base(
    _edgeFor(size),
  ).merge(_variantStyle(variant)).onDisabled(_disabledStyle()).merge(style);
}

/// Opacity of the loading spinner, so it reads as secondary to the icon.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// A fill that paints nothing.
const _transparent = Color(0x00000000);

/// The square's edge for one [PlaygroundIconButtonSize]: the labelled button's
/// height. The glyph stays at 16 in every size.
double _edgeFor(PlaygroundIconButtonSize size) => switch (size) {
  .small => PlaygroundTokens.controlSm,
  .medium => PlaygroundTokens.controlMd,
  .large => PlaygroundTokens.controlLg,
};

/// What every icon button shares: a centered square, and the spinner.
IconButtonStyler _base(double edge) => IconButtonStyler()
    .animate(PlaygroundTokens.motion)
    .size(edge, edge)
    .alignment(.center)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .icon(.size(PlaygroundTokens.icon))
    .spinner(
      SpinnerStyler()
          .size(PlaygroundTokens.icon)
          .opacity(_spinnerOpacity)
          .duration(_spinnerDuration),
    );

IconButtonStyler _variantStyle(PlaygroundIconButtonVariant variant) =>
    switch (variant) {
      .primary => _primary(),
      .secondary => _secondary(),
      .outline => _outline(),
      .ghost => _ghost(),
      .destructive => _destructive(),
    };

/// Primary: a solid `primary` fill, at 90% under the pointer.
///
/// A press lands on the hover fill. There is no deeper pressed step.
IconButtonStyler _primary() {
  final hover = playgroundTint(PlaygroundTokens.primary, 0.9)();

  return _content(PlaygroundTokens.primaryForeground())
      .color(PlaygroundTokens.primary())
      .onHovered(.color(hover))
      .onPressed(.color(hover))
      .onFocusVisible(.containerEffects(playgroundFocusRing()));
}

/// Secondary: a solid `secondary` fill, at 80% under the pointer.
IconButtonStyler _secondary() {
  final hover = playgroundTint(PlaygroundTokens.secondary, 0.8)();

  return _content(PlaygroundTokens.secondaryForeground())
      .color(PlaygroundTokens.secondary())
      .onHovered(.color(hover))
      .onPressed(.color(hover))
      .onFocusVisible(.containerEffects(playgroundFocusRing()));
}

/// Outline: a quiet fill inside an `input` border, with a slight lift.
///
/// The fill is the page color in the light theme and `input` at 30% in the
/// dark one, where it reads as part of a raised surface rather than a hole cut
/// through it. Under the pointer it is `accent`, or `input` at 50% in the dark.
IconButtonStyler _outline() {
  final fill = playgroundByBrightness(
    light: PlaygroundTokens.background,
    dark: playgroundTint(PlaygroundTokens.input, 0.3),
  )();
  final hover = playgroundByBrightness(
    light: PlaygroundTokens.accent,
    dark: playgroundTint(PlaygroundTokens.input, 0.5),
  )();
  final highlighted = _content(
    PlaygroundTokens.accentForeground(),
  ).color(hover);

  return _content(PlaygroundTokens.foreground())
      .color(fill)
      .border(
        .color(PlaygroundTokens.input()).width(PlaygroundTokens.strokeHairline),
      )
      // In the effects layer rather than the decoration: the dark fill is
      // translucent, and a decoration shadow would show through it.
      .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
      .onHovered(highlighted)
      // Press repeats the hover content color: a touch device never reports
      // hover, so a press with the fill alone would keep the rest foreground.
      .onPressed(highlighted)
      // The border turns `ring` along with the focus ring.
      .onFocusVisible(
        IconButtonStyler()
            .containerEffects(playgroundFocusRing())
            .border(playgroundFocusBorder()),
      );
}

/// Ghost: no fill and no border until the pointer arrives.
///
/// The hover fill is `accent`, at 50% in the dark theme, where full strength
/// would read as a raised control rather than a highlight.
IconButtonStyler _ghost() {
  final hover = playgroundTint(PlaygroundTokens.accent, 1, dark: 0.5)();
  final highlighted = _content(
    PlaygroundTokens.accentForeground(),
  ).color(hover);

  return _content(PlaygroundTokens.foreground())
      .color(_transparent)
      .onHovered(highlighted)
      // Press repeats the hover content color: a touch device never reports
      // hover, so a press with the fill alone would keep the rest foreground.
      .onPressed(highlighted)
      .onFocusVisible(.containerEffects(playgroundFocusRing()));
}

/// Destructive: a solid `destructive` fill for irreversible actions.
///
/// The dark theme's `destructive` is a light red that cannot carry a white
/// glyph as a solid fill, so it paints at 60% there and hovers at 70%. Hover
/// in the light theme is 90%, as on the primary button.
IconButtonStyler _destructive() {
  final fill = playgroundTint(PlaygroundTokens.destructive, 1, dark: 0.6)();
  final hover = playgroundTint(PlaygroundTokens.destructive, 0.9, dark: 0.7)();

  return _content(PlaygroundTokens.destructiveForeground())
      .color(fill)
      .onHovered(.color(hover))
      .onPressed(.color(hover))
      // Rings in its own red: `destructive` at 20%, 40% in the dark.
      .onFocusVisible(
        .containerEffects(
          playgroundFocusRing(
            color: PlaygroundTokens.destructive,
            alpha: 0.2,
            dark: 0.4,
          ),
        ),
      );
}

/// One color for the icon and the spinner.
IconButtonStyler _content(Color color) =>
    IconButtonStyler().icon(.color(color)).spinner(.color(color));

/// A disabled icon button keeps its variant's colors and fades.
///
/// It also clears the focus ring, because a disabled button that still rings
/// reads as actionable. Declared last, so it wins over every other state.
IconButtonStyler _disabledStyle() => IconButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(PlaygroundTokens.disabledOpacity));
