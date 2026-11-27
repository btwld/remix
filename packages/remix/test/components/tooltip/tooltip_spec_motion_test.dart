import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _triggerKey = ValueKey('trigger');
const _styleTransitionKey = ValueKey('style-transition');
const _widgetTransitionKey = ValueKey('widget-transition');

final _instant = TooltipStyler()
    .waitDuration(Duration.zero)
    .dismissDuration(Duration.zero);

Widget _styleTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => ScaleTransition(key: _styleTransitionKey, scale: animation, child: child);

Widget _widgetTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) =>
    FadeTransition(key: _widgetTransitionKey, opacity: animation, child: child);

Future<void> _hover(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
  await tester.pump();
}

Widget _tooltip(
  TooltipStyler style, {
  OverlayPositionConfig positioning = const OverlayPositionConfig(),
  Widget Function(BuildContext, Animation<double>, Widget)? transitionBuilder,
  AnimationStyle animationStyle = const AnimationStyle(),
}) {
  return RemixTooltip(
    style: _instant.merge(style),
    positioning: positioning,
    transitionBuilder: transitionBuilder,
    animationStyle: animationStyle,
    tooltipChild: const SizedBox(width: 20, height: 10),
    child: const SizedBox(key: _triggerKey, width: 40, height: 40),
  );
}

Rect _surface(WidgetTester tester) => tester.getRect(
  find.descendant(of: find.byType(RemixTooltip), matching: find.byType(Box)),
);

void main() {
  group('TooltipSpec motion and placement', () {
    testWidgets('a style transitionBuilder replaces the fade', (tester) async {
      await tester.pumpRemixApp(
        _tooltip(TooltipStyler().transitionBuilder(_styleTransition)),
      );
      await _hover(tester);

      expect(find.byKey(_styleTransitionKey), findsOneWidget);
    });

    testWidgets('a widget transitionBuilder wins over the style', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _tooltip(
          TooltipStyler().transitionBuilder(_styleTransition),
          transitionBuilder: _widgetTransition,
        ),
      );
      await _hover(tester);

      expect(find.byKey(_widgetTransitionKey), findsOneWidget);
      expect(find.byKey(_styleTransitionKey), findsNothing);
    });

    testWidgets('widget animationStyle fields override the style per field', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _tooltip(
          TooltipStyler().animationStyle(
            const AnimationStyle(
              curve: Curves.linear,
              duration: Duration(milliseconds: 400),
              reverseDuration: Duration(milliseconds: 200),
            ),
          ),
          animationStyle: const AnimationStyle(
            duration: Duration(milliseconds: 100),
          ),
        ),
      );

      final naked = tester.widget<NakedTooltip>(find.byType(NakedTooltip));
      expect(
        naked.animationStyle,
        const AnimationStyle(
          curve: Curves.linear,
          duration: Duration(milliseconds: 100),
          reverseDuration: Duration(milliseconds: 200),
        ),
      );
    });

    testWidgets('a style animationStyle paces the show', (tester) async {
      await tester.pumpRemixApp(
        _tooltip(
          TooltipStyler().animationStyle(
            const AnimationStyle(
              curve: Curves.linear,
              duration: Duration(milliseconds: 400),
            ),
          ),
        ),
      );
      await _hover(tester);

      final fade = tester.widget<FadeTransition>(
        find.descendant(
          of: find.byType(RemixTooltip),
          matching: find.byType(FadeTransition),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));
      expect(fade.opacity.value, closeTo(0.5, 0.01));
    });

    testWidgets('a style positioning places the tooltip', (tester) async {
      await tester.pumpRemixApp(
        _tooltip(
          TooltipStyler().positioning(
            const OverlayPositionConfig(side: OverlaySide.top, sideOffset: 8),
          ),
        ),
      );
      await _hover(tester);
      await tester.pumpAndSettle();

      final trigger = tester.getRect(find.byKey(_triggerKey));
      expect(_surface(tester).bottom, trigger.top - 8);
    });

    testWidgets('a non-default widget positioning wins over the style', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _tooltip(
          TooltipStyler().positioning(
            const OverlayPositionConfig(side: OverlaySide.top, sideOffset: 8),
          ),
          positioning: const OverlayPositionConfig(sideOffset: 4),
        ),
      );
      await _hover(tester);
      await tester.pumpAndSettle();

      final trigger = tester.getRect(find.byKey(_triggerKey));
      expect(_surface(tester).top, trigger.bottom + 4);
    });

    testWidgets('without style fields the tooltip fades below the trigger', (
      tester,
    ) async {
      await tester.pumpRemixApp(_tooltip(TooltipStyler()));
      await _hover(tester);
      await tester.pumpAndSettle();

      final naked = tester.widget<NakedTooltip>(find.byType(NakedTooltip));
      expect(naked.animationStyle, const AnimationStyle());
      expect(naked.positioning, const OverlayPositionConfig());
      final trigger = tester.getRect(find.byKey(_triggerKey));
      expect(_surface(tester).top, trigger.bottom);
    });
  });
}
