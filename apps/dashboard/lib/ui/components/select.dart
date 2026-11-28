import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';

part 'select.g.dart';

/// The sizes a select comes in. Pixel values are at 100% theme scaling.
///
/// The trigger text is 13px at every size.
enum UiSelectSize {
  /// A 32px trigger.
  size1,

  /// A 40px trigger. The default.
  size2,

  /// A 44px trigger.
  size3,
}

/// The looks a select's trigger comes in.
enum UiSelectVariant {
  /// The surface fill inside a quiet 1px frame that strengthens, over the
  /// muted fill, while hovered, pressed or open.
  surface,

  /// The muted fill inside the strong frame.
  soft,

  /// No fill until hovered or open. It sits in a negative margin, so its text
  /// lines up with the text around it.
  ghost,
}

/// The Fortal Select recipe: the trigger, the floating panel and its items.
///
/// The trigger answers hover, press and the open panel with the muted fill
/// and the strong frame, and turns its chevron half a turn while open. A new
/// value rises into place (an earlier one drops) while the old one leaves.
/// The panel grows in from the trigger edge and leaves faster than it came.
/// Items take the muted fill under the pointer or the keyboard.
///
/// The panel is at least as wide as its trigger. A [style] that gives the
/// content a `maxWidth` below the trigger's width must also set `minWidth`,
/// which replaces the minimum, because a minimum above a maximum is invalid.
///
/// [highContrast] gives the surface trigger the strong frame at rest and
/// moves the highlighted item of the surface and ghost variants to accent
/// step 12 under step 1 text. It, or the theme's high contrast switch, lifts
/// the placeholder and chevron from gray 10 to gray 11 so they read at 4.5:1.
@MixWidget(target: RemixSelect.new)
SelectStyler uiSelectStyle({
  UiSelectVariant variant = .surface,
  UiSelectSize size = .size2,
  bool highContrast = false,
  SelectStyler style = const SelectStyler.create(),
}) => SelectStyler()
    .trigger(_trigger(variant, size, highContrast: highContrast))
    .content(_content())
    .item(_item(variant, size, highContrast: highContrast))
    .panelTransition(
      const RemixPanelTransition(
        duration: UiMotion.standard,
        reverseDuration: UiMotion.instant,
        reducedMotionDuration: UiMotion.instant,
        builder: _panelMotion,
      ),
    )
    .merge(style);

/// The Fortal select item recipe, for styling one item on its own.
///
/// It is the item style [uiSelectStyle] gives every item, so a call site
/// can match a select's items outside the select.
SelectMenuItemStyler uiSelectMenuItemStyle({
  UiSelectVariant variant = .surface,
  UiSelectSize size = .size2,
  bool highContrast = false,
}) => _item(variant, size, highContrast: highContrast);

/// The trigger: its shape and text, then the variant's colors, then the open
/// state, which turns the chevron.
SelectTriggerStyler _trigger(
  UiSelectVariant variant,
  UiSelectSize size, {
  required bool highContrast,
}) => _triggerBase(highContrast: highContrast)
    .merge(_triggerScale(variant, size))
    .wrap(uiTouchTarget())
    .merge(switch (variant) {
      .surface => _framedTrigger(
        rest: highContrast ? UiTokens.controlBorder() : UiTokens.gray7(),
        fill: UiTokens.gray2(),
        active: UiTokens.gray3(),
      ),
      .soft => _framedTrigger(
        rest: UiTokens.gray8(),
        fill: UiTokens.gray3(),
        active: UiTokens.gray4(),
      ),
      .ghost => _ghostTrigger(),
    })
    .selectedWhileOpen(true)
    .onSelected(SelectTriggerStyler().indicatorAngle(math.pi))
    .onDisabled(
      SelectTriggerStyler()
          .containerEffects(.outline(.style(.none)))
          .wrap(.opacity(0.5)),
    )
    // The chevron turns on the transform spring; colors ride the same curve.
    .animate(
      AnimationConfig.curve(
        duration: UiSpringCurve.css.duration,
        curve: UiSpringCurve.css,
      ),
    );

/// The trigger's label, placeholder, icons, value roll and focus ring.
SelectTriggerStyler _triggerBase({required bool highContrast}) {
  final muted = highContrast ? UiTokens.gray11() : _mutedContent();
  TextStyler regular(Color color) => TextStyler(
    style: UiTokens.text2.mix(),
  ).fontWeight(UiTokens.fontWeightRegular()).color(color);

  return SelectTriggerStyler()
      .direction(.horizontal)
      .mainAxisAlignment(.spaceBetween)
      .borderRadius(.all(UiTokens.radius4OrFull()))
      .label(regular(UiTokens.gray12()))
      .placeholder(regular(muted))
      .icon(.color(UiTokens.gray12()).size(UiTokens.space4()))
      .indicator(.color(muted).size(UiTokens.space4()))
      .indicatorOpacity(1)
      .labelTransition(
        const RemixSelectLabelTransition(
          duration: UiMotion.standard,
          reverseDuration: UiMotion.fast,
          builder: _valueRoll,
        ),
      )
      .onFocusVisible(.containerEffects(uiFocusOutline()));
}

