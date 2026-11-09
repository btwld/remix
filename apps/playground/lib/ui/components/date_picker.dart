import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';
import 'button.dart';
import 'calendar.dart';
import 'icon_button.dart';
import 'popover.dart';
import 'select.dart';

/// The application's DatePicker composite.
///
/// Remix owns the trigger, overlay positioning, focus restoration, dismissal
/// and controlled selection. This facade wires the Playground outline Button,
/// Popover and Calendar recipes; callers override each child styler last.
///
/// Several independent child stylers require a hand-written composite rather
/// than a generated single-style adapter. There is no generated part.
class PlaygroundDatePicker extends StatelessWidget {
  const PlaygroundDatePicker({
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
    this.calendarLabels = const RemixCalendarLabels(),
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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => RemixDatePicker(
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
      formatDate: formatDate,
      calendarLabels: calendarLabels,
      focusNode: focusNode,
      autofocus: autofocus,
      positioning: positioning,
      icon: RemixIcons.calendar,
      placeholderStyle: ButtonStyler().label(
        .color(PlaygroundTokens.mutedForeground()),
      ),
      expandedStyle: ButtonStyler()
          .border(playgroundFocusBorder())
          .containerEffects(playgroundFocusRing()),
      buttonStyle: playgroundButtonStyle(
        variant: .outline,
        style: ButtonStyler()
            .mainAxisAlignment(.start)
            .minWidth(PlaygroundTokens.s16 * 3 + PlaygroundTokens.s12)
            .padding(.horizontal(PlaygroundTokens.s3))
            .label(
              .fontWeight(
                FontWeight.w400,
              ).textAlign(.start).maxLines(1).overflow(.ellipsis),
            )
            .merge(buttonStyle),
      ),
      calendarStyle: playgroundCalendarStyle(
        style: CalendarStyler()
            .day(
              CalendarDayStyler().minWidth(
                MediaQuery.textScalerOf(context).scale(PlaygroundTokens.s12),
              ),
            )
            .merge(calendarStyle),
      ),
      popoverStyle: playgroundPopoverStyle(
        style: PopoverStyler()
            .minWidth(
              math.max(
                MediaQuery.textScalerOf(context).scale(PlaygroundTokens.s12) *
                        DateTime.daysPerWeek +
                    PlaygroundTokens.s3 * 2 +
                    PlaygroundTokens.s1 * 2 +
                    PlaygroundTokens.strokeHairline * 2,
                math.max(
                  constraints.minWidth,
                  buttonStyle
                          .build(context)
                          .spec
                          .container
                          .spec
                          .box
                          ?.spec
                          .constraints
                          ?.minWidth ??
                      0,
                ),
              ),
            )
            .maxWidth(double.infinity)
            .padding(.all(PlaygroundTokens.s1))
            .merge(popoverStyle),
      ),
      navigationStyle: playgroundIconButtonStyle(
        variant: .ghost,
        style: IconButtonStyler()
            .size(PlaygroundTokens.s12, PlaygroundTokens.s12)
            .margin(.symmetric(vertical: PlaygroundTokens.s1))
            .icon(
              .size(
                MediaQuery.textScalerOf(context).scale(PlaygroundTokens.icon),
              ),
            )
            .merge(navigationStyle),
      ),
      selectorStyle: playgroundSelectStyle(
        style: SelectStyler()
            .trigger(
              SelectTriggerStyler()
                  .indicator(
                    .size(
                      MediaQuery.textScalerOf(
                        context,
                      ).scale(PlaygroundTokens.s2_5),
                    ),
                  )
                  .maxWidth(double.infinity)
                  .minHeight(
                    MediaQuery.textScalerOf(
                      context,
                    ).scale(PlaygroundTokens.controlMd),
                  )
                  .minWidth(
                    MediaQuery.textScalerOf(
                      context,
                    ).scale(PlaygroundTokens.s16 + PlaygroundTokens.s12),
                  ),
            )
            .merge(selectorStyle),
      ),
    ),
  );
}
