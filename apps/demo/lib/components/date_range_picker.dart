import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';
import 'calendar.dart' show calendarDemoSelectorStyle, calendarDemoTarget;
import 'range_calendar.dart' show reportingPeriodCalendarStyle;

// Picker widths are content bounds, with no matching Fortal spacing step.
const _pickerMinWidth = 260.0;
const _pickerPanelMaxWidth = 480.0;

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
    padding: EdgeInsets.all(FortalTokens.space1.resolve(context)),
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
        navigationStyle: fortalIconButtonStyle(
          variant: .ghost,
        ).size(calendarDemoTarget, calendarDemoTarget),
        selectorStyle: calendarDemoSelectorStyle(context),
        buttonStyle: fortalButtonStyle(variant: .outline)
            .minHeight(calendarDemoTarget)
            .minWidth(MediaQuery.textScalerOf(context).scale(_pickerMinWidth))
            .spacing(FortalTokens.space2())
            .icon(
              IconStyler().size(
                MediaQuery.textScalerOf(
                  context,
                ).scale(FortalTokens.space4.resolve(context)),
              ),
            ),
        popoverStyle: fortalPopoverStyle()
            .padding(.all(0))
            .maxWidth(
              MediaQuery.textScalerOf(context).scale(_pickerPanelMaxWidth),
            ),
        calendarStyle: reportingPeriodCalendarStyle
            .minWidth(
              MediaQuery.textScalerOf(context).scale(calendarDemoTarget) * 7 +
                  FortalTokens.space3.resolve(context) * 2,
            )
            .day(
              CalendarDayStyler()
                  .minWidth(
                    MediaQuery.textScalerOf(context).scale(calendarDemoTarget),
                  )
                  .minHeight(
                    MediaQuery.textScalerOf(context).scale(calendarDemoTarget),
                  ),
            ),
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
