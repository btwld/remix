import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'spinner.dart';

part 'button.g.dart';

/// The emphasis levels of a HeroUI button.
enum UiButtonVariant {
  /// The `accent` fill: the main action.
  primary,

  /// The neutral `default` fill under accent-tinted text.
  secondary,

  /// The neutral `default` fill under the ordinary text color.
  tertiary,

  /// No fill, inside a 1px `border` line.
  outline,

  /// No fill and no border until the pointer arrives.
  ghost,

  /// The `danger` fill, for a destructive action.
  danger,

  /// A soft `danger` tint, for a destructive action of lower emphasis.
  dangerSoft,
}

/// HeroUI button sizes. Heights are mobile-first and shrink from 768px up.
///
/// They are `onBreakpoint` fragments, which beat the base style whatever the
/// merge order: a caller's `style: ButtonStyler().height(50)` is ignored from
/// 768px up. Override with
/// `onBreakpoint(Breakpoint.minWidth(UiTokens.breakpointMd), ...)`.
enum UiButtonSize {
  /// 36px tall, 32px from 768px up.
  sm,

  /// 40px tall, 36px from 768px up. The default.
  md,

  /// 44px tall, 40px from 768px up.
  lg,
}

/// HeroUI recipe for [RemixButton].
///
/// One chain sets every state. The values come from two tables below:
/// [_metrics] has a row per size and [_palette] a row per variant, because
/// every variant sets the same four colors and nothing else.
///
/// HeroUI's pending state is Remix's `loading`: the button dims like a
/// disabled one, as upstream does, and shows Remix's spinner in place of its
/// content. [fullWidth] is HeroUI's `w-full`. [style] merges last.
@MixWidget(target: RemixButton.new)
ButtonStyler uiButtonStyle({
  UiButtonVariant variant = .primary,
  UiButtonSize size = .md,
  bool fullWidth = false,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant);

  return ButtonStyler()
      .animate(UiTokens.fillMotion)
      .height(metrics.height.mobile)
      .padding(.horizontal(metrics.paddingX))
      .mainAxisAlignment(.center)
      .spacing(_iconSpacing)
      .borderRadius(.all(UiTokens.radius3xl()))
      .color(palette.fill)
      .label(
        .style(metrics.text.mix())
            .fontWeight(.w500)
            .color(palette.foreground)
            .softWrap(false)
            .maxLines(1)
            .overflow(TextOverflow.ellipsis),
      )
      .icon(.size(metrics.icon).color(palette.foreground))
      .spinner(uiInlineSpinnerStyle(palette.foreground))
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointSm),
        .icon(.size(_iconFromSm)),
      )
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointMd),
        .height(metrics.height.desktop),
      )
      // Press is declared before hover, as upstream declares `:active` before
      // `:hover`: a pointer press shows the hover fill while the scale applies.
      .onPressed(
        ButtonStyler()
            .color(palette.pressed)
            .scale(metrics.pressedScale)
            .animate(_pressMotion),
      )
      .onHovered(.color(palette.hover))
      .onFocusVisible(.containerEffects(uiFocusRing()))
      .onDisabled(ButtonStyler().wrap(.opacity(UiTokens.disabledOpacity)))
      .merge(
        variant == .outline ? ButtonStyler().border(_outlineBorder()) : null,
      )
      .merge(fullWidth ? ButtonStyler().width(double.infinity) : null)
      .merge(style);
}

/// HeroUI's icon-only button, as a recipe for [RemixIconButton].
///
/// The same variants, sizes and states as [uiButtonStyle], from the same
/// two tables. The control is square at the button's height.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler uiIconButtonStyle({
  UiButtonVariant variant = .primary,
  UiButtonSize size = .md,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant);

  return IconButtonStyler()
      .animate(UiTokens.fillMotion)
      .size(metrics.height.mobile, metrics.height.mobile)
      .alignment(.center)
      .borderRadius(.all(UiTokens.radius3xl()))
      .color(palette.fill)
      .icon(.size(metrics.icon).color(palette.foreground))
      .spinner(uiInlineSpinnerStyle(palette.foreground))
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointSm),
        .icon(.size(_iconFromSm)),
      )
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointMd),
        .size(metrics.height.desktop, metrics.height.desktop),
      )
      // Press is declared before hover, as upstream declares `:active` before
      // `:hover`: a pointer press shows the hover fill while the scale applies.
      .onPressed(
        IconButtonStyler()
            .color(palette.pressed)
            .scale(metrics.pressedScale)
            .animate(_pressMotion),
      )
      .onHovered(.color(palette.hover))
      .onFocusVisible(.containerEffects(uiFocusRing()))
      .onDisabled(IconButtonStyler().wrap(.opacity(UiTokens.disabledOpacity)))
      .merge(
        variant == .outline
            ? IconButtonStyler().border(_outlineBorder())
            : null,
      )
      .merge(style);
}

