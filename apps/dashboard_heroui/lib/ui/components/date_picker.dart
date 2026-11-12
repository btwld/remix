import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'calendar.dart';
import 'popover.dart';

/// HeroUI's reviewed DatePicker composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class UiDatePicker extends StatelessWidget {
  const UiDatePicker({
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
    this.semanticLabel = 'Choose date',
    this.placeholder = 'Select date',
    this.formatDate,
    this.calendarLabels = uiCalendarLabels,
    this.focusNode,
    this.autofocus = false,
    this.positioning = const OverlayPositionConfig(
      sideOffset: 8,
      collisionPadding: EdgeInsets.all(8),
    ),
    this.buttonStyle = const ButtonStyler.create(),
    this.calendarStyle = const CalendarStyler.create(),
    this.popoverStyle = const PopoverStyler.create(),
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
  });

  /// Parent-owned selected date, or null for an empty selection.
  /// Civil-date comparison and bounds follow [RemixCalendar].
  final DateTime? value;

  /// Inclusive earliest selectable civil date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable civil date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests one available date, then closes even if the parent rejects it.
  /// A null callback disables the picker.
  final ValueChanged<DateTime>? onChanged;

  /// Called when the picker's popover opens.
  final VoidCallback? onOpen;

  /// Called when the popover closes: after [onChanged] for a completed
  /// selection, or alone when the picker is dismissed without selecting.
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

  /// Field purpose and the trigger's accessible name, such as "Appointment
  /// date". The trigger's accessible value is the selected date from
  /// [RemixCalendarLabels.fullDate], or [RemixCalendarLabels.noDate].
  final String semanticLabel;

  /// Visible trigger text without a selected date.
  final String placeholder;

  /// Visible trigger date text. Defaults to [RemixCalendarLabels.fullDate].
  ///
  /// It only changes what is painted: the accessible value always uses the
  /// complete [RemixCalendarLabels.fullDate], so compact formats such as
  /// "20/2" are never announced as the date.
  final String Function(DateTime)? formatDate;

  /// Caller-owned date labels and formatters; English by default.
  final RemixCalendarLabels calendarLabels;

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

  @override
  Widget build(BuildContext context) => RemixDatePicker(
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
    calendarLabels: calendarLabels,
    formatDate: formatDate,
    focusNode: focusNode,
    autofocus: autofocus,
    positioning: positioning,
    icon: RemixIcons.calendar,
    placeholderStyle: ButtonStyler()
        .labelColor(UiTokens.fieldPlaceholder())
        .labelFontWeight(FontWeight.w400),
    expandedStyle: ButtonStyler()
        .color(UiTokens.fieldFocus())
        .containerEffects(uiFocusRing()),
    buttonStyle: uiDatePickerButtonStyle(context).merge(buttonStyle),
    popoverStyle: uiPopoverStyle()
        .padding(.all(0))
        .maxWidth(MediaQuery.textScalerOf(context).scale(480))
        .borderRadius(.all(uiCalendarPopoverRadius()))
        .merge(popoverStyle),
    navigationStyle: uiCalendarNavigationStyle(context).merge(navigationStyle),
    selectorStyle: uiCalendarSelectorStyle(context).merge(selectorStyle),
    calendarStyle: uiCalendarStyle(
      style: uiCalendarGeometry(context).merge(calendarStyle),
    ),
  );
}

/// Field-shaped button approximation of upstream's segmented DateField.
ButtonStyler uiDatePickerButtonStyle(BuildContext context) => ButtonStyler()
    .minHeight(40)
    .onBreakpoint(
      const Breakpoint.minWidth(UiTokens.breakpointSm),
      ButtonStyler().minHeight(36),
    )
    .minWidth(200)
    .padding(.horizontal(12))
    .padding(.vertical(8))
    .spacing(8)
    .iconAlignment(.end)
    .mainAxisAlignment(.spaceBetween)
    .borderRadius(.all(UiTokens.radiusField()))
    .color(UiTokens.fieldBackground())
    .label(
      TextStyler()
          .style(UiTokens.textBase.mix())
          .color(UiTokens.fieldForeground())
          .softWrap(true)
          .onBreakpoint(
            const Breakpoint.minWidth(UiTokens.breakpointSm),
            TextStyler().style(UiTokens.textSm.mix()),
          ),
    )
    .icon(
      .size(
        MediaQuery.textScalerOf(context).scale(16),
      ).color(UiTokens.fieldPlaceholder()),
    )
    .containerEffects(uiSurfaceEffects())
    .onHovered(.color(UiTokens.defaultColor()))
    .onPressed(.color(UiTokens.defaultHover()))
    .onFocusVisible(.containerEffects(uiFocusRing()))
    .onDisabled(ButtonStyler().wrap(.opacity(UiTokens.disabledOpacity)));

/// date-picker.css: min(32px, radius * 2.5).
final uiCalendarPopoverRadius = uiRadius(
  UiTokens.radiusLg,
  scale: 2.5,
  max: 32,
);
