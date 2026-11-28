import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';
import 'select.dart';

/// The side of a day's touch slot at 100% text scaling in the default
/// header's month and year controls.
const uiCalendarTarget = 44.0;

// These calendar dimensions have no matching spacing-scale step.

/// The width of the month and year selectors at 100% text scaling.
const uiCalendarSelectorWidth = 146.0;

/// The width of the inline calendar at 100% text scaling: seven day slots.
const uiCalendarWidth = 328.0;

/// The width of a day slot, scaled with the text, for a calendar [width]
/// wide.
double uiCalendarDayWidth(
  BuildContext context, {
  double width = uiCalendarWidth,
}) => MediaQuery.textScalerOf(context).scale(width / DateTime.daysPerWeek);

/// The calendar's text-scaled size: seven day slots across [width]. Each day
/// is a circle 4px narrower than its slot, and rows keep the same 4px gap.
CalendarStyler uiCalendarGeometry(
  BuildContext context, {
  double width = uiCalendarWidth,
}) {
  final slot = uiCalendarDayWidth(context, width: width);

  return CalendarStyler()
      .maxWidth(slot * DateTime.daysPerWeek)
      .day(CalendarDayStyler().minWidth(slot).minHeight(slot - 4));
}

/// The previous and next month buttons: 32px pills in the secondary text
/// colour that fill gray 3 under the pointer and sink to 96% while held.
IconButtonStyler uiCalendarNavigationStyle(BuildContext context) {
  final scaler = MediaQuery.textScalerOf(context);
  final button = scaler.scale(32);

  return IconButtonStyler()
      .size(button, button)
      .alignment(.center)
      .borderRadius(.all(UiTokens.radiusFull()))
      .color(const Color(0x00000000))
      .icon(.size(scaler.scale(16)).color(UiTokens.gray11()))
      .onHovered(
        IconButtonStyler()
            .color(UiTokens.gray3())
            .icon(.color(UiTokens.gray12())),
      )
      .onPressed(IconButtonStyler().scale(0.96))
      .onFocusVisible(IconButtonStyler().containerEffects(uiFocusOutline()))
      .onDisabled(IconButtonStyler().wrap(.opacity(0.36)))
      .animate(
        AnimationConfig.curve(
          duration: UiMotion.fast,
          curve: UiMotion.easeStandard,
        ),
      );
}

/// The calendar's header gap, weekday row and day states: circles that fill
/// gray 3 under the pointer and sink to 94% while held, 13px tabular numbers,
/// medium today and selected numbers, and muted unavailable days. The
/// selected disc is painted by [uiCalendarSelectionLayer]. Shared by the
/// inline calendar and the date picker.
CalendarStyler uiCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .headerSpacing(14)
    .weekdaySpacing(6)
    .rowSpacing(4)
    .fixedWeeks(true)
    .monthTransition(uiCalendarMonthTransition)
    .selectionLayer(uiCalendarSelectionLayer())
    .weekday(
      TextStyler()
          .style(UiTokens.text1.mix())
          .fontWeight(UiTokens.fontWeightMedium())
          .height(2)
          .color(_mutedContent()),
    )
    .onDisabled(CalendarStyler().wrap(.opacity(0.5)))
    .day(uiCalendarDayStyle())
    .merge(style);

/// One day: a circle 2px in from each side of its slot with a 13px tabular
/// number.
CalendarDayStyler uiCalendarDayStyle() => CalendarDayStyler()
    .margin(.symmetric(horizontal: 2))
    .borderRadius(.all(UiTokens.radiusFull()))
    .label(
      TextStyler()
          .style(UiTokens.text2.mix())
          .height(1)
          .fontFeatures(const [FontFeature.tabularFigures()])
          .color(UiTokens.gray12()),
    )
    .containerEffects(RemixBoxEffectsMix())
    .onHovered(CalendarDayStyler().color(UiTokens.gray3()))
    .onPressed(CalendarDayStyler().scale(0.94))
    .onToday(
      CalendarDayStyler().label(
        TextStyler().fontWeight(UiTokens.fontWeightMedium()),
      ),
    )
    .onSelected(
      CalendarDayStyler()
          .color(const Color(0x00000000))
          .label(
            TextStyler()
                .color(uiCalendarSwatchInk())
                .fontWeight(UiTokens.fontWeightMedium()),
          ),
    )
    .onFocusVisible(CalendarDayStyler().containerEffects(uiFocusOutline()))
    .onDisabled(CalendarDayStyler().label(TextStyler().color(_mutedDay())))
    .onUnavailable(
      CalendarDayStyler().label(
        TextStyler().color(_mutedDay()).decoration(TextDecoration.lineThrough),
      ),
    )
    .animate(
      AnimationConfig.curve(
        duration: UiMotion.fast,
        curve: UiMotion.easeStandard,
      ),
    );

