import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../helpers/test_helpers.dart';
import '../vanilla/calendar_recipes_test.dart'
    show dayBox, dayDecoration, dayText;
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
  _pickerTests();
  for (final dark in [false, true]) {
    for (final range in [false, true]) {
      testWidgets(
        '$dark $range today is medium, the selection sits on accent discs, unavailable days are muted',
        (t) async {
          await t.pumpRemixApp(
            calendar(range: range),
            mode: dark ? .dark : .light,
            accent: .orla,
          );
          await t.pumpAndSettle();
          final context = t.element(find.text('6'));
          expect(dayText(t, 6)?.color, FortalTokens.gray12.resolve(context));
          expect(dayText(t, 6)?.fontWeight, FontWeight.w500);
          expect(dayText(t, 18)?.decoration, TextDecoration.lineThrough);
          expect(
            dayText(t, 18)?.color,
            FortalTokens.gray10.resolve(context).withValues(alpha: 0.42),
          );
          final disc = FortalTokens.accent9.resolve(context);
          final ends = range ? [10, 13] : [12];
          expect(_fills(t), containsAll([disc]));
          expect(_fills(t).where((c) => c == disc), hasLength(ends.length));
          if (range) {
            expect(
              _fills(t),
              contains(FortalTokens.accentSurface.resolve(context)),
            );
            expect(dayText(t, 11)?.color, FortalTokens.gray12.resolve(context));
          }
          for (final day in ends) {
            expect(dayDecoration(t, day)?.color?.a ?? 0, 0);
            expect(
              dayText(t, day)?.color,
              FortalTokens.accentSwatchContrast.resolve(context),
            );
            expect(
              contrastRatio(dayText(t, day)!.color!, disc),
              greaterThanOrEqualTo(4.5),
            );
          }
        },
      );
      testWidgets(
        '$dark $range navigation buttons are 32px pills that scale with 200 percent RTL text',
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
          expect(find.byType(RemixIconButton), findsNWidgets(2));
          final nav = t
              .widget<StyleSpecProvider<IconButtonSpec>>(
                find.byType(StyleSpecProvider<IconButtonSpec>).first,
              )
              .spec
              .spec;
          expect(nav.icon.spec.size, 32);
          expect(nav.container.spec.constraints?.maxWidth, 64);
          expect(find.byType(RemixSelect<int>), findsNothing);
          expect(t.takeException(), isNull);
        },
      );
    }
    testWidgets('$dark the disc glides to a new day on the morph spring', (
      t,
    ) async {
      await t.pumpRemixApp(
        StatefulBuilder(builder: (context, setState) => _Holder()),
        mode: dark ? .dark : .light,
      );
      await t.pumpAndSettle();
      final from = _disc(t);
      await t.tap(find.text('20'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 60));
      final mid = _disc(t);
      expect(mid.center.dx, isNot(from.center.dx));
      expect(
        mid.center.dy,
        inExclusiveRange(from.center.dy, _dayCenter(t, 20).dy),
      );
      await t.pumpAndSettle();
      expect(
        _disc(t).center,
        offsetMoreOrLessEquals(_dayCenter(t, 20), epsilon: 0.5),
      );
    });
    testWidgets('$dark six weeks keep one height across months', (t) async {
      await t.pumpRemixApp(calendar(), mode: dark ? .dark : .light);
      await t.pumpAndSettle();
      final before = t.getSize(find.byType(RemixCalendar)).height;
      await t.tap(find.bySemanticsLabel('Next month'));
      await t.pump(const Duration(milliseconds: 100));
      // Both month grids are mounted while the strip slides.
      expect(find.text('15'), findsNWidgets(2));
      await t.pumpAndSettle();
      expect(t.getSize(find.byType(RemixCalendar)).height, before);
      expect(find.text('15'), findsOneWidget);
    });
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

class _Holder extends StatefulWidget {
  @override
  State<_Holder> createState() => _HolderState();
}

void _pickerTests() {
  for (final range in [false, true]) {
    testWidgets('$range picker trigger, chevron, footer and popover', (
      t,
    ) async {
      await t.pumpRemixApp(
        SizedBox(
          width: 280,
          child: range
              ? FortalDateRangePicker(
                  value: CivilDateRange(
                    start: DateTime(2026, 11, 10),
                    end: DateTime(2026, 11, 13),
                  ),
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2028),
                  onChanged: (_) {},
                )
              : FortalDatePicker(
                  value: DateTime(2026, 11, 12),
                  firstDate: DateTime(2025),
                  lastDate: DateTime(2028),
                  onChanged: (_) {},
                ),
        ),
      );
      final context = t.element(find.byType(RemixButton));
      final trigger = t
          .widget<StyleSpecProvider<ButtonSpec>>(
            find.byType(StyleSpecProvider<ButtonSpec>).first,
          )
          .spec
          .spec
          .container
          .spec;
      final decoration = trigger.box!.spec.decoration! as BoxDecoration;
      expect(t.getSize(find.byType(RemixButton)).height, 40);
      expect(decoration.borderRadius, BorderRadius.circular(range ? 18 : 14));
      expect(
        (decoration.border! as Border).top.color,
        FortalTokens.gray7.resolve(context),
      );
      expect(
        decoration.color,
        (range ? FortalTokens.colorPanelSolid : FortalTokens.gray2).resolve(
          context,
        ),
      );
      if (range) expect(decoration.boxShadow, isNotEmpty);
      expect(find.byIcon(RemixIcons.chevronDown), findsOneWidget);

      await t.tap(find.byType(RemixButton));
      await t.pumpAndSettle();
      final labels = const RemixCalendarLabels();
      expect(
        find.text(
          range
              ? '${labels.fullDate(DateTime(2026, 11, 10))} – ${labels.fullDate(DateTime(2026, 11, 13))}'
              : labels.fullDate(DateTime(2026, 11, 12)),
        ),
        findsWidgets,
      );
      expect(find.byType(FortalCalendarFooter), findsOneWidget);
    });
  }
}

class _HolderState extends State<_Holder> {
  DateTime _value = DateTime(2026, 11, 12);

  @override
  Widget build(BuildContext context) => FortalCalendar(
    value: _value,
    firstDate: DateTime(2025),
    lastDate: DateTime(2028, 12, 31),
    currentDate: DateTime(2026, 11, 6),
    onChanged: (next) => setState(() => _value = next),
  );
}

Iterable<Color?> _fills(WidgetTester t) => t
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(AnimatedPositioned),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((box) => (box.decoration as ShapeDecoration).color);

Rect _disc(WidgetTester t) => t.getRect(
  find
      .descendant(
        of: find.byType(AnimatedPositioned),
        matching: find.byType(DecoratedBox),
      )
      .first,
);

Offset _dayCenter(WidgetTester t, int day) => t.getCenter(dayBox(day));
