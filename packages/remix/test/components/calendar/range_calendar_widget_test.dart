import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedCalendarDay;
import 'package:remix/remix.dart';

const _white = Color(0xffffffff);
const _blue = Color(0xff2255dd);
const _yellow = Color(0xffffcc22);
const _red = Color(0xffdd2244);
const _boundary = ValueKey('calendar pixels');

NakedDateRange _range(int start, int end) => NakedDateRange(
  start: DateTime(2024, 2, start),
  end: DateTime(2024, 2, end),
);

Widget _host(
  Widget child, {
  TextDirection direction = TextDirection.ltr,
  Brightness brightness = Brightness.light,
  double textScale = 1,
}) => WidgetsApp(
  color: _white,
  builder: (context, _) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      platformBrightness: brightness,
      textScaler: TextScaler.linear(textScale),
    ),
    child: Directionality(
      textDirection: direction,
      child: Overlay.wrap(
        child: Center(
          child: RepaintBoundary(
            key: _boundary,
            child: ColoredBox(color: _white, child: child),
          ),
        ),
      ),
    ),
  ),
);

RemixRangeCalendar _calendar({
  NakedDateRange? value,
  CalendarStyler style = const CalendarStyler.create(),
  CalendarSpec? styleSpec,
  FocusNode? focusNode,
  ValueChanged<NakedDateRange>? onChanged,
  RemixCalendarLabels labels = const RemixCalendarLabels(),
  RemixRangeCalendarLabels rangeLabels = const RemixRangeCalendarLabels(),
  bool Function(DateTime)? isDateUnavailable,
}) => RemixRangeCalendar(
  value: value,
  firstDate: DateTime(2024),
  lastDate: DateTime(2025, 12, 31),
  currentDate: DateTime(2024, 2, 15),
  focusNode: focusNode,
  onChanged: onChanged ?? (_) {},
  isDateUnavailable: isDateUnavailable,
  labels: labels,
  rangeLabels: rangeLabels,
  style: style,
  styleSpec: styleSpec,
);

Finder _day(int day) => find.byWidgetPredicate(
  (widget) => widget is NakedCalendarDay && widget.date.day == day,
);

Finder _box(int day) =>
    find.descendant(of: _day(day), matching: find.byType(Box)).first;

SemanticsNode _semantics(WidgetTester tester, int day) => tester.getSemantics(
  find
      .descendant(
        of: _day(day),
        matching: find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.button == true,
        ),
      )
      .first,
);

/// The range summary is a live region that is not painted by default.
Finder _summary(Pattern text) => find.bySemanticsLabel(
  text is RegExp ? text : RegExp(RegExp.escape(text as String)),
);

// Range variants follow onSelected so they override it on shared properties,
// and caps follow the preview so they sit on a draft fill.
CalendarStyler _style() => CalendarStyler(
  day: CalendarDayStyler()
      .color(_white)
      .label(TextStyler().color(const Color(0xff111111)))
      .onSelected(CalendarDayStyler().color(_blue))
      .onRangePreview(
        CalendarDayStyler()
            .color(_yellow)
            .onDisabled(CalendarDayStyler().color(_red)),
      )
      .onRangeStart(
        CalendarDayStyler().borderRadius(
          .only(
            topStart: const Radius.circular(22),
            bottomStart: const Radius.circular(22),
          ),
        ),
      )
      .onRangeEnd(
        CalendarDayStyler().borderRadius(
          .only(
            topEnd: const Radius.circular(22),
            bottomEnd: const Radius.circular(22),
          ),
        ),
      )
      .onRangeSingle(CalendarDayStyler().borderRadius(.circular(22))),
);

Future<({ByteData bytes, int width})> _pixels(WidgetTester tester) async {
  await tester.pumpAndSettle();
  final render = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_boundary),
  );
  final result = await tester.runAsync(() async {
    final image = render.toImageSync(pixelRatio: 1);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final width = image.width;
    image.dispose();
    return (bytes: bytes, width: width);
  });
  return result!;
}