/// The number on a selection disc: the accent's swatch ink, or black or
/// white, whichever reads better, for palettes whose swatch ink falls under
/// 4.5:1 on the disc.
final uiCalendarSwatchInk = ContextToken<Color>((context) {
  final disc = _disc.resolve(context);
  final ink = UiTokens.accentSwatchContrast.resolve(context);
  double ratio(Color a, Color b) {
    final (x, y) = (a.computeLuminance(), b.computeLuminance());
    return (x > y ? x + 0.05 : y + 0.05) / (x > y ? y + 0.05 : x + 0.05);
  }

  if (ratio(ink, disc) >= 4.5) return ink;
  const black = Color(0xFF000000);
  const white = Color(0xFFFFFFFF);
  return ratio(black, disc) > ratio(white, disc) ? black : white;
});

bool _highContrast(BuildContext context) =>
    UiTheme.maybeOf(context)?.highContrast ?? false;

/// Gray 10 reads at about 4.1:1 on a light page; high contrast takes gray 11.
final _mutedContent = ContextToken<Color>(
  (context) => _highContrast(context)
      ? UiTokens.gray11.resolve(context)
      : UiTokens.gray10.resolve(context),
);

/// The selection disc. Accent 9 of amber, green and orange falls under 3:1 on
/// the page, so high contrast takes accent 12.
final _disc = ContextToken<Color>(
  (context) => _highContrast(context)
      ? UiTokens.accent12.resolve(context)
      : UiTokens.accent9.resolve(context),
);

/// Muted text at 42%, for days that cannot be chosen.
final _mutedDay = ContextToken<Color>(
  (context) => UiTokens.gray10.resolve(context).withValues(alpha: 0.42),
);

/// The weeks slide a slot and 16px sideways on the smooth spring when the
/// month changes, and fade toward 40% as they leave.
final uiCalendarMonthTransition = RemixMonthTransition(
  duration: UiSpringCurve.smooth.duration,
  builder: (context, info, grid) {
    final sign = info.direction == RemixMonthDirection.forward ? 1.0 : -1.0;
    final t = UiSpringCurve.smooth.transform(info.animation.value);
    final away = info.isIncoming ? 1 - t : t;

    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) => Transform.translate(
          offset: Offset(
            (info.isIncoming ? sign : -sign) *
                away *
                (constraints.maxWidth + 16),
            0,
          ),
          child: Opacity(opacity: 1 - 0.6 * away, child: grid),
        ),
      ),
    );
  },
);

/// The selection painted under the days: a disc in the accent on each end,
/// and for ranges a pill of the accent's subtle tint across each week. Discs
/// glide on the morph spring and grow from 70% when the selection arrives.
///
/// [inset] narrows each slot to the drawn disc and bar.
RemixCalendarSelectionLayerBuilder uiCalendarSelectionLayer({
  double inset = 2,
}) => _layers.putIfAbsent(
  inset,
  () =>
      (context, selection) => _UiSelectionLayer(
        selection: selection,
        inset: inset,
        disc: _disc.resolve(context),
        band: UiTokens.accentSurface.resolve(context),
      ),
);
final _layers = <double, RemixCalendarSelectionLayerBuilder>{};

Rect _narrow(Rect rect, double inset) =>
    Rect.fromLTRB(rect.left + inset, rect.top, rect.right - inset, rect.bottom);

class _UiSelectionLayer extends StatelessWidget {
  const _UiSelectionLayer({
    required this.selection,
    required this.inset,
    required this.disc,
    required this.band,
  });

  final RemixCalendarSelection selection;
  final double inset;
  final Color disc;
  final Color band;

  @override
  Widget build(BuildContext context) {
    final start = selection.start;
    final end = selection.end;
    final range = start != null && end != null && start != end;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (range)
          for (final segment in selection.segments)
            _Glide(
              key: ValueKey(('band', segment.row)),
              rect: _narrow(selection.segmentRect(segment), inset),
              color: band,
            ),
        if (start != null)
          _Glide(
            key: const ValueKey('start'),
            rect: _narrow(selection.cellRect(start), inset),
            color: disc,
          ),
        if (range)
          _Glide(
            key: const ValueKey('end'),
            rect: _narrow(selection.cellRect(end), inset),
            color: disc,
          ),
      ],
    );
  }
}

/// A pill that glides to [rect] on the morph spring, and grows from 70% and
/// fades in when it first appears. Reduced motion places it at once.
class _Glide extends StatelessWidget {
  const _Glide({super.key, required this.rect, required this.color});

  final Rect rect;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final glide = UiSpringCurve.smooth;

    return AnimatedPositioned.fromRect(
      rect: rect,
      duration: still ? Duration.zero : glide.duration,
      curve: glide,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: still ? 1 : 0, end: 1),
        duration: still ? Duration.zero : UiMotion.fast,
        curve: UiMotion.easeEnter,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.scale(scale: 0.7 + 0.3 * t, child: child),
        ),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }
}

