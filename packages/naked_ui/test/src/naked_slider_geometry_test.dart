import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

void main() {
  for (final axis in Axis.values) {
    for (final direction in TextDirection.values) {
      for (final inverted in [false, true]) {
        testWidgets(
          '$axis $direction inverted=$inverted uses the marked rail',
          (tester) async {
            final changes = <List<double>>[];
            late NakedSliderState state;
            await tester.pumpWidget(
              Directionality(
                textDirection: direction,
                child: Center(
                  child: NakedSlider(
                    values: const [25],
                    orientation: axis,
                    inverted: inverted,
                    onChanged: changes.add,
                    builder: (context, snapshot, _) {
                      state = snapshot;
                      return const SizedBox.square(
                        dimension: 200,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 40, 40),
                          child: NakedSliderTrack(child: SizedBox.expand()),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
            final rail = tester.getRect(find.byType(NakedSliderTrack));
            Offset point(double value) {
              final visual = state.visualPercentageOf(value / 100);
              return axis == Axis.horizontal
                  ? Offset(rail.left + rail.width * visual, rail.center.dy)
                  : Offset(rail.center.dx, rail.top + rail.height * visual);
            }

            await tester.tapAt(point(25));
            await tester.pump();
            expect(changes, isEmpty);
            final gesture = await tester.startGesture(point(25));
            await gesture.moveTo(point(50));
            await tester.pump();
            await gesture.up();
            await tester.pump();
            expect(changes, [
              [50],
            ]);

            for (final endpoint in [0.0, 100.0]) {
              changes.clear();
              await tester.tapAt(point(endpoint));
              await tester.pump();
              expect(changes, [
                [endpoint],
              ]);
            }

            // Padding remains part of the hit target and clamps to an endpoint.
            changes.clear();
            final outside = point(0) + (point(0) - point(100)) / 14;
            await tester.tapAt(outside);
            await tester.pump();
            expect(changes, [
              [0],
            ]);
          },
        );
      }
    }
  }

  testWidgets('a collapsed rail ignores input without invalid values', (
    tester,
  ) async {
    final changes = <List<double>>[];
    final starts = <List<double>>[];
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: NakedSlider(
            values: const [50],
            onChanged: changes.add,
            onChangeStart: starts.add,
            child: const SizedBox(
              width: 200,
              height: 48,
              child: Align(
                child: NakedSliderTrack(child: SizedBox(width: 0, height: 48)),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(NakedSlider));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(changes, isEmpty);
    expect(starts, isEmpty);
  });
}
