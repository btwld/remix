import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('$direction focused range end has only outer edges', (t) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      await t.pumpWidget(
        WidgetsApp(
          color: const Color(0xFFFFFFFF),
          builder: (context, _) => FortalTheme(
            child: Directionality(
              textDirection: direction,
              child: Overlay.wrap(
                child: Center(
                  child: RemixRangeCalendar(
                    value: CivilDateRange(
                      start: DateTime(2026, 11, 10),
                      end: DateTime(2026, 11, 13),
                    ),
                    firstDate: DateTime(2026),
                    lastDate: DateTime(2027),
                    onChanged: (_) {},
                    focusNode: node,
                    style: reportingPeriodCalendarStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(
        () => FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.automatic,
      );
      node.requestFocus();
      await t.pumpAndSettle();
      for (var i = 0; i < 3; i++) {
        await t.sendKeyEvent(
          direction == TextDirection.ltr
              ? LogicalKeyboardKey.arrowRight
              : LogicalKeyboardKey.arrowLeft,
        );
        await t.pumpAndSettle();
      }
      final day = find
          .ancestor(
            of: find.text('13'),
            matching: find.byType(StyleSpecProvider<CalendarDaySpec>),
          )
          .first;
      final spec = t.widget<StyleSpecProvider<CalendarDaySpec>>(day).spec.spec;
      final border =
          (spec.container.spec.decoration as BoxDecoration).border as Border;
      expect(border.top.width, 2);
      expect(border.bottom.width, 2);
      expect(
        (direction == TextDirection.ltr ? border.left : border.right).style,
        BorderStyle.none,
      );
      expect(
        (direction == TextDirection.ltr ? border.right : border.left).width,
        2,
      );
      expect(t.takeException(), isNull);
    });
  }

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