/// The pickers' popover: it drops 8px and grows from 95% on the snappy
/// spring while fading in on the enter ease, and leaves over 150ms, rising
/// 6px and shrinking to 97%.
final uiCalendarPanelTransition = RemixPanelTransition(
  duration: UiSpringCurve.snappy.duration,
  reverseDuration: UiMotion.fast,
  builder: (context, info, panel) => AnimatedBuilder(
    animation: info.animation,
    child: panel,
    builder: (context, panel) {
      final animation = info.animation;
      final opening = animation.status != AnimationStatus.reverse;
      final v = animation.value;
      final t = opening
          ? UiSpringCurve.snappy.transform(v)
          : UiMotion.easeStandard.transform(v);
      final fade = opening
          ? UiMotion.easeEnter.transform((v * 1.33).clamp(0, 1).toDouble())
          : t;

      return Opacity(
        opacity: fade,
        child: Transform.translate(
          offset: Offset(0, (opening ? -8 : -6) * (1 - t)),
          child: Transform.scale(
            scale: (opening ? 0.95 : 0.97) + (opening ? 0.05 : 0.03) * t,
            alignment: AlignmentDirectional.topStart.resolve(
              Directionality.of(context),
            ),
            child: panel,
          ),
        ),
      );
    },
  ),
);

/// A picker footer: a 1px gray 6 rule 14px under the calendar and, 11px
/// below it, [status] in muted 12px text at the end of the row.
Widget uiCalendarFooter(String status) => _CalendarFooter(status: status);

class _CalendarFooter extends StatelessWidget {
  const _CalendarFooter({required this.status});

