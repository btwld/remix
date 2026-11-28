import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('one-day committed range resolves its directional radius', (
    t,
  ) async {
    await t.pumpWidget(
      WidgetsApp(
        color: const Color(0xffffffff),
        builder: (context, _) => FortalTheme(
          child: Overlay.wrap(
            child: Center(
              child: RemixRangeCalendar(
                value: CivilDateRange(
                  start: DateTime(2026, 11, 24),
                  end: DateTime(2026, 11, 24),
                ),
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
                onChanged: (_) {},
                style: fortalRangeCalendarStyle(),
              ),
            ),
          ),
        ),
      ),
    );
    expect(t.takeException(), isNull);
    expect(find.text('24'), findsOneWidget);
  });
  testWidgets('available range days have no resting tile', (tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) =>
            FortalTheme(child: const RangeCalendarExample()),
      ),
    );
    final day = find
        .ancestor(of: find.text('20'), matching: find.byType(Box))
        .first;
    final box = tester.widget<Box>(day);
    final decoration = box.styleSpec!.spec.decoration as BoxDecoration?;
    expect(decoration?.color?.a ?? 0, 0);
    expect(decoration?.border?.top.style ?? BorderStyle.none, BorderStyle.none);
  });
}
