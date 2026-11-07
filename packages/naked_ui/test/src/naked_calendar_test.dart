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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NakedButton(
                  onPressed: state.previousMonth,
                  child: const Text('Previous'),
                ),
                NakedButton(
                  onPressed: state.nextMonth,
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
      state.snapshot.previousMonth!();
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
    state.snapshot.nextMonth!();
    state.after.requestFocus();
    await tester.pump();
    await tester.pump();
    expect(state.after.hasFocus, isTrue);
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

      final state = await _pump(tester);
      state.change(() => state.unavailable = (date) => date.day == 28);
      await tester.pump();
      await _focus(tester, state);
      final selected = tester.getSemantics(find.bySemanticsLabel('2024-2-29'));
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
      semantics.dispose();
    },
  );

  testWidgets(
    'semantic input focus targets the requested day and keeps one Tab stop',
    (tester) async {
      final semantics = tester.ensureSemantics();
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
      semantics.dispose();
    },
  );

  testWidgets(
    'unavailable days accept semantic input focus without activation',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final state = await _pump(tester);
      state.change(() => state.unavailable = (date) => date.day == 20);
      await tester.pump();
      await _focus(tester, state);
      final target = tester.getSemantics(find.bySemanticsLabel('2024-2-20'));
      expect(
        target.getSemanticsData().hasAction(SemanticsAction.focus),
        isTrue,
      );
      expect(target.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      target.owner!.performAction(target.id, SemanticsAction.focus);
      await tester.pumpAndSettle();
      expect(state.days[DateTime(2024, 2, 20)]!.isFocused, isTrue);
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.requests, isEmpty);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 21));
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.requests, [DateTime(2024, 2, 21)]);
      semantics.dispose();
    },
  );

  testWidgets('out-of-bounds and disabled days omit semantic input focus', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
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
    semantics.dispose();
  });

  testWidgets('iOS follows the SDK semantic input-focus policy', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final semantics = tester.ensureSemantics();
    final state = await _pump(tester);
    final target = tester.getSemantics(find.bySemanticsLabel('2024-2-20'));
    expect(target.getSemanticsData().hasAction(SemanticsAction.focus), isFalse);
    expect(target.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
    target.owner!.performAction(target.id, SemanticsAction.tap);
    await tester.pump();
    expect(state.requests, [DateTime(2024, 2, 20)]);
    semantics.dispose();
    debugDefaultTargetPlatformOverride = null;
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
      expect(tester.takeException(), isArgumentError);
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
    expect(tester.takeException(), isArgumentError);
  });
}
