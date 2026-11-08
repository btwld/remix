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
    padding: const EdgeInsets.all(4),
    child: Center(
      child: RemixCalendar(
        value: _value,
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        semanticLabel: 'Appointment date',
        firstDayOfWeek: DateTime.monday,
        isDateUnavailable: (date) => date.weekday >= DateTime.saturday,
        onChanged: (date) => setState(() => _value = date),
        navigationStyle: fortalIconButtonStyle(variant: .ghost).size(44, 44),
        selectorStyle: fortalSelectStyle(),
        style: CalendarStyler()
            .weekday(TextStyler().fontSize(12).color(FortalTokens.gray11()))
            .day(
              CalendarDayStyler()
                  .borderRadius(.circular(6))
                  .label(TextStyler().fontSize(14))
                  .onHovered(CalendarDayStyler().color(FortalTokens.gray4()))
                  .onToday(
                    CalendarDayStyler()
                        .border(.color(FortalTokens.accent8()).width(1))
                        .label(
                          TextStyler()
                              .color(FortalTokens.accent11())
                              .fontWeight(FontWeight.w700),
                        ),
                  )
                  .onSelected(
                    CalendarDayStyler()
                        .color(FortalTokens.accentSolid())
                        .label(
                          TextStyler().color(FortalTokens.accentContrast()),
                        ),
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
    ),
  );
}
