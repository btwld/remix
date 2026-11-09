import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';
import 'calendar.dart' show calendarDemoSelectorStyle, calendarDemoTarget;

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
        navigationStyle: fortalIconButtonStyle(
          variant: .ghost,
        ).size(calendarDemoTarget, calendarDemoTarget),
        selectorStyle: calendarDemoSelectorStyle(context),
        style: reportingPeriodCalendarStyle
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

/// Range styling shared by the range calendar and date range picker stories.
final reportingPeriodCalendarStyle = CalendarStyler()
    .padding(.all(FortalTokens.space3()))
    .headerSpacing(FortalTokens.space2())
    .weekdaySpacing(FortalTokens.space1())
    .rowSpacing(FortalTokens.space1())
    .weekday(
      TextStyler().style(FortalTokens.text1.mix()).color(FortalTokens.gray11()),
    )
    .onDisabled(
      CalendarStyler().weekday(TextStyler().color(FortalTokens.gray9())),
    )
    .day(
      CalendarDayStyler()
          .label(TextStyler().style(FortalTokens.text2.mix()))
          .border(BorderMix.all(BorderSideMix.none))
          .onToday(
            CalendarDayStyler()
                .border(
                  BorderMix.all(
                    BorderSideMix(
                      color: FortalTokens.gray10(),
                      width: 1,
                      style: .solid,
                    ),
                  ),
                )
                .borderRadius(
                  BorderRadiusDirectionalMix.all(FortalTokens.radius3()),
                )
                .label(
                  TextStyler()
                      .color(FortalTokens.accent11())
                      .fontWeight(FontWeight.w700),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(_quietCommitted())
                .borderRadius(BorderRadiusDirectionalMix.circular(0))
                .variant(
                  _committedStart,
                  CalendarDayStyler().borderRadius(
                    .only(
                      topStart: FortalTokens.radius3(),
                      bottomStart: FortalTokens.radius3(),
                      topEnd: Radius.zero,
                      bottomEnd: Radius.zero,
                    ),
                  ),
                )
                .variant(
                  _committedEnd,
                  CalendarDayStyler().borderRadius(
                    .only(
                      topEnd: FortalTokens.radius3(),
                      bottomEnd: FortalTokens.radius3(),
                      topStart: Radius.zero,
                      bottomStart: Radius.zero,
                    ),
                  ),
                )
                .variant(
                  _committedSingle,
                  CalendarDayStyler().borderRadius(
                    BorderRadiusDirectionalMix.all(FortalTokens.radius3()),
                  ),
                )
                .label(TextStyler().color(FortalTokens.gray11())),
          )
          .onDisabled(
            CalendarDayStyler().label(TextStyler().color(FortalTokens.gray9())),
          )
          .onUnavailable(
            CalendarDayStyler().label(
              TextStyler().decoration(TextDecoration.lineThrough),
            ),
          )
          // Committed fills come from range roles. While drafting,
          // the old selection retains a quiet band and slightly stronger caps.
          .onRangeMiddle(
            CalendarDayStyler()
                .borderRadius(BorderRadiusDirectionalMix.circular(0))
                .color(FortalTokens.accent4())
                .label(TextStyler().color(FortalTokens.gray12()))
                .onDisabled(_mutedMiddle),
          )
          .onRangeStart(
            _endpoint.borderRadius(
              .only(
                topStart: FortalTokens.radius3(),
                bottomStart: FortalTokens.radius3(),
                topEnd: Radius.zero,
                bottomEnd: Radius.zero,
              ),
            ),
          )
          .onRangeEnd(
            _endpoint.borderRadius(
              .only(
                topEnd: FortalTokens.radius3(),
                bottomEnd: FortalTokens.radius3(),
                topStart: Radius.zero,
                bottomStart: Radius.zero,
              ),
            ),
          )
          .onRangeSingle(
            _endpoint.borderRadius(
              BorderRadiusDirectionalMix.all(FortalTokens.radius3()),
            ),
          )
          // Preview follows the caps so the draft has its own treatment.
          .onRangePreview(
            CalendarDayStyler()
                .color(FortalTokens.accent4())
                .border(
                  BorderMix(
                    top: _draftStroke,
                    bottom: _draftStroke,
                    left: _draftNone,
                    right: _draftNone,
                  ),
                )
                .label(TextStyler().color(FortalTokens.accent12()))
                .onRangeStart(
                  CalendarDayStyler()
                      .color(FortalTokens.accent5())
                      .border(.left(_draftStroke))
                      .onRtl(
                        CalendarDayStyler().border(
                          BorderMix(left: _draftNone, right: _draftStroke),
                        ),
                      ),
                )
                .onRangeEnd(
                  CalendarDayStyler()
                      .color(FortalTokens.accent5())
                      .border(.right(_draftStroke))
                      .onRtl(
                        CalendarDayStyler().border(
                          BorderMix(left: _draftStroke, right: _draftNone),
                        ),
                      ),
                )
                .onRangeSingle(
                  CalendarDayStyler()
                      .color(FortalTokens.accent5())
                      .border(BorderMix.all(_draftStroke)),
                )
                .onDisabled(
                  CalendarDayStyler()
                      .color(FortalTokens.error3())
                      .label(TextStyler().color(FortalTokens.error11())),
                ),
          )
          .onHovered(_pointer(pressed: false))
          .onPressed(_pointer(pressed: true))
          .onFocusVisible(
            CalendarDayStyler()
                .border(.all(_focusStroke))
                .onRangeMiddle(_focusEdges())
                .onRangeStart(_focusEdges(start: true))
                .onRangeEnd(_focusEdges(end: true)),
          ),
    );

final _endpoint = CalendarDayStyler()
    .color(FortalTokens.accentSolid())
    .label(TextStyler().color(FortalTokens.accentContrast()))
    .onDisabled(_mutedRange);

final _mutedMiddle = CalendarDayStyler()
    .color(FortalTokens.gray3())
    .label(TextStyler().color(FortalTokens.gray11()));

final _mutedRange = CalendarDayStyler()
    .color(FortalTokens.gray4())
    .label(TextStyler().color(FortalTokens.gray11()));

// Physical borders support square middles in Flutter; mirror cap edges in RTL.
final _draftStroke = BorderSideMix(
  color: FortalTokens.accent8(),
  width: 2,
  style: .solid,
);
final _draftNone = BorderSideMix(
  color: FortalTokens.accent8(),
  width: 0,
  style: .none,
);

CalendarDayStyler _pointer({required bool pressed}) => CalendarDayStyler()
    .color(pressed ? FortalTokens.gray6() : FortalTokens.gray4())
    .onSelected(
      CalendarDayStyler().color(
        pressed ? FortalTokens.gray4() : FortalTokens.gray3(),
      ),
    )
    .onRangeStart(
      CalendarDayStyler().color((pressed ? _capPressed : _capHover)()),
    )
    .onRangeEnd(
      CalendarDayStyler().color((pressed ? _capPressed : _capHover)()),
    )
    .onRangeSingle(
      CalendarDayStyler().color((pressed ? _capPressed : _capHover)()),
    )
    .onRangeMiddle(
      CalendarDayStyler().color(
        pressed ? FortalTokens.accent6() : FortalTokens.accent5(),
      ),
    )
    .onRangePreview(
      CalendarDayStyler().color(
        pressed ? FortalTokens.accent5() : FortalTokens.accent4(),
      ),
    );
final _capHover = ContextToken<Color>(
  (context) => FortalTokens.accentSolid.resolve(context).withValues(alpha: .9),
);
final _capPressed = ContextToken<Color>(
  (context) => FortalTokens.accentSolid.resolve(context).withValues(alpha: .8),
);
final _focusStroke = BorderSideMix(
  color: FortalTokens.focus8(),
  width: 2,
  style: .solid,
);

CalendarDayStyler _focusEdges({bool start = false, bool end = false}) =>
    CalendarDayStyler()
        .border(
          BorderMix(
            top: _focusStroke,
            bottom: _focusStroke,
            left: start ? _focusStroke : _draftNone,
            right: end ? _focusStroke : _draftNone,
          ),
        )
        .onRtl(
          CalendarDayStyler().border(
            BorderMix(
              top: _focusStroke,
              bottom: _focusStroke,
              left: end ? _focusStroke : _draftNone,
              right: start ? _focusStroke : _draftNone,
            ),
          ),
        );

// The live roles follow the draft; use the parent-owned value for stale geometry.
final _quietCommitted = ContextToken<Color>((context) {
  final value = NakedRangeCalendarState.maybeOf(context)?.value;
  final day = NakedCalendarDayState.maybeOf(context)?.date;
  final cap =
      value != null &&
      day != null &&
      (compareCivilDates(day, value.start) == 0 ||
          compareCivilDates(day, value.end) == 0);
  return (cap ? FortalTokens.gray4 : FortalTokens.gray3).resolve(context);
});
ContextVariant _committedRole(String name, NakedRangePosition position) =>
    ContextVariant('demo.calendar.committed-$name', (context) {
      final value = NakedRangeCalendarState.maybeOf(context)?.value;
      final day = NakedCalendarDayState.maybeOf(context)?.date;
      if (value == null || day == null || !value.contains(day)) return false;
      final start = compareCivilDates(day, value.start) == 0;
      final end = compareCivilDates(day, value.end) == 0;
      return (start && end
              ? NakedRangePosition.single
              : start
              ? NakedRangePosition.start
              : end
              ? NakedRangePosition.end
              : NakedRangePosition.middle) ==
          position;
    });
final _committedStart = _committedRole('start', .start);
final _committedEnd = _committedRole('end', .end);
final _committedSingle = _committedRole('single', .single);
