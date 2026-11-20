import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';
import '../helpers/heroui.dart';
import '../vanilla/calendar_recipes_test.dart'
    show dayBox, dayDecoration, dayText, dayBorder;
import '../vanilla/support.dart' show contrastRatio;

Widget calendar({bool range = false, bool enabled = true}) => range
    ? HeroUiRangeCalendar(
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
    : HeroUiCalendar(
        value: DateTime(2026, 11, 10),
        firstDate: DateTime(2025),
        lastDate: DateTime(2028, 12, 31),
        currentDate: DateTime(2026, 11, 6),
        onChanged: (_) {},
        enabled: enabled,
        isDateUnavailable: (d) => d.day == 18,
      );
void main() {
  testWidgets('bounded range field retains both endpoints at 200%', (t) async {
    await t.pumpHeroUi(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(1024, 768),
          textScaler: TextScaler.linear(2),
        ),
        child: SizedBox(
          width: 240,
          child: HeroUiDateRangePicker(
            value: CivilDateRange(
              start: DateTime(2026, 11, 10),
              end: DateTime(2026, 11, 13),
            ),
            firstDate: DateTime(2025),
            lastDate: DateTime(2028),
            onChanged: (_) {},
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    final text = find.textContaining('11/10/2026');
    final paragraph = t.renderObject<RenderParagraph>(text);
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(paragraph.text.toPlainText(), contains('11/13/2026'));
    expect(t.takeException(), isNull);
  });
  for (final mode in ['light', 'dark']) {
    for (final range in [false, true]) {
      testWidgets('$mode $range disabled days dim and do not select', (
        t,
      ) async {
        await t.pumpHeroUi(calendar(range: range, enabled: false), mode: mode);
        await t.pumpAndSettle();
        expect(t.opacityAbove(find.text('20')), HeroUiTokens.disabledOpacity);
        final before = dayDecoration(t, 10)?.color;
        await t.tap(find.text('20'));
        await t.pumpAndSettle();
        expect(dayDecoration(t, 10)?.color, before);
        expect(t.takeException(), isNull);
      });
    }
    testWidgets(
      '$mode range caps and draft ends have a distinct inset focus contour',
      (t) async {
        FocusManager.instance.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;
        addTearDown(
          () => FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.automatic,
        );
        await t.pumpHeroUi(calendar(range: true), mode: mode);
        await t.pumpAndSettle();
        final size = t.getSize(dayBox(10));
        await t.tap(find.text('10'));
        await t.pumpAndSettle();
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        final focused = t
            .widget<StyleSpecProvider<CalendarDaySpec>>(dayBox(11))
            .spec
            .spec
            .containerEffects;
        expect(focused?.outline.width, 2);
        expect(focused?.outlineOffset, -2);
        expect(
          focused?.outline.color,
          heroUiToken(HeroUiTokens.foreground, mode),
        );
        expect(t.getSize(dayBox(10)), size);
        expect(t.takeException(), isNull);
      },
      variant: desktopOnly,
    );
    testWidgets(
      '$mode calendar roles, pointer states and today contrast',
      (t) async {
        await t.pumpHeroUi(calendar(), mode: mode);
        await t.pumpAndSettle();
        expect(
          t.getSize(dayBox(10)),
          heroUiCase('calendar-day10', mode: mode).size,
        );
        expectCssColor(
          dayDecoration(t, 10)!.color!,
          heroUiCase('calendar-day10', mode: mode).styles['backgroundColor']!,
        );
        expect(
          dayDecoration(t, 10)?.color,
          heroUiToken(HeroUiTokens.accent, mode),
        );
        expect(
          dayText(t, 10)?.color,
          heroUiToken(HeroUiTokens.accentForeground, mode),
        );
        expect(
          contrastRatio(
            dayBorder(t, 6).top.color,
            Color.alphaBlend(
              dayDecoration(t, 6)!.color!,
              heroUiToken(HeroUiTokens.overlay, mode),
            ),
          ),
          greaterThanOrEqualTo(3),
        );
        expect(dayText(t, 18)?.decoration, TextDecoration.lineThrough);
        final mouse = await t.hoverCenter(dayBox(10));
        expect(
          dayDecoration(t, 10)?.color,
          heroUiToken(HeroUiTokens.accent, mode),
        );
        final press = await t.pressCenter(dayBox(10));
        expect(
          dayDecoration(t, 10)?.color,
          heroUiToken(HeroUiTokens.accentHover, mode),
        );
        await press.up();
        await mouse.removePointer();
        expect(t.takeException(), isNull);
      },
      variant: desktopOnly,
    );
    testWidgets(
      '$mode live draft beats committed range and preserves roles on hover',
      (t) async {
        await t.pumpHeroUi(calendar(range: true), mode: mode);
        await t.pumpAndSettle();
        expect(
          dayDecoration(t, 10)?.color,
          heroUiToken(HeroUiTokens.accent, mode),
        );
        expectCssColor(
          dayDecoration(t, 11)!.color!,
          heroUiCase(
            'range-calendar-day11',
            mode: mode,
          ).styles['backgroundColor']!,
        );
        await t.tap(find.text('20'));
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await t.pumpAndSettle();
        expect(dayDecoration(t, 10)?.color, isNot(dayDecoration(t, 20)?.color));
        expect(dayDecoration(t, 10)?.color, isNot(dayDecoration(t, 11)?.color));
        final mouse = await t.hoverCenter(dayBox(21));
        expect(
          dayDecoration(t, 21)?.color,
          isNot(heroUiToken(HeroUiTokens.accent, mode)),
        );
        await mouse.moveTo(t.getCenter(dayBox(10)));
        await t.pumpAndSettle();
        expect(
          dayDecoration(t, 10)?.color,
          isNot(heroUiToken(HeroUiTokens.accent, mode)),
        );
        await mouse.removePointer();
        expect(t.takeException(), isNull);
      },
      variant: desktopOnly,
    );
    for (final range in [false, true]) {
      testWidgets('$mode $range square RTL 200% tiles and scaled chevrons', (
        t,
      ) async {
        await t.pumpHeroUi(
          Directionality(
            textDirection: TextDirection.rtl,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(1024, 768),
                textScaler: TextScaler.linear(2),
              ),
              child: calendar(range: range),
            ),
          ),
          mode: mode,
        );
        await t.pumpAndSettle();
        expect(t.getSize(dayBox(10)), const Size(72, 72));
        final nav = t
            .widget<StyleSpecProvider<IconButtonSpec>>(
              find.byType(StyleSpecProvider<IconButtonSpec>).first,
            )
            .spec
            .spec;
        expect(nav.icon.spec.size, 32);
        expect(t.takeException(), isNull);
      });
      testWidgets(
        '$mode $range picker field, inset, nested selector cue and overrides',
        (t) async {
          await t.pumpHeroUi(
            range
                ? HeroUiDateRangePicker(
                    value: null,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2028),
                    currentDate: DateTime(2026, 11, 6),
                    onChanged: (_) {},
                    buttonStyle: ButtonStyler().minWidth(280),
                  )
                : HeroUiDatePicker(
                    value: null,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2028),
                    currentDate: DateTime(2026, 11, 6),
                    onChanged: (_) {},
                    buttonStyle: ButtonStyler().minWidth(280),
                  ),
            mode: mode,
          );
          final button = t
              .widget<StyleSpecProvider<ButtonSpec>>(
                find.byType(StyleSpecProvider<ButtonSpec>),
              )
              .spec
              .spec;
          expect(button.container.spec.box!.spec.constraints!.minWidth, 280);
          expect(button.iconAlignment, RemixPlacement.end);
          expect(
            button.icon.spec.color,
            heroUiToken(HeroUiTokens.fieldPlaceholder, mode),
          );
          await t.tap(find.byType(RemixButton));
          await t.pumpAndSettle();
          final pop = t
              .widget<StyleSpecProvider<PopoverSpec>>(
                find.byType(StyleSpecProvider<PopoverSpec>),
              )
              .spec
              .spec;
          expect(pop.container.spec.padding, EdgeInsets.zero);
          expect(
            (pop.container.spec.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(
              double.parse(
                heroUiCase(
                  'date-picker-popover',
                  mode: mode,
                  state: true,
                ).styles['borderRadius']!.replaceAll('px', ''),
              ),
            ),
          );
          await t.tap(find.bySemanticsLabel('Choose month'));
          await t.pumpAndSettle();
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
