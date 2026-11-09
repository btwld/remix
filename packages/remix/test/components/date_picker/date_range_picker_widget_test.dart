import 'dart:ui' show Tristate;
import 'package:flutter/rendering.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/date_picker_test_helpers.dart';

/// The range summary is an unpainted live region, found by its label.
Finder _summary(String text) =>
    find.bySemanticsLabel(RegExp(RegExp.escape(text)));

RemixDateRangePicker _picker({
  CivilDateRange? value,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? currentDate,
  ValueChanged<CivilDateRange>? onChanged,
  VoidCallback? onClose,
  FocusNode? focusNode,
  bool enabled = true,
  bool Function(DateTime)? isDateUnavailable,
  String semanticLabel = 'Booking dates',
  String placeholder = 'Select range',
  String Function(CivilDateRange)? formatRange,
  RemixCalendarLabels calendarLabels = const RemixCalendarLabels(),
  RemixRangeCalendarLabels rangeLabels = const RemixRangeCalendarLabels(),
  ButtonStyler buttonStyle = const ButtonStyler.create(),
  CalendarStyler calendarStyle = const CalendarStyler.create(),
  PopoverStyler popoverStyle = const PopoverStyler.create(),
}) => RemixDateRangePicker(
  value: value,
  firstDate: firstDate ?? DateTime(2023),
  lastDate: lastDate ?? DateTime(2026, 12, 31),
  currentDate: currentDate ?? DateTime(2024, 2, 15),
  onChanged: onChanged ?? (_) {},
  onClose: onClose,
  focusNode: focusNode,
  enabled: enabled,
  isDateUnavailable: isDateUnavailable,
  semanticLabel: semanticLabel,
  placeholder: placeholder,
  formatRange: formatRange,
  calendarLabels: calendarLabels,
  rangeLabels: rangeLabels,
  buttonStyle: buttonStyle,
  calendarStyle: calendarStyle,
  popoverStyle: popoverStyle,
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(RemixButton).first);
  await tester.pumpAndSettle();
  expect(find.byType(RemixRangeCalendar), findsOneWidget);
}

Finder _day(int day) => find.byWidgetPredicate(
  (widget) => widget is NakedCalendarDay && widget.date.day == day,
);

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

CivilDateRange _range(int start, int end) => CivilDateRange(
  start: DateTime(2024, 2, start),
  end: DateTime(2024, 2, end),
);

Future<void> _tapDay(WidgetTester tester, int day) async {
  await tester.ensureVisible(_day(day));
  await tester.pumpAndSettle();
  await tester.tap(_day(day));
  await tester.pumpAndSettle();
}

