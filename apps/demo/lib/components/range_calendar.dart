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
  NakedDateRange? _value = NakedDateRange(
    start: DateTime(2026, 11, 10),
    end: DateTime(2026, 11, 13),
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(4),
    child: Center(
      child: RemixRangeCalendar(
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
        style: CalendarStyler()
            .weekday(TextStyler().fontSize(12))
            .day(
              CalendarDayStyler()
                  .label(TextStyler().fontSize(14))
                  .border(.color(const Color(0x00000000)).width(2))
                  .onSelected(
                    CalendarDayStyler()
                        .color(const Color(0xFFDBE5FF))
                        .label(TextStyler().color(const Color(0xFF18306A))),
                  )
                  .onFocusVisible(
                    CalendarDayStyler().border(
                      .color(const Color(0xFF8DA4FF)).width(2),
                    ),
                  )
                  .onDisabled(
                    CalendarDayStyler().label(
                      TextStyler().color(const Color(0xFF8B8D98)),
                    ),
                  ),
            )
            .rangeStart(
              _endpoint.borderRadius(
                .only(
                  topStart: const Radius.circular(6),
                  bottomStart: const Radius.circular(6),
                ),
              ),
            )
            .rangeEnd(
              _endpoint.borderRadius(
                .only(
                  topEnd: const Radius.circular(6),
                  bottomEnd: const Radius.circular(6),
                ),
              ),
            )
            .rangeSingle(_endpoint.borderRadius(.circular(6)))
            .rangePreview(
              CalendarDayStyler()
                  .onSelected(
                    CalendarDayStyler()
                        .color(const Color(0xFFFAE2A0))
                        .label(TextStyler().color(const Color(0xFF653D00))),
                  )
                  .color(const Color(0xFFFAE2A0))
                  .label(TextStyler().color(const Color(0xFF653D00))),
            ),
      ),
    ),
  );
}

final _endpointFill = CalendarDayStyler()
    .color(const Color(0xFF3E63DD))
    .label(TextStyler().color(const Color(0xFFFFFFFF)));
final _endpoint = _endpointFill.onSelected(_endpointFill);
