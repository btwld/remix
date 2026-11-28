import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

/// The discs and pills of the selection layer, in global coordinates.
List<({Rect rect, Color color})> _layer(WidgetTester tester) => [
  for (final element
      in find
          .descendant(
            of: find.byType(AnimatedPositioned),
            matching: find.byType(DecoratedBox),
          )
          .evaluate())
    (
      rect: tester.getRect(find.byElementPredicate((e) => e == element)),
      color: ((element.widget as DecoratedBox).decoration as ShapeDecoration)
          .color!,
    ),
];

CalendarDaySpec _day(WidgetTester tester, int day) => tester
    .widget<StyleSpecProvider<CalendarDaySpec>>(
      find
          .ancestor(
            of: find.text('$day'),
            matching: find.byType(StyleSpecProvider<CalendarDaySpec>),
          )
          .first,
    )
    .spec
    .spec;

/// A day slot narrowed to its drawn circle, 2px in from each side.
Rect _dayRect(WidgetTester tester, int day) => tester
    .getRect(
      find
          .ancestor(
            of: find.text('$day'),
            matching: find.byType(StyleSpecProvider<CalendarDaySpec>),
          )
          .first,
    )
    .deflateHorizontally(2);

extension on Rect {
  Rect deflateHorizontally(double inset) =>
      Rect.fromLTRB(left + inset, top, right - inset, bottom);
}

double _contrast(Color a, Color b) {
  final x = a.computeLuminance(), y = b.computeLuminance();
  return (x > y ? x + .05 : y + .05) / (x > y ? y + .05 : x + .05);
}

void main() {
  for (final dark in [false, true]) {
    for (final rtl in [false, true]) {
      testWidgets(
        '$dark $rtl the range is two accent discs over a tinted pill',
        (tester) async {
          await _pump(tester, dark: dark, rtl: rtl);
          final context = tester.element(find.byType(RangeCalendarExample));
          final fills = tester
              .widgetList<DecoratedBox>(
                find.descendant(
                  of: find.byType(AnimatedPositioned),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .map((box) => (box.decoration as ShapeDecoration).color)
              .toList();
          final disc = FortalTokens.accent9.resolve(context);
          expect(fills.where((c) => c == disc), hasLength(2));
          expect(fills, contains(FortalTokens.accentSurface.resolve(context)));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  for (final rtl in [false, true]) {
    testWidgets('${rtl ? 'RTL' : 'LTR'} draft range moves the discs to the '
        'draft ends and tints the days between', (tester) async {
      await _pump(tester, rtl: rtl);
      final context = tester.element(find.byType(RangeCalendarExample));
      final disc = FortalTokens.accent9.resolve(context);
      final tint = FortalTokens.accentSurface.resolve(context);
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      final step = rtl
          ? LogicalKeyboardKey.arrowLeft
          : LogicalKeyboardKey.arrowRight;
      await tester.sendKeyEvent(step);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(step);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      final layer = _layer(tester);
      final discs = [
        for (final part in layer)
          if (part.color == disc) part.rect,
      ];
      expect(discs, hasLength(2));
      for (final (i, day) in [20, 22].indexed) {
        expect(discs[i].center.dx, closeTo(_dayRect(tester, day).center.dx, 1));
        expect(discs[i].center.dy, closeTo(_dayRect(tester, day).center.dy, 1));
      }
      final band = layer.singleWhere((part) => part.color == tint).rect;
      final (first, last) = rtl
          ? (_dayRect(tester, 22), _dayRect(tester, 20))
          : (_dayRect(tester, 20), _dayRect(tester, 22));
      expect(band.left, closeTo(first.left, 1));
      expect(band.right, closeTo(last.right, 1));
      expect(
        (_day(tester, 21).container.spec.decoration as BoxDecoration?)?.color,
        tint,
      );
      expect(
        (_day(tester, 11).container.spec.decoration as BoxDecoration?)?.color,
        isNot(tint),
      );
    });
  }

  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'} disabled range stays visible at '
        'half strength', (tester) async {
      await _pump(
        tester,
        dark: dark,
        child: Center(
          child: FortalRangeCalendar(
            value: CivilDateRange(
              start: DateTime(2026, 11, 10),
              end: DateTime(2026, 11, 13),
            ),
            firstDate: DateTime(2026),
            lastDate: DateTime(2027),
            firstDayOfWeek: DateTime.monday,
            enabled: false,
            onChanged: (_) {},
          ),
        ),
      );
      final context = tester.element(find.byType(FortalRangeCalendar));
      final disc = FortalTokens.accent9.resolve(context);
      final page = FortalTokens.colorBackground.resolve(context);
      final discs = [
        for (final part in _layer(tester))
          if (part.color == disc) part.rect,
      ];
      expect(discs, hasLength(2));
      expect(discs.first.center.dx, closeTo(_dayRect(tester, 10).center.dx, 1));
      expect(discs.last.center.dx, closeTo(_dayRect(tester, 13).center.dx, 1));
      final opacity = tester
          .widgetList<Opacity>(
            find.ancestor(
              of: find.byType(AnimatedPositioned).first,
              matching: find.byType(Opacity),
            ),
          )
          .fold<double>(1, (value, widget) => value * widget.opacity);
      expect(opacity, 0.5);
      expect(
        _contrast(
          Color.alphaBlend(disc.withValues(alpha: disc.a * opacity), page),
          page,
        ),
        greaterThan(1.15),
      );
    });
  }

  for (final rtl in [false, true]) {
    testWidgets('${rtl ? 'RTL' : 'LTR'} keyboard focus on the range end rings '
        'its disc', (tester) async {
      final node = FocusNode();
      addTearDown(node.dispose);
      final previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
      addTearDown(() => FocusManager.instance.highlightStrategy = previous);
      await _pump(
        tester,
        rtl: rtl,
        child: Center(
          child: FortalRangeCalendar(
            value: CivilDateRange(
              start: DateTime(2026, 11, 10),
              end: DateTime(2026, 11, 13),
            ),
            firstDate: DateTime(2026),
            lastDate: DateTime(2027),
            firstDayOfWeek: DateTime.monday,
            focusNode: node,
            onChanged: (_) {},
          ),
        ),
      );
      node.requestFocus();
      await tester.pumpAndSettle();
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(
          rtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight,
        );
        await tester.pumpAndSettle();
      }
      final ring = fortalFocusOutline()
          .resolve(tester.element(find.byType(FortalRangeCalendar)))
          .outline
          .color;
      Color? outline(int day) =>
          _day(tester, day).containerEffects?.outline.color;
      expect(outline(13)?.toARGB32(), ring.toARGB32());
      expect(outline(12)?.toARGB32(), isNot(ring.toARGB32()));
      final disc = FortalTokens.accent9.resolve(
        tester.element(find.byType(FortalRangeCalendar)),
      );
      final end = _layer(tester).lastWhere((part) => part.color == disc).rect;
      final box = _dayRect(tester, 13);
      expect(box.center.dx, closeTo(end.center.dx, 1));
      expect(box.width, closeTo(end.width, 1));
      expect(tester.takeException(), isNull);
    });
  }
}
