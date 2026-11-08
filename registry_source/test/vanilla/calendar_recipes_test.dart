import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

Finder dayBox(int day) =>
    find.ancestor(of: find.text('$day'), matching: find.byType(Box)).first;
BoxDecoration? dayDecoration(WidgetTester tester, int day) =>
    tester.widget<Box>(dayBox(day)).styleSpec!.spec.decoration
        as BoxDecoration?;
TextStyle? dayText(WidgetTester tester, int day) => tester
    .widget<StyledText>(
      find
          .ancestor(of: find.text('$day'), matching: find.byType(StyledText))
          .first,
    )
    .styleSpec!
    .spec
    .style;

Widget calendarHost(
  Widget child,
  VanillaThemeData theme, {
  bool rtl = false,
  double scale = 1,
}) => WidgetsApp(
  color: theme.background,
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, _, _) => builder(context),
  ),
  builder: (context, navigator) => VanillaTheme(
    theme: theme,
    child: Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(scale)),
        child: navigator!,
      ),
    ),
  ),
  home: Center(child: child),
);

VanillaCalendar calendar({
  bool enabled = true,
  CalendarStyler style = const CalendarStyler.create(),
}) => VanillaCalendar(
  value: DateTime(2026, 11, 12),
  firstDate: DateTime(2026, 11, 5),
  lastDate: DateTime(2026, 11, 25),
  currentDate: DateTime(2026, 11, 6),
  isDateUnavailable: (d) => d.day == 18,
  onChanged: (_) {},
  enabled: enabled,
  style: style,
);
VanillaRangeCalendar rangeCalendar({
  bool enabled = true,
  CivilDateRange? value,
}) => VanillaRangeCalendar(
  value:
      value ??
      CivilDateRange(
        start: DateTime(2026, 11, 10),
        end: DateTime(2026, 11, 13),
      ),
  firstDate: DateTime(2026),
  lastDate: DateTime(2027),
  currentDate: DateTime(2026, 11, 6),
  isDateUnavailable: (d) => d.day == 18,
  onChanged: (_) {},
  enabled: enabled,
);

