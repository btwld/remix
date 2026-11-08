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
  });

  final String start;
  final String end;
  final String draftStart;
  final String draftEnd;
  final String draftRange;
  final String chooseStart;
  final String chooseEnd;
  final String unavailableRange;
  final String invalidRange;

  /// Formats already-localized endpoint names, not raw DateTime values.
  final String Function(String start, String end) selectedRange;

  static String _selectedRange(String start, String end) =>
      'Selected range: $start to $end';
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
  });

  final NakedDateRange? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<NakedDateRange>? onChanged;
  final DateTime? currentDate;
  final bool Function(DateTime)? isDateUnavailable;
  final int firstDayOfWeek;
  final bool enabled;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final RemixCalendarLabels labels;
  final RemixRangeCalendarLabels rangeLabels;
  final Widget Function(BuildContext, NakedRangeCalendarState)? headerBuilder;
  final IconButtonStyler navigationStyle;
  final SelectStyler selectorStyle;
  final CalendarStyler style;

  /// Raw resolved spec; bypasses [style] and inherited styles.
  ///
  /// A resolved spec carries no variants, so every day renders its `day` spec:
  /// selection, availability and range positions are not painted. Use [style]
  /// for state and range styling.
  final CalendarSpec? styleSpec;

  static final styleFrom = CalendarStyler.new;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = CalendarStyler(
      day: CalendarDayStyler(
        container: BoxStyler()
            .constraints(.minWidth(44).minHeight(44))
            .alignment(Alignment.center),
      ),
    ).merge(style);
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

  String _summary(NakedRangeCalendarState state) => [
    if (state.value case final value?)
      rangeLabels.selectedRange(
        labels.fullDate(value.start),
        labels.fullDate(value.end),
      ),
    if (!state.isValueValid) rangeLabels.invalidRange,
    state.anchor == null ? rangeLabels.chooseStart : rangeLabels.chooseEnd,
    if (state.preview != null && !state.isPreviewValid)
      rangeLabels.unavailableRange,
  ].join('. ');

  String _dayLabel(DateTime date, NakedRangeCalendarState state) {
    final today = currentDate ?? DateTime.now();
    final committed = state.value;
    final draft = state.preview;
    return [
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
    ].join(', ');
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
