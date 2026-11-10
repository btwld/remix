part of 'calendar.dart';

extension RemixCalendarStylerRemixHelpers on CalendarStyler {
  /// Builds a [RemixCalendar] with this style.
  RemixCalendar call({
    Key? key,
    required DateTime? value,
    required DateTime firstDate,
    required DateTime lastDate,
    ValueChanged<DateTime>? onChanged,
    DateTime? currentDate,
    bool Function(DateTime)? isDateUnavailable,
    int firstDayOfWeek = DateTime.sunday,
    bool enabled = true,
    String? semanticLabel,
    FocusNode? focusNode,
    bool autofocus = false,
    RemixCalendarLabels labels = const RemixCalendarLabels(),
    Widget Function(BuildContext, NakedCalendarState)? headerBuilder,
    IconButtonStyler navigationStyle = const IconButtonStyler.create(),
    SelectStyler selectorStyle = const SelectStyler.create(),
  }) {
    return RemixCalendar(
      key: key,
      style: this,
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
      headerBuilder: headerBuilder,
      navigationStyle: navigationStyle,
      selectorStyle: selectorStyle,
    );
  }
}

// Calendar day states that are not Flutter WidgetStates. Each day resolves its
// style under the NakedCalendarDayState it scopes, so these apply to days only.
// Mix merges context variants by identity; keys are diagnostic labels only.
// They are namespaced so calendar variants read unambiguously in diagnostics.

NakedCalendarDayState? _dayState(BuildContext context) =>
    NakedState.maybeOf<NakedCalendarDayState>(context);

final _onTodayCalendarDayVariant = ContextVariant(
  'remix.calendar.day.today',
  (context) => _dayState(context)?.isToday ?? false,
);

final _onUnavailableCalendarDayVariant = _StateRankedContextVariant(
  'remix.calendar.day.unavailable',
  const {WidgetState.disabled},
  (context) => _dayState(context)?.isUnavailable ?? false,
);

_StateRankedContextVariant _rangeVariant(
  String name,
  bool Function(NakedCalendarDayState day) applies,
) => _StateRankedContextVariant(
  'remix.calendar.day.$name',
  const {WidgetState.selected},
  (context) {
    final day = _dayState(context);
    return day != null && applies(day);
  },
);

final _onRangeStartCalendarDayVariant = _rangeVariant(
  'range-start',
  (day) => day.rangePosition == NakedRangePosition.start,
);
final _onRangeMiddleCalendarDayVariant = _rangeVariant(
  'range-middle',
  (day) => day.rangePosition == NakedRangePosition.middle,
);
final _onRangeEndCalendarDayVariant = _rangeVariant(
  'range-end',
  (day) => day.rangePosition == NakedRangePosition.end,
);
final _onRangeSingleCalendarDayVariant = _rangeVariant(
  'range-single',
  (day) => day.rangePosition == NakedRangePosition.single,
);
final _onRangePreviewCalendarDayVariant = _rangeVariant(
  'range-preview',
  (day) => day.isInPreview,
);

/// Ranks a day condition with widget-state variants, which Mix applies after
/// plain context variants. Declared after `onSelected` or `onDisabled`, it
/// overrides them on shared properties; declared before, they override it.
// Mix 2.3.1 lib/src/core/style.dart mergeActiveVariants uses a stable partition
// by widget-state dependencies, preserving declaration order within each group
// (Mix CHANGELOG 2.2.0, "Declaration order within a priority group is reliable").
// Merging a variant key across layers retains its first-declaration position.
final class _StateRankedContextVariant extends ContextVariant {
  _StateRankedContextVariant(
    super.key,
    this.widgetStateDependencies,
    super.shouldApply,
  );

  @override
  final Set<WidgetState> widgetStateDependencies;
}

extension RemixCalendarDayStylerRemixHelpers on CalendarDayStyler {
  /// Styles the day matching the calendar's current date.
  ///
  /// Widget-state variants such as `onSelected` take precedence on shared
  /// properties, so a selected today still reads as selected.
  CalendarDayStyler onToday(CalendarDayStyler value) {
    return variant(_onTodayCalendarDayVariant, value);
  }

  /// Styles in-bounds days that `isDateUnavailable` rejects.
  ///
  /// These days are also disabled; declare this after `onDisabled` to override
  /// it. Days outside `firstDate`/`lastDate` are disabled but not unavailable.
  CalendarDayStyler onUnavailable(CalendarDayStyler value) {
    return variant(_onUnavailableCalendarDayVariant, value);
  }

  /// Styles the first day of a multi-day interval in [RemixRangeCalendar] only.
  ///
  /// The painted interval is the draft while one exists, otherwise the
  /// committed value. Range variants rank with widget states: declare them
  /// after `onSelected` (and `onDisabled`) to override those on shared
  /// properties. A one-day interval uses [onRangeSingle] instead.
  CalendarDayStyler onRangeStart(CalendarDayStyler value) {
    return variant(_onRangeStartCalendarDayVariant, value);
  }

  /// Styles interior days of a multi-day interval in [RemixRangeCalendar] only.
  ///
  /// Committed interior days are also selected; declare this after
  /// `onSelected` to override it.
  CalendarDayStyler onRangeMiddle(CalendarDayStyler value) {
    return variant(_onRangeMiddleCalendarDayVariant, value);
  }

  /// Styles the last day of a multi-day interval in [RemixRangeCalendar] only.
  ///
  /// A one-day interval uses [onRangeSingle] instead.
  CalendarDayStyler onRangeEnd(CalendarDayStyler value) {
    return variant(_onRangeEndCalendarDayVariant, value);
  }

  /// Styles a one-day interval in [RemixRangeCalendar] only, instead of
  /// combining [onRangeStart] and [onRangeEnd] caps.
  CalendarDayStyler onRangeSingle(CalendarDayStyler value) {
    return variant(_onRangeSingleCalendarDayVariant, value);
  }

  /// Styles the local draft in [RemixRangeCalendar] only, from its anchor to
  /// the focused day.
  ///
  /// Draft days are never selected. Position variants declared after this one
  /// override it on shared properties, so caps can sit on a draft fill.
  CalendarDayStyler onRangePreview(CalendarDayStyler value) {
    return variant(_onRangePreviewCalendarDayVariant, value);
  }
}
