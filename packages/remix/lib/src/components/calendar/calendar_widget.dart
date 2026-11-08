part of 'calendar.dart';

/// Caller-owned date presentation. Defaults are explicitly English, not
/// automatic locale detection. Weekday callbacks use Monday=1 to Sunday=7.
@immutable
class RemixCalendarLabels {
  const RemixCalendarLabels({
    this.previousMonth = 'Previous month',
    this.nextMonth = 'Next month',
    this.chooseMonth = 'Choose month',
    this.chooseYear = 'Choose year',
    this.today = 'Today',
    this.noDate = 'No date selected',
    this.month = _englishMonth,
    this.monthYear = _englishMonthYear,
    this.fullDate = _englishFullDate,
    this.weekday = _englishWeekday,
    this.day = _numericDay,
    this.year = _numericYear,
    this.joinDayLabel = _joinDayLabel,
  });

  /// Accessible name of the previous-month button.
  final String previousMonth;

  /// Accessible name of the next-month button.
  final String nextMonth;

  /// Placeholder and accessible name of the month selector.
  final String chooseMonth;

  /// Placeholder and accessible name of the year selector.
  final String chooseYear;

  /// Appended to the accessible name of the current date.
  final String today;

  /// Accessible value of a date picker trigger without a selected date.
  ///
  /// The trigger's name is the picker's purpose; this replaces the selected
  /// date as its value, so assistive technology does not read the visible
  /// placeholder as if it were one.
  final String noDate;

  /// Month name for the month selector items.
  final String Function(int month) month;

  /// Header semantics label, such as "February 2024", announced as a live region.
  final String Function(DateTime) monthYear;

  /// Complete accessible date name for each day, including the weekday.
  final String Function(DateTime) fullDate;

  /// Weekday column heading for a Dart weekday (Monday=1 through Sunday=7).
  final String Function(int) weekday;

  /// Visible day number.
  final String Function(DateTime) day;

  /// Year label for the year selector items.
  final String Function(int) year;

  /// Joins the full date and contextual labels, such as today.
  final String Function(List<String> parts) joinDayLabel;

  static String _joinDayLabel(List<String> parts) => parts.join(', ');

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static String _englishMonth(int month) => _months[month - 1];
  static String _englishMonthYear(DateTime date) =>
      '${_englishMonth(date.month)} ${date.year}';
  static String _englishFullDate(DateTime date) =>
      '${_weekdays[date.weekday - 1]}, ${_englishMonth(date.month)} ${date.day}, ${date.year}';
  static String _englishWeekday(int weekday) =>
      _weekdays[weekday - 1].substring(0, 2);
  static String _numericDay(DateTime date) => '${date.day}';
  static String _numericYear(int year) => '$year';
}

/// A styled controlled single-date calendar with keyboard day navigation.
///
/// Selection is parent-owned. [onChanged] requests date-only civil fields,
/// using a UTC fallback only when a local date cannot preserve those fields.
/// Focus and month browsing never change the selected value. Null callbacks
/// disable the whole calendar. An Overlay ancestor is needed for the default
/// month/year selectors. Supply [headerBuilder] for alternative navigation.
class RemixCalendar extends StatelessWidget {
  const RemixCalendar({
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

  /// Creates a [CalendarStyler], for `RemixCalendar.styleFrom(...)`.
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
    return NakedCalendar(
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
        controller: NakedState.controllerOf<NakedCalendarState>(context),
        labels: labels,
        firstDayOfWeek: firstDayOfWeek,
        weeks: state.weeks,
        headerBuilder: (context, spec) =>
            headerBuilder?.call(context, state) ??
            _CalendarHeader(
              displayedMonth: state.displayedMonth,
              previousMonth: state.showPreviousMonth,
              nextMonth: state.showNextMonth,
              showMonth: state.showMonth,
              firstDate: firstDate,
              lastDate: lastDate,
              labels: labels,
              navigationStyle: navigationStyle,
              selectorStyle: selectorStyle,
              spec: spec,
            ),
        dayBuilder: (date) => _day(date, effectiveStyle),
      ),
    );
  }

  Widget _day(DateTime date, CalendarStyler effectiveStyle) => _calendarDay(
    date: date,
    semanticLabel: _dayLabel(date),
    style: effectiveStyle,
    styleSpec: styleSpec,
    labels: labels,
  );

