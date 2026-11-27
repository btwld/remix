import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _childKey = ValueKey('content');

SkeletonStyler _style() => SkeletonStyler()
    .container(BoxStyler().color(const Color(0xFFEEEEEE)))
    .pulseColor(const Color(0xFFCCCCCC));

Widget _skeleton(bool loading, SkeletonStyler style, {VoidCallback? onTap}) {
  return RemixSkeleton(
    loading: loading,
    style: style,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: const SizedBox(key: _childKey, width: 100, height: 20),
    ),
  );
}

double _childOpacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find
          .ancestor(of: find.byKey(_childKey), matching: find.byType(Opacity))
          .first,
    )
    .opacity;

Finder _placeholder() =>
    find.descendant(of: find.byType(RemixSkeleton), matching: find.byType(Box));

double _placeholderOpacity(WidgetTester tester) => tester
    .widget<Opacity>(
      find.ancestor(of: _placeholder(), matching: find.byType(Opacity)).first,
    )
    .opacity;

void main() {
  group('SkeletonSpec reveal', () {
    testWidgets('shows the child at once by default', (tester) async {
      await tester.pumpRemixApp(_skeleton(true, _style()));
      await tester.pumpRemixApp(_skeleton(false, _style()));

      expect(_childOpacity(tester), 1);
      expect(_placeholder(), findsNothing);
    });

    testWidgets('revealDuration crossfades with the child rising into place', (
      tester,
    ) async {
      final style = _style()
          .revealDuration(const Duration(milliseconds: 200))
          .revealCurve(Curves.linear)
          .revealOffset(const Offset(0, 4));
      await tester.pumpRemixApp(_skeleton(true, style));
      final resting = tester.getTopLeft(find.byKey(_childKey));

      await tester.pumpRemixApp(_skeleton(false, style));
      await tester.pump(const Duration(milliseconds: 100));
      expect(_childOpacity(tester), closeTo(.5, .01));
      expect(_placeholderOpacity(tester), closeTo(.5, .01));
      expect(
        tester.getTopLeft(find.byKey(_childKey)).dy,
        closeTo(resting.dy + 2, .01),
      );

      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump();
      expect(_childOpacity(tester), 1);
      expect(_placeholder(), findsNothing);
      expect(tester.getTopLeft(find.byKey(_childKey)), resting);
    });

    testWidgets('the child takes taps while it is revealed', (tester) async {
      var taps = 0;
      final style = _style().revealDuration(const Duration(milliseconds: 200));
      await tester.pumpRemixApp(_skeleton(true, style, onTap: () => taps++));
      await tester.pumpRemixApp(_skeleton(false, style, onTap: () => taps++));
      await tester.pump(const Duration(milliseconds: 50));

      await tester.tap(find.byKey(_childKey));
      expect(taps, 1);
    });

    testWidgets('reduced motion shows the child at once', (tester) async {
      final style = _style().revealDuration(const Duration(milliseconds: 200));
      Widget host(bool loading) => MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: _skeleton(loading, style),
      );
      await tester.pumpRemixApp(host(true));
      await tester.pumpRemixApp(host(false));

      expect(_childOpacity(tester), 1);
      expect(_placeholder(), findsNothing);
    });
  });
}
