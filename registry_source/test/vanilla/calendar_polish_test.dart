import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'calendar_recipes_test.dart';
import 'support.dart';

double contrast(Color a, Color b) {
  final x = a.computeLuminance(), y = b.computeLuminance();
  return (x > y ? x + .05 : y + .05) / (x > y ? y + .05 : x + .05);
}

void main() {
  for (final theme in vanillaThemes) {
    for (final range in [false, true]) {
      testWidgets(
        '${theme.name} ${range ? "range" : "single"} day focus has a 3:1 keyline and keeps geometry',
        (t) async {
          FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.alwaysTraditional;
          addTearDown(
            () => FocusManager.instance.highlightStrategy =
                FocusHighlightStrategy.automatic,
          );
          final node = FocusNode();
          addTearDown(node.dispose);
          await t.pumpWidget(
            calendarHost(
              range
                  ? VanillaRangeCalendar(
                      value: CivilDateRange(
                        start: DateTime(2026, 11, 10),
                        end: DateTime(2026, 11, 13),
                      ),
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2027),
                      focusNode: node,
                      onChanged: (_) {},
                    )
                  : VanillaCalendar(
                      value: DateTime(2026, 11, 12),
                      firstDate: DateTime(2026),
                      lastDate: DateTime(2027),
                      focusNode: node,
                      onChanged: (_) {},
                    ),
              theme.data,
            ),
          );
          final days = range ? [10, 11, 12, 13] : [12, 13];
          final rects = [for (final day in days) t.getRect(dayBox(day))];
          node.requestFocus();
          await t.pumpAndSettle();
          for (var i = 0; i < days.length; i++) {
            if (i > 0) {
              await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
              await t.pumpAndSettle();
            }
            final spec = t
                .widget<StyleSpecProvider<CalendarDaySpec>>(dayBox(days[i]))
                .spec
                .spec;
            final fill = Color.alphaBlend(
              dayDecoration(t, days[i])!.color!,
              theme.data.background,
            );
            expect(
              dayDecoration(t, days[i])!.border!.top.color,
              theme.data.ring,
            );
            final effects = spec.containerEffects!;
            expect(effects.outlineOffset, -VanillaTokens.strokeRing);
            expect(effects.outline.color, tint(theme.data.ring, .5));
            final keyline = effects.overContent!.shadows.single;
            expect(keyline.spreadRadius, greaterThan(0));
            expect(
              contrast(Color.alphaBlend(keyline.color, fill), fill),
              greaterThanOrEqualTo(3),
            );
            expect(t.getRect(dayBox(days[i])), rects[i]);
            expect(spec.container.spec.foregroundDecoration, isNull);
          }
          expect(t.takeException(), isNull);
        },
      );
    }
    testWidgets('${theme.name} RTL draft perimeter reverses its caps', (
      t,
    ) async {
      await t.pumpWidget(calendarHost(rangeCalendar(), theme.data, rtl: true));
      await t.tap(find.text('20'));
      await t.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await t.pumpAndSettle();
      }
      // Hide keyboard focus to inspect only the draft perimeter.
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTouch;
      FocusManager.instance.primaryFocus?.unfocus();
      await t.pumpAndSettle();
      final start = dayBorder(t, 20, direction: TextDirection.rtl);
      final middle = dayBorder(t, 21, direction: TextDirection.rtl);
      final end = dayBorder(t, 22, direction: TextDirection.rtl);
      expect(start.left.style, BorderStyle.none);
      expect(
        start.right.style,
        BorderStyle.solid,
        reason:
            '${NakedCalendarDayState.maybeOf(t.element(dayBox(20)))?.rangePosition} ${NakedRangeCalendarState.maybeOf(t.element(dayBox(20)))?.preview} $start',
      );
      expect(middle.left.style, BorderStyle.none);
      expect(middle.right.style, BorderStyle.none);
      expect(end.left.style, BorderStyle.solid);
      expect(end.right.style, BorderStyle.none);
      expect(t.takeException(), isNull);
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });
  }
}
