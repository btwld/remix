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
enum FortalSelectSize {
  /// A 32px trigger.
  size1,

  /// A 40px trigger. The default.
  size2,

  /// A 44px trigger.
  size3,
}

/// The looks a select's trigger comes in.
enum FortalSelectVariant {
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
SelectStyler fortalSelectStyle({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
  bool highContrast = false,
  SelectStyler style = const SelectStyler.create(),
}) => SelectStyler()
    .trigger(_trigger(variant, size, highContrast: highContrast))
    .content(_content())
    .item(_item(variant, size, highContrast: highContrast))
    .panelTransition(
      const RemixPanelTransition(
        duration: FortalMotion.standard,
        reverseDuration: FortalMotion.instant,
        reducedMotionDuration: FortalMotion.instant,
        builder: _panelMotion,
      ),
    )
    .merge(style);

/// The Fortal select item recipe, for styling one item on its own.
///
/// It is the item style [fortalSelectStyle] gives every item, so a call site
/// can match a select's items outside the select.
SelectMenuItemStyler fortalSelectMenuItemStyle({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
  bool highContrast = false,
}) => _item(variant, size, highContrast: highContrast);

/// The trigger: its shape and text, then the variant's colors, then the open
/// state, which turns the chevron.
SelectTriggerStyler _trigger(
  FortalSelectVariant variant,
  FortalSelectSize size, {
  required bool highContrast,
}) => _triggerBase(highContrast: highContrast)
    .merge(_triggerScale(variant, size))
    .wrap(fortalTouchTarget())
    .merge(switch (variant) {
      .surface => _framedTrigger(
        rest: highContrast
            ? FortalTokens.controlBorder()
            : FortalTokens.gray7(),
        fill: FortalTokens.gray2(),
        active: FortalTokens.gray3(),
      ),
      .soft => _framedTrigger(
        rest: FortalTokens.gray8(),
        fill: FortalTokens.gray3(),
        active: FortalTokens.gray4(),
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
        duration: FortalSpringCurve.css.duration,
        curve: FortalSpringCurve.css,
      ),
    );

/// The trigger's label, placeholder, icons, value roll and focus ring.
SelectTriggerStyler _triggerBase({required bool highContrast}) {
  final muted = highContrast ? FortalTokens.gray11() : _mutedContent();
  TextStyler regular(Color color) => TextStyler(
    style: FortalTokens.text2.mix(),
  ).fontWeight(FortalTokens.fontWeightRegular()).color(color);

  return SelectTriggerStyler()
      .direction(.horizontal)
      .mainAxisAlignment(.spaceBetween)
      .borderRadius(.all(FortalTokens.radius4OrFull()))
      .label(regular(FortalTokens.gray12()))
      .placeholder(regular(muted))
      .icon(.color(FortalTokens.gray12()).size(FortalTokens.space4()))
      .indicator(.color(muted).size(FortalTokens.space4()))
      .indicatorOpacity(1)
      .labelTransition(
        const RemixSelectLabelTransition(
          duration: FortalMotion.standard,
          reverseDuration: FortalMotion.fast,
          builder: _valueRoll,
        ),
      )
      .onFocusVisible(.containerEffects(fortalFocusOutline()));
}

final _mutedContent = ContextToken<Color>(
  (context) => FortalTheme.maybeOf(context)?.highContrast ?? false
      ? FortalTokens.gray11.resolve(context)
      : FortalTokens.gray10.resolve(context),
);

/// The gap, padding and height of the trigger. A ghost trigger has no height;
/// it takes its padding and cancels it with a negative margin.
SelectTriggerStyler _triggerScale(
  FortalSelectVariant variant,
  FortalSelectSize size,
) => switch (variant) {
  .ghost => switch (size) {
    .size1 || .size2 =>
      SelectTriggerStyler()
          .spacing(FortalTokens.space2())
          .padding(.horizontal(FortalTokens.space2()))
          .padding(.vertical(FortalTokens.space1()))
          .margin(.horizontal(FortalTokens.selectGhostMarginX12()))
          .margin(.vertical(FortalTokens.selectGhostMarginY12())),
    .size3 =>
      SelectTriggerStyler()
          .spacing(FortalTokens.space2())
          .padding(.horizontal(FortalTokens.space3()))
          .padding(.vertical(FortalTokens.space2()))
          .margin(.horizontal(FortalTokens.selectGhostMarginX3()))
          .margin(.vertical(FortalTokens.selectGhostMarginY3())),
  },
  .surface || .soft =>
    SelectTriggerStyler()
        .spacing(FortalTokens.space3())
        .height(switch (size) {
          .size1 => FortalTokens.controlHeight1(),
          .size2 => FortalTokens.controlHeight2(),
          .size3 => FortalTokens.controlHeight3(),
        })
        .padding(.horizontal(_framedInset())),
};

/// The 12px content inset plus the 1px frame, which is painted inset.
final _framedInset = ContextToken<double>(
  (context) =>
      FortalTokens.space3.resolve(context) +
      FortalTokens.borderWidth1.resolve(context),
);

/// A [fill] inside a [rest] frame; hover, press, open and keyboard focus
/// strengthen the frame to gray 8, and all but focus move to the [active]
/// fill.
SelectTriggerStyler _framedTrigger({
  required Color rest,
  required Color fill,
  required Color active,
}) {
  final engaged = _frame(FortalTokens.gray8()).color(active);

  return _frame(rest)
      .color(fill)
      .onHovered(engaged)
      .onPressed(engaged)
      .onSelected(engaged)
      .onFocusVisible(_frame(FortalTokens.gray8()))
      .onDisabled(_frame(rest).color(fill));
}

/// Transparent with no frame; hover, press and open take the muted fill.
SelectTriggerStyler _ghostTrigger() {
  final engaged = SelectTriggerStyler().color(FortalTokens.gray3());

  return SelectTriggerStyler()
      .color(const Color(0x00000000))
      .onHovered(engaged)
      .onPressed(engaged)
      .onSelected(engaged)
      .onDisabled(SelectTriggerStyler().color(const Color(0x00000000)));
}

SelectTriggerStyler _frame(Color color) => SelectTriggerStyler()
    .containerEffects(.behindContent(fortalInsetSurface(strokes: [color])));

/// The floating panel: the raised surface in a quiet frame with the
/// floating shadow, 4px off the trigger and at least as wide as it.
SelectContentStyler _content() => SelectContentStyler()
    .maxHeight(320)
    .minWidth(remixAnchorWidth())
    .margin(.vertical(FortalTokens.space1()))
    .border(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()))
    .padding(.horizontal(_panelInset()))
    .padding(.vertical(_panelListInset()))
    .borderRadius(.all(FortalTokens.radius5()))
    .color(FortalTokens.colorPanelSolid())
    .decoration(BoxDecorationMix.create(boxShadow: FortalTokens.shadow5.mix()))
    .clipBehavior(Clip.antiAlias);

/// 6px around the list, which adds 2px above and below.
final _panelInset = _scaled(6);
final _panelListInset = _scaled(8);

/// An item in the panel: 13px text, the check 10px from the end, and the
/// muted fill under the pointer, the keyboard and a press.
SelectMenuItemStyler _item(
  FortalSelectVariant variant,
  FortalSelectSize size, {
  required bool highContrast,
}) {
  final radius = FortalTokens.radius2();
  final highlighted = highContrast && variant != .soft
      ? SelectMenuItemStyler()
            .color(FortalTokens.accent12())
            .text(.color(FortalTokens.accent1()))
            .iconColor(FortalTokens.accent1())
      : SelectMenuItemStyler().color(FortalTokens.gray3());

  // Rows keep the 36px pitch of the panel; the list is its own scroll
  // target, so no row widens past its drawn height.
  return SelectMenuItemStyler()
      .direction(.horizontal)
      .height(_itemHeight())
      .padding(.only(left: _itemStart(), right: _itemEnd()))
      .borderRadius(.all(radius))
      .text(
        TextStyler(
          style: FortalTokens.text2.mix(),
        ).color(FortalTokens.gray12()),
      )
      .indicator(
        BoxStyler(
          alignment: .centerRight,
          constraints: BoxConstraintsMix.width(_indicatorWidth()),
        ),
      )
      .icon(
        IconStyler(color: FortalTokens.gray12(), size: FortalTokens.space4()),
      )
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(highlighted)
      .onFocusVisible(
        SelectMenuItemStyler().container(
          highContrast
              ? FlexBoxStyler().fortalFocusRing(radius: radius)
              : FlexBoxStyler().wrap(fortalFocusRingModifier(visible: false)),
        ),
      )
      .onDisabled(
        SelectMenuItemStyler()
            .container(
              FlexBoxStyler().wrap(fortalFocusRingModifier(visible: false)),
            )
            .color(const Color(0x00000000))
            .wrap(.opacity(0.45)),
      )
      .animate(
        AnimationConfig.curve(
          duration: FortalMotion.instant,
          curve: FortalMotion.easeStandard,
        ),
      );
}

/// [px] at the theme's scaling.
ContextToken<double> _scaled(double px) => ContextToken<double>(
  (context) => px * FortalTokens.space1.resolve(context) / 4,
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
  final em = FortalTokens.text2.resolve(context).fontSize!;
  final sign = info.direction == .later ? 1.0 : -1.0;

  return AnimatedBuilder(
    animation: info.animation,
    builder: (context, child) {
      final t = info.animation.value;
      final double rest;
      final double travel;
      final double blur;
      if (info.entering) {
        rest = FortalMotion.easeEnter.transform(t);
        travel = sign * 0.35 * em * (1 - rest);
        blur = FortalMotion.blurSoft * (1 - rest);
      } else {
        rest = FortalMotion.easeStandard.transform(t);
        travel = -sign * 0.3 * em * (1 - rest);
        blur = FortalMotion.blurSubtle * (1 - rest);
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
          gone = FortalMotion.easeStandard.transform(1 - t);
          offset = toward / 2 * gone;
          scale = 1 - 0.02 * gone;
        } else {
          gone = 1 - FortalMotion.easeEnter.transform(t);
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
