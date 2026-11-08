import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/calendar_reference.dart';
import 'package:remix/remix.dart';

final _picker = find.byType(RemixDatePicker);
final _trigger = find.descendant(
  of: _picker,
  matching: find.byType(RemixButton),
);

// Measure the actual painted surface, not just the behavioral button's box.
final _triggerSurface = find.descendant(
  of: _trigger,
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is DecoratedBox &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).color != null,
  ),
);

Future<void> _pump(
  WidgetTester tester, {
  Size size = const Size(800, 600),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const CalendarReferenceApp());
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  if (finder.hitTestable().evaluate().isEmpty) {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Arabic empty picker announces localized noDate', (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await _pump(tester);
      await _tap(tester, find.text('العربية / RTL'));
      await _tap(tester, find.text('Clear selection'));
      expect(
        tester.widget<RemixDatePicker>(_picker).calendarLabels.noDate,
        'لم يتم اختيار تاريخ',
      );
      expect(
        tester.getSemantics(_trigger).getSemanticsData().value,
        'لم يتم اختيار تاريخ',
      );
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('Clear selection empties the picker and inline calendar', (
    tester,
  ) async {
    await _pump(tester);
    expect(tester.widget<RemixDatePicker>(_picker).value, isNotNull);
    await _tap(tester, find.text('Clear selection'));
    expect(tester.widget<RemixDatePicker>(_picker).value, isNull);
    expect(find.text('Select a date'), findsOneWidget);
    await _tap(tester, _trigger);
    await _tap(tester, find.text('13'));
    expect(
      tester.widget<RemixDatePicker>(_picker).value,
      DateTime(2026, 11, 13),
    );
    await _tap(tester, find.text('Clear selection'));
    await _tap(tester, find.text('Inline'));
    expect(
      tester.widget<RemixCalendar>(find.byType(RemixCalendar)).value,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'picker and inline are exclusive and preserve the selected date',
    (tester) async {
      await _pump(tester);
      expect(find.byType(RemixCalendar), findsNothing);
      await _tap(tester, _trigger);
      expect(find.byType(RemixCalendar), findsOneWidget);
      await _tap(tester, find.text('13'));
      expect(find.byType(RemixCalendar), findsNothing);
      expect(
        tester.widget<RemixDatePicker>(_picker).value,
        DateTime(2026, 11, 13),
      );

      await _tap(tester, find.text('Inline'));
      expect(_picker, findsNothing);
      expect(find.byType(RemixCalendar), findsOneWidget);
      expect(
        tester.widget<RemixCalendar>(find.byType(RemixCalendar)).value,
        DateTime(2026, 11, 13),
      );
      await _tap(tester, find.text('19'));
      await _tap(tester, find.text('Picker'));
      expect(find.byType(RemixCalendar), findsNothing);
      expect(
        tester.widget<RemixDatePicker>(_picker).value,
        DateTime(2026, 11, 19),
      );
      await _tap(tester, _trigger);
      expect(find.byType(RemixCalendar), findsOneWidget);
      expect(
        tester.widget<RemixCalendar>(find.byType(RemixCalendar)).value,
        DateTime(2026, 11, 19),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('painted trigger, hit target and popup align in LTR and RTL', (
    tester,
  ) async {
    await _pump(tester);
    for (final rtl in [false, true]) {
      if (rtl) await _tap(tester, find.text('العربية / RTL'));
      final surface = tester.getRect(_triggerSurface);
      expect(tester.getRect(_trigger), surface);
      expect(tester.getRect(_picker), surface);
      await tester.tapAt(
        Offset(rtl ? surface.left - 2 : surface.right + 2, surface.center.dy),
      );
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      await _tap(tester, _trigger);
      final panelSurface = find
          .ancestor(
            of: find.byType(RemixCalendar),
            matching: find.byType(DecoratedBox),
          )
          .first;
      final panel = tester.getRect(panelSurface);
      expect(
        rtl ? panel.right : panel.left,
        closeTo(rtl ? surface.right : surface.left, 1),
      );
      final decoration =
          tester.widget<DecoratedBox>(panelSurface).decoration as BoxDecoration;
      expect(decoration.color!.a, 1);
      expect(decoration.boxShadow, isNotEmpty);
      expect(panel.bottom, lessThanOrEqualTo(592));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'narrow RTL at 200% keeps hidden dates reachable by wheel and keys',
    (tester) async {
      await _pump(tester, size: const Size(360, 640));
      await _tap(tester, find.text('العربية / RTL'));
      await _tap(tester, find.text('200% text'));
      expect(find.textContaining('Tab into the calendar'), findsNothing);
      await _tap(tester, _trigger);
      final panel = tester.getRect(find.byType(RemixCalendar));
      expect(panel.left, greaterThanOrEqualTo(8));
      expect(panel.right, lessThanOrEqualTo(352));
      expect(panel.top, greaterThanOrEqualTo(8));
      expect(panel.bottom, lessThanOrEqualTo(632));
      final lastDay = find.text('٣٠');
      expect(lastDay.hitTestable(), findsNothing);
      await tester.sendEventToBinding(
        PointerHoverEvent(position: panel.center),
      );
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: panel.center,
          scrollDelta: const Offset(0, 600),
        ),
      );
      await tester.pumpAndSettle();
      expect(lastDay.hitTestable(), findsOneWidget);
      // The picker initially focuses the 12th; arrow navigation must reveal the
      // 26th even after pointer scrolling moved the viewport independently.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(find.text('٢٦').hitTestable(), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.byType(RemixCalendar), findsNothing);
      expect(
        tester.widget<RemixDatePicker>(_picker).value,
        DateTime(2026, 11, 26),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
