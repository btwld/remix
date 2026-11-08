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
        child: Focus(
          onKeyEvent: (_, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Center(child: child),
        ),
      ),
    );

class _Harness extends StatefulWidget {
  const _Harness({this.direction = TextDirection.ltr});
  final TextDirection direction;
  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  NakedDateRange? value;
  DateTime first = DateTime(2023, 1, 1, 20);
  DateTime last = DateTime.utc(2026, 12, 31);
  bool enabled = true;
  bool callback = true;
  int firstDay = DateTime.monday;
  bool Function(DateTime)? unavailable;
  final requests = <NakedDateRange>[];
  bool accept = false;
  void Function(NakedDateRange)? onRequest;
  int escapes = 0;
  final entry = FocusNode(debugLabel: 'calendar entry');
  final before = FocusNode(debugLabel: 'before');
  final after = FocusNode(debugLabel: 'after');
  late NakedRangeCalendarState snapshot;
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
        Focus(
          onKeyEvent: (_, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              escapes++;
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: NakedRangeCalendar(
            value: value,
            firstDate: first,
            lastDate: last,
            currentDate: DateTime(2024, 2, 15),
            firstDayOfWeek: firstDay,
            enabled: enabled,
            onChanged: callback
                ? (range) {
                    requests.add(range);
                    onRequest?.call(range);
                    if (accept) setState(() => value = range);
                  }
                : null,
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

NakedDateRange _range(int start, int end) => NakedDateRange(
  start: DateTime(2024, 2, start),
  end: DateTime(2024, 2, end),
);

Future<void> _tap(WidgetTester tester, int day) async {
  await tester.tap(_day(day));
  await tester.pumpAndSettle();
}

SemanticsNode _semantics(WidgetTester tester, int day) =>
    tester.getSemantics(find.bySemanticsLabel('2024-2-$day'));

void main() {
  for (final platform in [TargetPlatform.iOS, TargetPlatform.macOS]) {
    testWidgets(
      '$platform semantic anchor retains keyboard continuity without taking external focus',
      (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        final semantics = tester.ensureSemantics();
        try {
          final state = await _pump(tester);
          await _focus(tester, state);
          final anchor = _semantics(tester, 20);
          if (platform == TargetPlatform.iOS) {
            expect(
              anchor.getSemanticsData().hasAction(SemanticsAction.focus),
              isFalse,
            );
          }
          anchor.owner!.performAction(anchor.id, SemanticsAction.tap);
          await tester.pumpAndSettle();
          expect(state.days[DateTime(2024, 2, 20)]!.isFocused, isTrue);
          await _key(tester, LogicalKeyboardKey.arrowRight);
          expect(state.snapshot.preview, _range(20, 21));
          expect(state.requests, isEmpty);
          await _key(tester, LogicalKeyboardKey.escape);
          state.after.requestFocus();
          await tester.pumpAndSettle();
          final externalAnchor = _semantics(tester, 22);
          externalAnchor.owner!.performAction(
            externalAnchor.id,
            SemanticsAction.tap,
          );
          await tester.pumpAndSettle();
          expect(state.after.hasPrimaryFocus, isTrue);
          expect(state.snapshot.anchor, DateTime(2024, 2, 22));
          expect(state.requests, isEmpty);
        } finally {
          semantics.dispose();
          debugDefaultTargetPlatformOverride = null;
        }
      },
    );
  }

  testWidgets(
    'backward availability scan progresses across a skipped local date',
    (tester) async {
      var calls = 0;
      late NakedRangeCalendarState snapshot;
      await tester.pumpWidget(
        _host(
          NakedRangeCalendar(
            value: null,
            currentDate: DateTime.utc(2011, 12, 31),
            firstDate: DateTime.utc(2011, 12, 1),
            lastDate: DateTime.utc(2011, 12, 31),
            onChanged: (_) {},
            isDateUnavailable: (date) {
              if (++calls > 100)
                throw StateError('civil scan did not progress');
              return false;
            },
            builder: (_, state, _) {
              snapshot = state;
              return NakedCalendarDay(
                date: DateTime.utc(2011, 12, 31),
                semanticLabel: 'December 31',
                builder: (_, _, _) => const SizedBox.square(dimension: 44),
              );
            },
          ),
        ),
      );
      await tester.tap(find.byType(NakedCalendarDay));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(snapshot.anchor?.day, 31);
      expect(snapshot.isPreviewValid, isTrue);
      expect(calls, lessThan(100));
    },
  );

  testWidgets(
    'anchor, navigation, reverse completion and rejection stay controlled',
    (tester) async {
      final state = await _pump(tester);
      state.change(() => state.value = _range(10, 12));
      await tester.pump();
      await _tap(tester, 20);
      expect(state.snapshot.anchor, DateTime(2024, 2, 20));
      expect(state.snapshot.preview, _range(20, 20));
      expect(state.requests, isEmpty);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(state.snapshot.preview, _range(19, 20));
      expect(state.requests, isEmpty);
      expect(state.days[DateTime(2024, 2, 11)]!.isSelected, isTrue);
      expect(state.days[DateTime(2024, 2, 20)]!.isSelected, isFalse);
      await _key(tester, LogicalKeyboardKey.space);
      expect(state.requests, [_range(19, 20)]);
      expect(state.snapshot.anchor, isNull);
      expect(state.snapshot.preview, isNull);
      expect(state.snapshot.value, _range(10, 12));
      expect(state.days[DateTime(2024, 2, 11)]!.isSelected, isTrue);
      expect(state.days[DateTime(2024, 2, 19)]!.isSelected, isFalse);
    },
  );

  testWidgets(
    'same-day completion requests once; callback-requested rebuild clears draft',
    (tester) async {
      final state = await _pump(tester);
      await _tap(tester, 20);
      var requests = 0;
      state.onRequest = (_) {
        requests++;
        // A rebuild requested by the callback must see no draft.
        state.change(() {});
      };
      await _tap(tester, 20);
      expect(requests, 1);
      expect(state.requests, [_range(20, 20)]);
      expect(state.snapshot.anchor, isNull);
      await _tap(tester, 21);
      expect(state.snapshot.anchor, DateTime(2024, 2, 21));
      expect(state.requests.length, 1);
    },
  );

  testWidgets(
    'accepting parent, equal replacement and clear have civil value semantics',
    (tester) async {
      final state = await _pump(tester);
      state.change(() => state.accept = true);
      await tester.pump();
      await _tap(tester, 20);
      await _tap(tester, 22);
      expect(state.value, _range(20, 22));
      expect(state.days[DateTime(2024, 2, 21)]!.isSelected, isTrue);
      await _tap(tester, 24);
      state.snapshot.showMonth!(DateTime(2024, 3));
      await tester.pumpAndSettle();
      state.change(
        () => state.value = NakedDateRange(
          start: DateTime.utc(2024, 2, 20, 23),
          end: DateTime(2024, 2, 22, 18),
        ),
      );
      await tester.pumpAndSettle();
      expect(state.snapshot.anchor, DateTime(2024, 2, 24));
      expect(state.snapshot.displayedMonth, DateTime(2024, 3));
      state.change(() => state.value = null);
      await tester.pumpAndSettle();
      expect(state.snapshot.anchor, isNull);
      expect(state.snapshot.displayedMonth, DateTime(2024, 3));
    },
  );

  testWidgets(
    'inclusive unavailable interior blocks offscreen forward and reverse completion',
    (tester) async {
      final state = await _pump(tester);
      state.change(() => state.unavailable = (d) => d == DateTime(2024, 2, 29));
      await tester.pump();
      await _tap(tester, 28);
      await _key(tester, LogicalKeyboardKey.pageDown);
      await _tap(tester, 2);
      expect(state.requests, isEmpty);
      expect(state.snapshot.anchor, DateTime(2024, 2, 28));
      expect(state.snapshot.isPreviewValid, isFalse);
      await _key(tester, LogicalKeyboardKey.escape);
      await _tap(tester, 2);
      await _key(tester, LogicalKeyboardKey.pageUp);
      await _tap(tester, 28);
      expect(state.requests, isEmpty);
      expect(state.snapshot.anchor, DateTime(2024, 3, 2));
      final semantics = tester.ensureSemantics();
      await tester.pump();
      final target = _semantics(tester, 28);
      target.owner!.performAction(target.id, SemanticsAction.focus);
      await tester.pumpAndSettle();
      semantics.dispose();
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 29));
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.requests, isEmpty);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.requests, [
        NakedDateRange(start: DateTime(2024, 3), end: DateTime(2024, 3, 2)),
      ]);
    },
  );

