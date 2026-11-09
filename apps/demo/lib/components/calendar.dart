import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';

@widgetbook.UseCase(name: 'Appointment date', type: RemixCalendar)
Widget buildCalendarUseCase(BuildContext context) => const CalendarExample();

class CalendarExample extends StatefulWidget {
  const CalendarExample({super.key});

  @override
  State<CalendarExample> createState() => _CalendarExampleState();
}

class _CalendarExampleState extends State<CalendarExample> {
  DateTime? _value = DateTime(2026, 11, 12);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(FortalTokens.space1.resolve(context)),
    child: Center(
      child: FortalCalendar(
        value: _value,
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        semanticLabel: 'Appointment date',
        firstDayOfWeek: DateTime.monday,
        isDateUnavailable: (date) => date.weekday >= DateTime.saturday,
        onChanged: (date) => setState(() => _value = date),
      ),
    ),
  );
}
