import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'button.g.dart';

/// The visual weights this application offers for a button.
enum PlaygroundButtonVariant {
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
enum PlaygroundButtonSize {
  /// 32px minimum height.
  small,

  /// 36px minimum height. The default.
  medium,

  /// 40px minimum height.
  large,
}

/// The application's Button recipe.
///
/// Everything visual about a button lives in this function: geometry,
/// typography, the five variants, hover and press motion, and the
/// hover/pressed/focus/disabled fragments. Every state change settles over
/// 150ms on the shared curve (`PlaygroundMotion.standard`). Remix keeps ownership
/// of rendering, pointer and keyboard behavior, accessibility semantics, and
/// the loading/disabled interaction rules — this recipe never reimplements any
/// of that.
///
/// `@MixWidget(target: RemixButton.new)` generates `PlaygroundButton` into
/// `button.g.dart`: an adapter whose constructor is this function's
/// parameters plus every safe `RemixButton` parameter, and whose `build`
/// calls `RemixButton(style: playgroundButtonStyle(...), ...)`. Because
/// [variant] is a non-nullable enum, the generator also emits one named
/// constructor per enum value.
///
/// The widget's name comes from this function's name — the generator drops a
/// trailing `Style` and capitalises what is left — so renaming the recipe
/// renames the widget. There is nothing to keep in sync.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// PlaygroundButton.primary(
///   label: 'Publish',
///   style: ButtonStyler().color(const Color(0xFF7C3AED)),
///   onPressed: publish,
/// )
/// ```
///
/// State fragments merge by state, not by depth: an override that must beat
/// the recipe's hover fill has to be declared as a hover fragment too
/// (`ButtonStyler().onHovered(...)`).
@MixWidget(target: RemixButton.new)
ButtonStyler playgroundButtonStyle({
  PlaygroundButtonVariant variant = .primary,
  PlaygroundButtonSize size = .medium,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  return _base(_metricsFor(size))
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
/// label needs.
const _hoverAlpha = 0.9;

/// Alpha applied to the secondary fill while hovered: the fill at 80%.
const _secondaryHoverAlpha = 0.8;

/// The dark theme's destructive fills.
///
/// A dark destructive button is painted at 60%: the dark `destructive` is a
/// light red that reads as text on the page but cannot carry a white label as a
/// solid fill. Hover moves to 70% rather than 90%, which would measure about
/// 3.5:1 against that label.
const _darkDestructiveAlpha = 0.6;
const _darkDestructiveHoverAlpha = 0.7;

/// The dark ghost hover, `accent` at 50%: the dark `accent` at full strength
/// would read as a raised control rather than a highlight.
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

/// Opacity of the loading spinner, so it reads as secondary to the label.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// A fill that paints nothing, used by `ghost`.
const _noFill = Color(0x00000000);

/// Geometry for one [PlaygroundButtonSize]: 32px tall with a 12px side inset and a
/// 6px gap, 36px with 16 and 8, and 40px with 24 and 8.
///
/// The label and the icon do not grow with the control. Every size sets its
/// label in `textSm` and its icon at 16, so a row of mixed sizes still reads as
/// one typeface at one size.
typedef _PlaygroundButtonMetrics = ({
  double minHeight,
  double paddingX,
  double gap,
});

_PlaygroundButtonMetrics _metricsFor(PlaygroundButtonSize size) =>
    switch (size) {
      .small => (
        minHeight: PlaygroundSize.controlSm,
        paddingX: PlaygroundSpace.s3,
        gap: PlaygroundSpace.s1_5,
      ),
      .medium => (
        minHeight: PlaygroundSize.controlMd,
        paddingX: PlaygroundSpace.s4,
        gap: PlaygroundSpace.s2,
      ),
      .large => (
        minHeight: PlaygroundSize.controlLg,
        paddingX: PlaygroundSpace.s6,
        gap: PlaygroundSpace.s2,
      ),
    };

/// Layout, typography, and spinner defaults shared by every variant.
ButtonStyler _base(_PlaygroundButtonMetrics metrics) => ButtonStyler()
    .animate(PlaygroundMotion.standard)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .minHeight(metrics.minHeight)
    .padding(.horizontal(metrics.paddingX))
    .spacing(metrics.gap)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .label(.style(PlaygroundTokens.textSm.mix()).fontWeight(FontWeight.w500))
    .icon(.size(PlaygroundSize.icon))
    .spinner(
      .size(
        PlaygroundSize.icon,
      ).opacity(_spinnerOpacity).duration(_spinnerDuration),
    );

ButtonStyler _variantStyle(PlaygroundButtonVariant variant) =>
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
            // In the effects layer rather than the decoration: the dark fill is
            // translucent, and a decoration shadow would show through it.
            .containerEffects(.behindContent(PlaygroundShadow.xs.effects)),
      .ghost => _quiet(fill: _noFill, hoverFill: _ghostHoverFill()),
    };

/// A solid variant: its own fill, dimmed while hovered or pressed.
ButtonStyler _filled({
  required Color fill,
  required Color foreground,
  required Color hoverFill,
}) => _content(
  .color(fill),
  foreground,
).onHovered(.color(hoverFill)).onPressed(.color(hoverFill));

/// A quiet variant: `accent` under the pointer is what makes it interactive.
ButtonStyler _quiet({required Color fill, required Color hoverFill}) {
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

/// Applies one content color to the label, the icons, and the spinner.
ButtonStyler _content(ButtonStyler style, Color foreground) => style
    .label(.color(foreground))
    .icon(.color(foreground))
    .spinner(.color(foreground));

/// The keyboard focus ring: a 3px band of `ring` at half strength.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the box
/// without taking layout space, so focusing a control never reflows the row it
/// sits in. The outline variant also turns its own border `ring`, and the
/// destructive variant rings in its own red.
ButtonStyler _focusVisibleStyle(PlaygroundButtonVariant variant) =>
    switch (variant) {
      .destructive => ButtonStyler().containerEffects(
        playgroundFocusRing(
          color: PlaygroundTokens.destructive,
          alpha: _destructiveRingAlpha,
          dark: _darkDestructiveRingAlpha,
        ),
      ),
      .outline =>
        ButtonStyler()
            .containerEffects(playgroundFocusRing())
            .border(playgroundFocusBorder()),
      .primary ||
      .secondary ||
      .ghost => ButtonStyler().containerEffects(playgroundFocusRing()),
    };

/// The destructive focus ring: `destructive` at 20%, 40% in the dark.
const _destructiveRingAlpha = 0.2;
const _darkDestructiveRingAlpha = 0.4;

/// Declared last so it wins over every other state fragment.
///
/// A disabled control keeps whatever fill its variant gives it and simply
/// fades; the focus ring is cleared because a disabled button that still
/// draws a focus ring reads as actionable.
ButtonStyler _disabledStyle() => ButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(PlaygroundOpacity.disabled));
