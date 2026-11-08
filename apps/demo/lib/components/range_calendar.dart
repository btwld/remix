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
                  .border(.color(FortalTokens.grayA1()).width(2))
                  .onToday(
                    CalendarDayStyler().label(
                      TextStyler().fontWeight(FontWeight.w600),
                    ),
                  )
                  .onSelected(
                    CalendarDayStyler()
                        .color(FortalTokens.gray2())
                        .label(TextStyler().color(FortalTokens.gray9())),
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
                  )
                  // Committed fills come from range roles. While drafting,
                  // the old selection keeps only its faint onSelected treatment.
                  .onRangeMiddle(
                    CalendarDayStyler()
                        .color(FortalTokens.accent4())
                        .label(TextStyler().color(FortalTokens.accent11()))
                        .onDisabled(_mutedRange),
                  )
                  .onRangeStart(
                    _endpoint.borderRadius(
                      .only(
                        topStart: const Radius.circular(6),
                        bottomStart: const Radius.circular(6),
                      ),
                    ),
                  )
                  .onRangeEnd(
                    _endpoint.borderRadius(
                      .only(
                        topEnd: const Radius.circular(6),
                        bottomEnd: const Radius.circular(6),
                      ),
                    ),
                  )
                  .onRangeSingle(_endpoint.borderRadius(.circular(6)))
                  // Preview follows the caps so the draft has its own treatment.
                  .onRangePreview(
                    CalendarDayStyler()
                        .color(FortalTokens.accent3())
                        .border(.color(FortalTokens.accent8()).width(2))
                        .label(TextStyler().color(FortalTokens.accent12()))
                        .onRangeStart(
                          CalendarDayStyler().color(FortalTokens.accent5()),
                        )
                        .onRangeEnd(
                          CalendarDayStyler().color(FortalTokens.accent5()),
                        )
                        .onRangeSingle(
                          CalendarDayStyler().color(FortalTokens.accent5()),
                        )
                        .onDisabled(
                          CalendarDayStyler()
                              .color(FortalTokens.error3())
                              .label(
                                TextStyler().color(FortalTokens.error11()),
                              ),
                        ),
                  )
                  .onFocusVisible(
                    CalendarDayStyler().border(
                      .color(FortalTokens.focus8()).width(2),
                    ),
                  ),
            ),
      ),
    ),
  );
}

final _endpoint = CalendarDayStyler()
    .color(FortalTokens.accentSolid())
    .label(TextStyler().color(FortalTokens.accentContrast()))
    .onDisabled(_mutedRange);

final _mutedRange = CalendarDayStyler()
    .color(FortalTokens.gray3())
    .label(TextStyler().color(FortalTokens.gray9()));
