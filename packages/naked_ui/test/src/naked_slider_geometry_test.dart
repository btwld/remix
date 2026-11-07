import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
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

  testWidgets(
    'coincident thumb selection follows logical direction and then locks',
    (tester) async {
      for (final center in [0.0, 50.0, 100.0]) {
        for (final offset in [-2.0, 0.0, 2.0]) {
          for (final move in [-20.0, 20.0]) {
            for (final prior in [-1, 0, 1]) {
              for (final direction in TextDirection.values) {
                for (final kind in [
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                ]) {
                  var values = <double>[center, center];
                  final focus = [FocusNode(), FocusNode()];
                  final starts = <List<double>>[], ends = <List<double>>[];
                  late NakedSliderState state;
                  await tester.pumpWidget(
                    Directionality(
                      textDirection: direction,
                      child: Center(
                        child: StatefulBuilder(
                          builder: (context, setState) => NakedSlider(
                            values: values,
                            focusNodes: focus,
                            enableFeedback: false,
                            onChanged: (next) => setState(() => values = next),
                            onChangeStart: starts.add,
                            onChangeEnd: ends.add,
                            builder: (context, snapshot, _) {
                              state = snapshot;
                              return const SizedBox(
                                width: 248,
                                height: 48,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: NakedSliderTrack(
                                    child: SizedBox.expand(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                  if (prior >= 0) {
                    focus[prior].requestFocus();
                    await tester.pump();
                  }
                  final rail = tester.getRect(find.byType(NakedSliderTrack));
                  Offset point(double v) => Offset(
                    rail.left +
                        rail.width *
                            (direction == TextDirection.rtl
                                ? 1 - v / 100
                                : v / 100),
                    rail.center.dy,
                  );
                  final gesture = await tester.startGesture(
                    point(center + offset),
                    kind: kind,
                  );
                  await gesture.moveTo(point(center + move));
                  await tester.pump();
                  final side = (center + offset).clamp(0.0, 100.0) - center;
                  final index = side < 0
                      ? 0
                      : side > 0
                      ? 1
                      : move < 0
                      ? 0
                      : 1;
                  final expected = <double>[center, center];
                  expected[index] = index == 0
                      ? (center + move).clamp(0.0, center)
                      : (center + move).clamp(center, 100.0);
                  expect(
                    values,
                    expected,
                    reason: '$center $offset $move $prior $direction $kind',
                  );
                  if (side != 0 ||
                      (center + move).clamp(0.0, 100.0) != center) {
                    expect(state.activeThumbIndex, index);
                    await gesture.moveTo(point(center - move));
                    await tester.pump();
                    expect(state.activeThumbIndex, index);
                    expect(values[1 - index], center);
                    expect(values[0] <= values[1], isTrue);
                  }
                  await gesture.cancel();
                  await tester.pump();
                  expect(starts, [
                    [center, center],
                  ]);
                  expect(ends, [values]);
                  await tester.pumpWidget(const SizedBox());
                  for (final node in focus) {
                    node.dispose();
                  }
                }
              }
            }
          }
        }
      }
    },
  );

  testWidgets(
    'semantic centers follow an independently rebuilt rail across repaint boundaries',
    (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      var inset = 12.0;
      late StateSetter updateRail;
      for (final contained in [false, true]) {
        for (final painted in [true, false]) {
          for (final axis in Axis.values) {
            for (final direction in TextDirection.values) {
              for (final inverted in [false, true]) {
                await tester.pumpWidget(
                  Directionality(
                    textDirection: direction,
                    child: Center(
                      child: Opacity(
                        opacity: painted ? 1 : 0,
                        alwaysIncludeSemantics: true,
                        child: NakedSlider(
                          values: const [0, 25, 75, 100],
                          orientation: axis,
                          inverted: inverted,
                          semanticLabels: const [
                            'Min',
                            'Lower',
                            'Upper',
                            'Max',
                          ],
                          onChanged: (_) {},
                          builder: (context, state, _) => SizedBox.square(
                            dimension: 240,
                            child: _railBoundary(
                              contained,
                              StatefulBuilder(
                                builder: (context, setState) {
                                  updateRail = setState;
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      inset,
                                      inset + 7,
                                      inset + 13,
                                      inset + 19,
                                    ),
                                    child: _railBoundary(
                                      !contained,
                                      const NakedSliderTrack(
                                        child: SizedBox.expand(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                for (final next in [12.0, 60.0, 0.0]) {
                  updateRail(() => inset = next);
                  await tester.pump();
                  final rail = tester.getRect(find.byType(NakedSliderTrack));
                  for (var i = 0; i < 4; i++) {
                    var visual = [0.0, .25, .75, 1.0][i];
                    if (axis == Axis.vertical || direction == TextDirection.rtl)
                      visual = 1 - visual;
                    if (inverted) visual = 1 - visual;
                    final node = tester.getSemantics(
                      find.bySemanticsLabel(
                        ['Min', 'Lower', 'Upper', 'Max'][i],
                      ),
                    );
                    var transform = Matrix4.identity();
                    for (var current = node; ;) {
                      if (current.transform != null)
                        transform = current.transform! * transform;
                      if (current.parent == null) break;
                      current = current.parent!;
                    }
                    final center = MatrixUtils.transformRect(
                      transform,
                      node.rect,
                    ).center;
                    final expected = axis == Axis.horizontal
                        ? Offset(
                            rail.left + rail.width * visual,
                            rail.center.dy,
                          )
                        : Offset(
                            rail.center.dx,
                            rail.top + rail.height * visual,
                          );
                    expect(center.dx, closeTo(expected.dx, .001));
                    expect(center.dy, closeTo(expected.dy, .001));
                  }
                }
                await tester.pumpWidget(const SizedBox());
              }
            }
          }
        }
      }
      handle.dispose();
    },
  );

  testWidgets(
    'unmarked small sliders retain their constrained semantic bounds',
    (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: NakedSlider(
              values: [50],
              semanticLabels: ['Value'],
              child: SizedBox(width: 200, height: 24),
            ),
          ),
        ),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Value')).rect.size,
        const Size(48, 24),
      );
      handle.dispose();
    },
  );

  testWidgets(
    'arbitrary coincident groups open their outer identities on every axis',
    (tester) async {
      final middle = FocusNode();
      addTearDown(middle.dispose);
      for (final axis in Axis.values)
        for (final direction in TextDirection.values)
          for (final inverted in [false, true]) {
            for (final increasing in [false, true]) {
              final requests = <List<double>>[];
              late NakedSliderState state;
              await tester.pumpWidget(
                Directionality(
                  textDirection: direction,
                  child: Center(
                    child: NakedSlider(
                      values: const [20, 50, 50, 50, 80],
                      focusNodes: [null, null, middle, null, null],
                      orientation: axis,
                      inverted: inverted,
                      onChanged: requests.add,
                      enableFeedback: false,
                      builder: (context, snapshot, _) {
                        state = snapshot;
                        return const SizedBox.square(dimension: 200);
                      },
                    ),
                  ),
                ),
              );
              middle.requestFocus();
              await tester.pump();
              final rect = tester.getRect(find.byType(NakedSlider));
              Offset point(double value) {
                final visual = state.visualPercentageOf(value / 100);
                return axis == Axis.horizontal
                    ? Offset(rect.left + rect.width * visual, rect.center.dy)
                    : Offset(rect.center.dx, rect.top + rect.height * visual);
              }

              final gesture = await tester.startGesture(point(50));
              await gesture.moveTo(point(increasing ? 70 : 30));
              await tester.pump();
              expect(
                requests.last,
                increasing ? [20, 50, 50, 70, 80] : [20, 30, 50, 50, 80],
              );
              expect(state.activeThumbIndex, increasing ? 3 : 1);
              await gesture.cancel();
              await tester.pump();
              await tester.pumpWidget(const SizedBox());
            }
          }
    },
  );
  testWidgets(
    'visible constant-extent rail movement retains same-frame semantic centers and node IDs',
    (tester) async {
      final handle = tester.ensureSemantics();
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      try {
        for (final contained in [false, true])
          for (final axis in Axis.values)
            for (final direction in TextDirection.values)
              for (final inverted in [false, true]) {
                var origin = 12.0;
                late StateSetter update;
                await tester.pumpWidget(
                  Directionality(
                    textDirection: direction,
                    child: Center(
                      child: NakedSlider(
                        values: const [0, 25, 75, 100],
                        orientation: axis,
                        inverted: inverted,
                        semanticLabels: const ['Min', 'Lower', 'Upper', 'Max'],
                        onChanged: (_) {},
                        builder: (context, state, _) => SizedBox.square(
                          dimension: 240,
                          child: _railBoundary(
                            contained,
                            StatefulBuilder(
                              builder: (context, setState) {
                                update = setState;
                                return Padding(
                                  padding: axis == Axis.horizontal
                                      ? EdgeInsets.only(
                                          left: origin,
                                          right: 72 - origin,
                                        )
                                      : EdgeInsets.only(
                                          top: origin,
                                          bottom: 72 - origin,
                                        ),
                                  child: _railBoundary(
                                    !contained,
                                    const NakedSliderTrack(
                                      child: SizedBox.expand(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
                const labels = ['Min', 'Lower', 'Upper', 'Max'];
                final ids = [
                  for (final label in labels)
                    tester.getSemantics(find.bySemanticsLabel(label)).id,
                ];
                for (final next in [12.0, 60.0, 0.0]) {
                  update(() => origin = next);
                  await tester.pump();
                  final rail = tester.getRect(find.byType(NakedSliderTrack));
                  expect(
                    axis == Axis.horizontal ? rail.width : rail.height,
                    168,
                  );
                  for (var i = 0; i < 4; i++) {
                    var visual = [0.0, .25, .75, 1.0][i];
                    if (axis == Axis.vertical || direction == TextDirection.rtl)
                      visual = 1 - visual;
                    if (inverted) visual = 1 - visual;
                    final node = tester.getSemantics(
                      find.bySemanticsLabel(labels[i]),
                    );
                    expect(node.id, ids[i]);
                    var transform = Matrix4.identity();
                    for (var current = node; ;) {
                      if (current.transform != null)
                        transform = current.transform! * transform;
                      if (current.parent == null) break;
                      current = current.parent!;
                    }
                    final center = MatrixUtils.transformRect(
                      transform,
                      node.rect,
                    ).center;
                    final expected = axis == Axis.horizontal
                        ? Offset(
                            rail.left + rail.width * visual,
                            rail.center.dy,
                          )
                        : Offset(
                            rail.center.dx,
                            rail.top + rail.height * visual,
                          );
                    expect(center.dx, closeTo(expected.dx, .001));
                    expect(center.dy, closeTo(expected.dy, .001));
                  }
                }
                await tester.pumpWidget(const SizedBox());
                expect(tester.takeException(), isNull);
              }
      } finally {
        handle.dispose();
      }
    },
  );
}

Widget _railBoundary(bool enabled, Widget child) =>
    enabled ? RepaintBoundary(child: child) : child;
