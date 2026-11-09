import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

import '../vanilla/calendar_recipes_test.dart' show dayBox, dayDecoration;

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
      testWidgets('$family at $scale navigation is 24px scaled', (t) async {
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
        final glyphs = find.descendant(
          of: find.byType(RemixIconButton),
          matching: find.byType(RemixPathIcon),
        );
        for (final glyph in glyphs.evaluate()) {
          expect(
            t.getSize(find.byElementPredicate((e) => e == glyph)),
            Size.square(24 * scale),
          );
        }
        expect(glyphs, findsNWidgets(2));
      });
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
    }
  }
  testWidgets(
    'dark stale range lifts off picker surface while live draft wins',
    (t) async {
      t.view.devicePixelRatio = 1;
      t.view.physicalSize = const Size(1000, 1500);
      addTearDown(() {
        t.view.resetPhysicalSize();
        t.view.resetDevicePixelRatio();
      });
      await t.binding.setSurfaceSize(const Size(1000, 1500));
      addTearDown(() => t.binding.setSurfaceSize(null));
      await t.pumpWidget(host(fixture('range-picker')));
      await t.tap(find.byType(RemixButton));
      await t.pumpAndSettle();
      await t.tap(find.text('20'));
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pumpAndSettle();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pumpAndSettle();
      expect(dayDecoration(t, 10)?.color, const Color(0xff242424));
      expect(dayDecoration(t, 11)?.color?.toARGB32(), 0xff202020);
      expect(dayDecoration(t, 21)?.color, const Color(0xff2a2a2a));
      expect(dayDecoration(t, 20)?.color, const Color(0xff313131));
    },
  );
}
