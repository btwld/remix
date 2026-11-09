import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedCalendarDay;
import 'package:remix/remix.dart';

Future<void> _pump(
  WidgetTester tester, {
  Widget child = const RangeCalendarExample(),
  bool rtl = false,
  bool dark = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 900);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => FortalTheme(
        mode: dark ? FortalThemeMode.dark : FortalThemeMode.light,
        child: Directionality(
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
      ),
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

BoxDecoration _day(WidgetTester tester, int day) {
  final f = find.byWidgetPredicate(
    (w) => w is NakedCalendarDay && w.date.day == day,
  );
  return tester
          .widget<Box>(find.descendant(of: f, matching: find.byType(Box)).first)
          .styleSpec!
          .spec
          .decoration
      as BoxDecoration;
}

(double, double) _sides(BoxBorder border, bool rtl) => switch (border) {
  Border(:final left, :final right) => (left.width, right.width),
  BorderDirectional(:final start, :final end) =>
    rtl ? (end.width, start.width) : (start.width, end.width),
  _ => throw StateError('Unexpected border'),
};
void main() {
  for (final dark in [false, true]) {
    testWidgets('$dark today ring contrasts with the range middle by 3:1', (
      t,
    ) async {
      await _pump(
        t,
        dark: dark,
        child: RemixRangeCalendar(
          value: CivilDateRange(
            start: DateTime(2026, 11, 5),
            end: DateTime(2026, 11, 9),
          ),
          firstDate: DateTime(2025),
          lastDate: DateTime(2028),
          currentDate: DateTime(2026, 11, 6),
          onChanged: (_) {},
          style: fortalRangeCalendarStyle(),
        ),
      );
      final day = _day(t, 6);
      final a = day.border!.top.color.computeLuminance(),
          b = day.color!.computeLuminance();
      expect(
        (a > b ? a + .05 : b + .05) / (a > b ? b + .05 : a + .05),
        greaterThanOrEqualTo(3),
      );
    });
  }
  for (final rtl in [false, true]) {
    testWidgets(
      'draft edges connect without internal seams in ${rtl ? "RTL" : "LTR"}',
      (tester) async {
        await _pump(tester, rtl: rtl);
        await tester.tap(find.text('20'));
        await tester.sendKeyEvent(
          rtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight,
        );
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(
          rtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final start = _day(tester, 20).border!,
            middle = _day(tester, 21).border!;
        expect(_sides(start, rtl), rtl ? (0.0, 2.0) : (2.0, 0.0));
        expect(_sides(middle, rtl), (0.0, 0.0));
        expect([middle.top.width, middle.bottom.width], [2, 2]);
      },
    );
  }
  testWidgets('today composes with middle start and single range corners', (
    tester,
  ) async {
    await _pump(tester);
    final style = tester
        .widget<RemixRangeCalendar>(find.byType(RemixRangeCalendar))
        .style;
    for (final (start, end) in [(5, 9), (6, 9), (6, 6)]) {
      await _pump(
        tester,
        child: RemixRangeCalendar(
          value: CivilDateRange(
            start: DateTime(2026, 11, start),
            end: DateTime(2026, 11, end),
          ),
          firstDate: DateTime(2025),
          lastDate: DateTime(2028),
          currentDate: DateTime(2026, 11, 6),
          onChanged: (_) {},
          style: style,
        ),
      );
      expect(tester.takeException(), isNull);
      final radius = _day(tester, 6).borderRadius!.resolve(TextDirection.ltr);
      expect(
        radius.topLeft,
        start == 5 ? Radius.zero : const Radius.circular(6),
      );
      expect(
        radius.topRight,
        end == 6 ? const Radius.circular(6) : Radius.zero,
      );
    }
  });
}
