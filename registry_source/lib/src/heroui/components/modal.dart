import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'modal.g.dart';

/// HeroUI modal widths.
enum HeroUiModalSize {
  /// `max-w-xs`: 320px.
  xs,

  /// `max-w-sm`: 384px.
  sm,

  /// `max-w-md`: 448px. The default.
  md,

  /// `max-w-lg`: 512px.
  lg,

  /// Fills the viewport inside the container's inset, keeping the rounded card.
  cover,

  /// Fills the viewport edge to edge, without inset or rounded corners.
  full,
}

/// Where the dialog sits in the viewport.
enum HeroUiModalPlacement {
  /// A bottom sheet below the `sm` breakpoint, centered from it up.
  auto,

  /// Centered.
  center,

  /// Against the top edge.
  top,

  /// Against the bottom edge.
  bottom,
}

/// HeroUI recipe for [RemixDialog], the modal surface.
///
/// Open it with `showRemixDialog`, or `showRemixAlertDialog` for an alert; pass
/// `HeroUiTokens.backdrop` (resolved in the caller's context) as `barrierColor`
/// for HeroUI's backdrop.
@MixWidget(target: RemixDialog.new)
DialogStyler heroUiModalStyle({
  HeroUiModalSize size = .md,
  HeroUiModalPlacement placement = .auto,
  DialogStyler style = const DialogStyler.create(),
}) {
  final full = size == .full;
  final alignment = switch (placement) {
    .auto || .bottom => Alignment.bottomCenter,
    .center => Alignment.center,
    .top => Alignment.topCenter,
  };

  return DialogStyler()
      .wrap(_frame(full ? 0 : _inset, alignment))
      .onBreakpoint(
        const Breakpoint.minWidth(HeroUiTokens.breakpointSm),
        DialogStyler().wrap(
          _frame(
            full ? 0 : _insetSm,
            placement == .auto ? Alignment.center : alignment,
          ),
        ),
      )
      .padding(.all(_padding))
      .color(HeroUiTokens.overlay())
      .title(
        .style(
          HeroUiTokens.textBase.mix(),
        ).fontWeight(.w500).color(HeroUiTokens.foreground()),
      )
      .description(
        TextStyler(style: HeroUiTokens.textSm.mix())
            .color(HeroUiTokens.muted())
            .wrap(
              .padding(
                EdgeInsetsGeometryMix.only(
                  top: _bodyGap + _bodyInset,
                  bottom: _bodyInset,
                ),
              ),
            ),
      )
      .actions(
        FlexBoxStyler()
            .mainAxisAlignment(.end)
            .crossAxisAlignment(.center)
            .spacing(_actionsGap)
            .margin(.top(_footerGap)),
      )
      .merge(switch (size) {
        .xs => DialogStyler().maxWidth(_maxWidthXs),
        .sm => DialogStyler().maxWidth(_maxWidthSm),
        .md => DialogStyler().maxWidth(_maxWidthMd),
        .lg => DialogStyler().maxWidth(_maxWidthLg),
        .cover || .full => DialogStyler().width(.infinity).height(.infinity),
      })
      .merge(
        full
            ? null
            : DialogStyler()
                  .borderRadius(.all(HeroUiTokens.radiusPanel()))
                  .containerEffects(heroUiSurfaceEffects(overlay: true)),
      )
      .merge(style);
}

/// The positioning wrapper `.modal__container`: inset by its padding, then
/// aligned.
WidgetModifierConfig _frame(double inset, Alignment alignment) =>
    WidgetModifierConfig.padding(EdgeInsetsGeometryMix.all(inset))
        .align(alignment: alignment)
        .orderOfModifiers([PaddingModifier, AlignModifier]);

/// `.modal__container` `p-4`, then `sm:p-10`.
const _inset = 16.0;
const _insetSm = 40.0;

/// `.modal__dialog` `p-6`; `.modal__header + .modal__body` `mt-2`, and the
/// body's own `p-[3px]` (`modal-md-auto-body`); `.modal__body + .modal__footer`
/// `mt-5`; `.modal__footer` `gap-2`.
const _padding = 24.0;
const _bodyGap = 8.0;
const _bodyInset = 3.0;
const _footerGap = 20.0;
const _actionsGap = 8.0;

/// `max-w-xs`, `max-w-sm`, `max-w-md`, `max-w-lg`.
const _maxWidthXs = 320.0;
const _maxWidthSm = 384.0;
const _maxWidthMd = 448.0;
const _maxWidthLg = 512.0;
