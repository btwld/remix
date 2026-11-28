import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedCalendarDay;
import 'package:remix/remix.dart';

Widget _host(Widget child) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (context, _) => Directionality(
    textDirection: TextDirection.ltr,
    child: Overlay.wrap(child: Center(child: child)),
  ),
);

// With Sunday first, February 2026 fills exactly four rows and August 2026
// needs six.
final _fourWeeks = DateTime(2026, 2, 10);
final _sixWeeks = DateTime(2026, 8, 10);

RemixCalendar _calendar(DateTime value, CalendarStyler style) => RemixCalendar(
  key: ValueKey(value),
  value: value,
  firstDate: DateTime(2025),
  lastDate: DateTime(2027, 12, 31),
  currentDate: DateTime(2026, 2, 15),
  onChanged: (_) {},
  style: style,
);

Future<double> _height(
  WidgetTester tester,
  DateTime value,
  CalendarStyler style,
) async {
  await tester.pumpWidget(_host(_calendar(value, style)));
  return tester.getSize(find.byType(RemixCalendar)).height;
}

void main() {
  final style = CalendarStyler().rowSpacing(6);

  testWidgets('fixed weeks give every month the height of six weeks', (
    tester,
  ) async {
    final fixed = style.fixedWeeks(true);
    final six = await _height(tester, _sixWeeks, fixed);
    final four = await _height(tester, _fourWeeks, fixed);
    expect(four, six);
    // The padding rows are empty: February still shows 28 days.
    expect(find.byType(NakedCalendarDay), findsNWidgets(28));
    // Six-week months render as before, so the padded height is that of two
    // real rows, each a 44 pixel day plus the row gap.
    expect(await _height(tester, _sixWeeks, style), six);
    expect(six - await _height(tester, _fourWeeks, style), 2 * (44 + 6));
  });

  testWidgets('variable weeks are the default', (tester) async {
    final six = await _height(tester, _sixWeeks, style);
    final four = await _height(tester, _fourWeeks, style);
    expect(six - four, 2 * (44 + 6));
    expect(await _height(tester, _fourWeeks, style.fixedWeeks(false)), four);
  });

  testWidgets('range calendars use fixed weeks too', (tester) async {
    Future<double> height(DateTime month) async {
      await tester.pumpWidget(
        _host(
          RemixRangeCalendar(
            key: ValueKey(month),
            value: CivilDateRange(start: month, end: month),
            firstDate: DateTime(2025),
            lastDate: DateTime(2027, 12, 31),
            onChanged: (_) {},
            style: style.fixedWeeks(true),
          ),
        ),
      );
      return tester.getSize(find.byType(RemixRangeCalendar)).height;
    }

    expect(await height(_fourWeeks), await height(_sixWeeks));
  });
}
