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
    child: FortalDatePicker(
      value: _value,
      firstDate: DateTime(2025),
      lastDate: DateTime(2028, 12, 31),
      currentDate: DateTime(2026, 11, 6),
      semanticLabel: 'Appointment date',
      placeholder: 'Select a date',
      formatDate: (date) =>
          '${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.day}, ${date.year}',
      firstDayOfWeek: DateTime.monday,
      isDateUnavailable: (date) => date.weekday >= DateTime.saturday,
      onChanged: (date) => setState(() => _value = date),
    ),
  );
}
