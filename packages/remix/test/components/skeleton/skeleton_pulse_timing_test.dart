import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _base = Color(0xFF000000);
const _pulse = Color(0xFF0000FF);
const _leg = Duration(milliseconds: 1000);

SkeletonStyler _style() => SkeletonStyler()
    .container(BoxStyler().size(40, 10).color(_base))
    .pulseColor(_pulse)
    .duration(_leg);

/// How far the fill has moved from the base color toward the pulse color.
double _progress(WidgetTester tester) {
  final container = tester.widget<Container>(
    find.descendant(
      of: find.byType(RemixSkeleton),
      matching: find.byType(Container),
    ),
  );
  return (container.decoration! as BoxDecoration).color!.b;
}

void main() {
  group('SkeletonSpec pulse timing', () {
    testWidgets('the pulse is linear by default', (tester) async {
      await tester.pumpRemixApp(RemixSkeleton(style: _style()));
      await tester.pump(const Duration(milliseconds: 250));

      expect(_progress(tester), closeTo(.25, .01));
    });

    testWidgets('curve eases each leg', (tester) async {
      await tester.pumpRemixApp(
        RemixSkeleton(style: _style().curve(Curves.easeInOut)),
      );
      await tester.pump(const Duration(milliseconds: 250));
      expect(_progress(tester), closeTo(Curves.easeInOut.transform(.25), .01));

      // On the way back the same curve applies.
      await tester.pump(const Duration(milliseconds: 1000));
      expect(_progress(tester), closeTo(Curves.easeInOut.transform(.75), .01));
    });

    testWidgets('delay rests on the base frame before the first leg', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixSkeleton(style: _style().delay(const Duration(milliseconds: 300))),
      );
      await tester.pump(const Duration(milliseconds: 290));
      expect(_progress(tester), 0);

      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 250));
      expect(_progress(tester), closeTo(.25, .01));
    });

    testWidgets('cycles stops on the base frame after the last pulse', (
      tester,
    ) async {
      await tester.pumpRemixApp(RemixSkeleton(style: _style().cycles(2)));

      // Two pulses take four legs.
      await tester.pump(const Duration(milliseconds: 3500));
      expect(_progress(tester), closeTo(.5, .01));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      expect(_progress(tester), 0);
      expect(tester.hasRunningAnimations, isFalse);

      await tester.pump(const Duration(milliseconds: 500));
      expect(_progress(tester), 0);
    });

    testWidgets(
      'a delayed skeleton disposed before it starts leaves no timer',
      (tester) async {
        await tester.pumpRemixApp(
          RemixSkeleton(style: _style().delay(const Duration(seconds: 1))),
        );
        await tester.pumpRemixApp(const SizedBox());
        await tester.pump(const Duration(seconds: 2));

        expect(tester.takeException(), isNull);
      },
    );
  });
}
