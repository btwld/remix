import 'dart:ui' show Tristate;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

Widget _host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    WidgetsApp(
      color: const Color(0xffffffff),
      builder: (context, _) => Directionality(
        textDirection: direction,
        child: Center(child: child),
      ),
    );

class _Harness extends StatefulWidget {
  const _Harness({this.direction = TextDirection.ltr});
  final TextDirection direction;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  DateTime? value = DateTime.utc(2024, 2, 29, 18);
  DateTime first = DateTime(2023, 1, 1, 20);
  DateTime last = DateTime.utc(2026, 12, 31);
  bool enabled = true;
  bool callback = true;
  int firstDay = DateTime.monday;
  bool Function(DateTime)? unavailable;
  final requests = <DateTime>[];
  final entry = FocusNode(debugLabel: 'calendar entry');
  final before = FocusNode(debugLabel: 'before');
  final after = FocusNode(debugLabel: 'after');
  late NakedCalendarState snapshot;
  final days = <DateTime, NakedCalendarDayState>{};

  @override
  void dispose() {
    entry.dispose();
    before.dispose();
    after.dispose();
    super.dispose();
  }

  void change(VoidCallback action) => setState(action);

  @override
  Widget build(BuildContext context) => _host(
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NakedButton(
          focusNode: before,
          onPressed: () {},
          child: const Text('Before'),
        ),
        NakedCalendar(
          value: value,
          firstDate: first,
          lastDate: last,
          currentDate: DateTime(2024, 1, 15),
          firstDayOfWeek: firstDay,
          enabled: enabled,
          onChanged: callback ? requests.add : null,
          isDateUnavailable: unavailable,
          focusNode: entry,
          semanticLabel: 'Date',
          builder: (context, state, _) {
            snapshot = state;
            expect(NakedCalendarState.of(context), same(state));
            expect(NakedCalendarState.maybeOf(context), same(state));
            expect(
              NakedCalendarState.maybeControllerOf(context),
              same(NakedCalendarState.controllerOf(context)),
            );
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NakedButton(
                  onPressed: state.showPreviousMonth,
                  child: const Text('Previous'),
                ),
                NakedButton(
                  onPressed: state.showNextMonth,
                  child: const Text('Next'),
                ),
                for (final week in state.weeks)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final date in week)
                        if (date == null)
                          const SizedBox.square(dimension: 44)
                        else
                          NakedCalendarDay(
                            date: date,
                            semanticLabel:
                                '${date.year}-${date.month}-${date.day}',
                            builder: (context, state, _) {
                              days[date] = state;
                              expect(
                                NakedCalendarDayState.of(context),
                                same(state),
                              );
                              expect(
                                NakedCalendarDayState.maybeOf(context),
                                same(state),
                              );
                              expect(
                                NakedCalendarDayState.maybeControllerOf(
                                  context,
                                ),
                                same(
                                  NakedCalendarDayState.controllerOf(context),
                                ),
                              );
                              return SizedBox.square(
                                dimension: 44,
                                child: Center(child: Text('${date.day}')),
                              );
                            },
                          ),
                    ],
                  ),
              ],
            );
          },
        ),
        NakedButton(
          focusNode: after,
          onPressed: () {},
          child: const Text('After'),
        ),
      ],
    ),
    direction: widget.direction,
  );
}

Future<_HarnessState> _pump(
  WidgetTester tester, {
  TextDirection direction = TextDirection.ltr,
}) async {
  await tester.pumpWidget(_Harness(direction: direction));
  return tester.state<_HarnessState>(find.byType(_Harness));
}

Future<void> _focus(WidgetTester tester, _HarnessState state) async {
  state.entry.requestFocus();
  await tester.pumpAndSettle();
}

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

Finder _day(int day) =>
    find.byWidgetPredicate((w) => w is NakedCalendarDay && w.date.day == day);

