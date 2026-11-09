import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

Widget _host(Widget child) => WidgetsApp(
  color: const Color(0xffffffff),
  builder: (_, _) => Center(child: child),
);

/// `melos run test:calendar-civil` runs this file with TZ=Pacific/Apia, where
/// 2011-12-30 does not exist locally. Elsewhere the cases are ordinary days.
final _apiaLane = Platform.environment['TZ'] == 'Pacific/Apia';

void main() {
  test(
    'Apia lane: the local zone actually skips 2011-12-30',
    () {
      // Without this, a lane whose TZ is not applied passes vacuously.
      expect(
        DateTime(2011, 12, 30).day,
        31,
        reason: 'TZ=Pacific/Apia was set but not applied by the runtime.',
      );
    },
    skip: _apiaLane
        ? false
        : 'Runs in the Pacific/Apia lane (melos run test:calendar-civil).',
  );

  testWidgets('month and year navigation preserve a skipped civil day', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final requests = <DateTime>[];
    late NakedCalendarState snapshot;
    await tester.pumpWidget(
      _host(
        NakedCalendar(
          value: DateTime.utc(2010, 12, 30),
          firstDate: DateTime(2010),
          lastDate: DateTime(2012, 12, 31),
          focusNode: focus,
          onChanged: requests.add,
          builder: (_, state, _) {
            snapshot = state;
            return NakedCalendarDay(
              date: state.focusedDate,
              semanticLabel: 'Focused date',
              builder: (_, _, _) => const SizedBox.square(dimension: 44),
            );
          },
        ),
      ),
    );
    focus.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pumpAndSettle();
    expect(snapshot.focusedDate.year, 2011);
    expect(snapshot.focusedDate.month, 12);
    expect(snapshot.focusedDate.day, 30);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(requests.single.day, 30);
    // The skipped local day can only be carried as UTC civil fields.
    if (_apiaLane) expect(requests.single.isUtc, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    await tester.pumpAndSettle();
    expect(snapshot.focusedDate.month, 11);
    expect(snapshot.focusedDate.day, 30);
    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.pumpAndSettle();
    expect(snapshot.focusedDate.month, 12);
    expect(snapshot.focusedDate.day, 30);
  });

  testWidgets('civil month retains every date across a skipped local day', (
    tester,
  ) async {
    late NakedCalendarState snapshot;
    await tester.pumpWidget(
      _host(
        NakedCalendar(
          value: DateTime.utc(2011, 12, 30),
          firstDate: DateTime.utc(2011, 12, 1),
          lastDate: DateTime.utc(2011, 12, 31),
          onChanged: (_) {},
          builder: (_, state, _) {
            snapshot = state;
            return const SizedBox();
          },
        ),
      ),
    );
    final days = snapshot.weeks.expand((week) => week).whereType<DateTime>();
    expect(
      days.map((date) => date.day),
      orderedEquals(List.generate(31, (i) => i + 1)),
    );
    expect(snapshot.focusedDate.day, 30);
    expect(snapshot.value, DateTime.utc(2011, 12, 30));
  });

  for (final start in [
    DateTime.utc(2011, 12, 29),
    DateTime.utc(2024, 3, 9),
    DateTime.utc(2024, 11, 2),
  ]) {
    testWidgets('civil arrows and callbacks preserve fields from $start', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final requests = <DateTime>[];
      late NakedCalendarState snapshot;
      await tester.pumpWidget(
        _host(
          NakedCalendar(
            value: start,
            firstDate: DateTime.utc(start.year, start.month, 1),
            lastDate: DateTime.utc(start.year, start.month + 1, 0),
            focusNode: focus,
            onChanged: requests.add,
            builder: (_, state, _) {
              snapshot = state;
              return Column(
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
                              semanticLabel: 'Day ${date.day}',
                              builder: (_, _, _) => SizedBox.square(
                                dimension: 44,
                                child: Text('${date.day}'),
                              ),
                            ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      );
      focus.requestFocus();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      expect(requests.single.day, start.day + 1);
      final local = DateTime(start.year, start.month, start.day + 1);
      final representable =
          local.year == start.year &&
          local.month == start.month &&
          local.day == start.day + 1;
      expect(requests.single.isUtc, !representable);
      if (_apiaLane && start == DateTime.utc(2011, 12, 29)) {
        expect(representable, isFalse, reason: 'Dec 30 is skipped in Apia.');
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(snapshot.focusedDate.day, start.day + 2);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(snapshot.focusedDate.day, start.day + 1);
      expect(snapshot.value, start);
    });
  }
}
