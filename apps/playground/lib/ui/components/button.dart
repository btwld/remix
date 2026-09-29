import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'button.g.dart';

/// The visual weights this application offers for a button.
enum PlaygroundButtonVariant {
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
/// hover/pressed/focus/disabled fragments. Hover settles over 100ms and
/// press over 40ms. Remix keeps ownership of rendering, pointer and keyboard
/// behavior, accessibility semantics, and the loading/disabled interaction
/// rules — this recipe never reimplements any of that.
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
      .onFocusVisible(_focusVisibleStyle())
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

final _primaryHoverFill = playgroundTint(PlaygroundTokens.primary, _hoverAlpha);
final _secondaryHoverFill = playgroundTint(
  PlaygroundTokens.secondary,
  _hoverAlpha,
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

/// Hover and the other state changes.
const _motionDuration = Duration(milliseconds: 100);

/// Press is shorter than the base transition.
const _pressedMotionDuration = Duration(milliseconds: 40);

/// Opacity of the loading spinner, so it reads as secondary to the label.
const _spinnerOpacity = 0.65;

/// One full spinner revolution.
const _spinnerDuration = Duration(milliseconds: 800);

/// Width of the keyboard focus ring.
const _focusRingWidth = 2.0;

/// Distance between the control edge and its focus ring.
const _focusRingOffset = 2.0;

/// Opacity applied to the whole control while disabled.
const _disabledOpacity = 0.5;

/// A fill that paints nothing, used by `outline` and `ghost`.
const _noFill = Color(0x00000000);

/// Geometry and type scale for one [PlaygroundButtonSize].
typedef _PlaygroundButtonMetrics = ({
  double minHeight,
  double paddingX,
  double gap,
  double labelSize,
  double iconSize,
});

_PlaygroundButtonMetrics _metricsFor(PlaygroundButtonSize size) =>
    switch (size) {
      .small => (
        minHeight: 32.0,
        paddingX: 12.0,
        gap: 6.0,
        labelSize: 14.0,
        iconSize: 16.0,
      ),
      .medium => (
        minHeight: 36.0,
        paddingX: 16.0,
        gap: 8.0,
        labelSize: 14.0,
        iconSize: 16.0,
      ),
      .large => (
        minHeight: 40.0,
        paddingX: 20.0,
        gap: 8.0,
        labelSize: 16.0,
        iconSize: 18.0,
      ),
    };

/// Layout, typography, and spinner defaults shared by every variant.
ButtonStyler _base(_PlaygroundButtonMetrics metrics) => ButtonStyler()
    .animate(AnimationConfig.easeOut(_motionDuration))
    .direction(.horizontal)
    .mainAxisSize(.min)
    .mainAxisAlignment(.center)
    .crossAxisAlignment(.center)
    .minHeight(metrics.minHeight)
    .padding(.horizontal(metrics.paddingX))
    .spacing(metrics.gap)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .label(.fontSize(metrics.labelSize).fontWeight(FontWeight.w500))
    .icon(.size(metrics.iconSize))
    .spinner(
      .size(
        metrics.iconSize,
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
      .outline => _quiet(bordered: true),
      .ghost => _quiet(bordered: false),
    };

/// A solid variant: its own fill, dimmed while hovered or pressed.
ButtonStyler _filled({
  required Color fill,
  required Color foreground,
  required Color hoverFill,
}) => _content(.color(fill), foreground)
    .onHovered(.color(hoverFill))
    .onPressed(
      ButtonStyler()
          .animate(AnimationConfig.easeOut(_pressedMotionDuration))
          .color(hoverFill),
    );

/// A transparent variant: `accent` is what makes interaction visible.
ButtonStyler _quiet({required bool bordered}) {
  var style = _content(.color(_noFill), PlaygroundTokens.foreground());
  if (bordered) {
    style = style.border(.color(PlaygroundTokens.border()).width(1));
  }

  return style
      .onHovered(
        _content(
          .color(PlaygroundTokens.accent()),
          PlaygroundTokens.accentForeground(),
        ),
      )
      // Content color is re-applied on press, not only on hover: a touch
      // device never reports hover, so a press that changed the fill alone
      // would paint the accent surface under the default foreground.
      .onPressed(
        _content(
          ButtonStyler()
              .animate(AnimationConfig.easeOut(_pressedMotionDuration))
              .color(PlaygroundTokens.accent()),
          PlaygroundTokens.accentForeground(),
        ),
      );
}

/// Applies one content color to the label, the icons, and the spinner.
ButtonStyler _content(ButtonStyler style, Color foreground) => style
    .label(.color(foreground))
    .icon(.color(foreground))
    .spinner(.color(foreground));

/// The keyboard focus ring.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// box without taking layout space, so focusing a button never reflows the
/// row it sits in.
ButtonStyler _focusVisibleStyle() => ButtonStyler().containerEffects(
  .outline(
    .color(
      PlaygroundTokens.ring(),
    ).width(_focusRingWidth).strokeAlign(BorderSide.strokeAlignInside),
  ).outlineOffset(_focusRingOffset),
);

/// Declared last so it wins over every other state fragment.
///
/// A disabled control keeps whatever fill its variant gives it and simply
/// fades; the focus ring is cleared because a disabled button that still
/// draws a focus ring reads as actionable.
ButtonStyler _disabledStyle() => ButtonStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(_disabledOpacity));
