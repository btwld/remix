import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'dropdown.g.dart';

/// Deui menu-item tones.
enum DeuiDropdownItemVariant {
  /// The ordinary item.
  defaultItem,

  /// `menu-item--danger`: a destructive action, in the `danger` color.
  danger,
}

/// Deui recipe for [RemixMenu]: the dropdown trigger and its popover menu.
///
/// The panel opens in 360 ms and closes in 260 ms through Remix's panel
/// transition: [deuiDropdownTransition] fades it, scales it from .96 and wipes
/// it open from the corner at the trigger. Replace it with
/// `MenuStyler.panelTransition`.
///
/// Style a single row with [deuiDropdownItemStyle], for example a danger item
/// in `RemixMenuItem.style`.
@MixWidget(target: RemixMenu.new)
MenuStyler deuiDropdownStyle({MenuStyler style = const MenuStyler.create()}) =>
    MenuStyler()
        .trigger(
          MenuTriggerStyler().onFocusVisible(
            .containerEffects(deuiFocusRing()),
          ),
        )
        .overlay(_popover)
        .panelTransition(
          const RemixPanelTransition(
            duration: _enter,
            reverseDuration: _exit,
            builder: deuiDropdownTransition,
          ),
        )
        .item(deuiDropdownItemStyle())
        .divider(
          DividerStyler()
              .height(1)
              .color(DeuiTokens.border())
              .margin(.symmetric(vertical: _dividerGap)),
        )
        .merge(style);

/// One row of the menu: 40px, 8px corners, muted 16px icons.
MenuItemStyler deuiDropdownItemStyle({
  DeuiDropdownItemVariant variant = .defaultItem,
}) {
  final danger = variant == .danger;
  final label = danger ? DeuiTokens.danger : DeuiTokens.foreground;

  return MenuItemStyler()
      .direction(.horizontal)
      .crossAxisAlignment(.center)
      .minHeight(_minHeight)
      .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
      .borderRadius(.circular(_itemRadius))
      .label(.style(DeuiTokens.textSm.mix()).color(label()))
      .indicator(
        .size(
          _indicator,
        ).color(danger ? DeuiTokens.danger() : DeuiTokens.muted()),
      )
      .leadingIcon(
        .size(_icon)
            .color(danger ? DeuiTokens.danger() : DeuiTokens.muted())
            .wrap(.padding(.only(right: _iconGap))),
      )
      .trailingIcon(.size(_icon).color(DeuiTokens.muted()))
      .trailingText(.style(DeuiTokens.textXs.mix()).color(DeuiTokens.muted()))
      .onHovered(.color(deuiRowHover()))
      .onFocusVisible(.color(deuiRowHover()))
      .onDisabled(MenuItemStyler().wrap(.opacity(DeuiTokens.disabledOpacity)));
}

/// Opens the panel as a clip wipe from the corner at the trigger, with the
/// panel fading and growing from .96 under it; closes by reversing both over
/// the shorter exit.
///
/// [info]'s animation is linear. The fade follows `Cubic(.2, .8, .2, 1)` and
/// the wipe `Cubic(.16, 1, .3, 1)`, which finishes at 320 ms of the 360 ms
/// open. Reduced motion never reaches this builder: Remix opens and closes the
/// panel at once.
Widget deuiDropdownTransition(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final placement = OverlayPlacement.maybeOf(context);
  final direction = Directionality.of(context);
  final x = switch (placement?.alignment ?? OverlayAlignment.start) {
    OverlayAlignment.start => direction == TextDirection.ltr ? -1.0 : 1.0,
    OverlayAlignment.end => direction == TextDirection.ltr ? 1.0 : -1.0,
    OverlayAlignment.center => 0.0,
  };
  final opensAbove = placement?.side == OverlaySide.top;
  final origin = Alignment(x, opensAbove ? 1 : -1);

  return AnimatedBuilder(
    animation: info.animation,
    child: panel,
    builder: (context, child) {
      final value = info.animation.value;
      final closing = info.animation.status == AnimationStatus.reverse;
      final elapsed = 1 - value;
      final fade = closing
          ? 1 - _panelEase.transform(elapsed)
          : _panelEase.transform(value);
      final clip = closing
          ? 1 - _clipEase.transform(elapsed)
          : _clipEase.transform((value * _enterMs / _clipMs).clamp(0, 1));

      return Opacity(
        opacity: fade,
        alwaysIncludeSemantics: true,
        child: Transform.scale(
          alignment: origin,
          scale: _scaleFrom + (1 - _scaleFrom) * fade,
          child: ClipPath(clipper: _RevealClipper(origin, clip), child: child),
        ),
      );
    },
  );
}

class _RevealClipper extends CustomClipper<Path> {
  const _RevealClipper(this.origin, this.progress);

  final Alignment origin;
  final double progress;

  @override
  Path getClip(Size size) {
    final insetX = _wipeInset * size.width * (1 - progress);
    final insetY = _wipeInset * size.height * (1 - progress);
    final rect = Rect.fromLTRB(
      (origin.x + 1) / 2 * insetX,
      (origin.y + 1) / 2 * insetY,
      size.width - (1 - origin.x) / 2 * insetX,
      size.height - (1 - origin.y) / 2 * insetY,
    );
    return Path()..addRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(_clipRadius)),
    );
  }

  @override
  bool shouldReclip(_RevealClipper oldClipper) =>
      oldClipper.origin != origin || oldClipper.progress != progress;
}

final _popover = FlexBoxStyler()
    .padding(.symmetric(vertical: _menuPadding, horizontal: _menuPadding))
    .color(DeuiTokens.overlay())
    .borderRadius(.all(DeuiTokens.radiusLg()))
    .border(deuiHairline())
    .clipBehavior(.antiAlias);

const _enter = Duration(milliseconds: 360);
const _exit = Duration(milliseconds: 260);
const _enterMs = 360;
const _clipMs = 320;
const _panelEase = Cubic(.2, .8, .2, 1);
const _clipEase = Cubic(.16, 1, .3, 1);
const _scaleFrom = .96;
const _wipeInset = .92;
const _clipRadius = 12.0;
const _minHeight = 40.0;
const _paddingX = 10.0;
const _paddingY = 8.0;
const _itemRadius = 8.0;
const _indicator = 14.0;
const _icon = 16.0;
const _iconGap = 10.0;
const _menuPadding = 6.0;
const _dividerGap = 4.0;
