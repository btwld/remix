part of 'calendar.dart';

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

  /// Styles the first day of a multi-day painted range interval.
  ///
  /// The painted interval is the draft while one exists, otherwise the
  /// committed value. Range variants rank with widget states: declare them
  /// after `onSelected` (and `onDisabled`) to override those on shared
  /// properties. A one-day interval uses [onRangeSingle] instead.
  CalendarDayStyler onRangeStart(CalendarDayStyler value) {
    return variant(_onRangeStartCalendarDayVariant, value);
  }

  /// Styles days strictly inside a multi-day painted range interval.
  ///
  /// Committed interior days are also selected; declare this after
  /// `onSelected` to override it.
  CalendarDayStyler onRangeMiddle(CalendarDayStyler value) {
    return variant(_onRangeMiddleCalendarDayVariant, value);
  }

  /// Styles the last day of a multi-day painted range interval.
  ///
  /// A one-day interval uses [onRangeSingle] instead.
  CalendarDayStyler onRangeEnd(CalendarDayStyler value) {
    return variant(_onRangeEndCalendarDayVariant, value);
  }

  /// Styles the only day of a one-day painted range interval, instead of
  /// combining [onRangeStart] and [onRangeEnd] caps.
  CalendarDayStyler onRangeSingle(CalendarDayStyler value) {
    return variant(_onRangeSingleCalendarDayVariant, value);
  }

  /// Styles every day of the local draft, from its anchor to the focused day.
  ///
  /// Draft days are never selected. Position variants declared after this one
  /// override it on shared properties, so caps can sit on a draft fill.
  CalendarDayStyler onRangePreview(CalendarDayStyler value) {
    return variant(_onRangePreviewCalendarDayVariant, value);
  }
}
