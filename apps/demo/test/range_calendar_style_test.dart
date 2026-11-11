import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets('$dark draft hierarchy and separated week rows', (t) async {
      Widget host({bool enabled = true}) => WidgetsApp(
        color: const Color(0xffffffff),
        builder: (context, _) => FortalTheme(
          mode: dark ? FortalThemeMode.dark : FortalThemeMode.light,
          child: Overlay.wrap(
            child: Center(
              child: RemixRangeCalendar(
                value: CivilDateRange(
                  start: DateTime(2026, 11, 10),
                  end: DateTime(2026, 11, 13),
                ),
                firstDate: DateTime(2026),
                lastDate: DateTime(2027),
                firstDayOfWeek: DateTime.monday,
                enabled: enabled,
                onChanged: (_) {},
                style: fortalRangeCalendarStyle(),
              ),
            ),
          ),
        ),
      );
      Finder tile(int day) => find
          .ancestor(
            of: find.text('$day'),
            matching: find.byType(StyleSpecProvider<CalendarDaySpec>),
          )
          .first;
      Color fill(int day) =>
          (t
                      .widget<StyleSpecProvider<CalendarDaySpec>>(tile(day))
                      .spec
                      .spec
                      .container
                      .spec
                      .decoration
                  as BoxDecoration)
              .color!;
      await t.pumpWidget(host());
      final surface = FortalTokens.colorBackground.resolve(t.element(tile(11)));
      expect(
        t.getTopLeft(tile(13)).dy - t.getBottomLeft(tile(6)).dy,
        greaterThanOrEqualTo(4),
      );
      await t.tap(find.text('20'));
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pumpAndSettle();
      final stale = Color.alphaBlend(fill(11), surface);
      final cap = Color.alphaBlend(fill(10), surface);
      final draft = Color.alphaBlend(fill(21), surface);
      expect(_contrast(stale, surface), greaterThan(1.1));
      expect(
        _contrast(draft, surface),
        greaterThanOrEqualTo(_contrast(cap, surface)),
      );
      expect(_contrast(cap, surface), greaterThan(_contrast(stale, surface)));
      await t.pumpWidget(const SizedBox());
      await t.pumpWidget(host(enabled: false));
      expect(
        _contrast(Color.alphaBlend(fill(10), surface), surface),
        greaterThan(1.15),
      );
      expect(
        _contrast(Color.alphaBlend(fill(10), surface), surface),
        greaterThan(_contrast(Color.alphaBlend(fill(11), surface), surface)),
      );
    });
  }
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
                    style: fortalRangeCalendarStyle(),
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

// Range roles move to the preview while drafting; the selected snapshot stays visible.
double _contrast(Color a, Color b) {
  final x = a.computeLuminance(), y = b.computeLuminance();
  return (x > y ? x + .05 : y + .05) / (x > y ? y + .05 : x + .05);
}