final _mutedContent = ContextToken<Color>(
  (context) => UiTheme.maybeOf(context)?.highContrast ?? false
      ? UiTokens.gray11.resolve(context)
      : UiTokens.gray10.resolve(context),
);

/// The gap, padding and height of the trigger. A ghost trigger has no height;
/// it takes its padding and cancels it with a negative margin.
SelectTriggerStyler _triggerScale(UiSelectVariant variant, UiSelectSize size) =>
    switch (variant) {
      .ghost => switch (size) {
        .size1 || .size2 =>
          SelectTriggerStyler()
              .spacing(UiTokens.space2())
              .padding(.horizontal(UiTokens.space2()))
              .padding(.vertical(UiTokens.space1()))
              .margin(.horizontal(UiTokens.selectGhostMarginX12()))
              .margin(.vertical(UiTokens.selectGhostMarginY12())),
        .size3 =>
          SelectTriggerStyler()
              .spacing(UiTokens.space2())
              .padding(.horizontal(UiTokens.space3()))
              .padding(.vertical(UiTokens.space2()))
              .margin(.horizontal(UiTokens.selectGhostMarginX3()))
              .margin(.vertical(UiTokens.selectGhostMarginY3())),
      },
      .surface || .soft =>
        SelectTriggerStyler()
            .spacing(UiTokens.space3())
            .height(switch (size) {
              .size1 => UiTokens.controlHeight1(),
              .size2 => UiTokens.controlHeight2(),
              .size3 => UiTokens.controlHeight3(),
            })
            .padding(.horizontal(_framedInset())),
    };

/// The 12px content inset plus the 1px frame, which is painted inset.
final _framedInset = ContextToken<double>(
  (context) =>
      UiTokens.space3.resolve(context) + UiTokens.borderWidth1.resolve(context),
);

/// A [fill] inside a [rest] frame; hover, press, open and keyboard focus
/// strengthen the frame to gray 8, and all but focus move to the [active]
/// fill.
SelectTriggerStyler _framedTrigger({
  required Color rest,
  required Color fill,
  required Color active,
}) {
  final engaged = _frame(UiTokens.gray8()).color(active);

  return _frame(rest)
      .color(fill)
      .onHovered(engaged)
      .onPressed(engaged)
      .onSelected(engaged)
      .onFocusVisible(_frame(UiTokens.gray8()))
      .onDisabled(_frame(rest).color(fill));
}

/// Transparent with no frame; hover, press and open take the muted fill.
SelectTriggerStyler _ghostTrigger() {
  final engaged = SelectTriggerStyler().color(UiTokens.gray3());

  return SelectTriggerStyler()
      .color(const Color(0x00000000))
      .onHovered(engaged)
      .onPressed(engaged)
      .onSelected(engaged)
      .onDisabled(SelectTriggerStyler().color(const Color(0x00000000)));
}

SelectTriggerStyler _frame(Color color) => SelectTriggerStyler()
    .containerEffects(.behindContent(uiInsetSurface(strokes: [color])));

/// The floating panel: the raised surface in a quiet frame with the
/// floating shadow, 4px off the trigger and at least as wide as it.
SelectContentStyler _content() => SelectContentStyler()
    .maxHeight(320)
    .minWidth(remixAnchorWidth())
    .margin(.vertical(UiTokens.space1()))
    .border(.color(UiTokens.gray7()).width(UiTokens.borderWidth1()))
    .padding(.horizontal(_panelInset()))
    .padding(.vertical(_panelListInset()))
    .borderRadius(.all(UiTokens.radius5()))
    .color(UiTokens.colorPanelSolid())
    .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()))
    .clipBehavior(Clip.antiAlias);

/// 6px around the list, which adds 2px above and below.
final _panelInset = _scaled(6);
final _panelListInset = _scaled(8);

