import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

Finder dayBox(int day) => find
    .ancestor(
      of: find.text('$day'),
      matching: find.byType(StyleSpecProvider<CalendarDaySpec>),
    )
    .first;
BoxDecoration? dayDecoration(WidgetTester tester, int day) =>
    tester
            .widget<StyleSpecProvider<CalendarDaySpec>>(dayBox(day))
            .spec
            .spec
            .container
            .spec
            .decoration
        as BoxDecoration?;
Border dayBorder(
  WidgetTester tester,
  int day, {
  TextDirection direction = TextDirection.ltr,
}) {
  final border = dayDecoration(tester, day)!.border!;
  if (border is Border) return border;
  final logical = border as BorderDirectional;
  return Border(
    top: logical.top,
    bottom: logical.bottom,
    left: direction == TextDirection.ltr ? logical.start : logical.end,
    right: direction == TextDirection.ltr ? logical.end : logical.start,
  );
}

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
        expect(dayDecoration(t, 6)?.color?.a, 0);
        expect(dayDecoration(t, 6)?.border?.top.color, theme.data.input);
        expect(dayText(t, 6)?.fontWeight, FontWeight.w600);
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
        expect(dayDecoration(t, 11)?.color, isNot(theme.data.accent));
        await t.tap(find.text('20'));
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        expect(dayDecoration(t, 10)?.color, theme.data.muted);
        expect(dayDecoration(t, 8)?.color?.a, 0);
        expect(dayText(t, 10)?.color, theme.data.mutedForeground);
        expect(dayDecoration(t, 20)?.color, isNot(committed));
        expect(dayDecoration(t, 21)?.color, isNot(dayDecoration(t, 11)?.color));
        expect(dayBorder(t, 21).top.color.a, greaterThan(0));
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
      for (var i = 0; i < 3; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
      }
      for (final day in [18, 19, 20]) {
        expect(dayText(t, day)?.color, theme.data.destructive);
        final opacity = t
            .widget<Opacity>(
              find
                  .ancestor(of: dayBox(day), matching: find.byType(Opacity))
                  .first,
            )
            .opacity;
        expect(opacity, 1);
        final foreground = dayText(t, day)!.color!.computeLuminance();
        final background = theme.data.background.computeLuminance();
        final contrast = foreground > background
            ? (foreground + .05) / (background + .05)
            : (background + .05) / (foreground + .05);
        expect(contrast, greaterThanOrEqualTo(4.5));
      }
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
    testWidgets(
      '${theme.name} selected and range roles retain pointer feedback',
      (t) async {
        for (final (widget, days) in [
          (calendar(), [12]),
          (rangeCalendar(), [10, 11, 13]),
        ]) {
          await t.pumpWidget(calendarHost(widget, theme.data));
          final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
          await mouse.addPointer(location: Offset.zero);
          for (final day in days) {
            await mouse.moveTo(Offset.zero);
            await t.pumpAndSettle();
            final rest = dayDecoration(t, day)?.color;
            await mouse.moveTo(t.getCenter(dayBox(day)));
            await t.pumpAndSettle();
            final hover = dayDecoration(t, day)?.color;
            expect(hover, isNot(rest), reason: 'hover $day');
            await mouse.down(t.getCenter(dayBox(day)));
            await t.pumpAndSettle();
            expect(
              dayDecoration(t, day)?.color,
              isNot(hover),
              reason: 'press $day',
            );
            await mouse.cancel();
          }
          await mouse.removePointer();
          await t.pumpWidget(const SizedBox.shrink());
        }
      },
    );
    testWidgets(
      '${theme.name} draft has perimeter edges and keeps old range shapes',
      (t) async {
        await t.pumpWidget(calendarHost(rangeCalendar(), theme.data));
        final oldShapes = [
          for (final d in [10, 11, 12, 13]) dayDecoration(t, d)?.borderRadius,
        ];
        await t.tap(find.text('20'));
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        expect([
          for (final d in [10, 11, 12, 13]) dayDecoration(t, d)?.borderRadius,
        ], oldShapes);
        final middle = dayBorder(t, 21);
        expect(middle.top.color.a, greaterThan(0));
        expect(middle.bottom.color.a, greaterThan(0));
        expect(middle.left.style, BorderStyle.none, reason: middle.toString());
        expect(middle.right.style, BorderStyle.none);
        final start = dayBorder(t, 20);
        expect(start.left.color.a, greaterThan(0));
        expect(start.right.style, BorderStyle.none);
      },
    );
    testWidgets(
      '${theme.name} unavailable is readable while out of bounds fades',
      (t) async {
        await t.pumpWidget(calendarHost(calendar(), theme.data));
        expect(dayText(t, 18)?.color, theme.data.mutedForeground);
        double opacity(int d) {
          final ancestors = find.ancestor(
            of: dayBox(d),
            matching: find.byType(Opacity),
          );
          return ancestors.evaluate().isEmpty
              ? 1
              : t.widget<Opacity>(ancestors.first).opacity;
        }

        expect(opacity(18), 1);
        expect(opacity(1), VanillaTokens.disabledOpacity);
        await t.pumpWidget(calendarHost(rangeCalendar(), theme.data));
        await t.tap(find.text('17'));
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        expect(opacity(18), 1);
        expect(dayText(t, 18)?.color, theme.data.destructive);
      },
    );
    testWidgets('${theme.name} disabled selection is quiet', (t) async {
      for (final widget in [
        calendar(enabled: false),
        rangeCalendar(enabled: false),
      ]) {
        await t.pumpWidget(calendarHost(widget, theme.data));
        final selected = widget is VanillaCalendar ? 12 : 10;
        expect(dayDecoration(t, selected)?.color, theme.data.muted);
        expect(dayText(t, selected)?.color, theme.data.mutedForeground);
        expect(dayDecoration(t, 20)?.color?.a, 0);
      }
    });
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
          expect(
            button.spec.label.spec.style?.color,
            theme.data.mutedForeground,
          );
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
          expect(
            find.byType(range ? RemixRangeCalendar : RemixCalendar),
            findsOneWidget,
          );
          expect(dayText(t, 6)?.color, theme.data.foreground);
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
