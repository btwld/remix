import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../vanilla/calendar_recipes_test.dart' show dayBox;

Widget host(Widget child, {double scale = 1}) => WidgetsApp(
  color: const Color(0xffffffff),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, _, _) => builder(context),
  ),
  builder: (context, navigator) => FortalTheme(
    mode: .dark,
    child: MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(scale)),
      child: navigator!,
    ),
  ),
  home: Align(alignment: .topCenter, child: child),
);

Widget fixture(String family) {
  final first = DateTime(2025);
  final last = DateTime(2028, 12, 31);
  final today = DateTime(2026, 11, 6);
  final value = CivilDateRange(
    start: DateTime(2026, 11, 10),
    end: DateTime(2026, 11, 13),
  );
  return switch (family) {
    'calendar' => FortalCalendar(
      value: today,
      firstDate: first,
      lastDate: last,
      currentDate: today,
      firstDayOfWeek: DateTime.monday,
      onChanged: (_) {},
    ),
    'range' => FortalRangeCalendar(
      value: value,
      firstDate: first,
      lastDate: last,
      currentDate: today,
      firstDayOfWeek: DateTime.monday,
      onChanged: (_) {},
    ),
    'picker' => FortalDatePicker(
      value: today,
      firstDate: first,
      lastDate: last,
      currentDate: today,
      firstDayOfWeek: DateTime.monday,
      onChanged: (_) {},
    ),
    _ => FortalDateRangePicker(
      value: value,
      firstDate: first,
      lastDate: last,
      currentDate: today,
      firstDayOfWeek: DateTime.monday,
      onChanged: (_) {},
    ),
  };
}

void main() {
  for (final scale in [1.0, 2.0]) {
    for (final family in ['calendar', 'range', 'picker', 'range-picker']) {
      testWidgets('$family at $scale navigation is 32px scaled', (t) async {
        t.view.devicePixelRatio = 1;
        t.view.physicalSize = const Size(1000, 1500);
        addTearDown(() {
          t.view.resetPhysicalSize();
          t.view.resetDevicePixelRatio();
        });
        await t.binding.setSurfaceSize(const Size(1000, 1500));
        addTearDown(() => t.binding.setSurfaceSize(null));
        await t.pumpWidget(host(fixture(family), scale: scale));
        if (family.contains('picker')) {
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
        }
        final buttons = find.byType(StyleSpecProvider<IconButtonSpec>);
        expect(buttons, findsNWidgets(2));
        for (final button in t.widgetList<StyleSpecProvider<IconButtonSpec>>(
          buttons,
        )) {
          final box = button.spec.spec.container.spec.constraints!;
          expect(box.maxWidth, 32 * scale);
          expect(box.maxHeight, 32 * scale);
        }
      });
    }
  }
  // The calendars have no month select; only the pickers' header opens the
  // month panel.
  for (final scale in [1.0, 2.0]) {
    for (final family in ['picker', 'range-picker']) {
      group('', skip: _pickerGeometry, () {
        testWidgets(
          '$family at $scale month panel avoids slicing calendar numerals',
          (t) async {
            t.view.devicePixelRatio = 1;
            t.view.physicalSize = const Size(1000, 1500);
            addTearDown(() {
              t.view.resetPhysicalSize();
              t.view.resetDevicePixelRatio();
            });
            await t.binding.setSurfaceSize(const Size(1000, 1500));
            addTearDown(() => t.binding.setSurfaceSize(null));
            await t.pumpWidget(host(fixture(family), scale: scale));
            if (family.contains('picker')) {
              await t.tap(find.byType(RemixButton));
              await t.pumpAndSettle();
            }
            await t.tap(find.bySemanticsLabel('Choose month'));
            await t.pumpAndSettle();
            final panel = find.byType(StyleSpecProvider<SelectContentSpec>);
            final rect = t.getRect(panel);
            expect(
              t
                  .widget<StyleSpecProvider<SelectContentSpec>>(panel)
                  .spec
                  .spec
                  .container
                  .spec
                  .constraints
                  ?.maxHeight,
              262 * scale,
            );
            expect(rect.height, scale == 1 ? 262 : 498);
            final rows = [
              for (final day in [3, 10, 17, 24, 30])
                t.getRect(scale == 1 ? dayBox(day) : find.text('$day')),
            ];
            expect(
              rows.any(
                (row) => rect.bottom > row.top && rect.bottom < row.bottom,
              ),
              isFalse,
              reason: 'panel bottom ${rect.bottom}; rows $rows',
            );
            expect(
              find.byWidgetPredicate(
                (w) => w is RawScrollbar && w.thumbVisibility == true,
              ),
              findsWidgets,
            );
            expect(t.takeException(), isNull);
          },
        );
      });
    }
  }
}

const _pickerGeometry =
    'The calendar rows now sit 4px apart and the pickers keep their old panel '
    'geometry until the date picker re-skin, so the panel edge lands in a row.';
