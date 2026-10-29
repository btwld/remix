import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

Widget host(Widget child, {TextDirection direction = TextDirection.ltr}) =>
    Directionality(
      textDirection: direction,
      child: Center(child: child),
    );

void main() {
  testWidgets('pressing a slider endpoint thumb does not move its value', (
    tester,
  ) async {
    final changes = <double>[];
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 200,
          child: RemixSlider(
            value: 0,
            onChanged: changes.add,
            style: SliderStyler()
                .thumb(BoxStyler().width(20).height(20))
                .trackWidth(4),
          ),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(RemixSlider));
    await tester.tapAt(Offset(rect.left + 10, rect.center.dy));
    await tester.pump();
    expect(changes, isEmpty);
  });

  for (final direction in TextDirection.values) {
    for (final rawSpec in [false, true]) {
      for (final dimensions in [(20.0, 4.0), (12.0, 60.0), (36.0, 8.0)]) {
        final (thumbWidth, thickness) = dimensions;
        testWidgets(
          '$direction raw=$rawSpec thumb=$thumbWidth rail=$thickness round trips painted centers',
          (tester) async {
            for (final initial in [0.0, 0.25, 0.3333, 0.75, 1.0]) {
              final changes = <double>[];
              final events = <String>[];
              await tester.pumpWidget(
                host(
                  SizedBox(
                    width: 200,
                    child: RemixSlider(
                      value: initial,
                      enableFeedback: false,
                      onChanged: (next) {
                        changes.add(next);
                        events.add('change');
                      },
                      onChangeStart: (_) => events.add('start'),
                      onChangeEnd: (_) => events.add('end'),
                      style: rawSpec
                          ? const SliderStyler.create()
                          : SliderStyler()
                                .thumb(
                                  BoxStyler()
                                      .width(thumbWidth)
                                      .height(thumbWidth),
                                )
                                .trackThickness(thickness),
                      styleSpec: rawSpec
                          ? SliderSpec(
                              thumb: StyleSpec(
                                spec: BoxSpec(
                                  constraints: BoxConstraints.tightFor(
                                    width: thumbWidth,
                                    height: thumbWidth,
                                  ),
                                ),
                              ),
                              trackWidth: thickness,
                              rangeWidth: thickness,
                            )
                          : null,
                    ),
                  ),
                  direction: direction,
                ),
              );
              final thumb = find.byWidgetPredicate(
                (widget) =>
                    widget is RemixBoxAdapter &&
                    widget.styleSpec.spec.constraints?.maxWidth == thumbWidth,
              );
              final slider = tester.getRect(find.byType(RemixSlider));
              final center = tester.getCenter(thumb);
              final inset = math.max(thumbWidth, thickness) / 2;
              final visual = direction == TextDirection.rtl
                  ? 1 - initial
                  : initial;
              expect(
                center.dx,
                closeTo(slider.left + inset + (200 - 2 * inset) * visual, .001),
              );
              await tester.tapAt(center);
              await tester.pump();
              expect(
                changes,
                isEmpty,
                reason: 'pressing painted center at $initial',
              );
              expect(events, ['start', 'end']);

              // The rail endpoints (and the padding outside them) remain reachable.
              for (final target in [0.0, 1.0]) {
                changes.clear();
                events.clear();
                final physical = direction == TextDirection.rtl
                    ? 1 - target
                    : target;
                await tester.tapAt(
                  Offset(
                    slider.left + inset + (200 - 2 * inset) * physical,
                    center.dy,
                  ),
                );
                await tester.pump();
                expect(changes, initial == target ? isEmpty : [target]);
                expect(events.where((event) => event == 'start'), hasLength(1));
                expect(events.where((event) => event == 'end'), hasLength(1));
              }
            }
          },
        );
      }
    }
  }

  testWidgets('controlled drag moves the thumb by the pointer distance', (
    tester,
  ) async {
    var value = .25;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 200,
            child: RemixSlider(
              value: value,
              enableFeedback: false,
              onChanged: (next) => setState(() => value = next),
              style: SliderStyler()
                  .thumb(BoxStyler().width(20).height(20))
                  .trackThickness(4),
            ),
          ),
        ),
      ),
    );
    final thumb = find.byWidgetPredicate(
      (widget) =>
          widget is RemixBoxAdapter &&
          widget.styleSpec.spec.constraints?.maxWidth == 20,
    );
    final before = tester.getCenter(thumb);
    final gesture = await tester.startGesture(before);
    await tester.pump();
    expect(value, .25);
    await gesture.moveBy(const Offset(36, 0));
    await tester.pump();
    expect(value, closeTo(.45, .001));
    expect(tester.getCenter(thumb).dx, closeTo(before.dx + 36, .001));
    await gesture.up();
    await tester.pump();
  });

  testWidgets('facade keeps keyboard operation with semantics hidden', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    final semantics = tester.ensureSemantics();
    final changes = <double>[];
    await tester.pumpWidget(
      host(
        SizedBox(
          width: 200,
          child: RemixSlider(
            value: .5,
            onChanged: changes.add,
            excludeSemantics: true,
            focusNode: focus,
            autofocus: true,
            semanticLabel: 'Hidden volume',
          ),
        ),
      ),
    );
    await tester.pump();
    expect(focus.hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(changes, [.501]);
    expect(find.bySemanticsLabel('Hidden volume'), findsNothing);
    semantics.dispose();
  });
}
