import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'multi_select.g.dart';

/// The sizes a multi-select comes in. Pixel values are at 100% theme scaling.
enum UiMultiSelectSize {
  /// A 32px trigger with 22px chips.
  size1,

  /// A 40px trigger with 25px chips. The default.
  size2,

  /// A 44px trigger with 28px chips.
  size3,
}

bool _themeHighContrast(BuildContext context) =>
    UiTheme.maybeOf(context)?.highContrast ?? false;

/// The trigger's resting frame: the quiet border, or the control border once
/// the theme asks for high contrast.
final _restBorder = ContextToken<Color>(
  (context) => _themeHighContrast(context)
      ? UiTokens.controlBorder.resolve(context)
      : UiTokens.gray7.resolve(context),
);

/// The Fortal Multi Select recipe: a rounded field showing the picks as pill
/// chips, over a floating list whose options draw a check when picked.
///
/// It reads top to bottom: the trigger at rest, hovered or open, and
/// disabled; its chips; the panel; the options; then the size.
///
/// Hovering or opening the trigger darkens its border and fills it muted,
/// and the chips lift to the surface color. The panel drops in from just
/// above the trigger. Options take a muted fill under the pointer or the
/// keyboard and fade when disabled; a picked option shows a check, not a
/// heavier label.
///
/// [highContrast] moves the resting border to the control border and the
/// placeholder and chevron to gray step 11. The theme's high contrast switch
/// moves the border too.
@MixWidget(target: RemixMultiSelect.new)
SelectStyler uiMultiSelectStyle({
  UiMultiSelectSize size = .size2,
  bool highContrast = false,
  SelectStyler style = const SelectStyler.create(),
}) {
  final m = _metrics(size);
  final border = highContrast ? UiTokens.controlBorder() : _restBorder();
  final muted = highContrast ? UiTokens.gray11() : UiTokens.gray10();
  TextStyler text(double size, Color color) => TextStyler()
      .fontSize(size)
      .height(1.4)
      .letterSpacing(-.01 * size)
      .color(color)
      .maxLines(1)
      .overflow(.ellipsis);

  final lifted = SelectTriggerStyler()
      .color(UiTokens.gray3())
      .border(.all(.color(UiTokens.gray8())))
      .chip(BoxStyler().color(UiTokens.gray2()));

  return SelectStyler()
      .trigger(
        SelectTriggerStyler()
            .direction(.horizontal)
            .crossAxisAlignment(.center)
            .spacing(8)
            .constraints(.minHeight(m.height))
            // The 10px chevron box sits where a 16px one would centre its
            // mark, so the end padding takes the other 3px.
            .padding(.only(left: 12, right: 14, top: m.inset, bottom: m.inset))
            .borderRadius(.circular(14))
            .border(.all(.color(border).width(1)))
            .color(UiTokens.gray2())
            .placeholder(text(m.text, muted))
            .indicator(.color(muted).size(_chevron))
            .chip(
              BoxStyler()
                  .constraints(.maxWidth(144))
                  .margin(.only(right: 5))
                  // The 1px ring sits inside the box, so the padding is 1px
                  // short of the chip's 4px by 8px inset.
                  .padding(.symmetric(horizontal: 7, vertical: m.chipInset))
                  .borderRadius(.circular(999))
                  .border(.all(.color(UiTokens.gray6()).width(1)))
                  .color(UiTokens.gray3()),
            )
            .chipLabel(text(12, UiTokens.gray12()))
            .overflowLabel(
              text(
                12,
                UiTokens.gray11(),
              ).fontFeatures([const FontFeature.tabularFigures()]),
            )
            .onFocusVisible(.containerEffects(uiFocusOutline()))
            .onHovered(lifted)
            .onSelected(lifted)
            .onDisabled(SelectTriggerStyler().wrap(.opacity(.5)))
            .animate(.easeOut(UiMotion.fast)),
      )
      .content(
        SelectContentStyler()
            .margin(.only(top: 8))
            .minWidth(remixAnchorWidth())
            .padding(.all(5))
            .borderRadius(.circular(20))
            .border(.all(.color(UiTokens.gray7()).width(1)))
            .color(UiTokens.colorPanelSolid())
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()),
            )
            .clipBehavior(Clip.antiAlias),
      )
      .item(
        SelectMenuItemStyler()
            .direction(.horizontal)
            .crossAxisAlignment(.center)
            .spacing(12)
            .constraints(.minHeight(38))
            .padding(.horizontal(11))
            .borderRadius(.circular(15))
            .color(const Color(0x00000000))
            .text(text(13, UiTokens.gray12()))
            .indicator(BoxStyler(alignment: .center).size(16, 16))
            .icon(IconStyler(color: UiTokens.gray12(), size: _check))
            .onHovered(SelectMenuItemStyler().color(UiTokens.gray3()))
            .onFocusVisible(SelectMenuItemStyler().color(UiTokens.gray3()))
            .onDisabled(SelectMenuItemStyler().wrap(.opacity(.42)))
            .animate(.easeOut(UiMotion.instant)),
      )
      .panelTransition(_panelTransition)
      .merge(style);
}

// The chevron and check glyphs fill their boxes, so these boxes draw marks
// as wide as Fortal's 16px chevron and check, which leave a margin.
const _chevron = 10.0;
const _check = 12.0;

typedef _Metrics = ({
  double height,
  double inset,
  double chipInset,
  double text,
});

_Metrics _metrics(UiMultiSelectSize size) => switch (size) {
  .size1 => (height: 32, inset: 3, chipInset: 2, text: 13),
  .size2 => (height: 40, inset: 5, chipInset: 3, text: 13),
  .size3 => (height: 44, inset: 6, chipInset: 4, text: 13),
};

/// Drops the panel in from 6px above at 97% scale and lifts it out to 4px
/// above at 98%, fading both ways.
const _panelTransition = RemixPanelTransition(
  duration: UiMotion.standard,
  reverseDuration: UiMotion.instant,
  builder: _panelBuilder,
);

Widget _panelBuilder(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) {
  final animation = info.animation;
  final entering =
      animation.status == AnimationStatus.forward ||
      animation.status == AnimationStatus.completed;
  final opacity = CurvedAnimation(
    parent: animation,
    curve: const Interval(0, .75, curve: UiMotion.easeEnter),
    reverseCurve: UiMotion.easeStandard,
  );
  final motion = CurvedAnimation(
    parent: animation,
    curve: UiMotion.easeEnter,
    reverseCurve: UiMotion.easeStandard,
  );
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      final rest = 1 - motion.value;
      return Opacity(
        opacity: opacity.value,
        child: Transform.translate(
          offset: Offset(0, (entering ? -6 : -4) * rest),
          child: Transform.scale(
            scale: 1 - (entering ? .03 : .02) * rest,
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      );
    },
    child: panel,
  );
}