Color _pixel(
  WidgetTester tester,
  ({ByteData bytes, int width}) pixels,
  Offset global,
) {
  final point = global - tester.getTopLeft(find.byKey(_boundary));
  final index = (point.dy.floor() * pixels.width + point.dx.floor()) * 4;
  return Color.fromARGB(
    pixels.bytes.getUint8(index + 3),
    pixels.bytes.getUint8(index),
    pixels.bytes.getUint8(index + 1),
    pixels.bytes.getUint8(index + 2),
  );
}

void main() {
  for (final phase in [true, false]) {
    testWidgets(
      'root ${phase ? 'phase' : 'keyframe'} follows range endpoints without duplicating effects',
      (tester) async {
        final trigger = ValueNotifier(false);
        final moved = ValueNotifier(false);
        addTearDown(trigger.dispose);
        addTearDown(moved.dispose);
        var completions = 0;
        const selectedLabel = Color(0xff00ff00);
        final base = CalendarStyler()
            .heading(TextStyler().color(_red))
            .day(
              CalendarDayStyler()
                  .color(_white)
                  .onSelected(.label(TextStyler().color(selectedLabel)))
                  .onRangeStart(
                    CalendarDayStyler()
                        .color(_red)
                        .borderRadius(.circular(8))
                        .wrap(.opacity(.6)),
                  ),
            )
            .wrap(.opacity(.4));
        // Frames change the range-start variant; Mix builds nested day styles
        // with their variants on every frame, under each day's state.
        CalendarStyler frame(CalendarStyler base, double progress) => base
            .heading(TextStyler().color(Color.lerp(_red, _blue, progress)!))
            .day(
              CalendarDayStyler().onRangeStart(
                CalendarDayStyler().color(Color.lerp(_red, _blue, progress)!),
              ),
            );
        final style = phase
            ? base.phaseAnimation<int>(
                trigger: trigger,
                phases: const [0, 1],
                styleBuilder: (value, base) => frame(base, value.toDouble()),
                configBuilder: (_) => CurveAnimationConfig.linear(
                  const Duration(milliseconds: 100),
                  onEnd: () => completions++,
                ),
              )
            : base.keyframeAnimation(
                trigger: trigger,
                timeline: [
                  KeyframeTrack<double>('progress', [
                    const Keyframe.linear(1, Duration(milliseconds: 100)),
                  ], initial: 0),
                ],
                styleBuilder: (values, base) =>
                    frame(base, values.get<double>('progress')),
              );
        await tester.pumpWidget(
          _host(
            ValueListenableBuilder<bool>(
              valueListenable: moved,
              builder: (_, shift, _) => _calendar(
                value: shift ? _range(11, 13) : _range(10, 12),
                style: style,
              ),
            ),
          ),
        );
        Color? color(int day) =>
            (tester.widget<Box>(_box(day)).styleSpec!.spec.decoration
                    as BoxDecoration?)
                ?.color;
        expect(color(10), _red);
        expect(color(11), _white);
        trigger.value = true;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        final heading = tester.widget<RichText>(
          find.byWidgetPredicate(
            (widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'February 2024',
          ),
        );
        expect(heading.text.style!.color, Color.lerp(_red, _blue, .5));
        expect(color(10), heading.text.style!.color);
        expect(
          (tester.widget<Box>(_box(10)).styleSpec!.spec.decoration
                  as BoxDecoration)
              .borderRadius,
          BorderRadius.circular(8),
        );
        final label = tester.widget<StyledText>(
          find
              .descendant(of: _day(10), matching: find.byType(StyledText))
              .first,
        );
        expect(label.styleSpec!.spec.style!.color, selectedLabel);
        expect(
          find.byWidgetPredicate(
            (widget) => widget is Opacity && widget.opacity == .4,
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: _day(10),
            matching: find.byWidgetPredicate(
              (widget) => widget is Opacity && widget.opacity == .6,
            ),
          ),
          findsOneWidget,
        );
        moved.value = true;
        await tester.pump();
        expect(color(10), _white);
        await tester.pump(const Duration(milliseconds: 25));
        final runningHeading = tester.widget<RichText>(
          find.byWidgetPredicate(
            (widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'February 2024',
          ),
        );
        expect(
          runningHeading.text.style!.color,
          isNot(heading.text.style!.color),
        );
        expect(color(11), runningHeading.text.style!.color);
        trigger.value = false;
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 50));
        expect(color(10), _white);
        expect(color(11), Color.lerp(_red, _blue, .5));
        await tester.pumpAndSettle();
        if (phase) expect(completions, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'material-free root exposes controlled complete range and explicit draft semantics',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final requests = <NakedDateRange>[];
        await tester.pumpWidget(
          _host(_calendar(value: _range(10, 12), onChanged: requests.add)),
        );
        expect(_summary('Selected range:'), findsOneWidget);
        expect(_summary('Choose start date'), findsOneWidget);
        final selected = _semantics(tester, 10);
        expect(
          selected.getSemanticsData().flagsCollection.isSelected,
          ui.Tristate.isTrue,
        );
        expect(selected.label, contains('Range start'));
        await tester.tap(_day(20));
        await tester.pumpAndSettle();
        expect(requests, isEmpty);
        expect(_summary('Choose end date'), findsOneWidget);
        final draft = _semantics(tester, 20);
        expect(draft.label, contains('Draft start'));
        expect(draft.label, contains('Draft end'));
        expect(
          draft.getSemanticsData().flagsCollection.isSelected,
          ui.Tristate.isFalse,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        final end = _semantics(tester, 21);
        expect(end.label, contains('Draft range'));
        end.owner!.performAction(end.id, SemanticsAction.tap);
        await tester.pumpAndSettle();
        expect(requests, [_range(20, 21)]);
        expect(_summary('Choose start date'), findsOneWidget);
        expect(
          _semantics(tester, 10).getSemanticsData().flagsCollection.isSelected,
          ui.Tristate.isTrue,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final direction in TextDirection.values) {
    testWidgets(
      '$direction pixels show start/end caps, connected interiors and explicit single-day caps',
      (tester) async {
        await tester.pumpWidget(
          _host(
            _calendar(value: _range(12, 14), style: _style()),
            direction: direction,
          ),
        );
        var pixels = await _pixels(tester);
        final start = tester.getRect(_day(12));
        final middle = tester.getRect(_day(13));
        final end = tester.getRect(_day(14));
        final rtl = direction == TextDirection.rtl;
        expect(
          _pixel(tester, pixels, start.topLeft + Offset(rtl ? 41 : 2, 2)),
          _white,
        );
        expect(
          _pixel(tester, pixels, start.topLeft + Offset(rtl ? 2 : 41, 2)),
          _blue,
        );
        expect(
          _pixel(tester, pixels, middle.topLeft + const Offset(2, 2)),
          _blue,
        );
        expect(
          _pixel(tester, pixels, end.topLeft + Offset(rtl ? 2 : 41, 2)),
          _white,
        );
        expect(
          _pixel(tester, pixels, end.topLeft + Offset(rtl ? 41 : 2, 2)),
          _blue,
        );
        await tester.pumpWidget(
          _host(
            _calendar(value: _range(12, 12), style: _style()),
            direction: direction,
          ),
        );
        pixels = await _pixels(tester);
        final single = tester.getRect(_day(12));
        expect(
          _pixel(tester, pixels, single.topLeft + const Offset(2, 2)),
          _white,
        );
        expect(
          _pixel(tester, pixels, single.topRight + const Offset(-3, 2)),
          _white,
        );
        expect(
          _pixel(tester, pixels, single.centerLeft + const Offset(3, 0)),
          _blue,
        );
        expect(
          _pixel(tester, pixels, single.centerRight + const Offset(-3, 0)),
          _blue,
        );
      },
    );
  }

  testWidgets(
    'draft overlap paints preview while semantic selection stays committed; blocked completion explains why',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          _host(
            _calendar(
              value: _range(10, 12),
              style: _style(),
              isDateUnavailable: (d) => d.day == 14,
            ),
          ),
        );
        await tester.tap(_day(11));
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        var pixels = await _pixels(tester);
        expect(
          _pixel(
            tester,
            pixels,
            tester.getRect(_day(12)).centerLeft + const Offset(3, 0),
          ),
          _yellow,
        );
        expect(
          _semantics(tester, 12).getSemanticsData().flagsCollection.isSelected,
          ui.Tristate.isTrue,
        );
        for (var i = 0; i < 3; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
          await tester.pumpAndSettle();
        }
        await tester.pumpAndSettle();
        final blocked = _semantics(tester, 15);
        expect(
          blocked.getSemanticsData().hasAction(SemanticsAction.tap),
          isFalse,
        );
        expect(
          blocked.getSemanticsData().hasAction(SemanticsAction.focus),
          isTrue,
        );
        expect(_summary('Range contains unavailable dates'), findsOneWidget);
        pixels = await _pixels(tester);
        expect(
          _pixel(
            tester,
            pixels,
            tester.getRect(_day(15)).centerLeft + const Offset(3, 0),
          ),
          _red,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final rangeLast in [true, false]) {
    testWidgets(
      'a range variant declared ${rangeLast ? 'after' : 'before'} onSelected '
      '${rangeLast ? 'overrides' : 'yields to'} its fill',
      (tester) async {
        final day = CalendarDayStyler().color(_white);
        final selected = CalendarDayStyler().color(_blue);
        final start = CalendarDayStyler().color(_red);
        final style = CalendarStyler(
          day: rangeLast
              ? day.onSelected(selected).onRangeStart(start)
              : day.onRangeStart(start).onSelected(selected),
        );
        await tester.pumpWidget(
          _host(_calendar(value: _range(10, 12), style: style)),
        );
        final pixels = await _pixels(tester);
        expect(
          _pixel(
            tester,
            pixels,
            tester.getRect(_day(10)).centerRight + const Offset(-3, 0),
          ),
          rangeLast ? _red : _blue,
        );
        // The interior keeps the selected fill either way.
        expect(
          _pixel(
            tester,
            pixels,
            tester.getRect(_day(11)).topLeft + const Offset(2, 2),
          ),
          _blue,
        );
      },
    );
  }

  testWidgets(
    'root dark/RTL variants and nested day state variants resolve together',
    (tester) async {
      final style = _style()
          .onDark(
            CalendarStyler(
              day: CalendarDayStyler().onRangeStart(
                CalendarDayStyler(
                  label: TextStyler()
                      .fontSize(24)
                      .onSelected(TextStyler().fontWeight(FontWeight.w700)),
                ),
              ),
            ),
          )
          .onRtl(
            CalendarStyler(
              day: CalendarDayStyler().onRangeStart(
                CalendarDayStyler().onSelected(CalendarDayStyler().color(_red)),
              ),
            ),
          );
      await tester.pumpWidget(
        _host(
          _calendar(value: _range(12, 14), style: style),
          direction: TextDirection.rtl,
          brightness: Brightness.dark,
        ),
      );
      final text = tester
          .widget<RichText>(
            find
                .descendant(of: _day(12), matching: find.byType(RichText))
                .first,
          )
          .text
          .style!;
      expect(text.fontSize, 24);
      expect(text.fontWeight, FontWeight.w700);
      final pixels = await _pixels(tester);
      expect(
        _pixel(
          tester,
          pixels,
          tester.getRect(_day(12)).centerLeft + const Offset(3, 0),
        ),
        _red,
      );
    },
  );

  testWidgets(
    'raw spec renders every day with its day spec, without range variants',
    (tester) async {
      const raw = CalendarSpec(
        day: StyleSpec(
          spec: CalendarDaySpec(
            container: StyleSpec(
              spec: BoxSpec(
                constraints: BoxConstraints(minWidth: 44, minHeight: 44),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _blue,
                  border: Border.fromBorderSide(
                    BorderSide(color: _red, width: 2),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            label: StyleSpec(
              spec: TextSpec(
                style: TextStyle(color: _white, fontSize: 18),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        _host(
          StyleBuilder<CalendarSpec>(
            style: CalendarStyler(day: CalendarDayStyler().color(_yellow)),
            inheritable: true,
            builder: (_, _) => _calendar(
              value: _range(12, 14),
              style: _style(),
              styleSpec: raw,
            ),
          ),
        ),
      );
      for (final day in [11, 12, 13, 14]) {
        final spec = tester.widget<Box>(_box(day)).styleSpec!.spec;
        expect(spec.decoration, raw.day.spec.container.spec.decoration);
      }
      final text = tester.widget<RichText>(
        find.descendant(of: _day(12), matching: find.byType(RichText)).first,
      );
      expect(text.text.style!.fontSize, 18);
      expect(text.text.style!.color, _white);
      expect(text.maxLines, 1);
    },
  );

  for (final raw in [false, true]) {
    testWidgets('raw=$raw day/box/label metadata forwards once per day', (
      tester,
    ) async {
      final dayAnimation = AnimationConfig.linear(
        const Duration(milliseconds: 100),
      );
      final boxAnimation = AnimationConfig.linear(
        const Duration(milliseconds: 110),
      );
      final labelAnimation = AnimationConfig.linear(
        const Duration(milliseconds: 120),
      );
      // The range-start variant replaces the day's opacity modifier and
      // animation; the box and label keep their own.
      final style = CalendarStyler(
        day:
            CalendarDayStyler(
                  container: BoxStyler()
                      .animate(boxAnimation)
                      .wrap(.opacity(.8)),
                  label: TextStyler().wrap(.opacity(.7)),
                )
                .wrap(.opacity(.9))
                .onRangeStart(
                  CalendarDayStyler(
                    label: TextStyler().animate(labelAnimation),
                  ).animate(dayAnimation).wrap(.opacity(.6)),
                ),
      );
      final spec = CalendarSpec(
        day: StyleSpec(
          spec: CalendarDaySpec(
            container: StyleSpec(
              spec: const BoxSpec(
                constraints: BoxConstraints(minWidth: 44, minHeight: 44),
                alignment: Alignment.center,
              ),
              animation: boxAnimation,
              widgetModifiers: const [OpacityModifier(.8)],
            ),
            label: StyleSpec(
              spec: const TextSpec(),
              animation: labelAnimation,
              widgetModifiers: const [OpacityModifier(.7)],
            ),
          ),
          animation: dayAnimation,
          widgetModifiers: const [OpacityModifier(.9)],
        ),
      );
      await tester.pumpWidget(
        _host(
          _calendar(
            value: _range(12, 14),
            style: style,
            styleSpec: raw ? spec : null,
          ),
        ),
      );
      await tester.pumpAndSettle();
      final opacities = tester
          .widgetList<Opacity>(
            find.descendant(of: _day(12), matching: find.byType(Opacity)),
          )
          .map((w) => w.opacity)
          .toList();
      expect(opacities, unorderedEquals(raw ? [.9, .8, .7] : [.6, .8, .7]));
      final dayBuilder = tester.widget<StyleSpecBuilder<CalendarDaySpec>>(
        find
            .descendant(
              of: _day(12),
              matching: find.byWidgetPredicate(
                (w) => w is StyleSpecBuilder<CalendarDaySpec>,
              ),
            )
            .first,
      );
      expect(dayBuilder.styleSpec.animation, dayAnimation);
      expect(tester.widget<Box>(_box(12)).styleSpec!.animation, boxAnimation);
      final text = tester.widget<StyledText>(
        find.descendant(of: _day(12), matching: find.byType(StyledText)).first,
      );
      expect(text.styleSpec!.animation, labelAnimation);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'the summary is an unpainted live region over the weekday row by default',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_host(_calendar(value: _range(10, 12))));
        expect(find.textContaining('Selected range:'), findsNothing);
        final node = tester.getSemantics(_summary('Selected range:'));
        expect(node.label, contains('Choose start date'));
        expect(node.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
        expect(node.rect.isEmpty, isFalse);
        final weekdayRow = find
            .ancestor(of: find.text('Su'), matching: find.byType(Row))
            .first;
        final summaryRender = tester.renderObject<RenderBox>(
          _summary('Selected range:'),
        );
        final summaryRect = Rect.fromPoints(
          summaryRender.localToGlobal(node.rect.topLeft),
          summaryRender.localToGlobal(node.rect.bottomRight),
        );
        expect(summaryRect, tester.getRect(weekdayRow));
        await tester.tap(_day(20));
        await tester.pumpAndSettle();
        expect(_summary('Choose end date'), findsOneWidget);
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final disabled in [false, true]) {
    testWidgets(
      'noninteractive summary keeps selection without prompts (disabled: $disabled)',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          await tester.pumpWidget(
            _host(
              RemixRangeCalendar(
                value: _range(10, 12),
                firstDate: DateTime(2024),
                lastDate: DateTime(2025, 12, 31),
                enabled: !disabled,
                onChanged: disabled ? (_) {} : null,
              ),
            ),
          );
          final node = tester.getSemantics(_summary('Selected range:'));
          expect(
            node.label,
            'Selected range: Saturday, February 10, 2024 to Monday, February 12, 2024',
          );
          expect(node.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
          expect(_summary('Choose start date'), findsNothing);
          expect(_summary('Choose end date'), findsNothing);
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets('summaryBuilder paints the summary and keeps it live', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        _host(
          RemixRangeCalendar(
            value: _range(10, 12),
            firstDate: DateTime(2024),
            lastDate: DateTime(2025, 12, 31),
            currentDate: DateTime(2024, 2, 15),
            onChanged: (_) {},
            rangeLabels: RemixRangeCalendarLabels(
              joinSummary: (sentences) => sentences.join(' / '),
            ),
            summaryBuilder: (context, summary) => Text(summary),
          ),
        ),
      );
      final painted = find.textContaining('Selected range:');
      expect(painted, findsOneWidget);
      expect(
        tester.widget<Text>(painted).data,
        contains(' / Choose start date'),
      );
      expect(
        tester
            .getSemantics(painted)
            .getSemanticsData()
            .flagsCollection
            .isLiveRegion,
        isTrue,
      );
      // Only the painted summary is announced, not a second hidden copy.
      expect(_summary('Selected range:'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('day labels join their parts with the localizable joiner', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        _host(
          _calendar(
            value: _range(10, 12),
            labels: RemixCalendarLabels(
              joinDayLabel: (parts) => parts.join(' ؛ '),
            ),
          ),
        ),
      );
      expect(_semantics(tester, 10).label, contains(' ؛ Range start'));
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'long translations, RTL, narrow scrolling and 2x text retain day targets',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(260, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        _host(
          _calendar(
            value: _range(10, 12),
            rangeLabels: RemixRangeCalendarLabels(
              chooseStart:
                  'Veuillez sélectionner votre date de début de réservation',
              selectedRange: (start, end) =>
                  'Votre sélection de réservation du $start au $end',
            ),
          ),
          direction: TextDirection.rtl,
          textScale: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(tester.getSize(_day(12)).width, greaterThanOrEqualTo(44));
      expect(tester.getSize(_day(12)).height, greaterThanOrEqualTo(44));
    },
  );
}