void main() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('custom range label shows its end beyond four lines at $scale', (
      t,
    ) async {
      t.view.devicePixelRatio = 1;
      t.view.physicalSize = const Size(800, 1600);
      addTearDown(t.view.reset);
      const label =
          'Wednesday, the tenth of November, two thousand twenty-four '
          'through Monday, the twenty-fourth of March, two thousand twenty-five';
      await t.pumpWidget(
        pickerHost(
          SizedBox(
            width: 180,
            child: _picker(
              value: CivilDateRange(
                start: DateTime(2024, 11, 10),
                end: DateTime(2025, 3, 24),
              ),
              formatRange: (_) => label,
              buttonStyle: ButtonStyler()
                  .padding(.horizontal(12))
                  .label(TextStyler().fontSize(14).maxLines(1)),
            ),
          ),
          textScale: scale,
        ),
      );
      final paragraph = t.renderObject<RenderParagraph>(
        find.descendant(of: find.text(label), matching: find.byType(RichText)),
      );
      expect(paragraph.didExceedMaxLines, isFalse);
      final end = paragraph.getBoxesForSelection(
        const TextSelection(
          baseOffset: label.length - 11,
          extentOffset: label.length,
        ),
      );
      expect(end, isNotEmpty, reason: 'The final year must be laid out.');
      expect(end.last.bottom, lessThanOrEqualTo(paragraph.size.height));
      expect(t.takeException(), isNull);
    });
  }
  testWidgets('range label fit accounts for horizontal trigger margins', (
    t,
  ) async {
    await t.pumpWidget(
      pickerHost(
        SizedBox(
          width: 400,
          child: _picker(
            value: CivilDateRange(
              start: DateTime(2024, 11, 10),
              end: DateTime(2025, 3, 24),
            ),
            buttonStyle: ButtonStyler()
                .margin(.horizontal(60))
                .padding(.horizontal(12))
                .label(.fontSize(14)),
          ),
        ),
      ),
    );
    final label = t.widget<RemixButton>(find.byType(RemixButton)).label;
    expect(label, contains('11/10/2024'));
    expect(label, contains('3/24/2025'));
    final paragraph = t.renderObject<RenderParagraph>(
      find.descendant(of: find.text(label), matching: find.byType(RichText)),
    );
    expect(paragraph.didExceedMaxLines, isFalse);
    expect(t.takeException(), isNull);
  });
  for (final scale in [1.0, 2.0]) {
    testWidgets('cross-year endpoints fit a styled 240px trigger at $scale', (
      t,
    ) async {
      await t.pumpWidget(
        pickerHost(
          SizedBox(
            width: 240,
            child: _picker(
              value: CivilDateRange(
                start: DateTime(2024, 11, 10),
                end: DateTime(2025, 3, 24),
              ),
              buttonStyle: ButtonStyler()
                  .padding(.horizontal(12))
                  .label(.fontSize(14)),
            ),
          ),
          textScale: scale,
        ),
      );
      final label = t.widget<RemixButton>(find.byType(RemixButton)).label;
      expect(label, contains('11/10/2024'));
      expect(label, contains('3/24/2025'));
      final paragraph = t.renderObject<RenderParagraph>(
        find.descendant(of: find.text(label), matching: find.byType(RichText)),
      );
      expect(paragraph.didExceedMaxLines, isFalse);
      expect(t.takeException(), isNull);
    });
  }

  testWidgets(
    'placeholder and expanded fragments and leading icon follow value and opening',
    (tester) async {
      const normal = Color(0xff112233),
          empty = Color(0xff445566),
          expanded = Color(0xff778899);
      Widget field(CivilDateRange? value) => pickerHost(
        RemixDateRangePicker(
          value: value,
          firstDate: DateTime(2023),
          lastDate: DateTime(2026),
          currentDate: DateTime(2024, 2, 15),
          onChanged: (_) {},
          icon: const IconData(0xe123),
          buttonStyle: ButtonStyler().labelColor(normal),
          placeholderStyle: ButtonStyler().labelColor(empty),
          expandedStyle: ButtonStyler().labelColor(expanded),
        ),
      );
      Color? color() => tester
          .widget<RichText>(
            find
                .descendant(
                  of: find.byType(RemixButton).first,
                  matching: find.byType(RichText),
                )
                .last,
          )
          .text
          .style
          ?.color;
      await tester.pumpWidget(field(null));
      expect(color(), empty);
      expect(
        tester.widget<RemixButton>(find.byType(RemixButton).first).leadingIcon,
        const IconData(0xe123),
      );
      await _open(tester);
      expect(color(), expanded);
      await tester.tap(find.bySemanticsLabel('Choose year'));
      await tester.pumpAndSettle();
      expect(color(), expanded);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(color(), expanded);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(color(), empty);
      await tester.pumpWidget(field(_range(14, 16)));
      expect(color(), normal);
      await _open(tester);
      expect(color(), expanded);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(color(), normal);
    },
  );

  testWidgets(
    'bounded range keeps both endpoints visible and speaks the full range',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        pickerHost(SizedBox(width: 240, child: _picker(value: _range(14, 20)))),
      );
      final button = tester.widget<RemixButton>(find.byType(RemixButton).first);
      final text = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.text(button.label),
          matching: find.byType(RichText),
        ),
      );
      expect(text.didExceedMaxLines, isFalse);
      final value = tester
          .getSemantics(find.byType(RemixButton).first)
          .getSemanticsData()
          .value;
      expect(value, contains('February 14'));
      expect(value, contains('February 20'));
      semantics.dispose();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('removing an open range picker does not call onClose', (
    tester,
  ) async {
    var closes = 0;
    await tester.pumpWidget(pickerHost(_picker(onClose: () => closes++)));
    await _open(tester);
    await tester.pumpWidget(pickerHost(const SizedBox()));
    await tester.pumpAndSettle();
    expect(find.byType(RemixRangeCalendar), findsNothing);
    expect(closes, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('onOpen and onClose tell completion apart from dismissal', (
    tester,
  ) async {
    final events = <String>[];
    await tester.pumpWidget(
      pickerHost(
        RemixDateRangePicker(
          value: null,
          firstDate: DateTime(2023),
          lastDate: DateTime(2026, 12, 31),
          currentDate: DateTime(2024, 2, 15),
          onChanged: (range) =>
              events.add('changed ${range.start.day}-${range.end.day}'),
          onOpen: () => events.add('open'),
          onClose: () => events.add('close'),
        ),
      ),
    );
    await _open(tester);
    await _tapDay(tester, 20);
    expect(events, ['open'], reason: 'a draft anchor keeps the picker open');
    await pressKey(tester, LogicalKeyboardKey.escape);
    expect(events, ['open', 'close'], reason: 'dismissal never selects');
    events.clear();
    await _open(tester);
    await _tapDay(tester, 20);
    await _tapDay(tester, 22);
    expect(events, ['open', 'changed 20-22', 'close']);
  });

  for (final reopen in [false, true]) {
    testWidgets(
      'queued range completion is ignored after ${reopen ? 'reopen' : 'dismissal'}',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final requests = <CivilDateRange>[];
        try {
          await tester.pumpWidget(pickerHost(_picker(onChanged: requests.add)));
          await _open(tester);
          await _tapDay(tester, 20);
          final day = _semantics(tester, 22);
          final trigger = tester.getSemantics(find.byType(RemixButton).first);
          final owner = day.owner!;
          owner.performAction(trigger.id, SemanticsAction.tap);
          if (reopen) owner.performAction(trigger.id, SemanticsAction.tap);
          owner.performAction(day.id, SemanticsAction.tap);
          await tester.pumpAndSettle();
          expect(requests, isEmpty);
          expect(
            find.byType(RemixRangeCalendar),
            reopen ? findsOneWidget : findsNothing,
          );
          if (reopen) {
            await _tapDay(tester, 23);
            expect(requests, isEmpty);
            await _tapDay(tester, 24);
            expect(requests, [_range(23, 24)]);
          }
        } finally {
          semantics.dispose();
        }
      },
    );
  }

  testWidgets('range selection cleanup preserves a callback-reopened session', (
    tester,
  ) async {
    late SemanticsNode trigger;
    final semantics = tester.ensureSemantics();
    final requests = <CivilDateRange>[];
    try {
      await tester.pumpWidget(
        pickerHost(
          _picker(
            onChanged: (range) {
              requests.add(range);
              trigger.owner!.performAction(trigger.id, SemanticsAction.tap);
              trigger.owner!.performAction(trigger.id, SemanticsAction.tap);
            },
          ),
        ),
      );
      await _open(tester);
      trigger = tester.getSemantics(find.byType(RemixButton).first);
      await _tapDay(tester, 20);
      await _tapDay(tester, 22);
      expect(requests, [_range(20, 22)]);
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      expect(_summary('Choose start date'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets(
    'the keyboard hiding after the trigger takes focus keeps the draft',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(400, 800);
      // A text field above is focused, so the soft keyboard is showing.
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.reset);
      final text = TextEditingController();
      final textFocus = FocusNode();
      addTearDown(text.dispose);
      addTearDown(textFocus.dispose);
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EditableText(
                controller: text,
                focusNode: textFocus,
                style: const TextStyle(fontSize: 14),
                cursorColor: const Color(0xff000000),
                backgroundCursorColor: const Color(0xff888888),
              ),
              _picker(onChanged: requests.add),
            ],
          ),
        ),
      );
      textFocus.requestFocus();
      await tester.pump();
      await tester.tap(find.byType(RemixButton));
      await tester.pump();
      expect(textFocus.hasFocus, isFalse);
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      // The platform now animates the keyboard away over several frames.
      for (final bottom in [200.0, 100.0, 0.0]) {
        tester.view.viewInsets = FakeViewPadding(bottom: bottom);
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pumpAndSettle();
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      expect(focusInside(RemixRangeCalendar), isTrue);
      await _tapDay(tester, 20);
      expect(_summary('Choose end date'), findsOneWidget);
      await _tapDay(tester, 22);
      expect(requests, [_range(20, 22)]);
    },
  );

  testWidgets('trigger value covers empty, one-day and localized ranges', (
    tester,
  ) async {
    await withSemantics(tester, () async {
      String? value() => tester
          .getSemantics(find.bySemanticsLabel('Booking dates'))
          .getSemanticsData()
          .value;
      await tester.pumpWidget(pickerHost(_picker()));
      // The name already says this is a range; the empty value says so too.
      expect(value(), 'No date range selected');
      expect(find.text('Select range'), findsOneWidget);

      await tester.pumpWidget(pickerHost(_picker(value: _range(20, 20))));
      // A one-day range names its single date, painted and announced.
      expect(value(), 'Tuesday, February 20, 2024');
      expect(find.text('Tuesday, February 20, 2024'), findsOneWidget);

      await tester.pumpWidget(
        pickerHost(
          _picker(
            value: _range(10, 12),
            rangeLabels: RemixRangeCalendarLabels(
              noRange: 'Aucune période',
              rangeValue: (start, end) => 'du $start au $end',
            ),
          ),
        ),
      );
      expect(
        value(),
        'du Saturday, February 10, 2024 au Monday, February 12, 2024',
      );
      await tester.pumpWidget(
        pickerHost(
          _picker(
            rangeLabels: const RemixRangeCalendarLabels(
              noRange: 'Aucune période',
            ),
          ),
        ),
      );
      expect(value(), 'Aucune période');
    });
  });

  testWidgets('one button, localized trigger and exactly one expanded state', (
    tester,
  ) async {
    await withSemantics(tester, () async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        pickerHost(
          _picker(
            value: _range(10, 12),
            focusNode: focus,
            semanticLabel: 'Séjour',
            formatRange: (_) => '10–12 février',
          ),
        ),
      );
      final trigger = tester.getSemantics(find.bySemanticsLabel('Séjour'));
      // The purpose names the trigger; the full range is its value, not the
      // painted formatRange text.
      expect(
        trigger.getSemanticsData().value,
        'Saturday, February 10, 2024 to Monday, February 12, 2024',
      );
      expect(trigger.getSemanticsData().label, isNot(contains('10–12')));
      expect(trigger.getSemanticsData().flagsCollection.isButton, isTrue);
      expect(
        trigger.getSemanticsData().flagsCollection.isExpanded,
        Tristate.isFalse,
      );
      expect(find.byType(NakedButton), findsOneWidget);
      focus.requestFocus();
      await tester.pump();
      await pressKey(tester, LogicalKeyboardKey.enter);
      expect(focusedDate(), DateTime(2024, 2, 10));
      // The open calendar shares the purpose as its name; read the trigger.
      expect(
        tester
            .getSemantics(find.byType(RemixButton))
            .getSemanticsData()
            .flagsCollection
            .isExpanded,
        Tristate.isTrue,
      );
      await pressKey(tester, LogicalKeyboardKey.escape);
      expect(find.byType(RemixRangeCalendar), findsNothing);
      expect(focus.hasPrimaryFocus, isTrue);
    });
  });

  for (final kind in [
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  ]) {
    testWidgets(
      '$kind first release anchors and second release completes; cancel never selects',
      (tester) async {
        final requests = <CivilDateRange>[];
        await tester.pumpWidget(pickerHost(_picker(onChanged: requests.add)));
        await _open(tester);
        final first = await tester.startGesture(
          tester.getCenter(_day(20)),
          kind: kind,
        );
        await tester.pump();
        expect(requests, isEmpty);
        expect(_summary('Choose end date'), findsNothing);
        await first.up();
        await tester.pumpAndSettle();
        expect(_summary('Choose end date'), findsOneWidget);
        expect(find.byType(RemixRangeCalendar), findsOneWidget);
        final canceled = await tester.startGesture(
          tester.getCenter(_day(22)),
          kind: kind,
        );
        await canceled.cancel();
        await tester.pumpAndSettle();
        expect(requests, isEmpty);
        expect(find.byType(RemixRangeCalendar), findsOneWidget);
        final end = await tester.startGesture(
          tester.getCenter(_day(22)),
          kind: kind,
        );
        await tester.pump();
        expect(requests, isEmpty);
        await end.up();
        await tester.pumpAndSettle();
        expect(requests, [_range(20, 22)]);
        expect(find.byType(RemixRangeCalendar), findsNothing);
        expect(find.text('Select range'), findsOneWidget);
      },
    );
  }

  testWidgets(
    'controlled reverse and same-day requests close on rejection; accepting update formats value',
    (tester) async {
      var value = _range(10, 12);
      var accept = false;
      late StateSetter update;
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(
          StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return _picker(
                value: value,
                formatRange: (range) => '${range.start.day}–${range.end.day}',
                onChanged: (next) {
                  requests.add(next);
                  if (accept) setState(() => value = next);
                },
              );
            },
          ),
        ),
      );
      await _open(tester);
      await _tapDay(tester, 22);
      await _tapDay(tester, 20);
      expect(requests, [_range(20, 22)]);
      expect(find.text('10–12'), findsOneWidget);
      await _open(tester);
      expect(_summary('Choose start date'), findsOneWidget);
      await _tapDay(tester, 20);
      await _tapDay(tester, 20);
      expect(requests.last, _range(20, 20));
      expect(find.byType(RemixRangeCalendar), findsNothing);
      update(() => accept = true);
      await tester.pump();
      await _open(tester);
      await _tapDay(tester, 24);
      await _tapDay(tester, 25);
      expect(value, _range(24, 25));
      expect(find.text('24–25'), findsOneWidget);
    },
  );

  testWidgets(
    'real semantic focus/tap shares two-step selection; unavailable interior keeps session open',
    (tester) async {
      await withSemantics(tester, () async {
        final requests = <CivilDateRange>[];
        await tester.pumpWidget(
          pickerHost(
            _picker(
              onChanged: requests.add,
              isDateUnavailable: (d) => d.day == 21,
            ),
          ),
        );
        await _open(tester);
        final first = _semantics(tester, 20);
        first.owner!.performAction(first.id, SemanticsAction.tap);
        await tester.pumpAndSettle();
        final blocked = _semantics(tester, 22);
        expect(
          blocked.getSemanticsData().hasAction(SemanticsAction.tap),
          isFalse,
        );
        expect(
          blocked.getSemanticsData().hasAction(SemanticsAction.focus),
          isTrue,
        );
        blocked.owner!.performAction(blocked.id, SemanticsAction.focus);
        await tester.pumpAndSettle();
        expect(focusedDate(), DateTime(2024, 2, 22));
        expect(_summary('Range contains unavailable dates'), findsOneWidget);
        await pressKey(tester, LogicalKeyboardKey.enter);
        expect(requests, isEmpty);
        expect(find.byType(RemixRangeCalendar), findsOneWidget);
        final end = _semantics(tester, 19);
        end.owner!.performAction(end.id, SemanticsAction.tap);
        await tester.pumpAndSettle();
        expect(requests, [_range(19, 20)]);
        expect(find.byType(RemixRangeCalendar), findsNothing);
      });
    },
  );

  testWidgets(
    'cross-month keyboard draft navigates without callback and completes once',
    (tester) async {
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(_picker(value: _range(28, 29), onChanged: requests.add)),
      );
      await _open(tester);
      await pressKey(tester, LogicalKeyboardKey.enter);
      await pressKey(tester, LogicalKeyboardKey.pageDown);
      expect(focusedDate(), DateTime(2024, 3, 28));
      expect(requests, isEmpty);
      await pressKey(tester, LogicalKeyboardKey.space);
      expect(requests, [
        CivilDateRange(
          start: DateTime(2024, 2, 28),
          end: DateTime(2024, 3, 28),
        ),
      ]);
      expect(find.byType(RemixRangeCalendar), findsNothing);
    },
  );

  testWidgets(
    'same-frame close/open starts a fresh draft at the original month',
    (tester) async {
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(pickerHost(_picker(onChanged: requests.add)));
      await _open(tester);
      await _tapDay(tester, 20);
      await pressKey(tester, LogicalKeyboardKey.pageDown);
      expect(focusedDate(), DateTime(2024, 3, 20));
      final controller = outerController(tester);
      controller.close();
      controller.open();
      await tester.pumpAndSettle();
      expect(_summary('Choose start date'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is NakedCalendarDay && w.date == DateTime(2024, 3, 5),
        ),
        findsNothing,
        reason: 'the browsed month resets with the draft',
      );
      expect(focusedDate(), DateTime(2024, 2, 15));
      await _tapDay(tester, 22);
      expect(requests, isEmpty);
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      await _tapDay(tester, 23);
      expect(requests, [_range(22, 23)]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'same-frame reopen restores supplied start for actual keyboard continuation',
    (tester) async {
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(_picker(value: _range(10, 12), onChanged: requests.add)),
      );
      await _open(tester);
      await _tapDay(tester, 20);
      final controller = outerController(tester);
      controller.close();
      controller.open();
      await tester.pumpAndSettle();
      expect(focusedDate(), DateTime(2024, 2, 10));
      expect(_summary('Choose start date'), findsOneWidget);
      await pressKey(tester, LogicalKeyboardKey.enter);
      expect(_summary('Choose end date'), findsOneWidget);
      expect(requests, isEmpty);
      await pressKey(tester, LogicalKeyboardKey.arrowRight);
      await pressKey(tester, LogicalKeyboardKey.enter);
      expect(requests, [_range(10, 11)]);
      expect(find.byType(RemixRangeCalendar), findsNothing);
    },
  );

  for (final interruption in ['external', 'close', 'remove', 'disable']) {
    testWidgets('pending range session focus safely yields to $interruption', (
      tester,
    ) async {
      final external = FocusNode();
      addTearDown(external.dispose);
      var visible = true;
      var enabled = true;
      late StateSetter update;
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (_, setState) {
                  update = setState;
                  return visible
                      ? _picker(onChanged: requests.add, enabled: enabled)
                      : const Text('Removed');
                },
              ),
              NakedButton(
                focusNode: external,
                onPressed: () {},
                child: const Text('External focus'),
              ),
            ],
          ),
        ),
      );
      await _open(tester);
      await _tapDay(tester, 20);
      final controller = outerController(tester);
      controller.close();
      controller.open();
      // Interrupt before the new keyed calendar and pending focus entry attach.
      if (interruption == 'close') controller.close();
      if (interruption == 'remove') update(() => visible = false);
      if (interruption == 'disable') update(() => enabled = false);
      external.requestFocus();
      await tester.pumpAndSettle();
      expect(external.hasPrimaryFocus, isTrue);
      expect(requests, isEmpty);
      if (interruption == 'external') {
        expect(_summary('Choose start date'), findsOneWidget);
      } else {
        expect(find.byType(RemixRangeCalendar), findsNothing);
      }
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'nested month/year navigation and Escape preserve the outer draft',
    (tester) async {
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(pickerHost(_picker(onChanged: requests.add)));
      await _open(tester);
      await _tapDay(tester, 20);
      await tester.tap(find.byType(RemixSelect<int>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('March').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RemixSelect<int>).at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('2025').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(RemixSelect<int>).at(1));
      await tester.pumpAndSettle();
      await pressKey(tester, LogicalKeyboardKey.escape);
      // The anchor survived the nested selectors: the draft still waits for
      // its end date in the same opening.
      expect(_summary('Choose end date'), findsOneWidget);
      expect(requests, isEmpty);
      await pressKey(tester, LogicalKeyboardKey.escape);
      expect(find.byType(RemixRangeCalendar), findsNothing);
      await _open(tester);
      expect(_summary('Choose start date'), findsOneWidget);
    },
  );

  testWidgets(
    'selector then range picker then host dialog receive Escape in order',
    (tester) async {
      final navigator = GlobalKey<NavigatorState>();
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        pickerHost(const Text('Host'), navigatorKey: navigator),
      );
      final dialog = showNakedDialog<void>(
        context: navigator.currentContext!,
        barrierColor: const Color(0x55000000),
        builder: (_) => Center(child: _picker(focusNode: focus)),
      );
      await tester.pumpAndSettle();
      await _open(tester);
      await _tapDay(tester, 20);
      await tester.tap(find.byType(RemixSelect<int>).first);
      await tester.pumpAndSettle();
      await pressKey(tester, LogicalKeyboardKey.escape);
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      expect(_summary('Choose end date'), findsOneWidget);
      await pressKey(tester, LogicalKeyboardKey.escape);
      expect(find.byType(RemixRangeCalendar), findsNothing);
      expect(focus.hasPrimaryFocus, isTrue);
      expect(find.byType(RemixDateRangePicker), findsOneWidget);
      await pressKey(tester, LogicalKeyboardKey.escape);
      expect(find.byType(RemixDateRangePicker), findsNothing);
      await dialog;
    },
  );

  for (final dismissal in ['outside', 'escape', 'resize']) {
    testWidgets(
      '$dismissal dismissal discards draft without callback and restores focus',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 600);
        addTearDown(tester.view.reset);
        final requests = <CivilDateRange>[];
        var closes = 0;
        final focus = FocusNode();
        addTearDown(focus.dispose);
        await tester.pumpWidget(
          pickerHost(
            SafeArea(
              child: _picker(
                focusNode: focus,
                onChanged: requests.add,
                onClose: () => closes++,
              ),
            ),
          ),
        );
        await _open(tester);
        await _tapDay(tester, 20);
        expect(closes, 0);
        switch (dismissal) {
          case 'outside':
            await tester.tapAt(const Offset(1, 1));
          case 'escape':
            await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          case 'resize':
            tester.view.physicalSize = const Size(600, 800);
        }
        await tester.pumpAndSettle();
        expect(find.byType(RemixRangeCalendar), findsNothing);
        expect(requests, isEmpty);
        expect(focus.hasPrimaryFocus, isTrue);
        expect(closes, 1);
        await tester.pumpAndSettle();
        expect(closes, 1);
        await _open(tester);
        expect(_summary('Choose start date'), findsOneWidget);
      },
    );
  }

  for (final change in ['metrics', 'insets']) {
    testWidgets('$change change re-fits the open draft without dismissing it', (
      tester,
    ) async {
      final requests = <CivilDateRange>[];
      var insets = EdgeInsets.zero;
      late StateSetter update;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (_, setState) {
            update = setState;
            return pickerHost(
              SafeArea(child: _picker(onChanged: requests.add)),
              viewInsets: insets,
            );
          },
        ),
      );
      addTearDown(tester.view.reset);
      await _open(tester);
      await _tapDay(tester, 20);
      switch (change) {
        case 'metrics':
          tester.view.viewPadding = const FakeViewPadding(top: 40);
          tester.view.padding = const FakeViewPadding(top: 40);
        case 'insets':
          update(() => insets = const EdgeInsets.only(bottom: 100));
      }
      await tester.pumpAndSettle();
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      expect(_summary('Choose end date'), findsOneWidget);
      expect(requests, isEmpty);
      await _tapDay(tester, 22);
      expect(requests, [_range(20, 22)]);
      expect(find.byType(RemixRangeCalendar), findsNothing);
    });
  }

  for (final updateType in ['disabled', 'callback', 'focus']) {
    testWidgets(
      '$updateType change closes open draft; borrowed nodes remain usable',
      (tester) async {
        final firstFocus = FocusNode();
        final replacement = FocusNode();
        addTearDown(firstFocus.dispose);
        addTearDown(replacement.dispose);
        var enabled = true;
        var callback = true;
        var focus = firstFocus;
        late StateSetter update;
        final requests = <CivilDateRange>[];
        var closes = 0;
        await tester.pumpWidget(
          pickerHost(
            StatefulBuilder(
              builder: (_, setState) {
                update = setState;
                return RemixDateRangePicker(
                  value: null,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                  currentDate: DateTime(2024, 2, 15),
                  enabled: enabled,
                  focusNode: focus,
                  onChanged: callback ? requests.add : null,
                  onClose: () => closes++,
                );
              },
            ),
          ),
        );
        await _open(tester);
        await _tapDay(tester, 20);
        expect(closes, 0);
        update(() {
          switch (updateType) {
            case 'disabled':
              enabled = false;
            case 'callback':
              callback = false;
            case 'focus':
              focus = replacement;
          }
        });
        await tester.pumpAndSettle();
        expect(find.byType(RemixRangeCalendar), findsNothing);
        expect(requests, isEmpty);
        expect(closes, 1);
        await tester.pumpAndSettle();
        expect(closes, 1);
        expect(() => firstFocus.addListener(() {}), returnsNormally);
        update(() {
          enabled = true;
          callback = true;
        });
        await tester.pumpAndSettle();
        await _open(tester);
        expect(_summary('Choose start date'), findsOneWidget);
      },
    );
  }

  for (final reaction in ['remove', 'disable', 'callback', 'throw']) {
    testWidgets('complete callback can $reaction without stale overlays', (
      tester,
    ) async {
      var visible = true;
      var enabled = true;
      var callback = true;
      var count = 0;
      await tester.pumpWidget(
        pickerHost(
          StatefulBuilder(
            builder: (_, setState) => visible
                ? RemixDateRangePicker(
                    value: null,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                    currentDate: DateTime(2024, 2, 15),
                    enabled: enabled,
                    onChanged: callback
                        ? (_) {
                            count++;
                            if (reaction == 'throw')
                              throw StateError('Deliberate parent failure');
                            setState(() {
                              switch (reaction) {
                                case 'remove':
                                  visible = false;
                                case 'disable':
                                  enabled = false;
                                case 'callback':
                                  callback = false;
                              }
                            });
                          }
                        : null,
                  )
                : const Text('Gone'),
          ),
        ),
      );
      await _open(tester);
      await _tapDay(tester, 20);
      await tester.tap(_day(22));
      await tester.pumpAndSettle();
      expect(count, 1);
      expect(find.byType(RemixRangeCalendar), findsNothing);
      if (reaction == 'throw')
        expect(tester.takeException(), isA<StateError>());
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'invalid external value is formatted; equal values preserve draft and clear cancels it',
    (tester) async {
      CivilDateRange? value = _range(5, 15);
      late StateSetter update;
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(
          StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return _picker(
                value: value,
                firstDate: DateTime(2024, 2, 10),
                lastDate: DateTime(2024, 2, 25),
                formatRange: (r) => '${r.start.day}–${r.end.day}',
                onChanged: requests.add,
              );
            },
          ),
        ),
      );
      expect(find.text('5–15'), findsOneWidget);
      await _open(tester);
      expect(_summary('Selected range is unavailable'), findsOneWidget);
      await _tapDay(tester, 20);
      update(() => value = _range(5, 15));
      await tester.pumpAndSettle();
      // An equal parent value keeps the open draft rather than remounting.
      expect(_summary('Choose end date'), findsOneWidget);
      update(() => value = null);
      await tester.pumpAndSettle();
      expect(_summary('Choose start date'), findsOneWidget);
      expect(requests, isEmpty);
    },
  );

  testWidgets('Tab moves within panel without committing or discarding draft', (
    tester,
  ) async {
    await tester.pumpWidget(pickerHost(_picker()));
    await _open(tester);
    await _tapDay(tester, 20);
    final dayNode = FocusManager.instance.primaryFocus;
    await pressKey(tester, LogicalKeyboardKey.tab);
    expect(focusInside(RemixRangeCalendar), isTrue);
    expect(_summary('Choose end date'), findsOneWidget);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await pressKey(tester, LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus, dayNode);
    for (var i = 0; i < 12; i++) {
      await pressKey(tester, LogicalKeyboardKey.tab);
      expect(focusInside(RemixRangeCalendar), isTrue);
    }
  });

  testWidgets(
    '240x230 RTL 200% viewport reveals focused endpoint before completion',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(240, 230);
      addTearDown(tester.view.reset);
      final requests = <CivilDateRange>[];
      await tester.pumpWidget(
        pickerHost(
          Align(
            alignment: Alignment.bottomRight,
            child: _picker(value: _range(28, 29), onChanged: requests.add),
          ),
          textScale: 2,
          direction: TextDirection.rtl,
        ),
      );
      await _open(tester);
      expect(focusedDate(), DateTime(2024, 2, 28));
      final panel = tester.getRect(find.byType(RemixRangeCalendar));
      expect(panel.left, greaterThanOrEqualTo(8));
      expect(panel.right, lessThanOrEqualTo(232));
      expect(panel.top, greaterThanOrEqualTo(8));
      expect(panel.bottom, lessThanOrEqualTo(222));
      expect(_day(28).hitTestable(), findsOneWidget);
      await pressKey(tester, LogicalKeyboardKey.enter);
      await pressKey(tester, LogicalKeyboardKey.arrowUp);
      expect(focusedDate(), DateTime(2024, 2, 21));
      expect(_day(21).hitTestable(), findsOneWidget);
      expect(requests, isEmpty);
      await pressKey(tester, LogicalKeyboardKey.enter);
      expect(requests, [_range(21, 28)]);
      expect(find.byType(RemixRangeCalendar), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'neighbor text/selection survive; composing follows ordinary focus-loss policy',
    (tester) async {
      const composing = TextEditingValue(
        text: 'composing',
        selection: TextSelection.collapsed(offset: 4),
        composing: TextRange(start: 0, end: 9),
      );
      final controller = TextEditingController.fromValue(composing);
      final textFocus = FocusNode();
      final otherFocus = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(textFocus.dispose);
      addTearDown(otherFocus.dispose);
      await tester.pumpWidget(
        pickerHost(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 200,
                child: EditableText(
                  controller: controller,
                  focusNode: textFocus,
                  style: const TextStyle(color: Color(0xff000000)),
                  cursorColor: const Color(0xff000000),
                  backgroundCursorColor: const Color(0xff888888),
                ),
              ),
              RemixButton(
                label: 'Ordinary focus target',
                focusNode: otherFocus,
                onPressed: otherFocus.requestFocus,
              ),
              _picker(),
            ],
          ),
        ),
      );
      textFocus.requestFocus();
      await tester.pumpAndSettle();
      controller.value = composing;
      await tester.pump();
      await tester.tap(find.text('Ordinary focus target'));
      await tester.pumpAndSettle();
      final ordinaryFocusLoss = controller.value;
      expect(ordinaryFocusLoss.text, composing.text);
      expect(ordinaryFocusLoss.selection, composing.selection);
      // Flutter 3.44 EditableText._openOrCloseInputConnectionIfNeeded clears
      // composition on focus loss. The picker must match that SDK baseline,
      // not retain a composing range belonging to a closed input connection.
      expect(ordinaryFocusLoss.composing, TextRange.empty);
      textFocus.requestFocus();
      await tester.pumpAndSettle();
      controller.value = composing;
      await tester.pump();
      await tester.tap(find.byType(RemixDateRangePicker));
      await tester.pumpAndSettle();
      expect(find.byType(RemixRangeCalendar), findsOneWidget);
      expect(controller.value, ordinaryFocusLoss);
      await pressKey(tester, LogicalKeyboardKey.escape);
      expect(controller.value, ordinaryFocusLoss);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('summaryBuilder paints the open calendar summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      pickerHost(
        RemixDateRangePicker(
          value: null,
          firstDate: DateTime(2023),
          lastDate: DateTime(2026, 12, 31),
          currentDate: DateTime(2024, 2, 15),
          onChanged: (_) {},
          summaryBuilder: (context, summary) => Text(summary),
        ),
      ),
    );
    expect(find.textContaining('Choose start date'), findsNothing);
    await _open(tester);
    expect(find.textContaining('Choose start date'), findsOneWidget);
  });
}
