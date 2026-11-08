part of 'calendar.dart';

// Calendar day states that are not Flutter WidgetStates. Each day resolves its
// style under the NakedCalendarDayState it scopes, so these apply to days only.
// Mix merges context variants by identity; keys are diagnostic labels only.
// They are namespaced so calendar variants read unambiguously in diagnostics.

final _onTodayCalendarDayVariant = ContextVariant(
  'remix.calendar.day.today',
  (context) =>
      NakedState.maybeOf<NakedCalendarDayState>(context)?.isToday ?? false,
);

final _onUnavailableCalendarDayVariant = _DisabledContextVariant(
  'remix.calendar.day.unavailable',
  (context) =>
      NakedState.maybeOf<NakedCalendarDayState>(context)?.isUnavailable ??
      false,
);

/// An unavailable day is always disabled. Declaring that dependency ranks it
/// with widget-state variants, so it overrides `onDisabled` declared earlier.
final class _DisabledContextVariant extends ContextVariant {
  _DisabledContextVariant(super.key, super.shouldApply);

  @override
  Set<WidgetState> get widgetStateDependencies => const {WidgetState.disabled};
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
}
