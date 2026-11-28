import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedCalendarDay;
import 'package:remix/remix.dart';

const _disc = ValueKey('disc');

Widget _host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    WidgetsApp(
      color: const Color(0xffffffff),
      builder: (context, _) => Directionality(
        textDirection: direction,
        child: Overlay.wrap(child: Center(child: child)),
      ),
    );

final _received = <RemixCalendarSelection>[];

// Paints one box over the start cell, as a recipe's selection disc would.
Widget _layer(BuildContext context, RemixCalendarSelection selection) {
  _received.add(selection);
  final start = selection.start;
  return Stack(
    children: [
      if (start != null)
        Positioned.fromRect(
          rect: selection.cellRect(start),
          child: const _Disc(key: _disc),
        ),
    ],
  );
}

class _Disc extends StatefulWidget {
  const _Disc({super.key});

  @override
  State<_Disc> createState() => _DiscState();
}

class _DiscState extends State<_Disc> {
  @override
  Widget build(BuildContext context) =>
      const ColoredBox(color: Color(0xff2255dd));
}

final _style = CalendarStyler().rowSpacing(6).selectionLayer(_layer);

// With Sunday first, February 2024 starts in column 4 of row 0.
RemixCalendar _calendar(DateTime? value, {CalendarStyler? style}) =>
    RemixCalendar(
      value: value,
      firstDate: DateTime(2023),
      lastDate: DateTime(2026, 12, 31),
      currentDate: DateTime(2024, 2, 15),
      onChanged: (_) {},
      style: style ?? _style,
    );

RemixRangeCalendar _range(DateTime start, DateTime end) => RemixRangeCalendar(
  value: CivilDateRange(start: start, end: end),
  firstDate: DateTime(2023),
  lastDate: DateTime(2026, 12, 31),
  currentDate: DateTime(2024, 2, 15),
  onChanged: (_) {},
  style: _style,
);

Rect _dayRect(WidgetTester tester, String label) => tester.getRect(
  find.ancestor(of: find.text(label), matching: find.byType(NakedCalendarDay)),
);

const _cell = RemixCalendarCell.new;
const _segment = RemixCalendarSelectionSegment.new;

void main() {
  setUp(_received.clear);

  testWidgets('a single selection reports its cell and grid geometry', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar(DateTime(2024, 2, 14))));
    final selection = _received.last;
    expect(selection.start, _cell(row: 2, column: 3));
    expect(selection.end, selection.start);
    expect(selection.segments, [
      _segment(row: 2, startColumn: 3, endColumn: 3),
    ]);
    expect(selection.cellSize, const Size(44, 44));
    expect(selection.rowSpacing, 6);
    expect(tester.getRect(find.byKey(_disc)), _dayRect(tester, '14'));
  });

  testWidgets('cell bounds follow right-to-left columns', (tester) async {
    await tester.pumpWidget(
      _host(_calendar(DateTime(2024, 2, 15)), direction: TextDirection.rtl),
    );
    expect(_received.last.start, _cell(row: 2, column: 4));
    expect(tester.getRect(find.byKey(_disc)), _dayRect(tester, '15'));
  });

  testWidgets('the layer paints behind the days and keeps its state', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar(DateTime(2024, 2, 14))));
    final stack = tester.widget<Stack>(
      find.ancestor(of: find.text('14'), matching: find.byType(Stack)).first,
    );
    expect(
      find.descendant(
        of: find.byWidget(stack.children.first),
        matching: find.byKey(_disc),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byWidget(stack.children.last),
        matching: find.text('14'),
      ),
      findsOneWidget,
    );
    final state = tester.state(find.byKey(_disc));

    await tester.pumpWidget(_host(_calendar(DateTime(2024, 2, 20))));
    expect(_received.last.start, _cell(row: 3, column: 2));
    // Same element, so an implicit animation can glide to the new day.
    expect(tester.state(find.byKey(_disc)), same(state));
    expect(tester.getRect(find.byKey(_disc)), _dayRect(tester, '20'));
  });

  testWidgets('a range reports one segment per week and both ends', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(_range(DateTime(2024, 2, 8), DateTime(2024, 2, 20))),
    );
    final selection = _received.last;
    expect(selection.start, _cell(row: 1, column: 4));
    expect(selection.end, _cell(row: 3, column: 2));
    expect(selection.segments, [
      _segment(row: 1, startColumn: 4, endColumn: 6),
      _segment(row: 2, startColumn: 0, endColumn: 6),
      _segment(row: 3, startColumn: 0, endColumn: 2),
    ]);
    final layer = tester.getTopLeft(
      find.ancestor(of: find.text('11'), matching: find.byType(Stack)).first,
    );
    expect(
      selection.segmentRect(selection.segments[1]).shift(layer),
      _dayRect(tester, '11').expandToInclude(_dayRect(tester, '17')),
    );
  });

  testWidgets('an end in another month is absent from the grid', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(_range(DateTime(2024, 2, 26), DateTime(2024, 3, 5))),
    );
    final selection = _received.last;
    expect(selection.start, _cell(row: 4, column: 1));
    expect(selection.end, isNull);
    expect(selection.segments, [
      _segment(row: 4, startColumn: 1, endColumn: 4),
    ]);
  });

  testWidgets('an anchored draft replaces the committed range', (tester) async {
    await tester.pumpWidget(
      _host(_range(DateTime(2024, 2, 8), DateTime(2024, 2, 20))),
    );
    await tester.tap(find.text('10'));
    await tester.pump();
    final selection = _received.last;
    expect(selection.start, _cell(row: 1, column: 6));
    expect(selection.end, selection.start);
    expect(selection.segments, [
      _segment(row: 1, startColumn: 6, endColumn: 6),
    ]);
  });

  testWidgets('nothing visible selected reports an empty selection', (
    tester,
  ) async {
    await tester.pumpWidget(_host(_calendar(null)));
    expect(_received.last.isEmpty, isTrue);
    expect(_received.last.start, isNull);
    expect(find.byKey(_disc), findsNothing);
  });

  testWidgets('without a layer the grid has no stack', (tester) async {
    await tester.pumpWidget(
      _host(_calendar(DateTime(2024, 2, 14), style: CalendarStyler())),
    );
    expect(
      find.ancestor(of: find.text('14'), matching: find.byType(Stack)),
      findsNothing,
    );
    expect(_received, isEmpty);
  });
}
