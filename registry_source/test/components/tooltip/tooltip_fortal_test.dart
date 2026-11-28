import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('the bubble is 13px page-colored text on ink, 240px at most', (
    tester,
  ) async {
    late TooltipSpec spec;
    late Color ink, page;
    await tester.pumpRemixApp(
      Builder(
        builder: (context) {
          spec = fortalTooltipStyle().build(context).spec;
          ink = FortalTokens.gray12.resolve(context);
          page = FortalTokens.gray1.resolve(context);
          return const SizedBox.shrink();
        },
      ),
    );

    final box = spec.container.spec;
    final decoration = box.decoration! as BoxDecoration;
    expect(box.constraints, const BoxConstraints(maxWidth: 240));
    expect(
      box.padding,
      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
    expect(decoration.color, ink);
    expect(decoration.borderRadius, BorderRadius.circular(14));
    expect((decoration.border! as Border).top.color, isNot(ink));
    expect(spec.label.spec.style!.fontSize, 13);
    expect(spec.label.spec.style!.color, page);
    expect(contrastRatio(page, ink), greaterThanOrEqualTo(4.5));
    expect(spec.waitDuration, const Duration(milliseconds: 250));
    expect(
      spec.positioning,
      const OverlayPositionConfig(
        side: .top,
        alignment: .center,
        sideOffset: 8,
        collisionPadding: EdgeInsets.all(12),
      ),
    );
    expect(spec.animationStyle!.duration, FortalMotion.fast);
    expect(spec.animationStyle!.reverseDuration, FortalMotion.instant);
  });

  group('motion', () {
    Future<
      ({
        AnimationController controller,
        double Function() opacity,
        Offset Function() offset,
      })
    >
    pump(WidgetTester tester, {bool reduceMotion = false}) async {
      final controller = AnimationController(
        vsync: const TestVSync(),
        duration: FortalMotion.fast,
      );
      addTearDown(controller.dispose);
      late TooltipSpec spec;
      await tester.pumpRemixApp(
        MediaQuery(
          data: MediaQueryData(disableAnimations: reduceMotion),
          child: Builder(
            builder: (context) {
              spec = fortalTooltipStyle().build(context).spec;
              return spec.transitionBuilder!(
                context,
                controller,
                const SizedBox(width: 100, height: 40, child: Text('Tip')),
              );
            },
          ),
        ),
      );
      final box = find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == 100,
      );
      // At 0 the bubble sits 3px below its place.
      final place = tester.getCenter(box) - const Offset(0, 3);
      return (
        controller: controller,
        opacity: () => tester
            .widget<Opacity>(
              find.ancestor(of: box, matching: find.byType(Opacity)).first,
            )
            .opacity,
        offset: () => tester.getCenter(box) - place,
      );
    }

    testWidgets('rises 3px and grows from 97% while it fades in', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final motion = await pump(tester);
      expect(motion.opacity(), 0);
      expect(find.bySemanticsLabel('Tip'), findsOneWidget);
      semantics.dispose();

      motion.controller.value = .5;
      motion.controller.forward(from: .5);
      await tester.pump();
      final p = FortalMotion.easeEnter.transform(.5);
      expect(motion.opacity(), closeTo(p, .01));
      expect(motion.offset().dy, closeTo(3 * (1 - p), .01));
      await tester.pumpAndSettle();
      expect(motion.offset(), Offset.zero);
    });

    testWidgets('fades out over its 100ms reverse to 98%', (tester) async {
      final motion = await pump(tester);
      motion.controller.value = 1;
      motion.controller.reverse();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 75));
      final t = motion.controller.value;
      final p = FortalMotion.easeStandard.transform(1 - t);
      expect(motion.opacity(), closeTo(1 - p, .01));
      expect(motion.offset(), Offset.zero, reason: 'it leaves in place');
      await tester.pumpAndSettle();
    });

    testWidgets('only fades under reduced motion', (tester) async {
      final motion = await pump(tester, reduceMotion: true);
      motion.controller.value = .5;
      await tester.pump();
      expect(motion.opacity(), .5);
    });
  });
}
