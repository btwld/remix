import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/range_calendar_reference.dart';
import 'package:remix/remix.dart';

NakedDateRange _range(int start, int end) => NakedDateRange(
  start: DateTime(2026, 11, start),
  end: DateTime(2026, 11, end),
);

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(1024, 800),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const RangeCalendarReferenceApp(usePicker: true));
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder target) async {
  if (target.hitTestable().evaluate().isEmpty) {
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
  }
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Finder get _picker => find.byType(RemixDateRangePicker);
Finder get _trigger =>
    find.descendant(of: _picker, matching: find.byType(RemixButton));
NakedDateRange? _value(WidgetTester tester) =>
    tester.widget<RemixDateRangePicker>(_picker).value;

void main() {
  testWidgets(
    'reference accepts complete ranges and closes after rejected requests',
    (tester) async {
      await _pump(tester);
      await _tap(tester, _trigger);
      await _tap(tester, find.text('20'));
      expect(_value(tester), _range(10, 13));
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      await _tap(tester, find.text('22'));
      expect(_value(tester), _range(20, 22));
      expect(find.byType(RemixRangeCalendar), findsNothing);
      await _tap(tester, find.text('Reject requests'));
      await _tap(tester, _trigger);
      await _tap(tester, find.text('24'));
      await _tap(tester, find.text('27'));
      expect(_value(tester), _range(20, 22));
      expect(find.byType(RemixRangeCalendar), findsNothing);
      expect(
        find.text('Request rejected. The previous period is unchanged.'),
        findsOneWidget,
      );
      await _tap(tester, _trigger);
      await _tap(tester, find.text('25'));
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      expect(_value(tester), _range(20, 22));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'narrow Arabic 200 percent picker keeps days reachable and completes by keyboard',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await _pump(tester, size: const Size(320, 640));
        await _tap(tester, find.text('العربية / RTL'));
        await _tap(tester, find.text('200% text'));
        await _tap(tester, _trigger);
        await _tap(tester, find.text('٢٠'));
        final day = tester.getSize(
          find.bySemanticsLabel(RegExp('الجمعة، ٢٠ نوفمبر ٢٠٢٦')),
        );
        expect(day.width, greaterThanOrEqualTo(44));
        expect(day.height, greaterThanOrEqualTo(44));
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(_value(tester), _range(20, 21));
        expect(find.byType(RemixRangeCalendar), findsNothing);
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}
