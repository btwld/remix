import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
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
        icon: RemixIcons.calendar,
        placeholderStyle: ButtonStyler()
            .labelColor(FortalTokens.gray10())
            .labelFontWeight(FontWeight.w400),
        expandedStyle: ButtonStyler().border(
          .color(FortalTokens.focus8()).width(1),
        ),
        formatRange: _formatRange,
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
        buttonStyle: fortalButtonStyle(
          variant: .outline,
        ).minHeight(44).minWidth(260).spacing(8),
        popoverStyle: fortalPopoverStyle(),
        calendarStyle: reportingPeriodCalendarStyle,
      ),
    ),
  );
}

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
String _date(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}, ${date.year}';
String _formatRange(CivilDateRange range) {
  final start = range.start, end = range.end;
  if (start == end) return _date(start);
  if (start.year == end.year) {
    if (start.month == end.month)
      return '${_months[start.month - 1]} ${start.day}–${end.day}, ${end.year}';
    return '${_months[start.month - 1]} ${start.day} – ${_date(end)}';
  }
  return '${_date(start)} – ${_date(end)}';
}
