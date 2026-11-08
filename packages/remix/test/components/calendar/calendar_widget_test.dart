import 'dart:ui' show Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedCalendarDay;
import 'package:remix/remix.dart';

Widget _host(
  Widget child, {
  double textScale = 1,
  TextDirection direction = TextDirection.ltr,
}) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (context, _) => MediaQuery(
    data: MediaQuery.of(
      context,
    ).copyWith(textScaler: TextScaler.linear(textScale)),
    child: Directionality(
      textDirection: direction,
      child: Overlay.wrap(child: Center(child: child)),
    ),
  ),
);

RemixCalendar _calendar({
  CalendarStyler style = const CalendarStyler.create(),
  RemixCalendarLabels labels = const RemixCalendarLabels(),
  CalendarSpec? styleSpec,
  ValueChanged<DateTime>? onChanged,
  FocusNode? focusNode,
  DateTime? value,
  bool enabled = true,
}) => RemixCalendar(
  value: value ?? DateTime(2024, 2, 14),
  firstDate: DateTime(2023),
  lastDate: DateTime(2026, 12, 31),
  currentDate: DateTime(2024, 2, 15),
  onChanged: onChanged ?? (_) {},
  focusNode: focusNode,
  style: style,
  styleSpec: styleSpec,
  labels: labels,
  enabled: enabled,
);

class _PlatformScrollBehavior extends ScrollBehavior {
  const _PlatformScrollBehavior(this.platform);

  final TargetPlatform platform;

  @override
  TargetPlatform getPlatform(BuildContext context) => platform;
}

TextStyle? _renderedTextStyle(WidgetTester tester, String label) => tester
    .widget<RichText>(
      find.descendant(of: find.text(label), matching: find.byType(RichText)),
    )
    .text
    .style;