  String _dayLabel(DateTime date) {
    final today = currentDate ?? DateTime.now();
    return isSameCivilDate(date, today)
        ? labels.joinDayLabel([labels.fullDate(date), labels.today])
        : labels.fullDate(date);
  }
}

/// One styled day, shared by single and range calendars.
///
/// The day style resolves under the day's own [NakedCalendarDayState], so
/// widget-state and calendar day variants (today, unavailable, range position)
/// apply per day, including on root animation frames: Mix builds nested day
/// styles, with their variants, for every frame. A raw [styleSpec] carries no
/// variants and renders every day with its `day` spec.
Widget _calendarDay({
  required DateTime date,
  required String semanticLabel,
  required CalendarStyler style,
  required CalendarSpec? styleSpec,
  required RemixCalendarLabels labels,
}) => NakedCalendarDay(
  date: date,
  semanticLabel: semanticLabel,
  builder: (context, day, _) => WidgetStateProvider(
    states: day.states,
    child: Builder(
      builder: (context) {
        // Merge unresolved inherited styles before resolving this day's
        // context and state variants. Only the day renders, not root effects.
        final resolved = styleSpec == null
            ? (Style.maybeOf<CalendarSpec>(context)?.merge(style) ?? style)
                  .build(context)
            : StyleSpec(spec: styleSpec);
        // Root animation can change day anatomy too. Consume its frame data
        // here without rendering the root modifiers again for every day.
        return StyleAnimationBuilder<CalendarSpec>(
          spec: resolved.copyWith(
            animation: remixChildAnimation<CalendarSpec>(resolved.animation),
          ),
          builder: (context, frame) => StyleSpecBuilder<CalendarDaySpec>(
            styleSpec: frame.spec.day,
            builder: (context, spec) {
              final label = StyledText(labels.day(date), styleSpec: spec.label);
              if (spec.containerEffects == null ||
                  spec.containerEffects!.isEmpty) {
                return Box(styleSpec: spec.container, child: label);
              }
              return RemixBoxAdapter(
                styleSpec: spec.container,
                containerEffects: spec.containerEffects,
                child: label,
              );
            },
          ),
        );
      },
    ),
  ),
);

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.displayedMonth,
    required this.previousMonth,
    required this.nextMonth,
    required this.showMonth,
    required this.firstDate,
    required this.lastDate,
    required this.labels,
    required this.navigationStyle,
    required this.selectorStyle,
    required this.spec,
  });
  final DateTime displayedMonth;
  final VoidCallback? previousMonth;
  final VoidCallback? nextMonth;
  final ValueChanged<DateTime>? showMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final RemixCalendarLabels labels;
  final IconButtonStyler navigationStyle;
  final SelectStyler selectorStyle;
  final CalendarSpec spec;

  Widget _navigation({required bool previous}) => RemixIconButton(
    icon: null,
    semanticLabel: previous ? labels.previousMonth : labels.nextMonth,
    onPressed: previous ? previousMonth : nextMonth,
    style: IconButtonStyler()
        .constraints(.minWidth(44).minHeight(44))
        .merge(navigationStyle),
    iconBuilder: (context, spec, _) => RemixPathIcon(
      glyph: previous
          ? RemixPathGlyph.chevronLeft
          : RemixPathGlyph.chevronRight,
      matchTextDirection: true,
      styleSpec: StyleSpec(spec: spec),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final date = displayedMonth;
    final showMonth = this.showMonth;
    final interactive = showMonth != null;
    return Semantics(
      container: true,
      explicitChildNodes: true,
      header: true,
      liveRegion: true,
      label: labels.monthYear(date),
      child: Row(
        children: [
          Expanded(child: _navigation(previous: true)),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: RemixSelect<int>(
                    positioning: const OverlayPositionConfig(
                      side: .bottom,
                      alignment: .center,
                      sideOffset: 4,
                    ),
                    trigger: RemixSelectTrigger(
                      placeholder: labels.chooseMonth,
                    ),
                    semanticLabel: labels.chooseMonth,
                    selectedValue: date.month,
                    enabled: interactive,
                    items: [
                      for (var month = 1; month <= 12; month++)
                        if ((date.year != firstDate.year ||
                                month >= firstDate.month) &&
                            (date.year != lastDate.year ||
                                month <= lastDate.month))
                          RemixSelectItem(
                            value: month,
                            label: labels.month(month),
                          ),
                    ],
                    onChanged: interactive
                        ? (month) {
                            if (month != null) {
                              showMonth(DateTime(date.year, month));
                            }
                          }
                        : null,
                    // Preserve the recipe height as a minimum so scaled labels fit.
                    style: selectorStyle.trigger(
                      SelectTriggerStyler().maxHeight(double.infinity),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: RemixSelect<int>(
                    positioning: const OverlayPositionConfig(
                      side: .bottom,
                      alignment: .center,
                      sideOffset: 4,
                    ),
                    trigger: RemixSelectTrigger(placeholder: labels.chooseYear),
                    semanticLabel: labels.chooseYear,
                    selectedValue: date.year,
                    enabled: interactive,
                    items: [
                      for (
                        var year = firstDate.year;
                        year <= lastDate.year;
                        year++
                      )
                        RemixSelectItem(value: year, label: labels.year(year)),
                    ],
                    onChanged: interactive
                        ? (year) {
                            if (year != null) {
                              showMonth(DateTime(year, date.month));
                            }
                          }
                        : null,
                    // Preserve the recipe height as a minimum so scaled labels fit.
                    style: selectorStyle.trigger(
                      SelectTriggerStyler().maxHeight(double.infinity),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _navigation(previous: false)),
        ],
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView({
    required this.style,
    required this.styleSpec,
    required this.controller,
    required this.labels,
    required this.firstDayOfWeek,
    required this.weeks,
    required this.headerBuilder,
    required this.dayBuilder,
    this.summary,
  });
  final CalendarStyler style;
  final CalendarSpec? styleSpec;
  final WidgetStatesController controller;
  final RemixCalendarLabels labels;
  final int firstDayOfWeek;
  final List<List<DateTime?>> weeks;
  final Widget Function(BuildContext, CalendarSpec) headerBuilder;
  final Widget Function(DateTime) dayBuilder;
  final String? summary;

  @override
  Widget build(BuildContext context) => RemixStyleSpecBuilder<CalendarSpec>(
    style: style,
    styleSpec: styleSpec,
    controller: controller,
    trackFocusVisibility: true,
    builder: (context, spec) {
      var container = spec.container;
      final bounds = container.spec.constraints ?? const BoxConstraints();
      if (!bounds.hasBoundedWidth) {
        // Keep the default compact without conflicting with caller minima.
        container = container.copyWith(
          spec: container.spec.copyWith(
            constraints: bounds.copyWith(
              maxWidth: bounds.minWidth > 308 ? bounds.minWidth : 308,
            ),
          ),
        );
      }
      return Box(
        styleSpec: container,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dayWidth =
                spec.day.spec.container.spec.constraints?.minWidth ?? 44.0;
            final minimumWidth = 7 * (dayWidth > 44 ? dayWidth : 44.0);
            final available = constraints.maxWidth;
            final width = available.isFinite && available > minimumWidth
                ? available
                : minimumWidth;
            return SingleChildScrollView(
              primary: false,
              child: SingleChildScrollView(
                primary: false,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      headerBuilder(context, spec),
                      SizedBox(height: spec.headerSpacing ?? 0),
                      if (summary != null)
                        Semantics(
                          liveRegion: true,
                          child: StyledText(summary!, styleSpec: spec.weekday),
                        ),
                      Row(
                        children: [
                          for (var i = 0; i < 7; i++)
                            Expanded(
                              child: Center(
                                child: ExcludeSemantics(
                                  child: StyledText(
                                    labels.weekday(
                                      (firstDayOfWeek - 1 + i) % 7 + 1,
                                    ),
                                    styleSpec: spec.weekday,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: spec.weekdaySpacing ?? 0),
                      for (final (index, week) in weeks.indexed) ...[
                        if (index > 0) SizedBox(height: spec.rowSpacing ?? 4),
                        Row(
                          children: [
                            for (final date in week)
                              Expanded(
                                child: date == null
                                    ? const SizedBox(height: 44)
                                    : dayBuilder(date),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
