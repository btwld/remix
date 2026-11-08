part of 'calendar.dart';

/// Caller-owned range descriptions. Defaults are explicitly English.
@immutable
class RemixRangeCalendarLabels {
  const RemixRangeCalendarLabels({
    this.start = 'Range start',
    this.end = 'Range end',
    this.draftStart = 'Draft start',
    this.draftEnd = 'Draft end',
    this.draftRange = 'Draft range',
    this.chooseStart = 'Choose start date',
    this.chooseEnd = 'Choose end date',
    this.unavailableRange = 'Range contains unavailable dates',
    this.invalidRange = 'Selected range is unavailable',
    this.selectedRange = _selectedRange,
    this.joinSummary = _joinSentences,
    this.joinDayLabel = _joinParts,
  });

  /// Appended to the accessible name of the committed range's first day.
  final String start;

  /// Appended to the accessible name of the committed range's last day.
  final String end;

  /// Appended to the accessible name of the draft's anchor day.
  final String draftStart;

  /// Appended to the accessible name of the focused day ending the draft.
  final String draftEnd;

  /// Appended to the accessible name of every day inside the draft.
  final String draftRange;

  /// Summary instruction while no draft is anchored.
  final String chooseStart;

  /// Summary instruction while a draft waits for its second date.
  final String chooseEnd;

  /// Summary notice when the draft cannot complete over unavailable dates.
  final String unavailableRange;

  /// Summary notice when the supplied value fails bounds or availability.
  final String invalidRange;

  /// Formats already-localized endpoint names, not raw DateTime values.
  final String Function(String start, String end) selectedRange;

  /// Joins the range summary's sentences, such as the selected range and the
  /// next instruction. Defaults to English sentence punctuation.
  final String Function(List<String> sentences) joinSummary;

  /// Joins a day's accessible name parts: its date, today and range roles.
  final String Function(List<String> parts) joinDayLabel;

  static String _selectedRange(String start, String end) =>
      'Selected range: $start to $end';
  static String _joinSentences(List<String> sentences) => sentences.join('. ');
  static String _joinParts(List<String> parts) => parts.join(', ');
}

/// Controlled inclusive range selection over the shared calendar anatomy.
///
/// First activation anchors a draft; second eligible activation requests one
/// complete range. Focus/navigation/blur never commit. Selected semantics always
/// describe [value], not the draft. An Overlay is required for default selectors.
///
/// The painted interval is the draft while anchored, otherwise [value]. Style it
/// with day variants on `CalendarStyler.day`: `onRangeStart`, `onRangeMiddle`,
/// `onRangeEnd`, `onRangeSingle` and `onRangePreview`. They rank with widget
/// states, so declare them after `onSelected` to override its fill.
class RemixRangeCalendar extends StatelessWidget {
  const RemixRangeCalendar({
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
  final NakedDateRange? value;

  /// Inclusive earliest selectable date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests one complete range. Null disables the calendar.
  ///
  /// The parent decides whether to accept it by updating [value].
  final ValueChanged<NakedDateRange>? onChanged;

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

  static final styleFrom = CalendarStyler.new;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = _calendarDefaults.merge(style);
    return NakedRangeCalendar(
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
      builder: (context, state, _) => _CalendarView(
        style: effectiveStyle,
        styleSpec: styleSpec,
        controller: NakedState.controllerOf<NakedRangeCalendarState>(context),
        labels: labels,
        firstDayOfWeek: firstDayOfWeek,
        weeks: state.weeks,
        summary: _summary(state),
        summaryBuilder: summaryBuilder,
        headerBuilder: (context, spec) =>
            headerBuilder?.call(context, state) ??
            _CalendarHeader(
              displayedMonth: state.displayedMonth,
              previousMonth: state.previousMonth,
              nextMonth: state.nextMonth,
              showMonth: state.showMonth,
              firstDate: firstDate,
              lastDate: lastDate,
              labels: labels,
              navigationStyle: navigationStyle,
              selectorStyle: selectorStyle,
              spec: spec,
            ),
        dayBuilder: (date) => _day(date, state, effectiveStyle),
      ),
    );
  }

  String _summary(NakedRangeCalendarState state) => rangeLabels.joinSummary([
    if (state.value case final value?)
      rangeLabels.selectedRange(
        labels.fullDate(value.start),
        labels.fullDate(value.end),
      ),
    if (!state.isValueValid) rangeLabels.invalidRange,
    if (enabled && onChanged != null)
      state.anchor == null ? rangeLabels.chooseStart : rangeLabels.chooseEnd,
    if (state.preview != null && !state.isPreviewValid)
      rangeLabels.unavailableRange,
  ]);

  String _dayLabel(DateTime date, NakedRangeCalendarState state) {
    final today = currentDate ?? DateTime.now();
    final committed = state.value;
    final draft = state.preview;
    return rangeLabels.joinDayLabel([
      labels.fullDate(date),
      if (isSameCivilDate(date, today)) labels.today,
      if (committed != null && isSameCivilDate(date, committed.start))
        rangeLabels.start,
      if (committed != null && isSameCivilDate(date, committed.end))
        rangeLabels.end,
      if (draft != null && draft.contains(date)) rangeLabels.draftRange,
      if (state.anchor != null && isSameCivilDate(date, state.anchor!))
        rangeLabels.draftStart,
      if (draft != null && isSameCivilDate(date, state.focusedDate))
        rangeLabels.draftEnd,
    ]);
  }

  Widget _day(
    DateTime date,
    NakedRangeCalendarState state,
    CalendarStyler effectiveStyle,
  ) => _calendarDay(
    date: date,
    semanticLabel: _dayLabel(date, state),
    style: effectiveStyle,
    styleSpec: styleSpec,
    labels: labels,
  );
}