/// An item in the panel: 13px text, the check 10px from the end, and the
/// muted fill under the pointer, the keyboard and a press.
SelectMenuItemStyler _item(
  UiSelectVariant variant,
  UiSelectSize size, {
  required bool highContrast,
}) {
  final radius = UiTokens.radius2();
  final highlighted = highContrast && variant != .soft
      ? SelectMenuItemStyler()
            .color(UiTokens.accent12())
            .text(.color(UiTokens.accent1()))
            .iconColor(UiTokens.accent1())
      : SelectMenuItemStyler().color(UiTokens.gray3());

  // Rows keep the 36px pitch of the panel; the list is its own scroll
  // target, so no row widens past its drawn height.
  return SelectMenuItemStyler()
      .direction(.horizontal)
      .height(_itemHeight())
      .padding(.only(left: _itemStart(), right: _itemEnd()))
      .borderRadius(.all(radius))
      .text(TextStyler(style: UiTokens.text2.mix()).color(UiTokens.gray12()))
      .indicator(
        BoxStyler(
          alignment: .centerRight,
          constraints: BoxConstraintsMix.width(_indicatorWidth()),
        ),
      )
      .icon(IconStyler(color: UiTokens.gray12(), size: UiTokens.space4()))
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(highlighted)
      .onFocusVisible(
        SelectMenuItemStyler().container(
          highContrast
              ? FlexBoxStyler().uiFocusRing(radius: radius)
              : FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)),
        ),
      )
      .onDisabled(
        SelectMenuItemStyler()
            .container(
              FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)),
            )
            .color(const Color(0x00000000))
            .wrap(.opacity(0.45)),
      )
      .animate(
        AnimationConfig.curve(
          duration: UiMotion.instant,
          curve: UiMotion.easeStandard,
        ),
      );
}

/// [px] at the theme's scaling.
ContextToken<double> _scaled(double px) => ContextToken<double>(
  (context) => px * UiTokens.space1.resolve(context) / 4,
);

final _itemHeight = _scaled(36);
final _itemStart = _scaled(11);
final _itemEnd = _scaled(10);

/// The check's 16px glyph plus the 8px before it, so labels stop 34px from
/// the end when an item is checked.
final _indicatorWidth = _scaled(24);

/// The new value rises 0.35em out of a 4px blur over 200ms (an earlier one
/// drops), while the old one leaves the other way 0.3em into a 2px blur over
/// 150ms.
Widget _valueRoll(
  BuildContext context,
  RemixSelectLabelTransitionInfo info,
  Widget label,
) {
  final em = UiTokens.text2.resolve(context).fontSize!;
  final sign = info.direction == .later ? 1.0 : -1.0;

  return AnimatedBuilder(
    animation: info.animation,
    builder: (context, child) {
      final t = info.animation.value;
      final double rest;
      final double travel;
      final double blur;
      if (info.entering) {
        rest = UiMotion.easeEnter.transform(t);
        travel = sign * 0.35 * em * (1 - rest);
        blur = UiMotion.blurSoft * (1 - rest);
      } else {
        rest = UiMotion.easeStandard.transform(t);
        travel = -sign * 0.3 * em * (1 - rest);
        blur = UiMotion.blurSubtle * (1 - rest);
      }

      return Opacity(
        opacity: rest.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, travel),
          child: blur > 0
              ? ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: child,
                )
              : child,
        ),
      );
    },
    child: label,
  );
}

/// The panel grows in from the trigger edge: from 6px toward the trigger,
/// 0.97 scale and transparent, over 200ms on the enter ease. It leaves to
/// half that offset and 0.98 scale over 100ms on the standard ease. Under
/// reduced motion it only fades.
Widget _panelMotion(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final side = OverlayPlacement.maybeOf(context)?.side ?? OverlaySide.bottom;
  final (toward, origin) = switch (side) {
    OverlaySide.bottom => (const Offset(0, -6), Alignment.topCenter),
    OverlaySide.top => (const Offset(0, 6), Alignment.bottomCenter),
    OverlaySide.left => (const Offset(6, 0), Alignment.centerRight),
    OverlaySide.right => (const Offset(-6, 0), Alignment.centerLeft),
  };

  return RemixReducedMotionBuilder(
    builder: (context, reduceMotion) => AnimatedBuilder(
      animation: info.animation,
      builder: (context, child) {
        final t = info.animation.value;
        final leaving =
            info.animation.status == .reverse ||
            info.animation.status == .dismissed;
        if (reduceMotion) {
          return Opacity(opacity: t, child: child);
        }
        final double gone;
        final Offset offset;
        final double scale;
        if (leaving) {
          gone = UiMotion.easeStandard.transform(1 - t);
          offset = toward / 2 * gone;
          scale = 1 - 0.02 * gone;
        } else {
          gone = 1 - UiMotion.easeEnter.transform(t);
          offset = toward * gone;
          scale = 1 - 0.03 * gone;
        }

        return Opacity(
          opacity: (1 - gone).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(
              scale: scale,
              alignment: origin,
              child: child,
            ),
          ),
        );
      },
      child: panel,
    ),
  );
}
