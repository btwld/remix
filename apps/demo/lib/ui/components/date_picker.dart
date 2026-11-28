import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../theme/theme.dart';
import 'calendar.dart';
import 'popover.dart';

/// Fortal's DatePicker composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class FortalDatePicker extends StatelessWidget {
  const FortalDatePicker({
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
    trailingIcon: RemixIcons.chevronDown,
    // The value fills the trigger so the chevron sits at its end.
    textBuilder: (context, spec, text) => SizedBox(
      width: double.infinity,
      child: Text(
        text,
        style: spec.style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    footerBuilder: (context, value) => fortalCalendarFooter(
      value == null ? calendarLabels.noDate : calendarLabels.fullDate(value),
    ),
    closeDelay: const Duration(milliseconds: 300),
    placeholderStyle: ButtonStyler().label(TextStyler().color(_placeholder())),
    expandedStyle: _triggerHover,
    buttonStyle: _trigger(context).merge(buttonStyle),
    popoverStyle: fortalPopoverStyle()
        .padding(.all(FortalTokens.space4()))
        .borderRadius(.all(FortalTokens.radius6()))
        .color(FortalTokens.colorPanelSolid())
        .width(MediaQuery.textScalerOf(context).scale(320))
        .panelTransition(fortalCalendarPanelTransition)
        .merge(popoverStyle),
    navigationStyle: fortalCalendarNavigationStyle(
      context,
    ).merge(navigationStyle),
    selectorStyle: fortalCalendarSelectorStyle(context).merge(selectorStyle),
    calendarStyle: fortalCalendarStyle(
      style: fortalCalendarGeometry(context, width: 288).merge(calendarStyle),
    ),
  );
}

/// The trigger: a 40px field with the control corner, a 1px gray 7 frame
/// on gray 2, a 16px muted calendar icon and chevron 9px from 13px tabular
/// text, 12px in from each side. It never scales; hover and the open state
/// mute it.
ButtonStyler _trigger(BuildContext context) {
  final scaler = MediaQuery.textScalerOf(context);

  return ButtonStyler()
      .minHeight(FortalTokens.controlHeight2())
      .minWidth(scaler.scale(200))
      .padding(.horizontal(FortalTokens.space3()))
      .spacing(9)
      .borderRadius(.all(FortalTokens.radius4()))
      .color(FortalTokens.gray2())
      .border(.all(.color(_frame()).width(FortalTokens.borderWidth1())))
      .mainAxisAlignment(.start)
      .label(
        TextStyler()
            .style(FortalTokens.text2.mix())
            .fontWeight(FortalTokens.fontWeightRegular())
            .fontFeatures(const [FontFeature.tabularFigures()])
            .color(FortalTokens.gray12()),
      )
      .icon(.size(scaler.scale(16)).color(FortalTokens.gray10()))
      .onHovered(_triggerHover)
      .onPressed(_triggerHover)
      .onDisabled(ButtonStyler().wrap(.opacity(0.5)))
      .animate(
        AnimationConfig.curve(
          duration: FortalMotion.fast,
          curve: FortalMotion.easeStandard,
        ),
      );
}

final _triggerHover = ButtonStyler()
    .color(FortalTokens.gray3())
    .border(.all(.color(_hoverFrame()).width(FortalTokens.borderWidth1())));

/// [rest] by default; [lifted] under the theme's high contrast.
ContextToken<Color> _orHighContrast(ColorToken rest, ColorToken lifted) =>
    ContextToken<Color>(
      (context) =>
          (FortalTheme.maybeOf(context)?.highContrast ?? false ? lifted : rest)
              .resolve(context),
    );

/// Gray 10 reads at about 4.1:1 on a light field.
final _placeholder = _orHighContrast(FortalTokens.gray10, FortalTokens.gray11);

/// Gray 7 and 8 frames sit under 1.5:1 on the field.
final _frame = _orHighContrast(FortalTokens.gray7, FortalTokens.controlBorder);
final _hoverFrame = _orHighContrast(
  FortalTokens.gray8,
  FortalTokens.controlBorder,
);
