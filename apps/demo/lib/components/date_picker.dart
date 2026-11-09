import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';

@widgetbook.UseCase(name: 'Appointment date', type: RemixDatePicker)
Widget buildDatePickerUseCase(BuildContext context) =>
    const DatePickerExample();

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? _value;

  @override
  Widget build(BuildContext context) => Center(
    child: RemixDatePicker(
      value: _value,
      firstDate: DateTime(2025),
      lastDate: DateTime(2028, 12, 31),
      currentDate: DateTime(2026, 11, 6),
      semanticLabel: 'Appointment date',
      placeholder: 'Select a date',
      icon: RemixIcons.calendar,
      placeholderStyle: ButtonStyler()
          .labelColor(FortalTokens.gray10())
          .labelFontWeight(FontWeight.w400),
      expandedStyle: ButtonStyler().border(
        .color(FortalTokens.focus8()).width(1),
      ),
      formatDate: (date) =>
          '${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.day}, ${date.year}',
      firstDayOfWeek: DateTime.monday,
      isDateUnavailable: (date) => date.weekday >= DateTime.saturday,
      onChanged: (date) => setState(() => _value = date),
      buttonStyle: fortalButtonStyle(variant: .outline)
          .minHeight(44)
          .minWidth(MediaQuery.textScalerOf(context).scale(200))
          .spacing(8),
      popoverStyle: fortalPopoverStyle().maxWidth(
        MediaQuery.textScalerOf(context).scale(480),
      ),
      navigationStyle: fortalIconButtonStyle(variant: .ghost).size(44, 44),
      selectorStyle: fortalSelectStyle().trigger(
        SelectTriggerStyler().width(
          MediaQuery.textScalerOf(context).scale(146),
        ),
      ),
      calendarStyle: CalendarStyler()
          .minWidth(MediaQuery.textScalerOf(context).scale(308))
          .weekday(TextStyler().fontSize(12).color(FortalTokens.gray11()))
          .day(
            CalendarDayStyler()
                .borderRadius(.circular(6))
                .label(TextStyler().fontSize(14))
                .onToday(
                  CalendarDayStyler().label(
                    TextStyler()
                        .color(FortalTokens.accent11())
                        .fontWeight(FontWeight.w600),
                  ),
                )
                .onSelected(
                  CalendarDayStyler()
                      .color(FortalTokens.accentSolid())
                      .label(TextStyler().color(FortalTokens.accentContrast())),
                )
                .onFocusVisible(
                  CalendarDayStyler().border(
                    .color(FortalTokens.focus8()).width(2),
                  ),
                )
                .onDisabled(
                  CalendarDayStyler().label(
                    TextStyler().color(FortalTokens.gray9()),
                  ),
                )
                .onUnavailable(
                  CalendarDayStyler().label(
                    TextStyler().decoration(TextDecoration.lineThrough),
                  ),
                ),
          ),
    ),
  );
}
