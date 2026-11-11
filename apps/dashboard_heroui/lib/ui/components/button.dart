import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'spinner.dart';

part 'button.g.dart';

/// HeroUI button variants: solid (`primary`, `danger`), tinted (`secondary`,
/// `tertiary`, `dangerSoft`), and bare (`outline`, `ghost`).
enum UiButtonVariant {
  primary,
  secondary,
  tertiary,
  outline,
  ghost,
  danger,
  dangerSoft,
}

/// HeroUI button sizes. Heights are mobile-first and shrink from 768px up.
///
/// They are `onBreakpoint` fragments, which beat the base style whatever the
/// merge order: a caller's `style: ButtonStyler().height(50)` is ignored from
/// 768px up. Override with
/// `onBreakpoint(Breakpoint.minWidth(UiTokens.breakpointMd), ...)`.
enum UiButtonSize { sm, md, lg }

/// HeroUI recipe for [RemixButton].
///
/// HeroUI's pending state is Remix's `loading`: the button dims like a
/// disabled one, as upstream does, and shows Remix's spinner in place of its
/// content. [fullWidth] is HeroUI's `w-full`.
@MixWidget(target: RemixButton.new)
ButtonStyler uiButtonStyle({
  UiButtonVariant variant = .primary,
  UiButtonSize size = .md,
  bool fullWidth = false,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant);

  var result = ButtonStyler()
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
        ButtonStyler().icon(.size(_iconFromSm)),
      )
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointMd),
        ButtonStyler().height(metrics.height.desktop),
      )
      // `:active` is declared before `:hover`, so a pointer press shows the
      // hover fill while the scale still applies.
      .onPressed(
        ButtonStyler()
            .color(palette.pressed)
            .scale(metrics.pressedScale)
            .animate(_pressMotion),
      )
      .onHovered(ButtonStyler().color(palette.hover))
      .onFocusVisible(.containerEffects(uiFocusRing()))
      .animate(UiTokens.fillMotion);

  if (palette.bordered) {
    result = result.border(.color(UiTokens.border()).width(_borderWidth));
  }
  if (fullWidth) result = result.width(double.infinity);

  return result
      .onDisabled(ButtonStyler().wrap(.opacity(UiTokens.disabledOpacity)))
      .merge(style);
}

/// HeroUI's icon-only button, as a recipe for [RemixIconButton].
///
/// Same variants and sizes as [uiButtonStyle]; the control is square at the
/// button's height.
@MixWidget(target: RemixIconButton.new)
IconButtonStyler uiIconButtonStyle({
  UiButtonVariant variant = .primary,
  UiButtonSize size = .md,
  IconButtonStyler style = const IconButtonStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant);

  var result = IconButtonStyler()
      .size(metrics.height.mobile, metrics.height.mobile)
      .alignment(.center)
      .borderRadius(.all(UiTokens.radius3xl()))
      .color(palette.fill)
      .icon(.size(metrics.icon).color(palette.foreground))
      .spinner(uiInlineSpinnerStyle(palette.foreground))
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointSm),
        IconButtonStyler().icon(.size(_iconFromSm)),
      )
      .onBreakpoint(
        const Breakpoint.minWidth(UiTokens.breakpointMd),
        IconButtonStyler().size(metrics.height.desktop, metrics.height.desktop),
      )
      .onPressed(
        IconButtonStyler()
            .color(palette.pressed)
            .scale(metrics.pressedScale)
            .animate(_pressMotion),
      )
      .onHovered(IconButtonStyler().color(palette.hover))
      .onFocusVisible(.containerEffects(uiFocusRing()))
      .animate(UiTokens.fillMotion);

  if (palette.bordered) {
    result = result.border(.color(UiTokens.border()).width(_borderWidth));
  }

  return result
      .onDisabled(IconButtonStyler().wrap(.opacity(UiTokens.disabledOpacity)))
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

typedef _Palette = ({
  Color fill,
  Color hover,
  Color pressed,
  Color foreground,
  bool bordered,
});

/// The `--button-bg`, `-hover`, `-pressed`, and `-fg` variables per variant.
_Palette _palette(UiButtonVariant variant) => switch (variant) {
  .primary => (
    fill: UiTokens.accent(),
    hover: UiTokens.accentHover(),
    pressed: UiTokens.accentHover(),
    foreground: UiTokens.accentForeground(),
    bordered: false,
  ),
  .secondary => (
    fill: UiTokens.defaultColor(),
    hover: UiTokens.defaultHover(),
    pressed: UiTokens.defaultHover(),
    foreground: UiTokens.accentSoftForeground(),
    bordered: false,
  ),
  // `--button-fg` is unset, so the label keeps the inherited text colour.
  .tertiary => (
    fill: UiTokens.defaultColor(),
    hover: UiTokens.defaultHover(),
    pressed: UiTokens.defaultHover(),
    foreground: UiTokens.foreground(),
    bordered: false,
  ),
  .outline => (
    fill: UiTokens.transparent,
    hover: _outlineHover(),
    pressed: UiTokens.defaultColor(),
    foreground: UiTokens.defaultForeground(),
    bordered: true,
  ),
  .ghost => (
    fill: UiTokens.transparent,
    hover: UiTokens.defaultColor(),
    pressed: UiTokens.defaultColor(),
    foreground: UiTokens.defaultForeground(),
    bordered: false,
  ),
  .danger => (
    fill: UiTokens.danger(),
    hover: UiTokens.dangerHover(),
    pressed: UiTokens.dangerHover(),
    foreground: UiTokens.dangerForeground(),
    bordered: false,
  ),
  .dangerSoft => (
    fill: UiTokens.dangerSoft(),
    hover: UiTokens.dangerSoftHover(),
    pressed: UiTokens.dangerSoftHover(),
    foreground: UiTokens.dangerSoftForeground(),
    bordered: false,
  ),
};

/// `color-mix(in srgb, var(--default) 60%, transparent)`.
final _outlineHover = uiAlpha(UiTokens.defaultColor, .6);

/// `border border-border` on the outline variant.
const _borderWidth = 1.0;

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
