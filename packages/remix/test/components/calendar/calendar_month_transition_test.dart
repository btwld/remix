import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const _normal = Color(0xff000001);
const _selected = Color(0xff000002);
const _disabled = Color(0xff000003);
const _incoming = ValueKey('incoming');
const _outgoing = ValueKey('outgoing');

Widget _host(Widget child, {bool disableAnimations = false}) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (context, _) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: disableAnimations),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay.wrap(child: Center(child: child)),
    ),
  ),
);

final _calls = <RemixMonthTransitionInfo>[];

final _transition = RemixMonthTransition(
  duration: const Duration(milliseconds: 300),
  builder: (context, info, grid) {
    _calls.add(info);
    return KeyedSubtree(
      key: info.isIncoming ? _incoming : _outgoing,
      child: grid,
    );
  },
);

CalendarStyler _style({RemixMonthTransition? transition}) {
  final style = CalendarStyler(
    day: CalendarDayStyler()
        .color(_normal)
        .onSelected(CalendarDayStyler().color(_selected))
        .onDisabled(CalendarDayStyler().color(_disabled)),
  );
  return transition == null ? style : style.monthTransition(transition);
}

RemixCalendar _calendar({CalendarStyler? style}) => RemixCalendar(
  value: DateTime(2024, 2, 29),
  firstDate: DateTime(2023),
  lastDate: DateTime(2026, 12, 31),
  currentDate: DateTime(2024, 2, 15),
  onChanged: (_) {},
  style: style ?? _style(transition: _transition),
);

Finder _day(String label, {Key? grid}) => grid == null
    ? find.text(label)
    : find.descendant(of: find.byKey(grid), matching: find.text(label));

Color? _fill(WidgetTester tester, Finder label) {
  final box = find.ancestor(of: label, matching: find.byType(Box)).first;
  return (tester.widget<Box>(box).styleSpec?.spec.decoration as BoxDecoration?)
      ?.color;
}

Future<void> _next(WidgetTester tester) =>
    tester.tap(find.byType(RemixIconButton).last);

Future<void> _previous(WidgetTester tester) =>
    tester.tap(find.byType(RemixIconButton).first);

void main() {
  setUp(_calls.clear);

  testWidgets('both month grids are mounted until the transition completes', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar()));
    expect(_day('29'), findsOneWidget);

    await _next(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    // February 29 slides out while March 29 slides in.
    expect(_day('29', grid: _outgoing), findsOneWidget);
    expect(_day('29', grid: _incoming), findsOneWidget);
    expect(_day('31', grid: _incoming), findsOneWidget);
    final outgoing = _calls.lastWhere((info) => !info.isIncoming);
    expect(outgoing.direction, RemixMonthDirection.forward);
    expect(outgoing.animation.value, closeTo(0.5, 0.01));
    expect(
      _calls.lastWhere((info) => info.isIncoming).animation,
      same(outgoing.animation),
    );

    await tester.pumpAndSettle();
    expect(find.byKey(_outgoing), findsNothing);
    expect(_day('29'), findsOneWidget);
    expect(_day('31'), findsOneWidget);
    expect(_calls.last.animation.value, 1);
  });

  testWidgets('navigating back reports a backward transition', (tester) async {
    await tester.pumpWidget(_host(_calendar()));
    await _previous(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(_outgoing), findsOneWidget);
    expect(_calls.last.direction, RemixMonthDirection.backward);
    await tester.pumpAndSettle();
  });

  testWidgets('the outgoing grid keeps its displayed day styles', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar()));
    await _next(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    // Naked marks outgoing days disabled to make them inert; the grid still
    // paints the selection and plain days it showed.
    expect(_fill(tester, _day('29', grid: _outgoing)), _selected);
    expect(_fill(tester, _day('28', grid: _outgoing)), _normal);
    await tester.pumpAndSettle();
  });

  testWidgets('reduced motion swaps months at once', (tester) async {
    await tester.pumpWidget(_host(_calendar(), disableAnimations: true));
    await _next(tester);
    await tester.pump();
    expect(find.byKey(_outgoing), findsNothing);
    expect(_day('31'), findsOneWidget);
    expect(_day('29'), findsOneWidget);
  });

  testWidgets('without a transition the month swaps at once', (tester) async {
    await tester.pumpWidget(_host(_calendar(style: _style())));
    await _next(tester);
    await tester.pump();
    expect(_day('31'), findsOneWidget);
    expect(_day('29'), findsOneWidget);
    expect(_calls, isEmpty);
  });

  testWidgets('range calendars run the same transition', (tester) async {
    await tester.pumpWidget(
      _host(
        RemixRangeCalendar(
          value: CivilDateRange(
            start: DateTime(2024, 2, 27),
            end: DateTime(2024, 2, 29),
          ),
          firstDate: DateTime(2023),
          lastDate: DateTime(2026, 12, 31),
          currentDate: DateTime(2024, 2, 15),
          onChanged: (_) {},
          style: _style(transition: _transition),
        ),
      ),
    );
    await _next(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    expect(_day('29', grid: _outgoing), findsOneWidget);
    expect(_day('29', grid: _incoming), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byKey(_outgoing), findsNothing);
  });
}
