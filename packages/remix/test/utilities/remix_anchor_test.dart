import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_anchor.dart' show RemixAnchorScope;

const _boxKey = ValueKey('anchored-box');

Widget _scoped({
  required double width,
  required BoxStyler style,
  Widget? child,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Align(
      alignment: Alignment.topLeft,
      child: RemixAnchorScope(
        size: Size(width, 40),
        child: Box(key: _boxKey, style: style, child: child),
      ),
    ),
  );
}

void main() {
  group('remixAnchorWidth', () {
    testWidgets('sizes a box through width, minWidth, and maxWidth', (
      tester,
    ) async {
      await tester.pumpWidget(
        _scoped(
          width: 240,
          style: BoxStyler().width(remixAnchorWidth()),
          child: const SizedBox(width: 500, height: 10),
        ),
      );
      expect(tester.getSize(find.byKey(_boxKey)).width, 240);

      await tester.pumpWidget(
        _scoped(
          width: 240,
          style: BoxStyler().minWidth(remixAnchorWidth()),
          child: const SizedBox(width: 10, height: 10),
        ),
      );
      expect(tester.getSize(find.byKey(_boxKey)).width, 240);

      await tester.pumpWidget(
        _scoped(
          width: 240,
          style: BoxStyler().maxWidth(remixAnchorWidth()),
          child: const SizedBox(width: 500, height: 10),
        ),
      );
      expect(tester.getSize(find.byKey(_boxKey)).width, 240);
    });

    testWidgets('resolves to the scope width and to 0 without a scope', (
      tester,
    ) async {
      late double inside;
      late double outside;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            outside = remixAnchorWidth.resolve(context);
            return RemixAnchorScope(
              size: const Size(240, 40),
              child: Builder(
                builder: (context) {
                  inside = remixAnchorWidth.resolve(context);
                  return const SizedBox.shrink();
                },
              ),
            );
          },
        ),
      );

      expect(inside, 240);
      expect(outside, 0);
    });

    testWidgets('rebuilds dependents when the anchor size changes', (
      tester,
    ) async {
      final reader = Builder(
        builder: (context) => Text('${remixAnchorWidth.resolve(context)}'),
      );
      Widget scoped(double width) => Directionality(
        textDirection: TextDirection.ltr,
        child: RemixAnchorScope(size: Size(width, 40), child: reader),
      );

      await tester.pumpWidget(scoped(240));
      expect(find.text('240.0'), findsOneWidget);

      await tester.pumpWidget(scoped(320));
      expect(find.text('320.0'), findsOneWidget);
    });

    test('keeps styles that use it equal across calls', () {
      expect(
        BoxStyler().minWidth(remixAnchorWidth()),
        BoxStyler().minWidth(remixAnchorWidth()),
      );
    });
  });
}
