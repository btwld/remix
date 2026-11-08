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
    this.month = _englishMonth,
    this.monthYear = _englishMonthYear,
    this.fullDate = _englishFullDate,
    this.weekday = _englishWeekday,
    this.day = _numericDay,
    this.year = _numericYear,
  });
  final String previousMonth;
  final String nextMonth;
  final String chooseMonth;
  final String chooseYear;
  final String today;
  final String Function(DateTime) month;
  final String Function(DateTime) monthYear;
  final String Function(DateTime) fullDate;
  final String Function(int) weekday;
  final String Function(DateTime) day;
  final String Function(int) year;

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
  static String _englishMonth(DateTime date) => _months[date.month - 1];
  static String _englishMonthYear(DateTime date) =>
      '${_englishMonth(date)} ${date.year}';
  static String _englishFullDate(DateTime date) =>
      '${_weekdays[date.weekday - 1]}, ${_englishMonth(date)} ${date.day}, ${date.year}';
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
  final DateTime? value;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onChanged;
  final DateTime? currentDate;
  final bool Function(DateTime)? isDateUnavailable;
  final int firstDayOfWeek;
  final bool enabled;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool autofocus;
  final RemixCalendarLabels labels;

  /// Replaces header visuals/navigation only. Day behavior remains owned.
  final Widget Function(BuildContext, NakedCalendarState)? headerBuilder;

  /// Independent button styling, resolved in each navigation button state.
  final IconButtonStyler navigationStyle;

  /// Independent month/year selector styling.
  final SelectStyler selectorStyle;
  final CalendarStyler style;
  final CalendarSpec? styleSpec;
  static final styleFrom = CalendarStyler.new;

  Widget _navigation(NakedCalendarState state, {required bool previous}) =>
      RemixIconButton(
        icon: null,
        semanticLabel: previous ? labels.previousMonth : labels.nextMonth,
        onPressed: previous ? state.previousMonth : state.nextMonth,
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

  Widget _header(
    BuildContext context,
    NakedCalendarState state,
    CalendarSpec spec,
  ) {
    final date = state.displayedMonth;
    final interactive = state.showMonth != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _navigation(state, previous: true),
            Expanded(
              child: Center(
                child: Semantics(
                  header: true,
                  liveRegion: true,
                  child: StyledText(
                    labels.monthYear(date),
                    styleSpec: spec.heading,
                  ),
                ),
              ),
            ),
            _navigation(state, previous: false),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 146,
              child: RemixSelect<int>(
                trigger: RemixSelectTrigger(placeholder: labels.chooseMonth),
                semanticLabel: labels.chooseMonth,
                selectedValue: date.month,
                enabled: interactive,
                items: [
                  for (var month = 1; month <= 12; month++)
                    if ((date.year != firstDate.year ||
                            month >= firstDate.month) &&
                        (date.year != lastDate.year || month <= lastDate.month))
                      RemixSelectItem(
                        value: month,
                        label: labels.month(DateTime(date.year, month)),
                      ),
                ],
                onChanged: interactive
                    ? (month) {
                        if (month != null)
                          state.showMonth!(DateTime(date.year, month));
                      }
                    : null,
                style: selectorStyle,
              ),
            ),
            SizedBox(
              width: 146,
              child: RemixSelect<int>(
                trigger: RemixSelectTrigger(placeholder: labels.chooseYear),
                semanticLabel: labels.chooseYear,
                selectedValue: date.year,
                enabled: interactive,
                items: [
                  for (var year = firstDate.year; year <= lastDate.year; year++)
                    RemixSelectItem(value: year, label: labels.year(year)),
                ],
                onChanged: interactive
                    ? (year) {
                        if (year != null)
                          state.showMonth!(DateTime(year, date.month));
                      }
                    : null,
                style: selectorStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }

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
      builder: (context, state, _) => RemixStyleSpecBuilder<CalendarSpec>(
        style: effectiveStyle,
        styleSpec: styleSpec,
        controller: NakedState.controllerOf<NakedCalendarState>(context),
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
                          headerBuilder?.call(context, state) ??
                              _header(context, state, spec),
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
                          for (final week in state.weeks)
                            Row(
                              children: [
                                for (final date in week)
                                  Expanded(
                                    child: date == null
                                        ? const SizedBox(height: 44)
                                        : _day(date, effectiveStyle),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _day(DateTime date, CalendarStyler effectiveStyle) => NakedCalendarDay(
    date: date,
    semanticLabel: _dayLabel(date),
    builder: (context, day, _) => WidgetStateProvider(
      states: day.states,
      child: Builder(
        builder: (context) {
          // Merge unresolved inherited styles before resolving this day's
          // context and state variants. Only the day renders, not root effects.
          final resolved = styleSpec == null
              ? (Style.maybeOf<CalendarSpec>(context)?.merge(effectiveStyle) ??
                        effectiveStyle)
                    .build(context)
              : StyleSpec(spec: styleSpec!);
          // Root animation can change day anatomy too. Consume its frame data
          // here without rendering the root modifiers again for every day.
          return StyleAnimationBuilder<CalendarSpec>(
            spec: resolved.copyWith(
              animation: remixChildAnimation<CalendarSpec>(resolved.animation),
            ),
            builder: (context, frame) => StyleSpecBuilder<CalendarDaySpec>(
              styleSpec: frame.spec.day,
              builder: (context, spec) => Box(
                styleSpec: spec.container,
                child: StyledText(labels.day(date), styleSpec: spec.label),
              ),
            ),
          );
        },
      ),
    ),
  );

  String _dayLabel(DateTime date) {
    final today = currentDate ?? DateTime.now();
    final isToday =
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
    return isToday
        ? '${labels.fullDate(date)}, ${labels.today}'
        : labels.fullDate(date);
  }
}
