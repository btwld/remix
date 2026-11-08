import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';
import '../theme/effects.dart';
import 'icon_button.dart';
import 'select.dart';
import 'calendar.dart';

/// The application's RangeCalendar style recipe.
///
/// Remix owns the complete range, local draft and range roles. This recipe
/// paints committed endpoints in primary, interiors in accent, and the draft
/// with a tinted fill and primary outline. While drafting, the old committed
/// value keeps only its quiet selected treatment. Unavailable draft days use
/// the destructive text role and remain struck through and visibly muted.
CalendarStyler playgroundRangeCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => playgroundCalendarStyle()
    .day(
      CalendarDayStyler()
          .onSelected(
            CalendarDayStyler()
                .color(PlaygroundTokens.muted())
                .label(.color(PlaygroundTokens.mutedForeground())),
          )
          .onRangeMiddle(
            CalendarDayStyler()
                .color(PlaygroundTokens.accent())
                .borderRadius(
                  .only(
                    topStart: Radius.zero,
                    topEnd: Radius.zero,
                    bottomStart: Radius.zero,
                    bottomEnd: Radius.zero,
                  ),
                )
                .label(.color(PlaygroundTokens.accentForeground())),
          )
          .onRangeStart(
            _endpoint().borderRadius(
              .only(
                topStart: PlaygroundTokens.radiusSm(),
                bottomStart: PlaygroundTokens.radiusSm(),
                topEnd: Radius.zero,
                bottomEnd: Radius.zero,
              ),
            ),
          )
          .onRangeEnd(
            _endpoint().borderRadius(
              .only(
                topEnd: PlaygroundTokens.radiusSm(),
                bottomEnd: PlaygroundTokens.radiusSm(),
                topStart: Radius.zero,
                bottomStart: Radius.zero,
              ),
            ),
          )
          .onRangeSingle(
            _endpoint().borderRadius(
              .only(
                topStart: PlaygroundTokens.radiusSm(),
                topEnd: PlaygroundTokens.radiusSm(),
                bottomStart: PlaygroundTokens.radiusSm(),
                bottomEnd: PlaygroundTokens.radiusSm(),
              ),
            ),
          )
          .onRangePreview(
            CalendarDayStyler()
                .color(_draft())
                .border(
                  .color(_draftBorder()).width(PlaygroundTokens.strokeHairline),
                )
                .label(.color(PlaygroundTokens.foreground()))
                .onDisabled(
                  CalendarDayStyler()
                      .color(_blocked())
                      .label(.color(PlaygroundTokens.destructive())),
                ),
          ),
    )
    .merge(style);

CalendarDayStyler _endpoint() => CalendarDayStyler()
    .color(PlaygroundTokens.primary())
    .label(.color(PlaygroundTokens.primaryForeground()));

final _draft = playgroundTint(PlaygroundTokens.primary, 0.12, dark: 0.2);
final _draftBorder = playgroundTint(PlaygroundTokens.primary, 0.6);
final _blocked = playgroundTint(PlaygroundTokens.destructive, 0.1, dark: 0.2);

/// The application's RangeCalendar recipe.
///
/// Remix owns rendering, civil-date selection, keyboard navigation, focus and
/// semantics. This recipe supplies the day states, typography, Playground icon
/// navigation and Select selectors. Selectors retain intrinsic text height.
///
/// CalendarSpec has no generator target, so this facade composes the child
/// recipes by hand and deliberately has no generated part.
class PlaygroundRangeCalendar extends StatelessWidget {
  const PlaygroundRangeCalendar({
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

  /// Creates a [CalendarStyler], for `RemixRangeCalendar.styleFrom(...)`.
  static const styleFrom = CalendarStyler.new;

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
    rangeLabels: rangeLabels,
    headerBuilder: headerBuilder,
    navigationStyle: playgroundIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(PlaygroundTokens.s12, PlaygroundTokens.s12)
          .merge(navigationStyle),
    ),
    selectorStyle: playgroundSelectStyle(
      style: SelectStyler()
          .trigger(
            SelectTriggerStyler().width(
              MediaQuery.textScalerOf(
                context,
              ).scale(PlaygroundTokens.s16 * 2 + PlaygroundTokens.s6),
            ),
          )
          .merge(selectorStyle),
    ),
    style: playgroundRangeCalendarStyle(style: style),
    styleSpec: styleSpec,
    summaryBuilder: summaryBuilder,
  );
}