void main() {
  testWidgets('header and weekday gaps preserve column-centred navigation', (
    t,
  ) async {
    await t.pumpWidget(
      _host(
        _calendar(
          style: CalendarStyler()
              .headerSpacing(8)
              .weekdaySpacing(4)
              .day(CalendarDayStyler().minWidth(64).minHeight(64)),
        ),
      ),
    );
    final previous = find.byType(RemixIconButton).first;
    final next = find.byType(RemixIconButton).last;
    final first = find.text('4');
    final last = find.text('10');
    expect(t.getCenter(previous).dx, closeTo(t.getCenter(first).dx, .01));
    expect(t.getCenter(next).dx, closeTo(t.getCenter(last).dx, .01));
    final weekday = find.text('Su');
    expect(t.getTopLeft(weekday).dy - t.getBottomLeft(previous).dy, 8);
    final day = find.ancestor(
      of: find.text('1'),
      matching: find.byType(NakedCalendarDay),
    );
    expect(t.getTopLeft(day).dy - t.getBottomLeft(weekday).dy, 4);
    expect(t.takeException(), isNull);
  });

  testWidgets('default week rows have a four pixel vertical gap', (t) async {
    await t.pumpWidget(_host(_calendar()));
    Finder tile(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(NakedCalendarDay),
    );
    expect(
      t.getTopLeft(tile('8')).dy - t.getBottomLeft(tile('1')).dy,
      greaterThanOrEqualTo(4),
    );
    expect(t.getTopLeft(tile('2')).dx - t.getTopRight(tile('1')).dx, 0);
    await t.pumpWidget(_host(_calendar(style: CalendarStyler().rowSpacing(2))));
    expect(t.getTopLeft(tile('8')).dy - t.getBottomLeft(tile('1')).dy, 2);
  });

  testWidgets('day effects paint without changing layout', (tester) async {
    final style = CalendarStyler().day(
      CalendarDayStyler().onFocusVisible(
        CalendarDayStyler().containerEffects(
          RemixBoxEffectsMix.outline(
            BorderSideMix(color: const Color(0xff555555), width: 3),
          ).outlineOffset(-3),
        ),
      ),
    );
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(_host(_calendar(style: style, focusNode: node)));
    final day = find
        .ancestor(
          of: find.text('14'),
          matching: find.byType(StyleSpecProvider<CalendarDaySpec>),
        )
        .first;
    final before = tester.getRect(day);
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(
      () => FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic,
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    final spec = tester
        .widget<StyleSpecProvider<CalendarDaySpec>>(day)
        .spec
        .spec;
    expect(spec.containerEffects?.outline.width, 3);
    expect(tester.getRect(day), before);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dropdown caption has one row and a semantic live heading', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(_host(_calendar()));
    expect(find.text('February 2024'), findsNothing);
    final heading = tester.getSemantics(find.bySemanticsLabel('February 2024'));
    expect(heading.getSemanticsData().flagsCollection.isHeader, isTrue);
    expect(heading.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
    final month = tester.getRect(find.byType(RemixSelect<int>).first);
    final previous = tester.getRect(find.bySemanticsLabel('Previous month'));
    final next = tester.getRect(find.bySemanticsLabel('Next month'));
    expect(month.center.dy, previous.center.dy);
    expect(month.center.dy, next.center.dy);
    await tester.tap(find.bySemanticsLabel('Next month'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('March 2024'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('month and year selector text fits at 200 percent scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        RemixCalendar(
          value: DateTime(2024, 2, 14),
          firstDate: DateTime(2023),
          lastDate: DateTime(2026),
          onChanged: (_) {},
          labels: RemixCalendarLabels(month: (_) => 'فبراير'),
          selectorStyle: SelectStyler().trigger(
            SelectTriggerStyler()
                .height(32)
                .label(TextStyler().fontSize(16).height(1.5)),
          ),
        ),
        textScale: 2,
        direction: TextDirection.rtl,
      ),
    );
    for (final label in ['فبراير', '2024']) {
      final text = tester.renderObject<RenderParagraph>(
        find.descendant(of: find.text(label), matching: find.byType(RichText)),
      );
      final box = tester.getRect(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(RemixSelect<int>),
        ),
      );
      final top = text.localToGlobal(Offset.zero).dy;
      expect(text.didExceedMaxLines, isFalse);
      expect(top, greaterThanOrEqualTo(box.top));
      expect(top + text.size.height, lessThanOrEqualTo(box.bottom));
      final painter = TextPainter(
        text: text.text,
        textDirection: TextDirection.rtl,
        textScaler: TextScaler.linear(2),
      )..layout(maxWidth: text.size.width);
      expect(text.size.height, greaterThanOrEqualTo(painter.height));
      painter.dispose();
    }
  });

  testWidgets('today label uses the caller joiner', (tester) async {
    await tester.pumpWidget(
      _host(
        _calendar(
          labels: RemixCalendarLabels(
            fullDate: (_) => 'date',
            today: 'today',
            joinDayLabel: (parts) => parts.join(' / '),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('date / today'), findsOneWidget);
  });

  for (final phase in [false, true]) {
    testWidgets(
      'root ${phase ? 'phase' : 'implicit'} animation reaches day anatomy once',
      (tester) async {
        const red = Color(0xffff0000);
        const blue = Color(0xff0000ff);
        final trigger = ValueNotifier(false);
        addTearDown(trigger.dispose);
        var changed = false;
        var completions = 0;
        late StateSetter rebuild;
        await tester.pumpWidget(
          _host(
            StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                final color = changed ? blue : red;
                final base = CalendarStyler()
                    .weekday(TextStyler().color(color))
                    .day(CalendarDayStyler().color(color))
                    .wrap(.opacity(.5));
                final style = phase
                    ? base.phaseAnimation<int>(
                        trigger: trigger,
                        phases: const [0, 1],
                        styleBuilder: (value, base) => base
                            .weekday(
                              TextStyler().color(value == 0 ? red : blue),
                            )
                            .day(
                              CalendarDayStyler().color(
                                value == 0 ? red : blue,
                              ),
                            ),
                        configBuilder: (_) => CurveAnimationConfig.linear(
                          const Duration(milliseconds: 100),
                          onEnd: () => completions++,
                        ),
                      )
                    : base.animate(
                        CurveAnimationConfig.linear(
                          const Duration(milliseconds: 200),
                          onEnd: () => completions++,
                        ),
                      );
                return _calendar(style: style);
              },
            ),
          ),
        );
        final day = find.byWidgetPredicate(
          (widget) => widget is NakedCalendarDay && widget.date.day == 14,
        );
        Color? dayColor() =>
            (tester
                        .widget<Box>(
                          find
                              .descendant(of: day, matching: find.byType(Box))
                              .first,
                        )
                        .styleSpec!
                        .spec
                        .decoration
                    as BoxDecoration?)
                ?.color;
        expect(dayColor(), red);
        if (phase) {
          trigger.value = true;
        } else {
          rebuild(() => changed = true);
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(dayColor(), _renderedTextStyle(tester, 'Su')?.color);
        expect(dayColor(), isNot(red));
        expect(
          tester
              .widgetList<Opacity>(
                find.ancestor(of: day, matching: find.byType(Opacity)),
              )
              .where((widget) => widget.opacity == .5),
          hasLength(1),
        );
        await tester.pumpAndSettle();
        expect(completions, 1);
      },
    );
  }

  group('layout defaults are style values', () {
    Finder day(int value) => find.byWidgetPredicate(
      (w) => w is NakedCalendarDay && w.date.day == value,
    );

    testWidgets('defaults: 44 targets and a compact dropdown caption', (
      tester,
    ) async {
      await tester.pumpWidget(_host(_calendar()));
      expect(tester.getSize(find.byType(RemixCalendar)).width, 308);
      expect(tester.getSize(day(14)).height, 44);
      final selects = find.byType(RemixSelect<int>);
      expect(tester.getSize(selects.first).width, closeTo(127.2, .01));
      expect(
        tester.getRect(selects.last).left - tester.getRect(selects.first).right,
        8,
      );
    });

    testWidgets('a style can widen, unbound and resize the calendar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          _calendar(
            style: CalendarStyler()
                .constraints(.maxWidth(420))
                .selectorSpacing(20)
                .selectorRunSpacing(10)
                .day(CalendarDayStyler().constraints(.minHeight(52))),
          ),
        ),
      );
      expect(tester.getSize(find.byType(RemixCalendar)).width, 420);
      expect(tester.getSize(day(14)).height, 52);
      final selects = find.byType(RemixSelect<int>);
      expect(
        tester.getRect(selects.last).left - tester.getRect(selects.first).right,
        20,
      );
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 600,
            child: _calendar(
              style: CalendarStyler().constraints(.maxWidth(double.maxFinite)),
            ),
          ),
        ),
      );
      // Lifting the compact cap lets the calendar fill its parent.
      expect(tester.getSize(find.byType(RemixCalendar)).width, 600);
      // A caller minimum above the cap wins instead of conflicting with it.
      await tester.pumpWidget(
        _host(_calendar(style: CalendarStyler().constraints(.minWidth(360)))),
      );
      expect(tester.getSize(find.byType(RemixCalendar)).width, 360);
      expect(tester.takeException(), isNull);
    });

    testWidgets('selectorStyle can resize the month and year selectors', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          RemixCalendar(
            value: DateTime(2024, 2, 14),
            firstDate: DateTime(2023),
            lastDate: DateTime(2026, 12, 31),
            currentDate: DateTime(2024, 2, 15),
            onChanged: (_) {},
            selectorStyle: SelectStyler().trigger(
              SelectTriggerStyler().width(120),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(RemixSelect<int>).first).width, 120);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets(
    'material-free default renders full-date semantics and one live heading',
    (tester) async {
      final handle = tester.ensureSemantics();
      try {
        final changes = <DateTime>[];
        await tester.pumpWidget(_host(_calendar(onChanged: changes.add)));
        expect(find.bySemanticsLabel('February 2024'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Thursday, February 15, 2024, Today'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Wednesday, February 14, 2024'),
          findsOneWidget,
        );
        final heading = tester.getSemantics(
          find.bySemanticsLabel('February 2024'),
        );
        expect(heading.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
        expect(heading.getSemanticsData().flagsCollection.isHeader, isTrue);
        final selected = tester.getSemantics(
          find.bySemanticsLabel('Wednesday, February 14, 2024'),
        );
        expect(
          selected.getSemanticsData().flagsCollection.isSelected,
          Tristate.isTrue,
        );
        expect(selected.getSemanticsData().flagsCollection.isButton, isTrue);
        await tester.tap(find.text('16'));
        await tester.pump();
        expect(changes, [DateTime(2024, 2, 16)]);
        expect(tester.takeException(), isNull);
      } finally {
        handle.dispose();
      }
    },
  );

  testWidgets('day style variants mark today and unavailable days', (
    tester,
  ) async {
    const normal = Color(0xff000001);
    const selected = Color(0xff000002);
    const today = Color(0xff000003);
    const disabled = Color(0xff000004);
    const unavailable = Color(0xff000005);
    Future<void> pump(DateTime value) => tester.pumpWidget(
      _host(
        RemixCalendar(
          value: value,
          firstDate: DateTime(2024, 2, 10),
          lastDate: DateTime(2026, 12, 31),
          currentDate: DateTime(2024, 2, 15),
          isDateUnavailable: (date) => date.day == 20,
          onChanged: (_) {},
          style: CalendarStyler(
            day: CalendarDayStyler()
                .color(normal)
                .onToday(CalendarDayStyler().color(today))
                .onSelected(CalendarDayStyler().color(selected))
                .onDisabled(CalendarDayStyler().color(disabled))
                .onUnavailable(CalendarDayStyler().color(unavailable)),
          ),
        ),
      ),
    );
    Color? fill(int day) {
      final box = find
          .descendant(
            of: find.byWidgetPredicate(
              (w) =>
                  w is Semantics &&
                  (w.properties.label?.contains('February $day,') ?? false),
            ),
            matching: find.byType(Box),
          )
          .first;
      return (tester.widget<Box>(box).styleSpec?.spec.decoration
              as BoxDecoration?)
          ?.color;
    }

    await pump(DateTime(2024, 2, 14));
    expect(fill(15), today);
    expect(fill(14), selected);
    expect(fill(16), normal);
    // A predicate-rejected day is distinct from an out-of-bounds one.
    expect(fill(20), unavailable);
    expect(fill(5), disabled);
    // Selection, a widget state, outranks the today marker.
    await pump(DateTime(2024, 2, 15));
    expect(fill(15), selected);
  });

  testWidgets('day style resolves selected and hovered states independently', (
    tester,
  ) async {
    const normal = Color(0xff000001);
    const selected = Color(0xff000002);
    const hovered = Color(0xff000003);
    await tester.pumpWidget(
      _host(
        _calendar(
          style: CalendarStyler(
            day: CalendarDayStyler()
                .color(normal)
                .onSelected(CalendarDayStyler().color(selected))
                .onHovered(CalendarDayStyler().color(hovered)),
          ),
        ),
      ),
    );
    Color? fill(int day) {
      final box = find
          .descendant(
            of: find.byWidgetPredicate(
              (w) =>
                  w is Semantics &&
                  (w.properties.label?.contains('February $day,') ?? false),
            ),
            matching: find.byType(Box),
          )
          .first;
      return (tester.widget<Box>(box).styleSpec?.spec.decoration
              as BoxDecoration?)
          ?.color;
    }

    expect(fill(14), selected);
    expect(fill(13), normal);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: tester.getCenter(find.text('13')));
    await tester.pump();
    expect(fill(13), hovered);
    expect(fill(14), selected);
    await mouse.removePointer();
  });

  testWidgets('root context variants retain nested selected day styles', (
    tester,
  ) async {
    final brightness = ValueNotifier(Brightness.light);
    addTearDown(brightness.dispose);
    final style =
        CalendarStyler(
          day: CalendarDayStyler(label: TextStyler().fontSize(12)),
        ).onDark(
          CalendarStyler(
            day: CalendarDayStyler(
              label: TextStyler()
                  .fontSize(24)
                  .onSelected(TextStyler().fontWeight(FontWeight.w700)),
            ),
          ),
        );
    await tester.pumpWidget(
      _host(
        ValueListenableBuilder<Brightness>(
          valueListenable: brightness,
          builder: (context, value, _) => MediaQuery(
            data: MediaQuery.of(context).copyWith(platformBrightness: value),
            child: _calendar(style: style),
          ),
        ),
      ),
    );
    expect(_renderedTextStyle(tester, '14')?.fontSize, 12);
    brightness.value = Brightness.dark;
    await tester.pump();
    expect(_renderedTextStyle(tester, '14')?.fontSize, 24);
    expect(_renderedTextStyle(tester, '13')?.fontSize, 24);
    expect(_renderedTextStyle(tester, '14')?.fontWeight, FontWeight.w700);
    expect(
      _renderedTextStyle(tester, '13')?.fontWeight,
      isNot(FontWeight.w700),
    );
    brightness.value = Brightness.light;
    await tester.pump();
    expect(_renderedTextStyle(tester, '14')?.fontSize, 12);
  });

  testWidgets(
    'inherited day styles retain context, day states and nested effects',
    (tester) async {
      const heading = Color(0xff112233);
      const normal = Color(0xff445566);
      const selected = Color(0xff667788);
      const hovered = Color(0xff8899aa);
      final brightness = ValueNotifier(Brightness.light);
      addTearDown(brightness.dispose);
      final inherited =
          CalendarStyler(
                weekday: TextStyler().color(heading),
                day: CalendarDayStyler(
                  label: TextStyler()
                      .color(normal)
                      .fontSize(12)
                      .onSelected(TextStyler().fontWeight(FontWeight.w700))
                      .onHovered(TextStyler().color(hovered)),
                ).wrap(.opacity(0.6)),
              )
              .wrap(.opacity(0.8))
              .onDark(
                CalendarStyler(
                  day: CalendarDayStyler(
                    label: TextStyler()
                        .fontSize(24)
                        .onSelected(TextStyler().color(selected)),
                  ),
                ),
              );
      await tester.pumpWidget(
        _host(
          ValueListenableBuilder<Brightness>(
            valueListenable: brightness,
            builder: (context, value, _) => MediaQuery(
              data: MediaQuery.of(context).copyWith(platformBrightness: value),
              child: StyleProvider<CalendarSpec>(
                style: inherited,
                child: _calendar(),
              ),
            ),
          ),
        ),
      );
      expect(_renderedTextStyle(tester, 'Su')?.color, heading);
      expect(_renderedTextStyle(tester, '13')?.color, normal);
      expect(_renderedTextStyle(tester, '14')?.fontWeight, FontWeight.w700);
      expect(
        _renderedTextStyle(tester, '13')?.fontWeight,
        isNot(FontWeight.w700),
      );
      expect(_renderedTextStyle(tester, '14')?.fontSize, 12);
      // The root and nested day effects each wrap the day exactly once.
      expect(
        tester
            .widgetList<Opacity>(
              find.ancestor(
                of: find.text('14'),
                matching: find.byType(Opacity),
              ),
            )
            .map((widget) => widget.opacity),
        unorderedEquals([0.6, 0.8]),
      );
      brightness.value = Brightness.dark;
      await tester.pump();
      expect(_renderedTextStyle(tester, '14')?.fontSize, 24);
      expect(_renderedTextStyle(tester, '13')?.fontSize, 24);
      expect(_renderedTextStyle(tester, '14')?.color, selected);
      expect(_renderedTextStyle(tester, '13')?.color, normal);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: tester.getCenter(find.text('13')));
      await tester.pump();
      expect(_renderedTextStyle(tester, '13')?.color, hovered);
      expect(_renderedTextStyle(tester, '14')?.color, selected);
      await mouse.removePointer();
    },
  );

  testWidgets('local day styles override inherited matching fragments', (
    tester,
  ) async {
    const local = Color(0xff112233);
    const localSelected = Color(0xff445566);
    await tester.pumpWidget(
      _host(
        StyleProvider<CalendarSpec>(
          style: CalendarStyler(
            day: CalendarDayStyler(
              label: TextStyler()
                  .color(const Color(0xff778899))
                  .fontSize(18)
                  .onSelected(
                    TextStyler()
                        .color(const Color(0xffaabbcc))
                        .fontWeight(FontWeight.w700),
                  ),
            ),
          ),
          child: _calendar(
            style: CalendarStyler(
              day: CalendarDayStyler(
                label: TextStyler()
                    .color(local)
                    .onSelected(TextStyler().color(localSelected)),
              ),
            ),
          ),
        ),
      ),
    );
    expect(_renderedTextStyle(tester, '13')?.color, local);
    expect(_renderedTextStyle(tester, '14')?.color, localSelected);
    expect(_renderedTextStyle(tester, '14')?.fontSize, 18);
    expect(_renderedTextStyle(tester, '14')?.fontWeight, FontWeight.w700);
  });

  testWidgets('raw calendar spec bypasses inherited and local day styles', (
    tester,
  ) async {
    const raw = Color(0xff112233);
    final conflicting = CalendarStyler(
      day: CalendarDayStyler(
        label: TextStyler().color(const Color(0xff445566)),
      ).wrap(.opacity(0.6)),
    ).wrap(.opacity(0.8));
    await tester.pumpWidget(
      _host(
        StyleProvider<CalendarSpec>(
          style: conflicting,
          child: _calendar(
            style: conflicting,
            styleSpec: CalendarSpec(
              day: StyleSpec(
                spec: CalendarDaySpec(
                  label: StyleSpec(
                    spec: TextSpec(style: TextStyle(color: raw)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(_renderedTextStyle(tester, '13')?.color, raw);
    expect(_renderedTextStyle(tester, '14')?.color, raw);
    expect(
      find.ancestor(of: find.text('14'), matching: find.byType(Opacity)),
      findsNothing,
    );
  });

  testWidgets(
    'disabled state resolves root chrome independently of day states',
    (tester) async {
      const enabled = Color(0xff001122);
      const disabled = Color(0xff223344);
      final style = CalendarStyler()
          .color(enabled)
          .onDisabled(CalendarStyler().color(disabled));
      await tester.pumpWidget(_host(_calendar(style: style)));
      Color? rootFill() =>
          (tester.widget<Box>(find.byType(Box).first).styleSpec?.spec.decoration
                  as BoxDecoration?)
              ?.color;
      expect(rootFill(), enabled);
      await tester.pumpWidget(_host(_calendar(style: style, enabled: false)));
      expect(rootFill(), disabled);
    },
  );

  testWidgets(
    'default day hit targets are at least 44, width style and large-day style are honored',
    (tester) async {
      await tester.pumpWidget(_host(_calendar()));
      final target = find.bySemanticsLabel('Wednesday, February 14, 2024');
      expect(tester.getSize(target).width, greaterThanOrEqualTo(44));
      expect(tester.getSize(target).height, greaterThanOrEqualTo(44));
      await tester.pumpWidget(
        _host(_calendar(style: CalendarStyler().width(420))),
      );
      expect(tester.getSize(target).width, 60);
      await tester.pumpWidget(
        _host(
          _calendar(style: CalendarStyler(day: CalendarDayStyler().width(60))),
        ),
      );
      expect(tester.getSize(target).width, 60);
    },
  );

  for (final entry in [
    (CalendarStyler().day(CalendarDayStyler().minWidth(52)), 364.0),
    (CalendarStyler().padding(.all(12)), 332.0),
    (
      CalendarStyler()
          .padding(.all(12))
          .border(.color(const Color(0xff000000)).width(2)),
      336.0,
    ),
    (
      CalendarStyler().day(CalendarDayStyler().minWidth(52)).padding(.all(12)),
      388.0,
    ),
  ]) {
    testWidgets(
      'compact width includes day minimum, padding and border: ${entry.$2}',
      (tester) async {
        await tester.pumpWidget(_host(_calendar(style: entry.$1)));
        expect(tester.takeException(), isNull);
        final horizontal = tester
            .widgetList<Scrollable>(
              find.descendant(
                of: find.byType(RemixCalendar),
                matching: find.byType(Scrollable),
              ),
            )
            .where(
              (widget) =>
                  axisDirectionToAxis(widget.axisDirection) == Axis.horizontal,
            );
        expect(horizontal, hasLength(1));
        expect(
          tester
              .state<ScrollableState>(find.byWidget(horizontal.single))
              .position
              .maxScrollExtent,
          0,
        );
        expect(tester.getSize(find.byType(RemixCalendar)).width, entry.$2);
      },
    );
  }

  testWidgets('maxFinite in an unbounded parent uses the compact fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _calendar(style: CalendarStyler().maxWidth(double.maxFinite)),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(RemixCalendar)).width, 308);
  });

  testWidgets(
    'fallback width respects caller minima, maxima and resolved variants',
    (tester) async {
      for (final entry in [
        (CalendarStyler().minWidth(420), 420.0),
        (CalendarStyler().minWidth(420).maxWidth(560), 560.0),
        (CalendarStyler().onDisabled(CalendarStyler().minWidth(420)), 420.0),
      ]) {
        await tester.pumpWidget(
          _host(_calendar(style: entry.$1, enabled: false)),
        );
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 260,
            child: _calendar(style: CalendarStyler().minWidth(420)),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(RemixCalendar)).width, 260);
      expect(
        tester
            .getSize(find.bySemanticsLabel('Wednesday, February 14, 2024'))
            .width,
        greaterThanOrEqualTo(44),
      );
    },
  );

  testWidgets(
    '320-wide, RTL and 2x text with long labels have no paint overflow',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final labels = RemixCalendarLabels(
        month: (month) => 'Long localized month number $month',
        monthYear: (date) =>
            'Long localized heading ${date.month} ${date.year}',
        fullDate: (date) => 'Full date ${date.year}/${date.month}/${date.day}',
        weekday: (day) => 'Weekday $day',
      );
      await tester.pumpWidget(
        _host(
          _calendar(labels: labels),
          textScale: 2,
          direction: TextDirection.rtl,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.bySemanticsLabel('Full date 2024/2/14'), findsOneWidget);
    },
  );

  testWidgets(
    'small bounded viewport scrolls without overflow and reveals focused day',
    (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(
          SizedBox(
            width: 260,
            height: 180,
            child: _calendar(focusNode: focus, value: DateTime(2024, 2, 29)),
          ),
          textScale: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      focus.requestFocus();
      await tester.pumpAndSettle();
      final day = find.bySemanticsLabel('Thursday, February 29, 2024');
      final calendar = find.byType(RemixCalendar);
      final rect = tester.getRect(calendar);
      final dayRect = tester.getRect(day);
      expect(dayRect.top, greaterThanOrEqualTo(rect.top));
      expect(dayRect.bottom, lessThanOrEqualTo(rect.bottom));
      expect(tester.takeException(), isNull);
    },
  );

  for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
    testWidgets('$platform calendar scrolling is isolated from the host', (
      tester,
    ) async {
      final primary = ScrollController();
      addTearDown(primary.dispose);
      await tester.pumpWidget(
        _host(
          ScrollConfiguration(
            behavior: _PlatformScrollBehavior(platform),
            child: PrimaryScrollController(
              controller: primary,
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      primary: true,
                      itemCount: 100,
                      itemBuilder: (_, index) =>
                          SizedBox(height: 44, child: Text('Host row $index')),
                    ),
                  ),
                  SizedBox(width: 260, height: 180, child: _calendar()),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final calendarScrolls = tester.stateList<ScrollableState>(
        find.descendant(
          of: find.byType(RemixCalendar),
          matching: find.byType(Scrollable),
        ),
      );
      expect(primary.positions, hasLength(1));
      expect(calendarScrolls, hasLength(2));
      primary.jumpTo(80);
      await tester.pumpAndSettle();
      expect(primary.offset, 80);
      for (final scroll in calendarScrolls) {
        expect(scroll.position.pixels, 0);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'month/year selectors jump without selection and first Escape closes only selector',
    (tester) async {
      var hostEscapes = 0;
      final changes = <DateTime>[];
      await tester.pumpWidget(
        _host(
          CallbackShortcuts(
            bindings: {
              const SingleActivator(LogicalKeyboardKey.escape): () =>
                  hostEscapes++,
            },
            child: _calendar(onChanged: changes.add),
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Choose month'));
      await tester.pumpAndSettle();
      expect(find.text('October'), findsOneWidget);
      await tester.tap(find.text('October'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('October 2024'), findsOneWidget);
      expect(changes, isEmpty);
      await tester.tap(find.bySemanticsLabel('Choose year'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2026'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('October 2026'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Choose month'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('September'), findsNothing);
      expect(hostEscapes, 0);
      expect(changes, isEmpty);
    },
  );

  testWidgets(
    'caller labels and week-start replace all English date presentation',
    (tester) async {
      final labels = RemixCalendarLabels(
        previousMonth: 'Back',
        nextMonth: 'Forward',
        chooseMonth: 'Month option',
        chooseYear: 'Year option',
        today: 'Current day',
        month: (month) => 'M$month',
        monthYear: (date) => 'M${date.month} Y${date.year}',
        fullDate: (date) => 'Y${date.year} M${date.month} D${date.day}',
        weekday: (day) => 'W$day',
        day: (date) => 'D${date.day}',
        year: (year) => 'Y$year',
      );
      await tester.pumpWidget(
        _host(
          RemixCalendar(
            value: DateTime(2024, 2, 14),
            firstDate: DateTime(2024),
            lastDate: DateTime(2024, 12, 31),
            currentDate: DateTime(2024, 2, 15),
            labels: labels,
            firstDayOfWeek: 1,
            onChanged: (_) {},
          ),
        ),
      );
      expect(
        find.bySemanticsLabel('Y2024 M2 D15, Current day'),
        findsOneWidget,
      );
      expect(find.text('W1'), findsOneWidget);
      expect(find.bySemanticsLabel('M2 Y2024'), findsOneWidget);
      expect(find.bySemanticsLabel('Back'), findsOneWidget);
    },
  );
}
