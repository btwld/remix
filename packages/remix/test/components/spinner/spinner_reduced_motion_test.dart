import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';

/// How far the spinner has turned, as the painter sees it.
double _phase(WidgetTester tester) {
  final painter = tester
      .widget<CustomPaint>(
        find.descendant(
          of: find.byType(RemixSpinner),
          matching: find.byType(CustomPaint),
        ),
      )
      .painter;

  return switch (painter) {
    RemixSpinnerPainter(:final animation) => animation.value,
    RemixLeafSpinnerPainter(:final animation) => animation.value,
    _ => throw StateError('Unexpected spinner painter $painter'),
  };
}

void main() {
  group('RemixSpinner reduced motion', () {
    testWidgets('turns by default', (tester) async {
      await MotionHarness.pump(tester, const RemixSpinner());

      await tester.pump(const Duration(milliseconds: 100));

      expect(_phase(tester), greaterThan(0));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
    });

    for (final request in MotionRequest.values) {
      testWidgets('keeps essential motion on a ${request.name} request', (
        tester,
      ) async {
        final harness = await MotionHarness.pump(tester, const RemixSpinner());
        await tester.pump(const Duration(milliseconds: 100));
        final initial = _phase(tester);

        await harness.set(request, enabled: true);
        await tester.pump(const Duration(milliseconds: 100));
        final reduced = _phase(tester);
        expect(reduced, greaterThan(initial));
        expect(tester.binding.transientCallbackCount, greaterThan(0));

        await harness.set(request, enabled: false);
        await tester.pump(const Duration(milliseconds: 100));
        expect(_phase(tester), greaterThan(reduced));
      });
    }

    testWidgets('builds and turns without a MediaQuery ancestor', (
      tester,
    ) async {
      await tester.pumpWidget(
        RawView(
          view: tester.view,
          child: MixScope.empty(
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: RemixSpinner(),
            ),
          ),
        ),
        wrapWithView: false,
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(MediaQuery), findsNothing);
      expect(tester.takeException(), isNull);
      expect(_phase(tester), greaterThan(0));
    });

    testWidgets(
      'keeps turning when its duration changes under reduced motion',
      (tester) async {
        final duration = ValueNotifier(const Duration(seconds: 1));
        addTearDown(duration.dispose);
        final harness = await MotionHarness.pump(
          tester,
          ValueListenableBuilder<Duration>(
            valueListenable: duration,
            builder: (_, value, _) =>
                RemixSpinner(style: SpinnerStyler(duration: value)),
          ),
        );
        await harness.set(MotionRequest.platform, enabled: true);

        duration.value = const Duration(milliseconds: 500);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        expect(_phase(tester), greaterThan(0));
        expect(tester.binding.transientCallbackCount, greaterThan(0));
      },
    );

    testWidgets('keeps essential motion for the leaf spinner too', (
      tester,
    ) async {
      final harness = await MotionHarness.pump(
        tester,
        RemixSpinner(style: SpinnerStyler(opacity: 0.65)),
      );
      await harness.set(MotionRequest.platform, enabled: true);

      await tester.pump(const Duration(milliseconds: 100));

      expect(_phase(tester), greaterThan(0));
      expect(tester.binding.transientCallbackCount, greaterThan(0));
    });
  });
}
