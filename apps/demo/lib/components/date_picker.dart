import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';
import 'calendar.dart' show appointmentCalendarStyle, calendarDemoSelectorStyle;

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
      popoverStyle: fortalPopoverStyle()
          .padding(.all(0))
          .maxWidth(MediaQuery.textScalerOf(context).scale(480)),
      navigationStyle: fortalIconButtonStyle(variant: .ghost).size(44, 44),
      selectorStyle: calendarDemoSelectorStyle(context),
      calendarStyle: appointmentCalendarStyle(context),
    ),
  );
}
