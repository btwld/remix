import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

import '../helpers/test_helpers.dart';
import '../vanilla/calendar_recipes_test.dart'
    show dayBox, dayDecoration, dayText, dayBorder;
import '../vanilla/support.dart' show contrastRatio;

Widget calendar({bool range = false, bool enabled = true}) => range
    ? FortalRangeCalendar(
        value: CivilDateRange(
          start: DateTime(2026, 11, 10),
          end: DateTime(2026, 11, 13),
        ),
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        onChanged: (_) {},
        enabled: enabled,
        isDateUnavailable: (d) => d.day == 18,
      )
    : FortalCalendar(
        value: DateTime(2026, 11, 12),
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        onChanged: (_) {},
        enabled: enabled,
        isDateUnavailable: (d) => d.day == 18,
      );

void main() {
  for (final dark in [false, true]) {
    for (final range in [false, true]) {
      testWidgets(
        '$dark $range today is gray12 bold; selection, bounds and disabled remain distinct',
        (t) async {
          await t.pumpRemixApp(
            calendar(range: range),
            mode: dark ? .dark : .light,
            accent: .orla,
          );
          final context = t.element(find.text('6'));
          expect(dayText(t, 6)?.color, FortalTokens.gray12.resolve(context));
          expect(dayText(t, 6)?.fontWeight, FontWeight.w700);
          expect(dayText(t, 18)?.decoration, TextDecoration.lineThrough);
          expect(
            dayDecoration(t, range ? 10 : 12)?.color,
            FortalTokens.accentSolid.resolve(context),
          );
          expect(
            contrastRatio(
              dayText(t, range ? 10 : 12)!.color!,
              dayDecoration(t, range ? 10 : 12)!.color!,
            ),
            greaterThanOrEqualTo(4.5),
          );
          await t.pumpRemixApp(
            calendar(range: range, enabled: false),
            mode: dark ? .dark : .light,
          );
          expect(
            dayText(t, 20)?.color,
            FortalTokens.gray9.resolve(t.element(find.text('20'))),
          );
        },
      );
      testWidgets(
        '$dark $range navigation and selector chevrons scale with 200 percent RTL text',
        (t) async {
          await t.pumpRemixApp(
            MediaQuery(
              data: const MediaQueryData(
                size: Size(1000, 1000),
                textScaler: TextScaler.linear(2),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: calendar(range: range),
              ),
            ),
            mode: dark ? .dark : .light,
            textDirection: TextDirection.rtl,
          );
          final context = t.element(find.byType(RemixIconButton).first);
          final nav = t
              .widget<StyleSpecProvider<IconButtonSpec>>(
                find.byType(StyleSpecProvider<IconButtonSpec>).first,
              )
              .spec
              .spec;
          final selector = t
              .widget<StyleSpecProvider<SelectTriggerSpec>>(
                find.byType(StyleSpecProvider<SelectTriggerSpec>).first,
              )
              .spec
              .spec;
          expect(nav.icon.spec.size, FortalTokens.space5.resolve(context) * 2);
          final glyph = find.descendant(
            of: find.byType(RemixIconButton).first,
            matching: find.byType(RemixPathIcon),
          );
          expect(
            t.getSize(glyph).height,
            FortalTokens.space5.resolve(context) * 2,
          );
          expect(selector.indicator.spec.size, 18);
          final indicator = find.descendant(
            of: find.byType(RemixSelect<int>).first,
            matching: find.byType(RemixPathIcon),
          );
          expect(t.getSize(indicator).height, 18);

          expect(t.takeException(), isNull);
        },
      );
    }
    testWidgets('$dark stale cap separates from live middle', (t) async {
      await t.pumpRemixApp(
        calendar(range: true),
        mode: dark ? .dark : .light,
        accent: .orla,
      );
      await t.tap(find.text('20'));
      await t.pumpAndSettle();
      final context = t.element(find.text('20'));
      if (dark)
        expect(
          dayDecoration(t, 10)?.color,
          isNot(FortalTokens.accent4.resolve(context)),
        );
    });
    testWidgets(
      '$dark draft retains a hierarchy and a contrasting focus contour',
      (t) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(
          () => FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.automatic,
        );
        await t.pumpRemixApp(
          calendar(range: true),
          mode: dark ? .dark : .light,
          accent: .orla,
        );
        await t.tap(find.text('20'));
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        final outline = dayBorder(t, 21).top.color;
        final focus = dayBorder(t, 22).top.color;
        expect(
          contrastRatio(focus, outline),
          greaterThanOrEqualTo(dark ? 2 : 1.1),
        );
        final context = t.element(find.text('20'));
        if (dark)
          expect(
            dayDecoration(t, 10)?.color,
            isNot(FortalTokens.accent4.resolve(context)),
          );
        expect(dayDecoration(t, 10)?.color, isNot(dayDecoration(t, 11)?.color));
        final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer();
        await mouse.moveTo(t.getCenter(dayBox(21)));
        await t.pumpAndSettle();
        final hover = dayDecoration(t, 21)?.color;
        await mouse.down(t.getCenter(dayBox(21)));
        await t.pumpAndSettle();
        expect(dayDecoration(t, 21)?.color, isNot(hover));
        await mouse.cancel();
        await mouse.removePointer();
      },
    );
    for (final range in [false, true]) {
      testWidgets(
        '$dark $range picker forwards overrides and caps nested month panel',
        (t) async {
          await t.pumpRemixApp(
            range
                ? FortalDateRangePicker(
                    value: null,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2028),
                    currentDate: DateTime(2026, 11, 6),
                    onChanged: (_) {},
                    buttonStyle: ButtonStyler().minWidth(280),
                  )
                : FortalDatePicker(
                    value: null,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2028),
                    currentDate: DateTime(2026, 11, 6),
                    onChanged: (_) {},
                    buttonStyle: ButtonStyler().minWidth(280),
                  ),
            mode: dark ? .dark : .light,
          );
          expect(
            t.getSize(find.byType(RemixButton)).width,
            greaterThanOrEqualTo(280),
          );
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
          await t.tap(find.bySemanticsLabel('Choose month'));
          await t.pumpAndSettle();
          final spec = t
              .widget<StyleSpecProvider<SelectContentSpec>>(
                find.byType(StyleSpecProvider<SelectContentSpec>).first,
              )
              .spec
              .spec;
          expect(spec.container.spec.constraints?.maxHeight, equals(262));
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
}