  testWidgets(
    'activation rechecks changed captured predicate without rebuilding',
    (tester) async {
      final state = await _pump(tester);
      final blocked = <DateTime>{};
      final bool Function(DateTime) predicate = blocked.contains;
      state.change(() => state.unavailable = predicate);
      await tester.pump();
      await _tap(tester, 20);
      blocked.add(DateTime(2024, 2, 21));
      // There has been no widget rebuild since this mutation. The previously
      // enabled target's callback must not authorize a stale interval.
      await _tap(tester, 22);
      expect(state.requests, isEmpty);
      expect(state.snapshot.anchor, DateTime(2024, 2, 20));
      state.change(() {});
      await tester.pumpAndSettle();
      expect(identical(state.unavailable, predicate), isTrue);
      expect(state.days[DateTime(2024, 2, 22)]!.isDisabled, isTrue);
      blocked.clear();
      state.change(() {});
      await tester.pump();
      await _tap(tester, 22);
      expect(state.requests, [_range(20, 22)]);
    },
  );

  for (final kind in ['bounds', 'availability', 'disable', 'callback']) {
    testWidgets(
      '$kind invalidation discards anchor without correcting parent value',
      (tester) async {
        final state = await _pump(tester);
        state.change(() => state.value = _range(10, 12));
        await tester.pump();
        await _tap(tester, 20);
        state.change(() {
          switch (kind) {
            case 'bounds':
              state.first = DateTime(2024, 2, 21);
            case 'availability':
              state.unavailable = (d) => d.day == 20;
            case 'disable':
              state.enabled = false;
            case 'callback':
              state.callback = false;
          }
        });
        await tester.pumpAndSettle();
        expect(state.snapshot.anchor, isNull);
        expect(state.snapshot.value, _range(10, 12));
        expect(state.requests, isEmpty);
        if (kind == 'bounds') expect(state.snapshot.isValueValid, isFalse);
      },
    );
  }

