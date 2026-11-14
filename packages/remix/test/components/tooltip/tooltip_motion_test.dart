import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _triggerKey = ValueKey('trigger');
const _transitionKey = ValueKey('transition');

// Opens at once on hover and closes at once on exit, so only the show and
// hide animations take time.
final _instant = TooltipStyler()
    .waitDuration(Duration.zero)
    .dismissDuration(Duration.zero);

Widget _tooltip({
  Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder,
  AnimationStyle animationStyle = const AnimationStyle(),
  OverlaySide side = OverlaySide.top,
}) {
  return RemixTooltip(
    style: _instant,
    transitionBuilder: transitionBuilder,
    animationStyle: animationStyle,
    positioning: OverlayPositionConfig(side: side),
    tooltipChild: const Text('tip'),
    child: const SizedBox(key: _triggerKey, width: 40, height: 40),
  );
}

Future<TestGesture> _hover(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
  // The first frame starts the show animation.
  await tester.pump();

  return mouse;
}

/// The fade Remix draws around the tooltip surface, if any.
Finder _surfaceFade() => find.descendant(
  of: find.byType(RemixTooltip),
  matching: find.byType(FadeTransition),
);

void main() {
  group('RemixTooltip motion', () {
    testWidgets('fades the surface at Naked UI pace by default', (
      tester,
    ) async {
      await tester.pumpRemixApp(_tooltip());
      await _hover(tester);

      expect(_surfaceFade(), findsOneWidget);
      final fade = tester.widget<FadeTransition>(_surfaceFade());
      // Naked UI shows in 150ms.
      await tester.pump(const Duration(milliseconds: 100));
      expect(fade.opacity.value, inExclusiveRange(0, 1));
      await tester.pump(const Duration(milliseconds: 60));
      expect(fade.opacity.value, 1);
      expect(
        find.descendant(of: _surfaceFade(), matching: find.text('tip')),
        findsOneWidget,
      );
    });

    testWidgets('animationStyle paces showing and hiding', (tester) async {
      const style = AnimationStyle(
        curve: Curves.linear,
        duration: Duration(milliseconds: 400),
        reverseDuration: Duration(milliseconds: 200),
      );
      await tester.pumpRemixApp(_tooltip(animationStyle: style));

      final naked = tester.widget<NakedTooltip>(find.byType(NakedTooltip));
      expect(naked.animationStyle, style);

      final mouse = await _hover(tester);
      final fade = tester.widget<FadeTransition>(_surfaceFade());
      await tester.pump(const Duration(milliseconds: 200));
      expect(fade.opacity.value, closeTo(0.5, 0.01));
      await tester.pump(const Duration(milliseconds: 200));
      expect(fade.opacity.value, 1);

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(fade.opacity.value, closeTo(0.5, 0.01));
      await tester.pump(const Duration(milliseconds: 101));
      expect(find.text('tip'), findsNothing);
    });

    testWidgets('transitionBuilder replaces the fade around the surface', (
      tester,
    ) async {
      Animation<double>? animation;
      OverlayPlacement? placement;
      await tester.pumpRemixApp(
        _tooltip(
          side: OverlaySide.bottom,
          transitionBuilder: (context, value, child) {
            animation = value;
            placement = OverlayPlacement.of(context);
            return ScaleTransition(
              key: _transitionKey,
              scale: value,
              child: child,
            );
          },
        ),
      );

      final mouse = await _hover(tester);
      expect(animation!.status, AnimationStatus.forward);
      await tester.pumpAndSettle();

      expect(animation!.value, 1);
      expect(placement!.side, OverlaySide.bottom);
      expect(_surfaceFade(), findsNothing);
      // The builder wraps the whole styled surface, not just the label.
      expect(
        find.descendant(
          of: find.byKey(_transitionKey),
          matching: find.ancestor(
            of: find.text('tip'),
            matching: find.byType(Box),
          ),
        ),
        findsOneWidget,
      );

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      expect(animation!.status, AnimationStatus.reverse);
      await tester.pumpAndSettle();
      expect(find.text('tip'), findsNothing);
    });

    testWidgets('transitionBuilder sees a finished animation under reduced '
        'motion', (tester) async {
      Animation<double>? animation;
      await tester.pumpRemixApp(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: _tooltip(
            animationStyle: const AnimationStyle(
              duration: Duration(seconds: 1),
            ),
            transitionBuilder: (context, value, child) {
              animation = value;
              return child;
            },
          ),
        ),
      );

      await _hover(tester);
      await tester.pump();

      expect(animation!.value, 1);
      expect(find.text('tip'), findsOneWidget);
    });

    test('TooltipStyler.call forwards the motion parameters', () {
      Widget builder(
        BuildContext context,
        Animation<double> animation,
        Widget child,
      ) => child;
      const style = AnimationStyle(duration: Duration(milliseconds: 180));

      final tooltip = TooltipStyler()(
        transitionBuilder: builder,
        animationStyle: style,
        tooltipChild: const Text('tip'),
        child: const Text('target'),
      );

      expect(tooltip.transitionBuilder, builder);
      expect(tooltip.animationStyle, style);
    });

    test('defaults to the fade builder', () {
      const tooltip = RemixTooltip(
        tooltipChild: Text('tip'),
        child: Text('target'),
      );

      expect(
        tooltip.transitionBuilder,
        RemixTooltip.defaultTooltipTransitionBuilder,
      );
    });
  });
}
