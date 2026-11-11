import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';
import '../helpers/heroui.dart';
import '../vanilla/calendar_recipes_test.dart'
    show dayBox, dayDecoration, dayText, dayBorder;
import '../vanilla/support.dart' show contrastRatio;
import 'calendar_recipes_test.dart' show calendar;

Widget picker({bool range = false}) => range
    ? HeroUiDateRangePicker(
        value: CivilDateRange(
          start: DateTime(2026, 11, 10),
          end: DateTime(2026, 11, 13),
        ),
        firstDate: DateTime(2025),
        lastDate: DateTime(2028),
        currentDate: DateTime(2026, 11, 6),
        onChanged: (_) {},
      )
    : HeroUiDatePicker(
        value: DateTime(2026, 11, 10),
        firstDate: DateTime(2025),
        lastDate: DateTime(2028),
        currentDate: DateTime(2026, 11, 6),
        onChanged: (_) {},
      );
ButtonSpec buttonSpec(WidgetTester t) => t
    .widget<StyleSpecProvider<ButtonSpec>>(
      find.byType(StyleSpecProvider<ButtonSpec>),
    )
    .spec
    .spec;
Color fill(WidgetTester t) =>
    (buttonSpec(t).container.spec.box!.spec.decoration as BoxDecoration).color!;