void main() {
  for (final theme in vanillaThemes) {
    testWidgets(
      '${theme.name} calendar differentiates today, selection and unavailable',
      (t) async {
        await t.pumpWidget(calendarHost(calendar(), theme.data));
        expect(dayDecoration(t, 20)?.color?.a, 0);
        expect(dayDecoration(t, 12)?.color, theme.data.primary);
        expect(dayText(t, 12)?.color, theme.data.primaryForeground);
        expect(dayDecoration(t, 6)?.color, theme.data.accent);
        expect(dayText(t, 18)?.decoration, TextDecoration.lineThrough);
        expect(dayText(t, 1)?.decoration, isNot(TextDecoration.lineThrough));
        expect(dayText(t, 1)?.color, theme.data.mutedForeground);
      },
    );
    testWidgets('${theme.name} calendar hover and press are visible', (
      t,
    ) async {
      await t.pumpWidget(calendarHost(calendar(), theme.data));
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer();
      addTearDown(mouse.removePointer);
      final resting = dayDecoration(t, 20)?.color;
      await mouse.moveTo(t.getCenter(dayBox(20)));
      await t.pumpAndSettle();
      expect(dayDecoration(t, 20)?.color, isNot(resting));
      await mouse.down(t.getCenter(dayBox(20)));
      await t.pumpAndSettle();
      expect(dayDecoration(t, 20)?.color, isNot(resting));
      await mouse.up();
    });
    testWidgets(
      '${theme.name} range draft differs and de-emphasizes committed selection',
      (t) async {
        await t.pumpWidget(calendarHost(rangeCalendar(), theme.data));
        final committed = dayDecoration(t, 10)?.color;
        expect(committed, theme.data.primary);
        expect(dayDecoration(t, 11)?.color, theme.data.accent);
        await t.tap(find.text('20'));
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        expect(dayDecoration(t, 10)?.color, theme.data.muted);
        expect(dayText(t, 10)?.color, theme.data.mutedForeground);
        expect(dayDecoration(t, 20)?.color, isNot(committed));
        expect(dayDecoration(t, 21)?.color, isNot(dayDecoration(t, 11)?.color));
        expect(
          (dayDecoration(t, 21)?.border as Border?)?.top.color.a,
          greaterThan(0),
        );
        await t.sendKeyEvent(LogicalKeyboardKey.escape);
        await t.pumpAndSettle();
        expect(dayDecoration(t, 10)?.color, committed);
      },
    );
    testWidgets('${theme.name} blocked preview has an error treatment', (
      t,
    ) async {
      await t.pumpWidget(calendarHost(rangeCalendar(), theme.data));
      await t.tap(find.text('17'));
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pumpAndSettle();
      expect(dayText(t, 18)?.color, theme.data.destructive);
      expect(dayText(t, 18)?.decoration, TextDecoration.lineThrough);
    });
    testWidgets(
      '${theme.name} range endpoints and single day retain rounded caps',
      (t) async {
        await t.pumpWidget(calendarHost(rangeCalendar(), theme.data));
        final start = dayDecoration(
          t,
          10,
        )?.borderRadius?.resolve(TextDirection.ltr);
        final end = dayDecoration(
          t,
          13,
        )?.borderRadius?.resolve(TextDirection.ltr);
        expect(start?.topLeft, tokenOf(theme.data, VanillaTokens.radiusSm));
        expect(start?.topRight, Radius.zero);
        expect(end?.topLeft, Radius.zero);
        expect(end?.topRight, tokenOf(theme.data, VanillaTokens.radiusSm));
        await t.pumpWidget(
          calendarHost(
            rangeCalendar(
              value: CivilDateRange(
                start: DateTime(2026, 11, 10),
                end: DateTime(2026, 11, 10),
              ),
            ),
            theme.data,
          ),
        );
        expect(
          dayDecoration(t, 10)?.borderRadius?.resolve(TextDirection.ltr),
          BorderRadius.all(tokenOf(theme.data, VanillaTokens.radiusSm)),
        );
      },
    );
    testWidgets('${theme.name} caller overrides win on day states', (t) async {
      await t.pumpWidget(
        calendarHost(
          calendar(
            style: CalendarStyler().day(
              CalendarDayStyler().onSelected(
                CalendarDayStyler().color(theme.data.destructive),
              ),
            ),
          ),
          theme.data,
        ),
      );
      expect(dayDecoration(t, 12)?.color, theme.data.destructive);
    });
    for (final range in [false, true]) {
      testWidgets(
        '${theme.name} ${range ? "range" : "single"} disabled days fade',
        (t) async {
          await t.pumpWidget(
            calendarHost(
              range ? rangeCalendar(enabled: false) : calendar(enabled: false),
              theme.data,
            ),
          );
          final opacity = find.ancestor(
            of: dayBox(range ? 10 : 12),
            matching: find.byType(Opacity),
          );
          expect(opacity, findsWidgets);
          expect(
            t.widget<Opacity>(opacity.first).opacity,
            VanillaTokens.disabledOpacity,
          );
        },
      );
    }
    for (final range in [false, true]) {
      testWidgets(
        '${theme.name} ${range ? "range" : "single"} picker supplies each child recipe',
        (t) async {
          final picker = range
              ? VanillaDateRangePicker(
                  value: null,
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2027),
                  currentDate: DateTime(2026, 11, 6),
                  onChanged: (_) {},
                )
              : VanillaDatePicker(
                  value: null,
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2027),
                  currentDate: DateTime(2026, 11, 6),
                  onChanged: (_) {},
                );
          await t.pumpWidget(calendarHost(picker, theme.data));
          final button = t
              .widget<StyleSpecProvider<ButtonSpec>>(
                find.byType(StyleSpecProvider<ButtonSpec>).first,
              )
              .spec;
          expect(button.spec.label.spec.style?.color, theme.data.foreground);
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
          expect(
            find.byType(range ? RemixRangeCalendar : RemixCalendar),
            findsOneWidget,
          );
          expect(dayText(t, 6)?.color, theme.data.accentForeground);
          final panel = t
              .widget<StyleSpecProvider<PopoverSpec>>(
                find.byType(StyleSpecProvider<PopoverSpec>).first,
              )
              .spec;
          expect(decorationOf(panel.spec.container)?.color, theme.data.popover);
          expect(decorationOf(panel.spec.container)?.boxShadow, isNotEmpty);
          expect(t.takeException(), isNull);
        },
      );
    }
  }
}
