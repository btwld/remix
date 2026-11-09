import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';

@widgetbook.UseCase(name: 'Reporting period', type: RemixRangeCalendar)
Widget buildRangeCalendarUseCase(BuildContext context) =>
    const RangeCalendarExample();

class RangeCalendarExample extends StatefulWidget {
  const RangeCalendarExample({super.key});

  @override
  State<RangeCalendarExample> createState() => _RangeCalendarExampleState();
}

class _RangeCalendarExampleState extends State<RangeCalendarExample> {
  CivilDateRange? _value = CivilDateRange(
    start: DateTime(2026, 11, 10),
    end: DateTime(2026, 11, 13),
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(FortalTokens.space1.resolve(context)),
    child: Center(
      child: FortalRangeCalendar(
        value: _value,
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        semanticLabel: 'Reporting period',
        firstDayOfWeek: DateTime.monday,
        isDateUnavailable: (date) =>
            date.year == 2026 && date.month == 11 && date.day == 18,
        onChanged: (range) => setState(() => _value = range),
      ),
    ),
  );
}
