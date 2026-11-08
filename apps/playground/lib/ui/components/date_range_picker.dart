import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';
import 'button.dart';
import 'range_calendar.dart';
import 'icon_button.dart';
import 'popover.dart';
import 'select.dart';

/// The application's DateRangePicker composite.
///
/// Remix owns the trigger, overlay positioning, focus restoration, dismissal
/// and controlled selection. This facade wires the Playground outline Button,
/// Popover and RangeCalendar recipes; callers override each child styler last.
///
/// Several independent child stylers require a hand-written composite rather
/// than a generated single-style adapter. There is no generated part.
class PlaygroundDateRangePicker extends StatelessWidget {
  const PlaygroundDateRangePicker({
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
      sideOffset: PlaygroundTokens.s1,
      collisionPadding: EdgeInsets.all(PlaygroundTokens.s2),
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
  Widget build(BuildContext context) => RemixDateRangePicker(
    value: value,
    firstDate: firstDate,
    lastDate: lastDate,
    onChanged: onChanged,
    onOpen: onOpen,
    onClose: onClose,
    currentDate: currentDate,
    isDateUnavailable: isDateUnavailable,
    firstDayOfWeek: firstDayOfWeek,
    enabled: enabled,
    semanticLabel: semanticLabel,
    placeholder: placeholder,
    formatRange: formatRange,
    calendarLabels: calendarLabels,
    rangeLabels: rangeLabels,
    focusNode: focusNode,
    autofocus: autofocus,
    positioning: positioning,
    buttonStyle: playgroundButtonStyle(variant: .outline, style: buttonStyle),
    calendarStyle: playgroundRangeCalendarStyle(style: calendarStyle),
    popoverStyle: playgroundPopoverStyle(
      style: PopoverStyler()
          .width(
            PlaygroundTokens.s12 * DateTime.daysPerWeek +
                PlaygroundTokens.s3 * 2 +
                PlaygroundTokens.s1 * 2 +
                PlaygroundTokens.strokeHairline * 2,
          )
          .padding(.all(PlaygroundTokens.s1))
          .merge(popoverStyle),
    ),
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
    summaryBuilder: summaryBuilder,
  );
}