typedef _Metrics = ({
  UiResponsive height,
  double paddingX,
  TextStyleToken text,
  double icon,
  double pressedScale,
});

/// `.button` (`h-10 md:h-9 px-4 text-sm`) and the `--sm` / `--lg` overrides;
/// the pressed scale is each size's `:active` transform.
_Metrics _metrics(UiButtonSize size) => switch (size) {
  .sm => (
    height: (mobile: 36, desktop: 32),
    paddingX: 12,
    text: UiTokens.textSm,
    icon: _iconFromSm,
    pressedScale: .98,
  ),
  .md => (
    height: (mobile: 40, desktop: 36),
    paddingX: 16,
    text: UiTokens.textSm,
    icon: _iconUpToSm,
    pressedScale: .97,
  ),
  .lg => (
    height: (mobile: 44, desktop: 40),
    paddingX: 16,
    text: UiTokens.textBase,
    icon: _iconUpToSm,
    pressedScale: .96,
  ),
};

typedef _Palette = ({Color fill, Color hover, Color pressed, Color foreground});

/// The `--button-bg`, `-hover`, `-pressed`, and `-fg` variables per variant.
_Palette _palette(UiButtonVariant variant) => switch (variant) {
  .primary => (
    fill: UiTokens.accent(),
    hover: UiTokens.accentHover(),
    pressed: UiTokens.accentHover(),
    foreground: UiTokens.accentForeground(),
  ),
  .secondary => (
    fill: UiTokens.defaultColor(),
    hover: UiTokens.defaultHover(),
    pressed: UiTokens.defaultHover(),
    foreground: UiTokens.accentSoftForeground(),
  ),
  // `--button-fg` is unset, so the label keeps the inherited text colour.
  .tertiary => (
    fill: UiTokens.defaultColor(),
    hover: UiTokens.defaultHover(),
    pressed: UiTokens.defaultHover(),
    foreground: UiTokens.foreground(),
  ),
  .outline => (
    fill: UiTokens.transparent,
    hover: _outlineHover(),
    pressed: UiTokens.defaultColor(),
    foreground: UiTokens.defaultForeground(),
  ),
  .ghost => (
    fill: UiTokens.transparent,
    hover: UiTokens.defaultColor(),
    pressed: UiTokens.defaultColor(),
    foreground: UiTokens.defaultForeground(),
  ),
  .danger => (
    fill: UiTokens.danger(),
    hover: UiTokens.dangerHover(),
    pressed: UiTokens.dangerHover(),
    foreground: UiTokens.dangerForeground(),
  ),
  .dangerSoft => (
    fill: UiTokens.dangerSoft(),
    hover: UiTokens.dangerSoftHover(),
    pressed: UiTokens.dangerSoftHover(),
    foreground: UiTokens.dangerSoftForeground(),
  ),
};

/// `color-mix(in srgb, var(--default) 60%, transparent)`.
final _outlineHover = uiAlpha(UiTokens.defaultColor, .6);

/// `border border-border` on the outline variant.
BoxBorderMix _outlineBorder() => .color(UiTokens.border()).width(1);

/// `svg`: `size-5 sm:size-4` (`size-4` always on `--sm`).
const _iconUpToSm = 20.0;
const _iconFromSm = 16.0;

/// `gap-2` less the icon's `-mx-0.5` on both sides.
const _iconSpacing = 8.0 - 2 * 2;

/// `transform 250ms var(--ease-smooth)`, applied while pressed.
const _pressMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 250),
  curve: UiTokens.easeSmooth,
);
