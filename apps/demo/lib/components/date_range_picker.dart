import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';
import 'range_calendar.dart' show reportingPeriodCalendarStyle;

@widgetbook.UseCase(name: 'Reporting period', type: RemixDateRangePicker)
Widget buildDateRangePickerUseCase(BuildContext context) =>
    const DateRangePickerExample();

class DateRangePickerExample extends StatefulWidget {
  const DateRangePickerExample({super.key});

  @override
  State<DateRangePickerExample> createState() => _DateRangePickerExampleState();
}

class _DateRangePickerExampleState extends State<DateRangePickerExample> {
  CivilDateRange? _value = CivilDateRange(
    start: DateTime(2026, 11, 10),
    end: DateTime(2026, 11, 13),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4),
    child: Center(
      child: RemixDateRangePicker(
        value: _value,
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        semanticLabel: 'Reporting period',
        firstDayOfWeek: DateTime.monday,
        isDateUnavailable: (date) =>
            date.year == 2026 && date.month == 11 && date.day == 18,
        onChanged: (range) => setState(() => _value = range),
        navigationStyle: fortalIconButtonStyle(variant: .ghost).size(44, 44),
        selectorStyle: fortalSelectStyle(),
        buttonStyle: fortalButtonStyle(variant: .outline).minHeight(44),
        popoverStyle: fortalPopoverStyle(),
        calendarStyle: reportingPeriodCalendarStyle,
      ),
    ),
  );
}
