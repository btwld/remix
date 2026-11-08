import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/range_calendar_reference.dart';
import 'package:remix/remix.dart';

final _calendar = find.byType(RemixRangeCalendar);
CivilDateRange _range(int start, int end) => CivilDateRange(
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
  await tester.pumpWidget(const RangeCalendarReferenceApp());
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

CivilDateRange? _value(WidgetTester tester) =>
    tester.widget<RemixRangeCalendar>(_calendar).value;

void main() {
  testWidgets(
    'reference commits complete reverse and same-day ranges, and honors rejection',
    (tester) async {
      await _pump(tester);
      expect(_value(tester), _range(10, 13));
      await _tap(tester, find.text('22'));
      expect(_value(tester), _range(10, 13));
      await _tap(tester, find.text('20'));
      expect(_value(tester), _range(20, 22));
      await _tap(tester, find.text('24'));
      await _tap(tester, find.text('24'));
      expect(_value(tester), _range(24, 24));
      await _tap(tester, find.text('Reject requests'));
      await _tap(tester, find.text('25'));
      await _tap(tester, find.text('27'));
      expect(_value(tester), _range(24, 24));
      expect(
        find.text('Request rejected. The previous period is unchanged.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'unavailable interior blocks completion without replacing the draft anchor',
    (tester) async {
      await _pump(tester);
      await _tap(tester, find.text('17'));
      await _tap(tester, find.text('20'));
      expect(_value(tester), _range(10, 13));
      await _tap(tester, find.text('16'));
      expect(_value(tester), _range(16, 17));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Escape closes a nested selector before cancelling the inline draft',
    (tester) async {
      await _pump(tester);
      await _tap(tester, find.text('20'));
      await _tap(tester, find.bySemanticsLabel('Choose year'));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await _tap(tester, find.text('22'));
      expect(_value(tester), _range(20, 22));
      await _tap(tester, find.text('24'));
      expect(await tester.sendKeyDownEvent(LogicalKeyboardKey.escape), isTrue);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await _tap(tester, find.text('25'));
      expect(_value(tester), _range(20, 22));
      await _tap(tester, find.text('27'));
      expect(_value(tester), _range(25, 27));
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.macOS),
  );

  testWidgets(
    '320px Arabic at 200 percent keeps full-size days reachable and selectable',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await _pump(tester, size: const Size(320, 640));
        await _tap(tester, find.text('العربية / RTL'));
        await _tap(tester, find.text('200% text'));
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
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}