void main() {
  setUp(() {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(
      () => FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic,
    );
  });
  for (final mode in ['light', 'dark']) {
    for (final range in [false, true]) {
      testWidgets(
        '$mode $range selected focus contrasts fill and surface',
        (t) async {
          FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.alwaysTraditional;
          addTearDown(
            () => FocusManager.instance.highlightStrategy =
                FocusHighlightStrategy.automatic,
          );
          await t.pumpHeroUi(
            Align(
              alignment: .topCenter,
              child: picker(range: range),
            ),
            mode: mode,
          );
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
          final effects = t
              .widget<StyleSpecProvider<CalendarDaySpec>>(dayBox(10))
              .spec
              .spec
              .containerEffects!;
          expect(
            contrastRatio(effects.outline.color, dayDecoration(t, 10)!.color!),
            greaterThanOrEqualTo(3),
          );
          expect(
            contrastRatio(
              effects.outline.color,
              heroUiToken(HeroUiTokens.overlay, mode),
            ),
            greaterThanOrEqualTo(3),
          );
          expect(effects.outlineOffset, -2);
        },
        variant: desktopOnly,
      );
      testWidgets('$mode $range open field leaves four pixels outside ring', (
        t,
      ) async {
        await t.pumpHeroUi(
          Align(
            alignment: .topCenter,
            child: picker(range: range),
          ),
          mode: mode,
        );
        await t.tap(find.byType(RemixButton));
        await t.pumpAndSettle();
        final trigger = t.getRect(find.byType(RemixButton));
        final popover = t.getRect(
          find.byType(range ? RemixRangeCalendar : RemixCalendar),
        );
        final ring = buttonSpec(t).containerEffects!;
        expect(
          popover.top -
              trigger.bottom -
              ring.outlineOffset -
              ring.outline.width,
          greaterThanOrEqualTo(4),
        );
      });
    }
    testWidgets(
      '$mode ordinary day and range middle hover are distinct',
      (t) async {
        for (final range in [false, true]) {
          await t.pumpHeroUi(calendar(range: range), mode: mode);
          await t.pumpAndSettle();
          final day = range ? 11 : 20;
          final rest = dayDecoration(t, day)!.color;
          final mouse = await t.hoverCenter(dayBox(day));
          expect(dayDecoration(t, day)!.color, isNot(rest));
          await mouse.removePointer();
        }
      },
      variant: desktopOnly,
    );
    testWidgets('$mode field hover and press have distinct fills', (t) async {
      await t.pumpHeroUi(picker(), mode: mode);
      await t.pumpAndSettle();
      final rest = fill(t);
      final mouse = await t.hoverCenter(find.byType(RemixButton));
      final hover = fill(t);
      final press = await t.pressCenter(find.byType(RemixButton));
      expect(fill(t), isNot(rest));
      expect(fill(t), isNot(hover));
      expect(hover, heroUiToken(HeroUiTokens.defaultColor, mode));
      await press.cancel();
      await mouse.removePointer();
    }, variant: desktopOnly);
    testWidgets('$mode weekday labels and blue today match reference', (
      t,
    ) async {
      for (final range in [true, false]) {
        await t.pumpHeroUi(calendar(range: range), mode: mode);
        await t.pumpAndSettle();
        expect(find.text('Sun'), findsOneWidget);
        final weekday = t
            .widget<StyledText>(
              find
                  .ancestor(
                    of: find.text('Sun'),
                    matching: find.byType(StyledText),
                  )
                  .first,
            )
            .styleSpec!
            .spec
            .style!;
        final header = heroUiCase(
          range ? 'range-calendar-header-cell' : 'calendar-header-cell',
          mode: mode,
        );
        expect(weekday.fontSize, header.px('fontSize'));
        expect(
          weekday.fontWeight,
          FontWeight.values[header.px('fontWeight') ~/ 100 - 1],
        );
        expectCssColor(weekday.color!, header.styles['color']!);
      }
      final blue = heroUiToken(HeroUiTokens.accentSoftForeground, mode);
      expect(dayText(t, 6)!.color, blue);
      expect(dayBorder(t, 6).top.color, blue);
      expect(
        contrastRatio(
          blue,
          Color.alphaBlend(
            dayDecoration(t, 6)!.color!,
            heroUiToken(HeroUiTokens.overlay, mode),
          ),
        ),
        greaterThanOrEqualTo(3),
      );
    });
    for (final range in [false, true]) {
      for (final scale in [1.0, 2.0]) {
        for (final rtl in [false, true]) {
          testWidgets(
            '$mode range=$range $scale rtl=$rtl month panel width and row gap',
            (t) async {
              await t.pumpHeroUi(
                MediaQuery(
                  data: MediaQueryData(
                    size: const Size(1024, 768),
                    textScaler: TextScaler.linear(scale),
                  ),
                  child: Directionality(
                    textDirection: rtl ? .rtl : .ltr,
                    child: Align(
                      alignment: .topCenter,
                      child: picker(range: range),
                    ),
                  ),
                ),
                mode: mode,
              );
              await t.tap(find.byType(RemixButton));
              await t.pumpAndSettle();
              final trigger = t.getRect(
                find.byType(StyleSpecProvider<SelectTriggerSpec>).first,
              );
              await t.tap(find.bySemanticsLabel('Choose month'));
              await t.pumpAndSettle();
              final panel = t.getRect(
                find.byType(StyleSpecProvider<SelectContentSpec>),
              );
              final content = t
                  .widget<StyleSpecProvider<SelectContentSpec>>(
                    find.byType(StyleSpecProvider<SelectContentSpec>),
                  )
                  .spec
                  .spec;
              expect(
                content.container.spec.constraints?.maxHeight,
                38 + 160 * scale,
              );
              expect(panel.height, 38 + 160 * scale);
              final rows = [
                for (final day in [1, 8, 15, 22, 29]) t.getRect(dayBox(day)),
              ];
              expect(
                panel.width,
                closeTo(trigger.width, .01),
                reason: 'panel=$panel trigger=$trigger rows=$rows',
              );
              expect(
                rows.any(
                  (row) => panel.bottom > row.top && panel.bottom < row.bottom,
                ),
                isFalse,
                reason: 'panel=$panel trigger=$trigger rows=$rows',
              );
              final item = t
                  .widget<StyleSpecProvider<SelectMenuItemSpec>>(
                    find
                        .byWidgetPredicate(
                          (w) =>
                              w is StyleSpecProvider<SelectMenuItemSpec> &&
                              w.spec.spec.containerEffects != null,
                        )
                        .first,
                  )
                  .spec
                  .spec;
              expect(item.containerEffects?.outlineOffset, -2);
              final focused = find
                  .byWidgetPredicate(
                    (w) =>
                        w is StyleSpecProvider<SelectMenuItemSpec> &&
                        w.spec.spec.containerEffects != null,
                  )
                  .first;
              final itemRect = t.getRect(focused);
              expect(itemRect.bottom, lessThanOrEqualTo(panel.bottom));
              expect(itemRect.top, greaterThanOrEqualTo(panel.top));
              expect(t.takeException(), isNull);
            },
          );
        }
      }
    }
  }
}
