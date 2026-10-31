import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_reduced_motion.dart'
    show remixReducedMotionOf;

import '../helpers/motion_harness.dart';

void main() {
  group('RemixReducedMotionBuilder', () {
    testWidgets('reports no preference by default', (tester) async {
      bool? reported;
      late BuildContext context;
      await MotionHarness.pump(
        tester,
        RemixReducedMotionBuilder(
          builder: (buildContext, reduceMotion) {
            context = buildContext;
            reported = reduceMotion;

            return const SizedBox();
          },
        ),
      );

      expect(reported, isFalse);
      expect(remixReducedMotionOf(context), isFalse);
    });

    for (final request in MotionRequest.values) {
      testWidgets('reports a ${request.name} request', (tester) async {
        bool? reported;
        late BuildContext context;
        final harness = await MotionHarness.pump(
          tester,
          RemixReducedMotionBuilder(
            builder: (buildContext, reduceMotion) {
              context = buildContext;
              reported = reduceMotion;

              return const SizedBox();
            },
          ),
        );

        await harness.set(request, enabled: true);

        expect(reported, isTrue);
        expect(remixReducedMotionOf(context), isTrue);

        await harness.set(request, enabled: false);

        expect(reported, isFalse);
        expect(remixReducedMotionOf(context), isFalse);
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

            return RemixReducedMotionBuilder(
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

    testWidgets('a MediaQuery override cannot turn the platform request off', (
      tester,
    ) async {
      bool? reported;
      final harness = await MotionHarness.pump(
        tester,
        MediaQuery(
          data: const MediaQueryData(disableAnimations: false),
          child: RemixReducedMotionBuilder(
            builder: (_, reduceMotion) {
              reported = reduceMotion;

              return const SizedBox();
            },
          ),
        ),
      );

      await harness.set(MotionRequest.platform, enabled: true);

      expect(reported, isTrue);
    });

    testWidgets('does not rebuild for unrelated accessibility changes', (
      tester,
    ) async {
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      var builds = 0;
      await MotionHarness.pump(
        tester,
        RemixReducedMotionBuilder(
          builder: (_, _) {
            builds++;

            return const SizedBox();
          },
        ),
      );
      final initialBuilds = builds;

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(boldText: true);
      await tester.pump();

      expect(builds, initialBuilds);

      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(boldText: true, reduceMotion: true);
      await tester.pump();

      expect(builds, initialBuilds + 1);
    });

    testWidgets('stops listening once removed', (tester) async {
      var builds = 0;
      final harness = await MotionHarness.pump(
        tester,
        RemixReducedMotionBuilder(
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
