import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'spinner.dart';

part 'button.g.dart';

/// The emphasis levels of a Deui button.
enum DeuiButtonVariant {
  /// The blue `primary` fill: the main action.
  primary,

  /// The quiet `surfaceSecondary` fill inside a hairline border.
  secondary,

  /// No fill and muted text until the pointer arrives.
  ghost,

  /// No fill, inside a hairline border.
  outline,

  /// A 12% `danger` tint under danger text, for a destructive action.
  danger,
}

/// Deui button sizes: 32, 36 and 48 px tall.
enum DeuiButtonSize {
  /// 32px tall, 12px label.
  small,

  /// 36px tall, 14px label. The default.
  medium,

  /// 48px tall, 16px label.
  large,
}

/// Deui recipe for [RemixButton]: a pill with a spring that grows a little on
/// hover and presses in on tap.
///
/// The values come from two tables below: [_metrics] has a row per size and
/// [_palette] a row per variant. Deui's focus ring is a 2px primary ring, 2px
/// off the pill. A loading button keeps its label's colour on the spinner.
/// [fullWidth] stretches it. [style] merges last.
@MixWidget(target: RemixButton.new)
ButtonStyler deuiButtonStyle({
  DeuiButtonVariant variant = .primary,
  DeuiButtonSize size = .medium,
  bool fullWidth = false,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant);

  return ButtonStyler()
      .animate(_spring)
      .minHeight(metrics.height)
      .padding(.horizontal(metrics.paddingX))
      .mainAxisAlignment(.center)
      .spacing(metrics.gap)
      .borderRadius(.circular(_pill))
      .color(palette.fill)
      .label(
        .style(metrics.text.mix())
            .fontWeight(.w500)
            .color(palette.foreground)
            .softWrap(false)
            .maxLines(1)
            .overflow(TextOverflow.ellipsis),
      )
      .icon(.size(_icon).color(palette.foreground))
      .spinner(deuiInlineSpinnerStyle(palette.foreground))
      .onHovered(
        ButtonStyler()
            .color(palette.hover)
            .label(.color(palette.hoverForeground))
            .scale(_hoverScale),
      )
      .onPressed(ButtonStyler().scale(_pressedScale))
      .onFocusVisible(.containerEffects(deuiFocusRing()))
      .onDisabled(ButtonStyler().wrap(.opacity(DeuiTokens.disabledOpacity)))
      .merge(
        palette.bordered
            ? ButtonStyler().border(.color(DeuiTokens.border()).width(1))
            : null,
      )
      .merge(fullWidth ? ButtonStyler().width(double.infinity) : null)
      .merge(style);
}

/// Deui's icon-only button, as a recipe for [RemixIconButton].
///
/// The same variants and states as [deuiButtonStyle], square at the button's
/// height.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler deuiIconButtonStyle({
  DeuiButtonVariant variant = .ghost,
  DeuiButtonSize size = .medium,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant);

  return IconButtonStyler()
      .animate(_spring)
      .size(metrics.height, metrics.height)
      .alignment(.center)
      .borderRadius(.circular(_pill))
      .color(palette.fill)
      .icon(.size(_icon).color(palette.foreground))
      .spinner(deuiInlineSpinnerStyle(palette.foreground))
      .onHovered(
        IconButtonStyler()
            .color(palette.hover)
            .icon(.color(palette.hoverForeground))
            .scale(_hoverScale),
      )
      .onPressed(IconButtonStyler().scale(_pressedScale))
      .onFocusVisible(.containerEffects(deuiFocusRing()))
      .onDisabled(IconButtonStyler().wrap(.opacity(DeuiTokens.disabledOpacity)))
      .merge(
        palette.bordered
            ? IconButtonStyler().border(.color(DeuiTokens.border()).width(1))
            : null,
      )
      .merge(style);
}

typedef _Metrics = ({
  double height,
  double paddingX,
  double gap,
  TextStyleToken text,
});

/// Deui's `small`, `medium` and `large` rows: `(32, 12, 6)`, `(36, 20, 8)`,
/// `(48, 24, 8)` for height, horizontal padding and icon gap.
_Metrics _metrics(DeuiButtonSize size) => switch (size) {
  .small => (height: 32, paddingX: 12, gap: 6, text: DeuiTokens.textXs),
  .medium => (height: 36, paddingX: 20, gap: 8, text: DeuiTokens.textSm),
  .large => (height: 48, paddingX: 24, gap: 8, text: DeuiTokens.textBase),
};

typedef _Palette = ({
  Color fill,
  Color hover,
  Color foreground,
  Color hoverForeground,
  bool bordered,
});

_Palette _palette(DeuiButtonVariant variant) => switch (variant) {
  .primary => (
    fill: DeuiTokens.accent(),
    hover: DeuiTokens.accentHover(),
    foreground: DeuiTokens.accentForeground(),
    hoverForeground: DeuiTokens.accentForeground(),
    bordered: false,
  ),
  .secondary => (
    fill: DeuiTokens.surfaceSecondary(),
    hover: DeuiTokens.surfaceSecondary(),
    foreground: DeuiTokens.foreground(),
    hoverForeground: DeuiTokens.foreground(),
    bordered: true,
  ),
  .ghost => (
    fill: DeuiTokens.transparent,
    hover: _quietHover(),
    foreground: DeuiTokens.muted(),
    hoverForeground: DeuiTokens.foreground(),
    bordered: false,
  ),
  .outline => (
    fill: DeuiTokens.transparent,
    hover: _quietHover(),
    foreground: DeuiTokens.foreground(),
    hoverForeground: DeuiTokens.foreground(),
    bordered: true,
  ),
  .danger => (
    fill: DeuiTokens.dangerSoft(),
    hover: DeuiTokens.dangerSoft(),
    foreground: DeuiTokens.danger(),
    hoverForeground: DeuiTokens.danger(),
    bordered: false,
  ),
};

/// `surfaceSecondary` at 60%: what ghost and outline buttons show on hover.
final _quietHover = deuiAlpha(DeuiTokens.surfaceSecondary, .6);

/// A pill: any radius past half the height.
const _pill = 999.0;
const _icon = 16.0;
const _hoverScale = 1.02;
const _pressedScale = .93;

/// Deui's spring: mass .6, stiffness 500, damping 30.
final _spring = AnimationConfig.springDescription(
  mass: .6,
  stiffness: 500,
  damping: 30,
);
