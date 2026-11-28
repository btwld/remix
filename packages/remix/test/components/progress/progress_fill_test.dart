import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

ProgressStyler _style([RemixProgressFill? fill]) {
  final style = ProgressStyler()
      .width(200)
      .height(8)
      .indicatorColor(Colors.blue);
  return fill == null ? style : style.indicatorFill(fill);
}

/// The container, track, indicator, and track container boxes, in order.
Rect _rect(WidgetTester tester, int index) => tester.getRect(
  find.byWidget(tester.widgetList<Box>(find.byType(Box)).elementAt(index)),
);

void main() {
  group('ProgressSpec.indicatorFill', () {
    testWidgets('shrink, the default, sizes the indicator to the value', (
      tester,
    ) async {
      await tester.pumpRemixApp(RemixProgress(value: .25, style: _style()));

      final track = _rect(tester, 1);
      final indicator = _rect(tester, 2);
      expect(indicator.left, track.left);
      expect(indicator.width, 50);
      expect(
        find.descendant(
          of: find.byType(RemixProgress),
          matching: find.byType(FractionalTranslation),
        ),
        findsNothing,
      );
    });

    testWidgets('slide keeps the full width and shows the value share', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixProgress(value: .25, style: _style(.slide)),
      );

      final track = _rect(tester, 1);
      final indicator = _rect(tester, 2);
      expect(indicator.width, 200);
      expect(indicator.right, track.left + 50);
      expect(
        tester.getRect(
          find.descendant(
            of: find.byType(RemixProgress),
            matching: find.byType(ClipRect),
          ),
        ),
        track,
      );
    });

    testWidgets('slide enters from the right in right-to-left text', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixProgress(value: .25, style: _style(.slide)),
        textDirection: TextDirection.rtl,
      );

      final track = _rect(tester, 1);
      final indicator = _rect(tester, 2);
      expect(indicator.width, 200);
      expect(indicator.left, track.right - 50);
    });

    testWidgets('slide at the full value covers the track', (tester) async {
      await tester.pumpRemixApp(RemixProgress(value: 1, style: _style(.slide)));

      expect(_rect(tester, 2), _rect(tester, 1));
    });
  });
}
