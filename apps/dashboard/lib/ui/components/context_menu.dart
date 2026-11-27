import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'context_menu.g.dart';

const _rowHeight = 34.0;
const _rowInset = 11.0;
const _iconSize = 15.0;
// The icon sits in a 16px box followed by a 9px gap; a 15px glyph with a
// 10px gap puts the label at the same x.
const _iconGap = 10.0;
// 5px inside the 1px edge, which is painted in the foreground.
const _panelPadding = 6.0;
const _dividerGap = 5.0;
const _panelMinWidth = 208.0;
const _panelMaxHeight = 300.0;
const _viewportInset = 8.0;
const _disabledOpacity = .45;

const _enterScaleFrom = .96;
const _exitScaleTo = .98;
const _scaleDuration = Duration(milliseconds: 200);
const _rowDuration = Duration(milliseconds: 200);
const _rowRise = 2.0;
const _rowStaggerLimit = 4;
const _rowFill = UiMotion.instant;

/// The open transition runs until the last staggered row settles.
final _openDuration = UiMotion.staggerItem * _rowStaggerLimit + _rowDuration;

/// The Fortal context menu recipe: the floating panel opened at the pointer,
/// its rows, and their motion.
///
/// The panel grows from the point it opened at and fades in; rows rise into
/// place one after another. Mark a destructive row with
/// [uiContextMenuItemStyle] and `destructive: true`.
///
/// [highContrast] draws the focus ring on the keyboard-focused row, on top of
/// the highlight fill.
@MixWidget(target: RemixContextMenu.new)
MenuStyler uiContextMenuStyle({
  bool highContrast = false,
  MenuStyler style = const MenuStyler.create(),
}) {
  final radius = UiTokens.radius6();

  return MenuStyler()
      .positioning(
        const OverlayPositionConfig(
          collisionPadding: EdgeInsets.all(_viewportInset),
        ),
      )
      .overlay(
        FlexBoxStyler()
            .minWidth(_panelMinWidth)
            .maxHeight(_panelMaxHeight)
            .padding(.all(_panelPadding))
            .borderRadius(.all(radius))
            // The panel edge, drawn in the foreground to take no layout space.
            .foregroundDecoration(
              BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(
                    color: UiTokens.gray7(),
                    width: UiTokens.borderWidth1(),
                  ),
                ),
                borderRadius: BorderRadiusMix.all(radius),
              ),
            )
            .color(UiTokens.colorPanelSolid())
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()),
            )
            .clipBehavior(Clip.antiAlias),
      )
      .item(uiContextMenuItemStyle(highContrast: highContrast))
      .divider(
        DividerStyler()
            .height(UiTokens.borderWidth1())
            .margin(.vertical(_dividerGap))
            .color(UiTokens.gray7()),
      )
      .panelTransition(
        RemixPanelTransition(
          duration: _openDuration,
          reverseDuration: UiMotion.instant,
          builder: _panelMotion,
        ),
      )
      .itemTransition(const RemixMenuItemTransition(builder: _rowMotion))
      .merge(style);
}

/// The Fortal context menu row recipe.
///
/// It is the style [uiContextMenuStyle] gives every row. Pass it as a
/// row's `style` with [destructive] set to draw that row in the danger color.
MenuItemStyler uiContextMenuItemStyle({
  bool destructive = false,
  bool highContrast = false,
}) {
  final text = destructive ? UiTokens.error11() : UiTokens.gray12();
  final icon = destructive ? UiTokens.error11() : UiTokens.gray11();
  final radius = UiTokens.radius4();
  final highlighted = MenuItemStyler().color(
    destructive ? UiTokens.error3() : UiTokens.gray3(),
  );
  final pressed = MenuItemStyler().container(
    FlexBoxStyler().foregroundDecoration(
      BoxDecorationMix(
        color: UiTokens.grayA3(),
        borderRadius: BorderRadiusMix.all(radius),
      ),
    ),
  );

  return MenuItemStyler()
      .direction(.horizontal)
      .spacing(_iconGap)
      .height(_rowHeight)
      .padding(.horizontal(_rowInset))
      .borderRadius(.all(radius))
      .color(const Color(0x00000000))
      .label(.style(UiTokens.text2.mix()).color(text))
      .leadingIcon(.color(icon).size(_iconSize))
      .trailingIcon(.color(icon).size(_iconSize))
      .trailingText(.color(UiTokens.gray11()))
      .indicator(.color(icon).size(_iconSize))
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(pressed)
      .onFocusVisible(
        MenuItemStyler().container(
          highContrast
              ? FlexBoxStyler().uiFocusRing(radius: radius)
              : FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)),
        ),
      )
      .onDisabled(
        MenuItemStyler()
            .color(const Color(0x00000000))
            .wrap(.opacity(_disabledOpacity)),
      )
      .animate(
        AnimationConfig.curve(duration: _rowFill, curve: UiMotion.easeStandard),
      );
}

double _progress(Duration elapsed, Duration span) =>
    (elapsed.inMicroseconds / span.inMicroseconds).clamp(0.0, 1.0);

/// A critically damped spring that settles in [_scaleDuration], sampled at
/// [elapsed].
double _snappy(Duration elapsed) {
  final omega = 2 * math.pi / (_scaleDuration.inMicroseconds / 1e6);
  final t = elapsed.inMicroseconds / 1e6;
  return 1 - (1 + omega * t) * math.exp(-omega * t);
}

Widget _panelMotion(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final placement = OverlayPlacement.maybeOf(context);
  final point = info.openPosition;
  final origin = point == null || placement == null
      ? Offset.zero
      : point - placement.offset;

  return AnimatedBuilder(
    animation: info.animation,
    child: panel,
    builder: (context, child) {
      final animation = info.animation;
      final double opacity;
      final double scale;
      if (animation.status == AnimationStatus.reverse) {
        final t = UiMotion.easeStandard.transform(1 - animation.value);
        opacity = 1 - t;
        scale = 1 - (1 - _exitScaleTo) * t;
      } else {
        final elapsed = _openDuration * animation.value;
        opacity = UiMotion.easeEnter.transform(
          _progress(elapsed, UiMotion.fast),
        );
        scale = animation.value == 1
            ? 1
            : _enterScaleFrom + (1 - _enterScaleFrom) * _snappy(elapsed);
      }
      return Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          alignment: Alignment.topLeft,
          origin: origin,
          child: child,
        ),
      );
    },
  );
}

Widget _rowMotion(
  BuildContext context,
  RemixMenuItemTransitionInfo info,
  Widget entry,
) {
  final delay = UiMotion.staggerItem * math.min(info.index, _rowStaggerLimit);

  return AnimatedBuilder(
    animation: info.animation,
    child: entry,
    builder: (context, child) {
      final animation = info.animation;
      if (animation.status == AnimationStatus.reverse || animation.value == 1) {
        return child!;
      }
      final elapsed = _openDuration * animation.value - delay;
      final t = UiMotion.easeEnter.transform(
        elapsed.isNegative ? 0 : _progress(elapsed, _rowDuration),
      );
      return Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, -_rowRise * (1 - t)),
          child: child,
        ),
      );
    },
  );
}
