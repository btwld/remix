part of 'date_picker.dart';

/// A button-triggered, controlled complete inclusive date-range calendar.
///
/// The first eligible activation starts a draft and keeps the picker open.
/// The second requests one complete range and closes even if the parent rejects
/// it. Dismissal never selects; every outer open starts a fresh draft session.
/// Unavailable endpoints or interior dates prevent completion without closing.
///
/// An Overlay ancestor is required. Labels are explicitly English by default;
/// callers own localization through [placeholder], [semanticLabel], [formatRange],
/// [calendarLabels] and [rangeLabels]. Selection remains parent-owned; there is
/// no partial value or public open/draft controller.
/// The popover contains focus but is not a modal dialog. Scrolling an ancestor
/// closes a root picker. A picker nested in a menu or popover closes when that
/// outer root closes. Removing an open picker does not call [onClose].
class RemixDateRangePicker extends StatelessWidget {
  const RemixDateRangePicker({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.onOpen,
    this.onClose,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel = 'Choose date range',
    this.placeholder = 'Select date range',
    this.formatRange,
    this.calendarLabels = const RemixCalendarLabels(),
    this.rangeLabels = const RemixRangeCalendarLabels(),
    this.focusNode,
    this.autofocus = false,
    this.positioning = const OverlayPositionConfig(
      sideOffset: 4,
      collisionPadding: EdgeInsets.all(8),
    ),
    this.buttonStyle = const ButtonStyler.create(),
    this.calendarStyle = const CalendarStyler.create(),
    this.popoverStyle = const PopoverStyler.create(),
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
    this.summaryBuilder,
  });

  /// Parent-owned complete inclusive range, or null for an empty selection.
  /// Civil-date comparison and bounds follow [RemixRangeCalendar].
  final CivilDateRange? value;

  /// Inclusive earliest selectable civil date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable civil date, on or after [firstDate].
  final DateTime lastDate;

  /// Complete-range request. Null disables the trigger and calendar.
  final ValueChanged<CivilDateRange>? onChanged;

  /// Called when the picker's popover opens.
  final VoidCallback? onOpen;

  /// Called when the popover closes: after [onChanged] for a completed range,
  /// or alone when the picker is dismissed with or without a draft.
  /// Removing an open picker does not call this callback.
  final VoidCallback? onClose;

  /// Today marker and fallback focus date; defaults to the current date.
  final DateTime? currentDate;

  /// Marks in-range dates unselectable while keeping them keyboard-focusable.
  final bool Function(DateTime)? isDateUnavailable;

  /// First weekday column, from Monday=1 through Sunday=7.
  final int firstDayOfWeek;

  /// Whether the trigger can open the calendar and dates can be selected.
  /// Disabling an open picker closes it without selecting.
  final bool enabled;

  /// Field purpose and the trigger's accessible name, such as "Stay dates".
  /// The trigger's accessible value is the complete range from
  /// [RemixRangeCalendarLabels.rangeValue], a one-day range's single date, or
  /// [RemixRangeCalendarLabels.noRange].
  final String semanticLabel;

  /// Visible trigger text without a complete range.
  final String placeholder;

  /// Visible trigger text for a complete range. Defaults to the
  /// [RemixCalendarLabels.fullDate] endpoints joined by an en dash, or the
  /// single date of a one-day range; those labels are English unless
  /// [calendarLabels] is localized. Provide this callback for locale-specific
  /// range grammar. It only changes what is painted, never the accessible
  /// value.
  final String Function(CivilDateRange)? formatRange;

  /// Caller-owned date labels and formatters; English by default.
  final RemixCalendarLabels calendarLabels;

  /// Caller-owned range roles, summaries and accessible values; English by default.
  final RemixRangeCalendarLabels rangeLabels;

  /// Optional caller-owned trigger focus node. Replacing it closes the picker.
  final FocusNode? focusNode;

  /// Whether to focus the trigger automatically; does not open the calendar.
  final bool autofocus;

  /// Panel placement, offsets and collision padding relative to the trigger.
  /// The panel also avoids the view's safe area and keyboard exclusions.
  final OverlayPositionConfig positioning;

  /// Trigger styling, resolved against the trigger's own interaction state.
  final ButtonStyler buttonStyle;

  /// Calendar and day styling, resolved against each part's own state.
  final CalendarStyler calendarStyle;

  /// Styling for the popover panel containing the calendar.
  final PopoverStyler popoverStyle;

  /// Month-navigation button styling, resolved in each button's state.
  final IconButtonStyler navigationStyle;

  /// Month/year selector styling, resolved in each selector’s state.
  final SelectStyler selectorStyle;

  /// Paints the calendar's range summary; see
  /// [RemixRangeCalendar.summaryBuilder]. Unpainted, but still announced, by
  /// default.
  final Widget Function(BuildContext context, String summary)? summaryBuilder;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    final singleDay = value != null && isSameCivilDate(value.start, value.end);
    final String? spoken;
    if (value == null) {
      spoken = null;
    } else if (singleDay) {
      spoken = calendarLabels.fullDate(value.start);
    } else {
      spoken = rangeLabels.rangeValue(
        calendarLabels.fullDate(value.start),
        calendarLabels.fullDate(value.end),
      );
    }
    final label = value == null
        ? placeholder
        : formatRange?.call(value) ??
              (singleDay
                  ? calendarLabels.fullDate(value.start)
                  : '${calendarLabels.fullDate(value.start)} – '
                        '${calendarLabels.fullDate(value.end)}');
    return _DatePickerHost<CivilDateRange>(
      enabled: enabled,
      onChanged: onChanged,
      onOpen: onOpen,
      onClose: onClose,
      label: label,
      semanticLabel: semanticLabel,
      semanticValue: spoken ?? rangeLabels.noRange,
      focusNode: focusNode,
      autofocus: autofocus,
      positioning: positioning,
      buttonStyle: buttonStyle,
      popoverStyle: popoverStyle,
      calendarBuilder: (focus, select) => RemixRangeCalendar(
        value: value,
        firstDate: firstDate,
        lastDate: lastDate,
        onChanged: select,
        currentDate: currentDate,
        isDateUnavailable: isDateUnavailable,
        firstDayOfWeek: firstDayOfWeek,
        enabled: select != null,
        semanticLabel: semanticLabel,
        focusNode: focus,
        labels: calendarLabels,
        rangeLabels: rangeLabels,
        style: calendarStyle,
        navigationStyle: navigationStyle,
        selectorStyle: selectorStyle,
        summaryBuilder: summaryBuilder,
      ),
    );
  }
}
