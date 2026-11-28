import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'calendar.dart';

/// The range calendar's look: the calendar's header gap, weekday row and
/// days, with the range painted under them by the selection layer as a
/// subtle-tint pill across each week and an accent disc on each end. Middle
/// days keep foreground numbers; end numbers take the swatch ink. A draft
/// preview tints the days it would cover. Shared by the range calendar and
/// the date range picker.
CalendarStyler fortalRangeCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => fortalCalendarStyle()
    .day(
      CalendarDayStyler()
          .onRangeMiddle(
            CalendarDayStyler()
                .color(const Color(0x00000000))
                .label(
                  TextStyler()
                      .color(FortalTokens.gray12())
                      .fontWeight(FortalTokens.fontWeightRegular()),
                )
                .onHovered(CalendarDayStyler().color(_middleHover())),
          )
          .onRangeStart(_end)
          .onRangeEnd(_end)
          .onRangeSingle(_end)
          .onRangePreview(
            CalendarDayStyler()
                .color(FortalTokens.accentSurface())
                .onRangeStart(_end)
                .onRangeEnd(_end)
                .onRangeSingle(_end),
          ),
    )
    .merge(style);

/// An end of the range: the disc underneath shows through, under a medium
/// number in the swatch ink, whatever the pointer does.
final _end = CalendarDayStyler()
    .color(const Color(0x00000000))
    .label(
      TextStyler()
          .color(fortalCalendarSwatchInk())
          .fontWeight(FortalTokens.fontWeightMedium()),
    )
    .onHovered(CalendarDayStyler().color(const Color(0x00000000)));

/// The foreground at 7% over the range pill, under the pointer.
final _middleHover = ContextToken<Color>(
  (context) => FortalTokens.gray12.resolve(context).withValues(alpha: 0.07),
);

/// Fortal's RangeCalendar composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class FortalRangeCalendar extends StatelessWidget {
  const FortalRangeCalendar({
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
    this.rangeLabels = const RemixRangeCalendarLabels(),
    this.headerBuilder,
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
    this.style = const CalendarStyler.create(),
    this.styleSpec,
    this.summaryBuilder,
  });

  /// Parent-owned complete inclusive range, compared by civil fields.
  ///
  /// It is never clamped or corrected; an invalid value stays selected.
  final CivilDateRange? value;

  /// Inclusive earliest selectable date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests one complete range. Null disables the calendar.
  ///
  /// The parent decides whether to accept it by updating [value].
  final ValueChanged<CivilDateRange>? onChanged;

  /// Today, for the `onToday` variant and fallback focus; defaults to now.
  final DateTime? currentDate;

  /// Marks in-range dates unavailable. A range cannot include them, even
  /// offscreen; they stay keyboard-focusable. Rebuild when results change.
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

  /// Caller-owned date labels and formatters; English by default.
  final RemixCalendarLabels labels;

  /// Caller-owned range roles, instructions and joiners; English by default.
  final RemixRangeCalendarLabels rangeLabels;

  /// Replaces header visuals/navigation only. Day behavior remains owned.
  final Widget Function(BuildContext, NakedRangeCalendarState)? headerBuilder;

  /// Independent button styling, resolved in each navigation button state.
  final IconButtonStyler navigationStyle;

  /// Independent month/year selector styling.
  final SelectStyler selectorStyle;

  /// Calendar and day styling, including the range day variants.
  final CalendarStyler style;

  /// Raw resolved spec; bypasses [style] and inherited styles.
  ///
  /// A resolved spec carries no variants, so every day renders its `day` spec:
  /// selection, availability and range positions are not painted. Use [style]
  /// for state and range styling.
  final CalendarSpec? styleSpec;

  /// Paints the range summary: the selected range, the next instruction and
  /// any availability problem.
  ///
  /// By default the summary is not painted; it is a live region for assistive
  /// technology only. A builder makes it visible and keeps it live.
  final Widget Function(BuildContext context, String summary)? summaryBuilder;

  @override
  Widget build(BuildContext context) => RemixRangeCalendar(
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
        (context, state) => fortalCalendarHeader(
          month: state.displayedMonth,
          onPrevious: state.showPreviousMonth,
          onNext: state.showNextMonth,
          labels: labels,
          navigationStyle: navigationStyle,
        ),
    rangeLabels: rangeLabels,
    summaryBuilder: summaryBuilder,
    navigationStyle: fortalCalendarNavigationStyle(
      context,
    ).merge(navigationStyle),
    selectorStyle: fortalCalendarSelectorStyle(context).merge(selectorStyle),
    style: fortalRangeCalendarStyle(
      style: fortalCalendarGeometry(context).merge(style),
    ),
    styleSpec: styleSpec,
  );
}
