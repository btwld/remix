import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/motion_harness.dart';

void main() {
  group('RemixReducedMotion', () {
    testWidgets('reports no preference by default', (tester) async {
      bool? reported;
      late BuildContext context;
      await MotionHarness.pump(
        tester,
        RemixReducedMotion(
          builder: (buildContext, reduceMotion) {
            context = buildContext;
            reported = reduceMotion;

            return const SizedBox();
          },
        ),
      );

      expect(reported, isFalse);
      expect(RemixReducedMotion.of(context), isFalse);
    });

    for (final request in MotionRequest.values) {
      testWidgets('reports a ${request.name} request', (tester) async {
        bool? reported;
        late BuildContext context;
        final harness = await MotionHarness.pump(
          tester,
          RemixReducedMotion(
            builder: (buildContext, reduceMotion) {
              context = buildContext;
              reported = reduceMotion;

              return const SizedBox();
            },
          ),
        );

        await harness.set(request, enabled: true);

        expect(reported, isTrue);
        expect(RemixReducedMotion.of(context), isTrue);

        await harness.set(request, enabled: false);

        expect(reported, isFalse);
        expect(RemixReducedMotion.of(context), isFalse);
      });
    }

    testWidgets('platform reduceMotion does not set MediaQuery', (
      tester,
    ) async {
      bool? mediaQueryDisabled;
      bool? reported;
      final harness = await MotionHarness.pump(
        tester,
        Builder(
          builder: (context) {
            mediaQueryDisabled = MediaQuery.disableAnimationsOf(context);

            return RemixReducedMotion(
              builder: (_, reduceMotion) {
                reported = reduceMotion;

                return const SizedBox();
              },
            );
          },
        ),
      );

      await harness.set(MotionRequest.platform, enabled: true);

      expect(mediaQueryDisabled, isFalse);
      expect(reported, isTrue);
    });

    testWidgets('stops listening once removed', (tester) async {
      var builds = 0;
      final harness = await MotionHarness.pump(
        tester,
        RemixReducedMotion(
          builder: (_, _) {
            builds++;

            return const SizedBox();
          },
        ),
      );
      await tester.pumpWidget(const SizedBox());
      final buildsWhenRemoved = builds;

      await harness.set(MotionRequest.platform, enabled: true);

      expect(builds, buildsWhenRemoved);
      expect(tester.takeException(), isNull);
    });
  });
}