  testWidgets(
    'invalid anchor detected at activation cancels without restarting',
    (tester) async {
      final state = await _pump(tester);
      final blocked = <DateTime>{};
      state.change(() => state.unavailable = blocked.contains);
      await tester.pump();
      await _tap(tester, 20);
      blocked.add(DateTime(2024, 2, 20));
      await _tap(tester, 22);
      expect(state.snapshot.anchor, isNull);
      expect(state.requests, isEmpty);
    },
  );

  testWidgets(
    'external invalid range remains selected; view clamps independently',
    (tester) async {
      final state = await _pump(tester);
      state.change(() {
        state.first = DateTime(2024, 2, 10);
        state.last = DateTime(2024, 2, 25);
        state.value = _range(5, 15);
        state.unavailable = (d) => d.day == 11;
      });
      await tester.pumpAndSettle();
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 10));
      expect(state.snapshot.isValueValid, isFalse);
      expect(state.days[DateTime(2024, 2, 11)]!.isSelected, isTrue);
      expect(state.days[DateTime(2024, 2, 11)]!.isDisabled, isTrue);
      expect(state.snapshot.value, _range(5, 15));
      expect(state.requests, isEmpty);
    },
  );

  testWidgets(
    'semantic actions preserve committed selection and blocked-date focus',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final state = await _pump(tester);
      state.change(() {
        state.value = _range(10, 12);
        state.unavailable = (d) => d.day == 21;
      });
      await tester.pump();
      final start = _semantics(tester, 20);
      start.owner!.performAction(start.id, SemanticsAction.tap);
      await tester.pumpAndSettle();
      expect(state.requests, isEmpty);
      expect(
        _semantics(tester, 11).getSemanticsData().flagsCollection.isSelected,
        Tristate.isTrue,
      );
      expect(
        _semantics(tester, 20).getSemanticsData().flagsCollection.isSelected,
        Tristate.isFalse,
      );
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
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 22));
      expect(state.snapshot.isPreviewValid, isFalse);
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.requests, isEmpty);
      final end = _semantics(tester, 19);
      end.owner!.performAction(end.id, SemanticsAction.tap);
      await tester.pump();
      expect(state.requests, [_range(19, 20)]);
      expect(state.snapshot.anchor, isNull);
      for (var day = 1; day <= 29; day++) {
        expect(find.bySemanticsLabel('2024-2-$day'), findsOneWidget);
      }
      semantics.dispose();
    },
  );

  testWidgets(
    'draft survives Tab/blur and Escape cancels while bubbling once',
    (tester) async {
      final state = await _pump(tester);
      await _tap(tester, 20);
      await _key(tester, LogicalKeyboardKey.tab);
      expect(state.after.hasFocus, isTrue);
      expect(state.snapshot.anchor, DateTime(2024, 2, 20));
      await _key(tester, LogicalKeyboardKey.tab); // wrap to before
      await _focus(tester, state);
      await _key(tester, LogicalKeyboardKey.escape);
      expect(state.snapshot.anchor, isNull);
      expect(state.escapes, 1);
      expect(state.requests, isEmpty);
    },
  );

  testWidgets(
    'shared navigation retains RTL, leap, month, week and year movement',
    (tester) async {
      final state = await _pump(tester, direction: TextDirection.rtl);
      await _tap(tester, 29);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(state.snapshot.focusedDate, DateTime(2024, 3));
      expect(
        state.snapshot.preview,
        NakedDateRange(start: DateTime(2024, 2, 29), end: DateTime(2024, 3)),
      );
      await _key(tester, LogicalKeyboardKey.home);
      expect(state.snapshot.focusedDate, DateTime(2024, 2, 26));
      await _key(tester, LogicalKeyboardKey.end);
      expect(state.snapshot.focusedDate, DateTime(2024, 3, 3));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await _key(tester, LogicalKeyboardKey.pageDown);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      expect(state.snapshot.focusedDate, DateTime(2025, 3, 3));
      expect(state.requests, isEmpty);
    },
  );

  for (final kind in [
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
  ]) {
    testWidgets(
      '$kind anchors/completes on release only, cancellation never selects',
      (tester) async {
        final state = await _pump(tester);
        final gesture = await tester.startGesture(
          tester.getCenter(_day(20)),
          kind: kind,
        );
        await tester.pump();
        expect(state.snapshot.anchor, isNull);
        await gesture.cancel();
        await tester.pumpAndSettle();
        expect(state.snapshot.anchor, isNull);
        await _tap(tester, 20);
        final completion = await tester.startGesture(
          tester.getCenter(_day(22)),
          kind: kind,
        );
        await tester.pump();
        expect(state.requests, isEmpty);
        await completion.cancel();
        await tester.pumpAndSettle();
        expect(state.requests, isEmpty);
        final release = await tester.startGesture(
          tester.getCenter(_day(22)),
          kind: kind,
        );
        await release.up();
        await tester.pumpAndSettle();
        expect(state.requests, [_range(20, 22)]);
      },
    );
  }

  for (final accept in [false, true]) {
    testWidgets(
      'forward cross-month completion keeps the view (accept: $accept)',
      (tester) async {
        final state = await _pump(tester);
        state.accept = accept;
        await _focus(tester, state);
        await _tap(tester, 28);
        await _key(tester, LogicalKeyboardKey.pageDown);
        expect(state.snapshot.focusedDate, DateTime(2024, 3, 28));
        await _key(tester, LogicalKeyboardKey.enter);
        expect(state.requests, [
          NakedDateRange(
            start: DateTime(2024, 2, 28),
            end: DateTime(2024, 3, 28),
          ),
        ]);
        // Accepting the value this calendar just requested is not an external
        // change: browsing and keyboard focus stay on the completed end.
        expect(state.snapshot.displayedMonth, DateTime(2024, 3));
        expect(state.snapshot.focusedDate, DateTime(2024, 3, 28));
        expect(state.days[DateTime(2024, 3, 28)]!.isFocused, isTrue);
      },
    );
  }

  testWidgets(
    'an external range change after completion still recentres on its start',
    (tester) async {
      final state = await _pump(tester);
      state.accept = true;
      await _focus(tester, state);
      await _tap(tester, 28);
      await _key(tester, LogicalKeyboardKey.pageDown);
      await _key(tester, LogicalKeyboardKey.enter);
      expect(state.snapshot.displayedMonth, DateTime(2024, 3));
      state.change(
        () => state.value = NakedDateRange(
          start: DateTime(2024, 6, 3),
          end: DateTime(2024, 6, 5),
        ),
      );
      await tester.pumpAndSettle();
      expect(state.snapshot.displayedMonth, DateTime(2024, 6));
      expect(state.snapshot.focusedDate, DateTime(2024, 6, 3));
      expect(state.days[DateTime(2024, 6, 3)]!.isFocused, isTrue);
    },
  );

  testWidgets(
    'a parent that substitutes a different range recentres on its start',
    (tester) async {
      final state = await _pump(tester);
      // The parent snaps the requested range to the start of the end month.
      state.onRequest = (range) => state.change(
        () => state.value = NakedDateRange(
          start: DateTime(range.end.year, range.end.month),
          end: range.end,
        ),
      );
      await _focus(tester, state);
      await _tap(tester, 20);
      await _key(tester, LogicalKeyboardKey.pageDown);
      await _key(tester, LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(
        state.value,
        NakedDateRange(start: DateTime(2024, 3), end: DateTime(2024, 3, 20)),
      );
      expect(state.snapshot.displayedMonth, DateTime(2024, 3));
      expect(state.snapshot.focusedDate, DateTime(2024, 3));
    },
  );

  testWidgets('semantic iOS policy remains unchanged for range days', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final semantics = tester.ensureSemantics();
    final state = await _pump(tester);
    final day = _semantics(tester, 20);
    expect(day.getSemanticsData().hasAction(SemanticsAction.focus), isFalse);
    day.owner!.performAction(day.id, SemanticsAction.tap);
    await tester.pump();
    expect(state.snapshot.anchor, DateTime(2024, 2, 20));
    expect(state.requests, isEmpty);
    semantics.dispose();
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('G4 warmed 100-year probe compares null and real predicates', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final state = await _pump(tester);
    var calls = 0;
    state.change(() {
      state.first = DateTime(1900);
      state.last = DateTime(2100, 12, 31);
    });
    await tester.pump();
    for (final withPredicate in [false, true]) {
      state.change(
        () => state.unavailable = withPredicate
            ? (_) {
                calls++;
                return false;
              }
            : null,
      );
      await tester.pumpAndSettle();
      final builds = <int>[];
      final activations = <int>[];
      for (var iteration = 0; iteration < 5; iteration++) {
        state.snapshot.showMonth!(DateTime(2024, 2));
        await tester.pumpAndSettle();
        await _tap(tester, 15);
        calls = 0;
        final watch = Stopwatch()..start();
        state.snapshot.showMonth!(DateTime(1924, 2));
        await tester.pumpAndSettle();
        watch.stop();
        final buildCalls = calls;
        expect(buildCalls, withPredicate ? inInclusiveRange(36500, 38000) : 0);
        calls = 0;
        final commitWatch = Stopwatch()..start();
        final target = tester.getSemantics(find.bySemanticsLabel('1924-2-15'));
        target.owner!.performAction(target.id, SemanticsAction.tap);
        await tester.pumpAndSettle();
        commitWatch.stop();
        expect(calls, withPredicate ? inInclusiveRange(36500, 38000) : 0);
        expect(
          state.requests.last,
          NakedDateRange(
            start: DateTime(1924, 2, 15),
            end: DateTime(2024, 2, 15),
          ),
        );
        if (iteration > 0) {
          builds.add(watch.elapsedMicroseconds);
          activations.add(commitWatch.elapsedMicroseconds);
        }
        print(
          'G4 predicate=$withPredicate iteration=$iteration buildCalls=$buildCalls activationCalls=$calls',
        );
      }
      builds.sort();
      activations.sort();
      print(
        'G4 predicate=$withPredicate warmed build us=$builds; activation+rebuild us=$activations. Debug widget-test pump timing is not a device-frame benchmark.',
      );
    }
    semantics.dispose();
  });
}
