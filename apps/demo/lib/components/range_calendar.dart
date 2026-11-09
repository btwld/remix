import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../ui/ui.dart';
import 'calendar.dart' show calendarDemoSelectorStyle;

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
        navigationStyle: fortalIconButtonStyle(variant: .ghost).size(44, 44),
        selectorStyle: calendarDemoSelectorStyle(context),
        style: reportingPeriodCalendarStyle
            .minWidth(
              MediaQuery.textScalerOf(context).scale(44) * 7 +
                  FortalTokens.space3.resolve(context) * 2,
            )
            .day(
              CalendarDayStyler()
                  .minWidth(MediaQuery.textScalerOf(context).scale(44))
                  .minHeight(MediaQuery.textScalerOf(context).scale(44)),
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
    .heading(TextStyler().color(FortalTokens.gray11()))
    .weekday(TextStyler().fontSize(12).color(FortalTokens.gray11()))
    .onDisabled(
      CalendarStyler()
          .heading(TextStyler().color(FortalTokens.gray9()))
          .weekday(TextStyler().color(FortalTokens.gray9())),
    )
    .day(
      CalendarDayStyler()
          .label(TextStyler().fontSize(14))
          .border(BorderMix.all(BorderSideMix.none))
          .onToday(
            CalendarDayStyler()
                .border(
                  BorderMix.all(
                    BorderSideMix(
                      color: FortalTokens.accent8(),
                      width: 1,
                      style: .solid,
                    ),
                  ),
                )
                .borderRadius(BorderRadiusDirectionalMix.circular(6))
                .label(
                  TextStyler()
                      .color(FortalTokens.accent11())
                      .fontWeight(FontWeight.w700),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(FortalTokens.gray2())
                .label(TextStyler().color(FortalTokens.gray9())),
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
          // the old selection keeps only its faint onSelected treatment.
          .onRangeMiddle(
            CalendarDayStyler()
                .borderRadius(BorderRadiusDirectionalMix.circular(0))
                .color(FortalTokens.accent4())
                .label(TextStyler().color(FortalTokens.accent11()))
                .onDisabled(_mutedRange),
          )
          .onRangeStart(
            _endpoint.borderRadius(
              .only(
                topStart: const Radius.circular(6),
                bottomStart: const Radius.circular(6),
                topEnd: Radius.zero,
                bottomEnd: Radius.zero,
              ),
            ),
          )
          .onRangeEnd(
            _endpoint.borderRadius(
              .only(
                topEnd: const Radius.circular(6),
                bottomEnd: const Radius.circular(6),
                topStart: Radius.zero,
                bottomStart: Radius.zero,
              ),
            ),
          )
          .onRangeSingle(
            _endpoint.borderRadius(BorderRadiusDirectionalMix.circular(6)),
          )
          // Preview follows the caps so the draft has its own treatment.
          .onRangePreview(
            CalendarDayStyler()
                .color(FortalTokens.accent3())
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
    .color(pressed ? FortalTokens.gray5() : FortalTokens.gray4())
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