  /// The selected date or range, or the empty-selection label.
  final String status;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: UiTokens.gray6.resolve(context))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: StyledText(
                status,
                style: TextStyler()
                    .style(UiTokens.text1.mix())
                    .color(_mutedContent())
                    .maxLines(1)
                    .overflow(TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The calendar header: the month and year on the left, previous and next
/// month buttons on the right. Shared by the calendar and range calendar.
Widget uiCalendarHeader({
  required DateTime month,
  VoidCallback? onPrevious,
  VoidCallback? onNext,
  RemixCalendarLabels labels = const RemixCalendarLabels(),
  IconButtonStyler navigationStyle = const IconButtonStyler.create(),
}) => _CalendarHeader(
  month: month,
  onPrevious: onPrevious,
  onNext: onNext,
  labels: labels,
  navigationStyle: navigationStyle,
);

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    this.onPrevious,
    this.onNext,
    this.labels = const RemixCalendarLabels(),
    this.navigationStyle = const IconButtonStyler.create(),
  });

  /// The displayed month.
  final DateTime month;

  /// Shows the previous month; null disables the button.
  final VoidCallback? onPrevious;

  /// Shows the next month; null disables the button.
  final VoidCallback? onNext;

  /// The month title and button names.
  final RemixCalendarLabels labels;

  /// Button styling merged over [uiCalendarNavigationStyle].
  final IconButtonStyler navigationStyle;

  @override
  Widget build(BuildContext context) {
    final style = uiCalendarNavigationStyle(context).merge(navigationStyle);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 34),
      child: Row(
        children: [
          Expanded(
            child: StyledText(
              labels.monthYear(month),
              style: TextStyler()
                  .style(UiTokens.text3.mix())
                  .fontWeight(UiTokens.fontWeightMedium())
                  .fontFeatures(const [FontFeature.tabularFigures()])
                  .color(UiTokens.gray12())
                  .maxLines(1),
            ),
          ),
          // The buttons' empty edge lines up with the last day's circle.
          Transform.translate(
            offset: Offset(
              Directionality.of(context) == TextDirection.ltr ? 6 : -6,
              0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                RemixIconButton(
                  icon: RemixIcons.chevronLeft,
                  semanticLabel: labels.previousMonth,
                  onPressed: onPrevious,
                  style: style,
                ),
                RemixIconButton(
                  icon: RemixIcons.chevronRight,
                  semanticLabel: labels.nextMonth,
                  onPressed: onNext,
                  style: style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The month and year selectors: select triggers sized to the calendar, whose
/// capped panels always show a scrollbar so overflow stays discoverable.
SelectStyler uiCalendarSelectorStyle(BuildContext context) => uiSelectStyle()
    .trigger(
      SelectTriggerStyler()
          .padding(.horizontal(UiTokens.space2()))
          .indicator(.size(MediaQuery.textScalerOf(context).scale(9)))
          .height(UiTokens.touchTargetMin())
          .width(
            MediaQuery.textScalerOf(context).scale(uiCalendarSelectorWidth),
          ),
    )
    .content(
      SelectContentStyler()
          // Half an extra item plus the panel borders puts the bottom
          // in a calendar row gap rather than through the day labels.
          .maxHeight(
            MediaQuery.textScalerOf(
              context,
            ).scale(UiTokens.touchTargetMin.resolve(context) * 6.5 + 2),
          )
          .wrap(WidgetModifierConfig.modifier(const _CalendarScrollCueMix())),
    );

final class _CalendarScrollCueMix extends ModifierMix<_CalendarScrollCue> {
  const _CalendarScrollCueMix();

  @override
  _CalendarScrollCue resolve(BuildContext context) =>
      const _CalendarScrollCue();

  @override
  _CalendarScrollCueMix merge(_CalendarScrollCueMix? other) => other ?? this;

  @override
  List<Object?> get props => const [];
}

final class _CalendarScrollCue extends WidgetModifier<_CalendarScrollCue> {
  const _CalendarScrollCue();

  @override
  Widget build(Widget child) => ScrollConfiguration(
    behavior: const _CalendarScrollBehavior(),
    child: child,
  );

  @override
  _CalendarScrollCue copyWith() => this;

  @override
  _CalendarScrollCue lerp(_CalendarScrollCue? other, double t) => this;

  @override
  List<Object?> get props => const [];
}

class _CalendarScrollBehavior extends ScrollBehavior {
  const _CalendarScrollBehavior();
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => RawScrollbar(
    controller: details.controller,
    thumbVisibility: true,
    thumbColor: UiTokens.gray9.resolve(context),
    thickness: UiTokens.space1.resolve(context),
    child: child,
  );
}

/// Fortal's Calendar composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class UiCalendar extends StatelessWidget {
  const UiCalendar({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.labels = const RemixCalendarLabels(),
    this.headerBuilder,
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
    this.style = const CalendarStyler.create(),
    this.styleSpec,
  });

  /// Parent-owned selected date, compared by year/month/day fields.
  final DateTime? value;

  /// Inclusive earliest selectable date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests a selected date. Null disables the calendar.
  ///
  /// The parent decides whether to accept it by updating [value].
  final ValueChanged<DateTime>? onChanged;

  /// Today, for the `onToday` variant and fallback focus; defaults to now.
  final DateTime? currentDate;

  /// Marks in-range dates unselectable; they stay keyboard-focusable.
  final bool Function(DateTime)? isDateUnavailable;

  /// First weekday column, from Monday=1 through Sunday=7.
  final int firstDayOfWeek;

  /// Whether navigation, focus and selection are enabled.
  final bool enabled;

  /// Accessible name of the calendar group.
  final String? semanticLabel;

  /// Focus entry point; requesting it focuses the current day.
  final FocusNode? focusNode;

  /// Whether to focus the current day on mount.
  final bool autofocus;

  /// Caller-owned labels and date formatters; English by default.
  final RemixCalendarLabels labels;

  /// Replaces header visuals/navigation only. Day behavior remains owned.
  final Widget Function(BuildContext, NakedCalendarState)? headerBuilder;

  /// Independent button styling, resolved in each navigation button state.
  final IconButtonStyler navigationStyle;

  /// Independent month/year selector styling.
  final SelectStyler selectorStyle;

  /// Calendar and day styling, resolved in each part's own state.
  final CalendarStyler style;

  /// Raw resolved spec; bypasses [style] and inherited styles.
  final CalendarSpec? styleSpec;

  @override
  Widget build(BuildContext context) => RemixCalendar(
    value: value,
    firstDate: firstDate,
    lastDate: lastDate,
    onChanged: onChanged,
    currentDate: currentDate,
    isDateUnavailable: isDateUnavailable,
    firstDayOfWeek: firstDayOfWeek,
    enabled: enabled,
    semanticLabel: semanticLabel,
    focusNode: focusNode,
    autofocus: autofocus,
    labels: labels,
    headerBuilder:
        headerBuilder ??
        (context, state) => uiCalendarHeader(
          month: state.displayedMonth,
          onPrevious: state.showPreviousMonth,
          onNext: state.showNextMonth,
          labels: labels,
          navigationStyle: navigationStyle,
        ),
    navigationStyle: uiCalendarNavigationStyle(context).merge(navigationStyle),
    selectorStyle: uiCalendarSelectorStyle(context).merge(selectorStyle),
    style: uiCalendarStyle(style: uiCalendarGeometry(context).merge(style)),
    styleSpec: styleSpec,
  );
}

/// The keyboard focus ring color of a day: gray 11 in dark mode, focus 8 in
/// light mode.
final uiCalendarFocusColor = ContextToken<Color>(
  (context) => (UiTheme.of(context).isDark ? UiTokens.gray11 : UiTokens.focus8)
      .resolve(context),
);
