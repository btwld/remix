import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
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
      firstDayOfWeek: DateTime.monday,
      isDateUnavailable: (date) => date.weekday >= DateTime.saturday,
      onChanged: (date) => setState(() => _value = date),
      buttonStyle: fortalButtonStyle(variant: .outline).minHeight(44),
      popoverStyle: fortalPopoverStyle(),
      navigationStyle: fortalIconButtonStyle(variant: .ghost).size(44, 44),
      selectorStyle: fortalSelectStyle(),
      calendarStyle: CalendarStyler().day(
        CalendarDayStyler()
            .borderRadius(.circular(6))
            .label(TextStyler().fontSize(14))
            .onSelected(
              CalendarDayStyler()
                  .color(const Color(0xFF3E63DD))
                  .label(TextStyler().color(const Color(0xFFFFFFFF))),
            )
            .onFocusVisible(
              CalendarDayStyler().border(
                .color(const Color(0xFF3E63DD)).width(2),
              ),
            )
            .onDisabled(
              CalendarDayStyler().label(
                TextStyler().color(const Color(0xFF8B8D98)),
              ),
            ),
      ),
    ),
  );
}
