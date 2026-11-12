import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'button.dart';
import 'close_button.dart';

part 'toast.g.dart';

/// HeroUI toast tones: the title takes the status color, and so does the
/// leading icon, except `accent`, whose icon stays `overlay-foreground`.
enum UiToastVariant {
  /// Neutral: the `overlay-foreground` color.
  defaultToast,

  /// Informational: only the title takes the `accent` tint; the icon keeps
  /// `overlay-foreground`.
  accent,

  /// A positive outcome, in the `success` tint.
  success,

  /// Something that needs attention, in the `warning` tint.
  warning,

  /// An error or destructive outcome, in the `danger` tint.
  danger,
}

/// HeroUI recipe for [RemixToast] and, as its `style`, [RemixToastScope].
///
/// Stacking, timing, and dismissal stay with Remix. The action is HeroUI's
/// default button, as in `Toast` (`toast-default-action`): beside the message
/// above 768px and under it from 768px down. Below 640px it adds `mt-2`
/// through a second `action`.
///
/// An `action` replaces rather than merges, so a caller who styles it restates
/// `uiButtonStyle()` in their `action`, and again, with `.margin(.top(2))`,
/// in an `onNot(ContextVariant.breakpoint(Breakpoint.minWidth(
/// UiTokens.breakpointSm)), ...)` fragment; without that fragment the
/// recipe's own action wins below 640px.
@MixWidget(target: RemixToast.new)
ToastStyler uiToastStyle({
  UiToastVariant variant = .defaultToast,
  ToastStyler style = const ToastStyler.create(),
}) {
  final (title, icon) = switch (variant) {
    .defaultToast => (UiTokens.overlayForeground, UiTokens.overlayForeground),
    .accent => (UiTokens.accentSoftForeground, UiTokens.overlayForeground),
    .success => (
      UiTokens.successSoftForeground,
      UiTokens.successSoftForeground,
    ),
    .warning => (
      UiTokens.warningSoftForeground,
      UiTokens.warningSoftForeground,
    ),
    .danger => (UiTokens.dangerSoftForeground, UiTokens.dangerSoftForeground),
  };

  return ToastStyler()
      .direction(.horizontal)
      .crossAxisAlignment(.start)
      .spacing(_gap)
      .padding(.horizontal(_paddingX).vertical(_paddingY))
      .color(UiTokens.surface())
      .borderRadius(.all(UiTokens.radiusPanel()))
      .containerEffects(uiSurfaceEffects(overlay: true))
      // `.toast__indicator`: a `size-4` icon with `p-1` around it.
      .icon(
        IconStyler()
            .size(_icon)
            .color(icon())
            .wrap(.padding(EdgeInsetsGeometryMix.all(_iconPadding))),
      )
      .title(
        TextStyler(
          style: UiTokens.textSm.mix(),
        ).fontWeight(.w500).color(title()),
      )
      .description(
        TextStyler(style: UiTokens.textSm.mix()).color(UiTokens.muted()),
      )
      .action(uiButtonStyle())
      .closeButton(_closeButton)
      .onBreakpoint(
        const Breakpoint.maxWidth(UiTokens.breakpointMd),
        ToastStyler().actionPlacement(.below),
      )
      .onNot(
        ContextVariant.breakpoint(
          const Breakpoint.minWidth(UiTokens.breakpointSm),
        ),
        ToastStyler().action(uiButtonStyle().margin(.top(_actionMargin))),
      )
      .merge(style);
}

/// `.toast__close-button` on top of the close button: `size-5` with a
/// `size-3.5` icon and `bg-default` on hover; from `sm` up it gains the border
/// and the overlay fill, and its icon is `size-3`.
/// No padding: upstream's icon overflows `p-1`, which would shrink it here.
final _closeButton = uiCloseButtonStyle()
    .size(_closeSize, _closeSize)
    .padding(.all(0))
    .icon(.size(_closeIcon))
    .onHovered(.color(UiTokens.defaultColor()))
    .onBreakpoint(
      const Breakpoint.minWidth(UiTokens.breakpointSm),
      IconButtonStyler()
          .color(UiTokens.overlay())
          .border(.all(.color(UiTokens.border()).width(_closeBorder)))
          .icon(.size(_closeIconFromSm))
          .onHovered(IconButtonStyler().color(UiTokens.defaultColor())),
    );

/// `.toast` `px-4 py-3 gap-1.5`.
const _paddingX = 16.0;
const _paddingY = 12.0;
const _gap = 6.0;

/// `.toast__action`: `mt-2 sm:mt-0`. A stacked action is already `gap-1.5`
/// below the message, so the margin adds the rest of `mt-2` below `sm`.
const _actionMargin = 8 - _gap;

/// `.toast__indicator` `size-4` with `p-1`, and `.toast__close-button`
/// `size-5`.
const _icon = 16.0;
const _iconPadding = 4.0;
const _closeSize = 20.0;

/// `size-3.5`, `sm:size-3`, and `sm:border`.
const _closeIcon = 14.0;
const _closeIconFromSm = 12.0;
const _closeBorder = 1.0;