void main() {
  for (final excludeRoot in [false, true]) {
    testWidgets(
      'excludeSemantics hides ${excludeRoot ? 'calendar' : 'day'} without disabling selection',
      (tester) async {
        final semantics = tester.ensureSemantics();

        var selections = 0;
        await tester.pumpWidget(
          _host(
            NakedCalendar(
              value: null,
              firstDate: DateTime(2024),
              lastDate: DateTime(2024, 12, 31),
              currentDate: DateTime(2024, 2, 15),
              excludeSemantics: excludeRoot,
              semanticLabel: 'Calendar group',
              onChanged: (_) => selections++,
              builder: (_, _, _) => NakedCalendarDay(
                date: DateTime(2024, 2, 15),
                semanticLabel: 'Hidden day',
                excludeSemantics: !excludeRoot,
                builder: (_, _, _) => const SizedBox(
                  width: 44,
                  height: 44,
                  child: Text('Day visual'),
                ),
              ),
            ),
          ),
        );
        expect(find.bySemanticsLabel('Hidden day'), findsNothing);
        expect(find.bySemanticsLabel('Day visual'), findsNothing);
        expect(
          find.bySemanticsLabel('Calendar group'),
          excludeRoot ? findsNothing : findsOneWidget,
        );
        await tester.tap(find.text('Day visual'));
        expect(selections, 1);
        semantics.dispose();
      },
    );
  }

  testWidgets('retained day tap is inert after disposal', (tester) async {
    final state = await _pump(tester);
    final tap = tester
        .widget<Semantics>(
          find.byWidgetPredicate(
            (widget) =>
                widget is Semantics && widget.properties.label == '2024-2-29',
          ),
        )
        .properties
        .onTap!;
    await tester.pumpWidget(const SizedBox());
    expect(state.mounted, isFalse);
    tap();
    expect(state.requests, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('retained month actions are inert after disposal', (
    tester,
  ) async {
    final state = await _pump(tester);
    final next = state.snapshot.showNextMonth!;
    final previous = state.snapshot.showPreviousMonth!;
    final show = state.snapshot.showMonth!;
    await tester.pumpWidget(const SizedBox());
    expect(state.mounted, isFalse);
    next();
    previous();
    show(DateTime(2024, 3));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'controlled selection normalizes civil fields; rejecting callback retains value',
    (tester) async {
      final state = await _pump(tester);
      expect(state.days[DateTime(2024, 2, 29)]!.isSelected, isTrue);
      await tester.tap(_day(28));
      await tester.pump();
      expect(state.requests, [DateTime(2024, 2, 28)]);
      expect(state.days[DateTime(2024, 2, 29)]!.isSelected, isTrue);
      expect(state.days[DateTime(2024, 2, 28)]!.isSelected, isFalse);
      await tester.tap(_day(29));
      await tester.pump();
      expect(state.requests.last, DateTime(2024, 2, 29));
      expect(state.requests.last.isUtc, isFalse);
      expect(state.requests.last.hour, 0);
    },
  );

  testWidgets('pointer entry retains focus across a removed month day', (
    tester,
  ) async {
    final state = await _pump(tester);
    await tester.tap(_day(29));
    await tester.pumpAndSettle();
    await _key(tester, LogicalKeyboardKey.arrowRight);
    expect(state.snapshot.focusedDate, DateTime(2024, 3));
    expect(state.days[DateTime(2024, 3)]!.isFocused, isTrue);
    await _key(tester, LogicalKeyboardKey.arrowRight);
    expect(state.snapshot.focusedDate, DateTime(2024, 3, 2));
  });

  testWidgets(
    'arrows, week edges, page and shifted-year keys focus without selecting',
    (tester) async {
      final state = await _pump(tester);
      await _focus(tester, state);
      expect(state.days[DateTime(2024, 2, 29)]!.isFocused, isTrue);
      await _key(tester, LogicalKeyboardKey.pageDown);
      expect(state.snapshot.focusedDate, DateTime(2024, 3, 29));
      await _key(tester, LogicalKeyboardKey.pageUp);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await _key(tester, LogicalKeyboardKey.pageDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      expect(state.snapshot.focusedDate, DateTime(2025, 2, 28));
      await _key(tester, LogicalKeyboardKey.home);
      expect(state.snapshot.focusedDate, DateTime(2025, 2, 24));
      await _key(tester, LogicalKeyboardKey.end);
      expect(state.snapshot.focusedDate, DateTime(2025, 3, 2));
      await _key(tester, LogicalKeyboardKey.arrowUp);
      expect(state.snapshot.focusedDate, DateTime(2025, 2, 23));
      await _key(tester, LogicalKeyboardKey.arrowDown);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(state.snapshot.focusedDate, DateTime(2025, 3, 1));
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(state.snapshot.focusedDate, DateTime(2025, 3, 2));
      expect(state.requests, isEmpty);
      await _key(tester, LogicalKeyboardKey.enter);
      await _key(tester, LogicalKeyboardKey.space);
      expect(state.requests, [DateTime(2025, 3, 2), DateTime(2025, 3, 2)]);
    },
  );

  testWidgets(
    'RTL visual arrows reverse while week movement remains chronological',
    (tester) async {
      final state = await _pump(tester, direction: TextDirection.rtl);
      await _focus(tester, state);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(state.snapshot.focusedDate, DateTime(2024, 3, 1));
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 29));
    },
  );

  testWidgets('day grid has one Tab stop and Shift+Tab leaves in reverse', (
    tester,
  ) async {
    final state = await _pump(tester);
    await _focus(tester, state);
    await _key(tester, LogicalKeyboardKey.tab);
    expect(state.after.hasFocus, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await _key(tester, LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(state.days[DateTime(2024, 2, 29)]!.isFocused, isTrue);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await _key(tester, LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(
      state.entry.hasFocus,
      isTrue,
    ); // The preceding header button, not another day.
    expect(state.days.values.where((s) => s.isFocused), isEmpty);
  });

  testWidgets(
    'inclusive civil bounds stop movement and all unavailable days stay navigable',
    (tester) async {
      final state = await _pump(tester);
      state.change(() {
        state.first = DateTime.utc(2024, 2, 28, 23);
        state.last = DateTime(2024, 3, 1, 1);
        state.unavailable = (_) => true;
      });
      await tester.pump();
      await _focus(tester, state);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 28));
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 28));
      await _key(tester, LogicalKeyboardKey.arrowDown);
      expect(state.snapshot.focusedDate, DateTime(2024, 3, 1));
      await _key(tester, LogicalKeyboardKey.arrowRight);
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.requests, isEmpty);
      expect(state.days[DateTime(2024, 3, 1)]!.isFocused, isTrue);
      state.change(() => state.unavailable = null);
      await tester.pump();
      await _key(tester, LogicalKeyboardKey.space);
      expect(state.requests, [DateTime(2024, 3, 1)]);
    },
  );

  testWidgets(
    'external updates, clears and config repairs preserve controlled state and do not steal focus',
    (tester) async {
      final state = await _pump(tester);
      state.snapshot.showMonth!(DateTime(2025, 8));
      await tester.pump();
      state.change(() {});
      await tester.pump();
      expect(state.snapshot.displayedMonth, DateTime(2025, 8));
      state.change(() => state.value = null);
      await tester.pump();
      expect(state.snapshot.displayedMonth, DateTime(2025, 8));
      state.after.requestFocus();
      await tester.pump();
      state.change(() => state.value = DateTime(2030, 5));
      await tester.pump();
      expect(state.snapshot.displayedMonth, DateTime(2026, 12));
      expect(state.snapshot.value, DateTime(2030, 5));
      expect(state.after.hasFocus, isTrue);
      state.change(() => state.last = DateTime(2024, 6, 20));
      await tester.pump();
      await tester.pump();
      expect(state.snapshot.focusedDate, DateTime(2024, 6, 20));
      expect(state.after.hasFocus, isTrue);
      expect(state.requests, isEmpty);
    },
  );

  testWidgets(
    'month header preserves day focus but does not take a focused header',
    (tester) async {
      final state = await _pump(tester);
      await _focus(tester, state);
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(state.days[DateTime(2024, 3, 29)]!.isFocused, isTrue);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(state.snapshot.focusedDate, DateTime(2024, 3, 30));
      state.after.requestFocus();
      await tester.pump();
      state.snapshot.showPreviousMonth!();
      await tester.pump();
      await tester.pump();
      expect(state.after.hasFocus, isTrue);
    },
  );

  testWidgets('pending focus does not override an external focus request', (
    tester,
  ) async {
    final state = await _pump(tester);
    await _focus(tester, state);
    state.snapshot.showNextMonth!();
    state.after.requestFocus();
    await tester.pump();
    await tester.pump();
    expect(state.after.hasFocus, isTrue);
  });

  testWidgets('pointer-entry pending handoff yields to external focus', (
    tester,
  ) async {
    final state = await _pump(tester);
    await tester.tap(_day(29));
    await tester.pumpAndSettle();
    state.snapshot.nextMonth!();
    state.after.requestFocus();
    await tester.pumpAndSettle();
    expect(state.after.hasPrimaryFocus, isTrue);
  });

  testWidgets(
    'week rows are immutable and weekday ordering/leap/year boundaries are real dates',
    (tester) async {
      final state = await _pump(tester);
      expect(state.snapshot.weeks.first.take(3), [null, null, null]);
      expect(
        state.snapshot.weeks
            .expand((week) => week)
            .whereType<DateTime>()
            .length,
        29,
      );
      expect(() => state.snapshot.weeks.add([]), throwsUnsupportedError);
      expect(
        () => state.snapshot.weeks.first[0] = DateTime(2024),
        throwsUnsupportedError,
      );
      state.change(() => state.firstDay = DateTime.sunday);
      await tester.pump();
      expect(state.snapshot.weeks.first.take(4), [null, null, null, null]);
      state.snapshot.showMonth!(DateTime(2023, 12));
      await tester.pump();
      await _focus(tester, state);
      state.change(() => state.value = DateTime(2023, 12, 31));
      await tester.pump();
      await tester.pump();
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(state.snapshot.focusedDate, DateTime(2024));
    },
  );

  for (final kind in [
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  ]) {
    testWidgets('$kind selects on release, not hover/down or cancellation', (
      tester,
    ) async {
      final state = await _pump(tester);
      final gesture = await tester.createGesture(kind: kind);
      await gesture.addPointer(location: tester.getCenter(_day(15)));
      await tester.pump();
      expect(state.requests, isEmpty);
      await gesture.down(tester.getCenter(_day(15)));
      await tester.pump();
      expect(state.requests, isEmpty);
      await gesture.cancel();
      await tester.pump();
      expect(state.requests, isEmpty);
      await gesture.down(tester.getCenter(_day(15)));
      await gesture.up();
      await tester.pump();
      expect(state.requests, [DateTime(2024, 2, 15)]);
      await gesture.removePointer();
    });
  }

  testWidgets(
    'disable/null callback suppress all actions and clear a held press',
    (tester) async {
      final state = await _pump(tester);
      final gesture = await tester.startGesture(tester.getCenter(_day(15)));
      await tester.pump();
      expect(state.days[DateTime(2024, 2, 15)]!.isPressed, isTrue);
      state.change(() => state.enabled = false);
      await tester.pump();
      expect(state.days[DateTime(2024, 2, 15)]!.isPressed, isFalse);
      await gesture.up();
      await tester.pump();
      expect(state.requests, isEmpty);
      expect(state.snapshot.showMonth, isNull);
      state.change(() {
        state.enabled = true;
        state.callback = false;
      });
      await tester.pump();
      await tester.tap(_day(15));
      await tester.pump();
      expect(state.requests, isEmpty);
      expect(state.days[DateTime(2024, 2, 15)]!.isDisabled, isTrue);
    },
  );

  testWidgets(
    'semantics expose all dates once, full name, selected, disabled, focus and tap action',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final state = await _pump(tester);
        state.change(() => state.unavailable = (date) => date.day == 28);
        await tester.pump();
        await _focus(tester, state);
        final selected = tester.getSemantics(
          find.bySemanticsLabel('2024-2-29'),
        );
        expect(selected.getSemanticsData().flagsCollection.isButton, isTrue);
        expect(
          selected.getSemanticsData().flagsCollection.isSelected,
          Tristate.isTrue,
        );
        expect(
          selected.getSemanticsData().flagsCollection.isFocused,
          Tristate.isTrue,
        );
        expect(
          selected.getSemanticsData().hasAction(SemanticsAction.tap),
          isTrue,
        );
        final unavailable = tester.getSemantics(
          find.bySemanticsLabel('2024-2-28'),
        );
        expect(
          unavailable.getSemanticsData().flagsCollection.isEnabled,
          Tristate.isFalse,
        );
        expect(
          unavailable.getSemanticsData().flagsCollection.isFocused,
          isNot(Tristate.none),
        );
        expect(
          unavailable.getSemanticsData().hasAction(SemanticsAction.tap),
          isFalse,
        );
        for (var day = 1; day <= 29; day++) {
          expect(find.bySemanticsLabel('2024-2-$day'), findsOneWidget);
        }
        selected.owner!.performAction(selected.id, SemanticsAction.tap);
        await tester.pump();
        expect(state.requests, [DateTime(2024, 2, 29)]);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'semantic input focus targets the requested day and keeps one Tab stop',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final state = await _pump(tester);
        await _focus(tester, state);
        final target = tester.getSemantics(find.bySemanticsLabel('2024-2-20'));
        expect(
          target.getSemanticsData().hasAction(SemanticsAction.focus),
          isTrue,
        );
        target.owner!.performAction(target.id, SemanticsAction.focus);
        await tester.pumpAndSettle();
        expect(state.snapshot.focusedDate, DateTime(2024, 2, 20));
        expect(state.days[DateTime(2024, 2, 20)]!.isFocused, isTrue);
        expect(find.bySemanticsLabel('2024-2-20'), findsOneWidget);
        await _key(tester, LogicalKeyboardKey.enter);
        expect(state.requests, [DateTime(2024, 2, 20)]);
        await _key(tester, LogicalKeyboardKey.tab);
        expect(state.after.hasFocus, isTrue);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'unavailable days accept semantic input focus without activation',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final state = await _pump(tester);
        state.change(() => state.unavailable = (date) => date.day == 20);
        await tester.pump();
        await _focus(tester, state);
        final target = tester.getSemantics(find.bySemanticsLabel('2024-2-20'));
        expect(
          target.getSemanticsData().hasAction(SemanticsAction.focus),
          isTrue,
        );
        expect(
          target.getSemanticsData().hasAction(SemanticsAction.tap),
          isFalse,
        );
        target.owner!.performAction(target.id, SemanticsAction.focus);
        await tester.pumpAndSettle();
        expect(state.days[DateTime(2024, 2, 20)]!.isFocused, isTrue);
        await _key(tester, LogicalKeyboardKey.enter);
        expect(state.requests, isEmpty);
        await _key(tester, LogicalKeyboardKey.arrowRight);
        expect(state.snapshot.focusedDate, DateTime(2024, 2, 21));
        await _key(tester, LogicalKeyboardKey.enter);
        expect(state.requests, [DateTime(2024, 2, 21)]);
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('out-of-bounds and disabled days omit semantic input focus', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final state = await _pump(tester);
      state.change(() => state.first = DateTime(2024, 2, 10));
      await tester.pumpAndSettle();
      bool hasFocusAction(int day) => tester
          .getSemantics(find.bySemanticsLabel('2024-2-$day'))
          .getSemanticsData()
          .hasAction(SemanticsAction.focus);
      expect(hasFocusAction(9), isFalse);
      expect(hasFocusAction(10), isTrue);
      state.change(() => state.enabled = false);
      await tester.pumpAndSettle();
      expect(hasFocusAction(10), isFalse);
      state.change(() {
        state.enabled = true;
        state.callback = false;
      });
      await tester.pumpAndSettle();
      expect(hasFocusAction(10), isFalse);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('iOS follows the SDK semantic input-focus policy', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final state = await _pump(tester);
      final target = tester.getSemantics(find.bySemanticsLabel('2024-2-20'));
      expect(
        target.getSemanticsData().hasAction(SemanticsAction.focus),
        isFalse,
      );
      expect(target.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      target.owner!.performAction(target.id, SemanticsAction.tap);
      await tester.pump();
      expect(state.requests, [DateTime(2024, 2, 20)]);
    } finally {
      semantics.dispose();
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('week-start reconfiguration keeps the focused civil date', (
    tester,
  ) async {
    final state = await _pump(tester);
    state.change(() => state.value = DateTime(2024, 2, 25));
    await tester.pump();
    await _focus(tester, state);
    state.change(() => state.firstDay = DateTime.sunday);
    await tester.pumpAndSettle();
    expect(state.days[DateTime(2024, 2, 25)]!.isFocused, isTrue);
    await _key(tester, LogicalKeyboardKey.arrowRight);
    expect(state.snapshot.focusedDate, DateTime(2024, 2, 26));
    expect(state.requests, isEmpty);
  });

  testWidgets(
    'stable caller keys reconcile date registration without a parent rebuild',
    (tester) async {
      final date = ValueNotifier(DateTime(2024, 2, 14));
      addTearDown(date.dispose);
      final selected = <DateTime>[];
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _host(
          NakedCalendar(
            value: DateTime(2024, 2, 15),
            firstDate: DateTime(2024),
            lastDate: DateTime(2024, 12, 31),
            onChanged: selected.add,
            focusNode: focus,
            builder: (_, _, _) => ValueListenableBuilder<DateTime>(
              valueListenable: date,
              builder: (_, value, _) => NakedCalendarDay(
                key: const ValueKey('stable'),
                date: value,
                semanticLabel: 'Full date',
                builder: (_, state, _) => SizedBox.square(
                  dimension: 44,
                  child: Text('${state.date.day}'),
                ),
              ),
            ),
          ),
        ),
      );
      date.value = DateTime(2024, 2, 15);
      await tester.pump();
      focus.requestFocus();
      await tester.pumpAndSettle();
      await _key(tester, LogicalKeyboardKey.numpadEnter);
      expect(selected, [DateTime(2024, 2, 15)]);
    },
  );

  testWidgets(
    'outgoing range middle day keeps selection during a month transition',
    (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final days = <DateTime, NakedCalendarDayState>{};
      await tester.pumpWidget(
        _host(
          NakedRangeCalendar(
            value: NakedDateRange(
              start: DateTime(2024, 2, 10),
              end: DateTime(2024, 2, 12),
            ),
            firstDate: DateTime(2024),
            lastDate: DateTime(2024, 12, 31),
            onChanged: (_) {},
            focusNode: focus,
            builder: (_, state, _) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: ValueKey(state.displayedMonth),
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final week in state.weeks)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final date in week)
                          if (date == null)
                            const SizedBox.square(dimension: 44)
                          else
                            NakedCalendarDay(
                              date: date,
                              semanticLabel:
                                  '${date.year}-${date.month}-${date.day}',
                              builder: (_, day, _) {
                                days[date] = day;
                                return SizedBox.square(
                                  dimension: 44,
                                  child: Text('${date.day}'),
                                );
                              },
                            ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      focus.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final outgoing = days[DateTime(2024, 2, 11)]!;
      expect(outgoing.isOutsideMonth, isTrue);
      expect(outgoing.isSelected, isTrue);
      expect(outgoing.rangePosition, NakedRangePosition.middle);
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
    },
  );

  group('month transitions', () {
    final states = <String, NakedCalendarDayState>{};

    Future<List<DateTime>> pumpSwitcher(
      WidgetTester tester,
      FocusNode focus,
    ) async {
      final requests = <DateTime>[];
      states.clear();
      // Keying each grid by navigation, not by month, keeps the outgoing
      // February beside the incoming one when the user returns to it.
      DateTime? lastMonth;
      var generation = 0;
      Key gridKey(DateTime month) {
        if (lastMonth != month) generation++;
        lastMonth = month;
        return ValueKey(generation);
      }

      await tester.pumpWidget(
        _host(
          NakedCalendar(
            value: DateTime(2024, 2, 15),
            firstDate: DateTime(2024),
            lastDate: DateTime(2024, 12, 31),
            onChanged: requests.add,
            focusNode: focus,
            builder: (_, state, _) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Column(
                key: gridKey(state.displayedMonth),
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final week in state.weeks)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (final date in week)
                          if (date == null)
                            const SizedBox.square(dimension: 44)
                          else
                            NakedCalendarDay(
                              date: date,
                              semanticLabel:
                                  '${date.year}-${date.month}-${date.day}',
                              builder: (_, day, _) {
                                states['${date.month}-${date.day}'] = day;
                                return SizedBox.square(
                                  dimension: 44,
                                  child: Text('${date.day}'),
                                );
                              },
                            ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
      return requests;
    }

    testWidgets('outgoing month days build inert instead of throwing', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        final focus = FocusNode();
        addTearDown(focus.dispose);
        await pumpSwitcher(tester, focus);
        focus.requestFocus();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
        // February is still painted while it fades out, but it is inert.
        final outgoing = states['2-15']!;
        expect(outgoing.isOutsideMonth, isTrue);
        expect(outgoing.isDisabled, isTrue);
        expect(find.bySemanticsLabel('2024-2-15'), findsNothing);
        expect(find.bySemanticsLabel('2024-3-15'), findsOneWidget);
        expect(states['3-15']!.isOutsideMonth, isFalse);
        await tester.pump(); // Rebuild after the deferred focus handoff.
        expect(states['3-15']!.isFocused, isTrue);
        expect(states['2-15']!.isFocused, isFalse);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('an outgoing selected day keeps its selected paint', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        final focus = FocusNode();
        addTearDown(focus.dispose);
        await pumpSwitcher(tester, focus);
        expect(states['2-15']!.isSelected, isTrue);

        focus.requestFocus();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // February fades out still showing its selection, but stays inert.
        final outgoing = states['2-15']!;
        expect(outgoing.isOutsideMonth, isTrue);
        expect(outgoing.isSelected, isTrue);
        expect(outgoing.isDisabled, isTrue);
        expect(outgoing.isFocused, isFalse);
        expect(find.bySemanticsLabel('2024-2-15'), findsNothing);
        expect(states['2-16']!.isSelected, isFalse);
        await tester.pumpAndSettle();
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('rapid back-and-forth keeps one live day per date', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final requests = await pumpSwitcher(tester, focus);
      focus.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      // The first February grid is still fading out beside the incoming one.
      // Only the newest grid is live: it holds focus and is the one tab stop.
      final newest = tester
          .elementList(
            find.descendant(
              of: find.byType(AnimatedSwitcher),
              matching: find.byType(FadeTransition),
            ),
          )
          .last;
      bool isUnder(Element ancestor, BuildContext? context) {
        var found = false;
        context?.visitAncestorElements((element) {
          found = identical(element, ancestor);
          return !found;
        });
        return found;
      }

      expect(
        isUnder(newest, FocusManager.instance.primaryFocus?.context),
        isTrue,
        reason: 'primary focus sits under the newest grid',
      );
      final dayStops = FocusManager.instance.rootScope.traversalDescendants
          .where(
            (node) =>
                node.context
                    ?.findAncestorWidgetOfExactType<NakedCalendarDay>() !=
                null,
          )
          .toList();
      expect(dayStops, hasLength(1), reason: 'one tab stop for the date');
      expect(isUnder(newest, dayStops.single.context), isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(requests, [DateTime(2024, 2, 16)]);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('unavailable days do not report hover', (tester) async {
    final state = await _pump(tester);
    state.change(() => state.unavailable = (date) => date.day == 20);
    await tester.pump();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: tester.getCenter(_day(20)));
    await tester.pump();
    expect(state.days[DateTime(2024, 2, 20)]!.isHovered, isFalse);
    await mouse.moveTo(tester.getCenter(_day(21)));
    await tester.pump();
    expect(state.days[DateTime(2024, 2, 21)]!.isHovered, isTrue);
  });

  testWidgets('isUnavailable reports in-bounds predicate dates only', (
    tester,
  ) async {
    final state = await _pump(tester);
    state.change(() {
      state.first = DateTime(2024, 2, 10);
      state.unavailable = (_) => true;
    });
    await tester.pump();
    final outOfBounds = state.days[DateTime(2024, 2, 5)]!;
    expect(outOfBounds.isDisabled, isTrue);
    expect(outOfBounds.isUnavailable, isFalse);
    final rejected = state.days[DateTime(2024, 2, 12)]!;
    expect(rejected.isDisabled, isTrue);
    expect(rejected.isUnavailable, isTrue);
  });

  for (final invalidWeekday in [0, 8]) {
    testWidgets('rejects weekday $invalidWeekday', (tester) async {
      await tester.pumpWidget(
        _host(
          NakedCalendar(
            value: null,
            firstDate: DateTime(2024),
            lastDate: DateTime(2025),
            firstDayOfWeek: invalidWeekday,
            builder: (_, _, _) => const SizedBox(),
          ),
        ),
      );
      expect(tester.takeException(), isAssertionError);
    });
  }
  testWidgets('rejects reversed inclusive bounds', (tester) async {
    await tester.pumpWidget(
      _host(
        NakedCalendar(
          value: null,
          firstDate: DateTime(2025),
          lastDate: DateTime(2024),
          builder: (_, _, _) => const SizedBox(),
        ),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });
}
