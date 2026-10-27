import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

Widget host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    Directionality(
      textDirection: direction,
      child: Center(child: child),
    );

void main() {
  testWidgets('excluded slider retains keyboard focus and arrows', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final changes = <List<double>>[];
    await tester.pumpWidget(
      host(
        NakedSlider(
          values: const [50],
          focusNodes: [focus],
          excludeSemantics: true,
          semanticLabels: const ['Hidden slider'],
          onChanged: changes.add,
          child: const SizedBox(width: 200, height: 48),
        ),
      ),
    );
    focus.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(changes, [
      [51.0],
    ]);
    expect(find.bySemanticsLabel('Hidden slider'), findsNothing);
    semantics.dispose();
  });

  testWidgets('removing active slider thumb during drag does not crash', (
    tester,
  ) async {
    var values = <double>[20, 80];
    late StateSetter rebuild;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return NakedSlider(
              key: const ValueKey('slider'),
              values: values,
              onChanged: (_) {},
              child: const SizedBox(width: 200, height: 48),
            );
          },
        ),
      ),
    );
    final rect = tester.getRect(find.byKey(const ValueKey('slider')));
    final gesture = await tester.startGesture(
      Offset(rect.left + 160, rect.center.dy),
    );
    await gesture.moveBy(const Offset(25, 0));
    await tester.pump();
    rebuild(() => values = [20]);
    await tester.pump();
    await gesture.moveBy(const Offset(-10, 0));
    await gesture.up();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('one slider tap emits one start and one end', (tester) async {
    final starts = <List<double>>[];
    final ends = <List<double>>[];
    final changes = <List<double>>[];
    await tester.pumpWidget(
      host(
        NakedSlider(
          values: const [20],
          onChanged: changes.add,
          onChangeStart: starts.add,
          onChangeEnd: ends.add,
          child: const SizedBox(width: 200, height: 48),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(NakedSlider));
    await tester.tapAt(Offset(rect.left + 80, rect.center.dy));
    await tester.pump();
    expect(starts, [
      [20.0],
    ]);
    expect(ends, [
      [40.0],
    ]);
    expect(changes, [
      [40.0],
    ]);
  });

  for (final axis in Axis.values) {
    for (final removeEarlier in [false, true]) {
      testWidgets(
        '$axis removing ${removeEarlier ? "earlier" : "active"} thumb ends the session',
        (tester) async {
          var values = <double>[20, 50, 80];
          final first = FocusNode();
          final middle = FocusNode();
          final last = FocusNode();
          for (final node in [first, middle, last]) {
            addTearDown(node.dispose);
          }
          var nodes = <FocusNode>[first, middle, last];
          late StateSetter rebuild;
          final starts = <List<double>>[];
          final ends = <List<double>>[];
          final changes = <List<double>>[];
          final dragging = <bool>[];
          NakedSliderState? state;
          await tester.pumpWidget(
            host(
              StatefulBuilder(
                builder: (context, setState) {
                  rebuild = setState;
                  return NakedSlider(
                    values: values,
                    focusNodes: nodes,
                    orientation: axis,
                    minSpacing: 10,
                    onChanged: changes.add,
                    onChangeStart: starts.add,
                    onChangeEnd: ends.add,
                    onDragChange: dragging.add,
                    builder: (context, snapshot, _) {
                      state = snapshot;
                      return SizedBox(
                        width: axis == Axis.horizontal ? 200 : 48,
                        height: axis == Axis.horizontal ? 48 : 200,
                      );
                    },
                  );
                },
              ),
            ),
          );
          final rect = tester.getRect(find.byType(NakedSlider));
          Offset point(double value) => axis == Axis.horizontal
              ? Offset(rect.left + 2 * value, rect.center.dy)
              : Offset(rect.center.dx, rect.bottom - 2 * value);
          final gesture = await tester.startGesture(point(80));
          await gesture.moveTo(point(95));
          await tester.pump();
          expect(last.hasFocus, isTrue);
          final requested = List<double>.of(changes.last);
          rebuild(() {
            values = removeEarlier ? [50, 80] : [20, 50];
            nodes = removeEarlier ? [middle, last] : [first, middle];
          });
          await tester.pump();
          final count = changes.length;
          expect(state!.isDragging, isFalse);
          expect(state!.activeThumbIndex, isNull);
          await gesture.moveTo(point(60));
          await gesture.up();
          await tester.pump();
          expect(tester.takeException(), isNull);
          expect(changes, hasLength(count));
          expect(starts, [
            [20, 50, 80],
          ]);
          expect(ends, [requested]);
          expect(dragging, [true, false]);
          for (final values in changes) {
            expect(values, hasLength(3));
            expect(values.last, inInclusiveRange(60, 100));
          }
          if (removeEarlier) {
            expect(last.hasPrimaryFocus, isTrue);
            expect(state!.focusedThumbIndex, 1);
            await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
            await tester.pump();
            expect(changes.last, [50, 79]);
          }
          await tester.pumpWidget(const SizedBox());
          // The slider must leave ownership of external nodes to the caller.
          last.addListener(() {});
        },
      );
    }

    for (final accept in [false, true]) {
      testWidgets(
        '$axis controlled $accept rebuild retains last request at cancellation',
        (tester) async {
          var values = <double>[20];
          late StateSetter rebuild;
          final events = <String>[];
          final ends = <List<double>>[];
          final changes = <List<double>>[];
          await tester.pumpWidget(
            host(
              StatefulBuilder(
                builder: (context, setState) {
                  rebuild = setState;
                  return NakedSlider(
                    values: values,
                    orientation: axis,
                    onChanged: (next) {
                      events.add('change');
                      changes.add(next);
                      if (accept) setState(() => values = next);
                    },
                    onChangeStart: (_) => events.add('start'),
                    onChangeEnd: (next) {
                      events.add('end');
                      ends.add(next);
                    },
                    child: SizedBox(
                      width: axis == Axis.horizontal ? 200 : 48,
                      height: axis == Axis.horizontal ? 48 : 200,
                    ),
                  );
                },
              ),
            ),
          );
          final rect = tester.getRect(find.byType(NakedSlider));
          Offset point(double fraction) => axis == Axis.horizontal
              ? Offset(rect.left + rect.width * fraction, rect.center.dy)
              : Offset(rect.center.dx, rect.bottom - rect.height * fraction);
          final gesture = await tester.startGesture(point(.2));
          await gesture.moveTo(point(.6));
          await tester.pump();
          expect(changes.last, [60]);
          rebuild(() {});
          await tester.pump();
          await gesture.cancel();
          await tester.pump();
          expect(events, ['start', 'change', 'end']);
          expect(ends, [
            [60],
          ]);
        },
      );

      testWidgets('$axis tap controlled $accept has one exact sequence', (
        tester,
      ) async {
        var values = <double>[20];
        final events = <String>[];
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) => NakedSlider(
                values: values,
                orientation: axis,
                onChanged: (next) {
                  events.add('change ${next.single}');
                  if (accept) setState(() => values = next);
                },
                onChangeStart: (next) => events.add('start ${next.single}'),
                onChangeEnd: (next) => events.add('end ${next.single}'),
                child: SizedBox(
                  width: axis == Axis.horizontal ? 200 : 48,
                  height: axis == Axis.horizontal ? 48 : 200,
                ),
              ),
            ),
          ),
        );
        final rect = tester.getRect(find.byType(NakedSlider));
        await tester.tapAt(
          axis == Axis.horizontal
              ? Offset(rect.left + 80, rect.center.dy)
              : Offset(rect.center.dx, rect.bottom - 80),
        );
        await tester.pump();
        expect(events, ['start 20.0', 'change 40.0', 'end 40.0']);
      });
    }
  }

  for (final removeCallback in [false, true]) {
    testWidgets(
      'disabling via ${removeCallback ? "callback" : "enabled"} closes original callbacks after build',
      (tester) async {
        var enabled = true;
        var attached = true;
        late StateSetter rebuild;
        final ends = <List<double>>[];
        final dragging = <bool>[];
        final changes = <List<double>>[];
        await tester.pumpWidget(
          host(
            StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return NakedSlider(
                  values: const [20],
                  enabled: enabled,
                  onChanged: attached ? changes.add : null,
                  onChangeStart: (_) {},
                  onDragChange: enabled && attached ? dragging.add : null,
                  onChangeEnd: enabled && attached
                      ? (next) {
                          ends.add(next);
                          // Ending from didUpdateWidget must be safe for a controlled owner.
                          setState(() {});
                        }
                      : null,
                  child: const SizedBox(width: 200, height: 48),
                );
              },
            ),
          ),
        );
        final rect = tester.getRect(find.byType(NakedSlider));
        final gesture = await tester.startGesture(
          Offset(rect.left + 40, rect.center.dy),
        );
        await gesture.moveTo(Offset(rect.left + 120, rect.center.dy));
        await tester.pump();
        rebuild(() {
          if (removeCallback) {
            attached = false;
          } else {
            enabled = false;
          }
        });
        await tester.pump();
        await gesture.moveBy(const Offset(20, 0));
        await gesture.up();
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(changes, [
          [60],
        ]);
        expect(ends, [
          [60],
        ]);
        expect(dragging, [true, false]);
      },
    );
  }
}
