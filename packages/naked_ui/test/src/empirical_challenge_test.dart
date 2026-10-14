import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  group('Empirical Challenge Tests for NakedTooltip', () {
    testWidgets(
      'Scenario 1: Trigger focused -> mouse enters -> mouse exits -> tooltip must remain visible',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        const triggerKey = Key('trigger-1');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedTooltip(
              hoverDelay: Duration.zero,
              dismissDelay: Duration.zero,
              animationStyle: AnimationStyle.noAnimation,
              overlayBuilder: (context, animation) =>
                  const Text('Tooltip Content'),
              child: Focus(
                focusNode: focusNode,
                child: const SizedBox(
                  key: triggerKey,
                  width: 100,
                  height: 40,
                  child: Text('Trigger 1'),
                ),
              ),
            ),
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);

        // 1. Focus trigger
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content'),
          findsOneWidget,
          reason: 'Tooltip should be visible when focused',
        );

        // 2. Mouse enters trigger
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKey)));
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content'),
          findsOneWidget,
          reason: 'Tooltip should remain visible on hover',
        );

        // 3. Mouse exits trigger (while focus remains)
        await mouse.moveTo(Offset.zero);
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content'),
          findsOneWidget,
          reason:
              'Tooltip must remain visible after mouse leaves because focus is held',
        );
      },
    );

    testWidgets(
      'Scenario 2: Trigger unfocused -> mouse enters -> mouse exits -> tooltip must dismiss',
      (tester) async {
        const triggerKey = Key('trigger-2');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedTooltip(
              hoverDelay: Duration.zero,
              dismissDelay: Duration.zero,
              animationStyle: AnimationStyle.noAnimation,
              overlayBuilder: (context, animation) =>
                  const Text('Tooltip Content 2'),
              child: const SizedBox(
                key: triggerKey,
                width: 100,
                height: 40,
                child: Text('Trigger 2'),
              ),
            ),
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);

        // Initially not visible
        expect(find.text('Tooltip Content 2'), findsNothing);

        // 1. Mouse enters
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKey)));
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content 2'),
          findsOneWidget,
          reason: 'Tooltip should be visible when hovered',
        );

        // 2. Mouse exits
        await mouse.moveTo(Offset.zero);
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content 2'),
          findsNothing,
          reason: 'Tooltip must dismiss when mouse exits unfocused trigger',
        );
      },
    );

    testWidgets(
      'Scenario 3: Trigger focused -> trigger loses focus -> tooltip must dismiss',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        const triggerKey = Key('trigger-3');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedTooltip(
              hoverDelay: Duration.zero,
              dismissDelay: Duration.zero,
              animationStyle: AnimationStyle.noAnimation,
              overlayBuilder: (context, animation) =>
                  const Text('Tooltip Content 3'),
              child: Focus(
                focusNode: focusNode,
                child: const SizedBox(
                  key: triggerKey,
                  width: 100,
                  height: 40,
                  child: Text('Trigger 3'),
                ),
              ),
            ),
          ),
        );

        // 1. Focus trigger
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content 3'),
          findsOneWidget,
          reason: 'Tooltip should be visible when focused',
        );

        // 2. Unfocus trigger
        focusNode.unfocus();
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip Content 3'),
          findsNothing,
          reason: 'Tooltip must dismiss when focus is lost',
        );
      },
    );

    testWidgets(
      'Scenario 4a: Trigger A hovered (unfocused) -> hover over Trigger B -> Trigger A dismisses, Trigger B shows',
      (tester) async {
        const triggerKeyA = Key('trigger-4a');
        const triggerKeyB = Key('trigger-4b');

        await tester.pumpMaterialWidget(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: const Duration(milliseconds: 500),
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip A'),
                child: const SizedBox(
                  key: triggerKeyA,
                  width: 100,
                  height: 40,
                  child: Text('Trigger A'),
                ),
              ),
              const SizedBox(width: 50),
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: const Duration(milliseconds: 500),
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip B'),
                child: const SizedBox(
                  key: triggerKeyB,
                  width: 100,
                  height: 40,
                  child: Text('Trigger B'),
                ),
              ),
            ],
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);

        // 1. Hover Trigger A
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKeyA)));
        await tester.pumpAndSettle();
        expect(find.text('Tooltip A'), findsOneWidget);
        expect(find.text('Tooltip B'), findsNothing);

        // 2. Move directly to Trigger B before Trigger A's 500ms dismissDelay expires
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKeyB)));
        await tester.pump();

        // Stale non-focus-held Tooltip A should be dismissed immediately by Trigger B onEnter
        expect(
          find.text('Tooltip A'),
          findsNothing,
          reason:
              'Trigger A stale tooltip must be dismissed when entering Trigger B',
        );
        expect(
          find.text('Tooltip B'),
          findsOneWidget,
          reason: 'Trigger B tooltip must be visible',
        );
      },
    );

    testWidgets(
      'Scenario 4b: Trigger A focused -> hover over Trigger B -> Trigger A stays visible (held by focus) while Trigger B shows',
      (tester) async {
        final focusA = FocusNode(debugLabel: 'focusA');
        final focusB = FocusNode(debugLabel: 'focusB');
        addTearDown(focusA.dispose);
        addTearDown(focusB.dispose);

        const triggerKeyA = Key('trigger-4b-a');
        const triggerKeyB = Key('trigger-4b-b');

        await tester.pumpMaterialWidget(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: Duration.zero,
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip A'),
                child: Focus(
                  focusNode: focusA,
                  child: const SizedBox(
                    key: triggerKeyA,
                    width: 100,
                    height: 40,
                    child: Text('Trigger A'),
                  ),
                ),
              ),
              const SizedBox(width: 50),
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: Duration.zero,
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip B'),
                child: Focus(
                  focusNode: focusB,
                  child: const SizedBox(
                    key: triggerKeyB,
                    width: 100,
                    height: 40,
                    child: Text('Trigger B'),
                  ),
                ),
              ),
            ],
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);

        // 1. Trigger A is focused
        focusA.requestFocus();
        await tester.pumpAndSettle();
        expect(
          find.text('Tooltip A'),
          findsOneWidget,
          reason: 'Tooltip A is visible from focus',
        );
        expect(find.text('Tooltip B'), findsNothing);

        // 2. Hover over Trigger B
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKeyB)));
        await tester.pumpAndSettle();

        // Verification: Tooltip A is focus-held, so it is NOT dismissed by _dismissStaleTooltips.
        // Tooltip B is hovered, so it also shows.
        expect(
          find.text('Tooltip A'),
          findsOneWidget,
          reason:
              'Tooltip A remains visible because Trigger A retains keyboard focus',
        );
        expect(
          find.text('Tooltip B'),
          findsOneWidget,
          reason: 'Tooltip B is visible because Trigger B is hovered',
        );

        // 3. Move mouse away from Trigger B
        await mouse.moveTo(Offset.zero);
        await tester.pumpAndSettle();

        expect(
          find.text('Tooltip B'),
          findsNothing,
          reason: 'Tooltip B dismisses when mouse exits',
        );
        expect(
          find.text('Tooltip A'),
          findsOneWidget,
          reason: 'Tooltip A remains visible as long as Trigger A has focus',
        );
      },
    );

    testWidgets(
      'Scenario 4c: Trigger A focused -> Tab to Trigger B -> Focus shifts to B, Tooltip A dismisses after dismissDelay, Tooltip B shows',
      (tester) async {
        final focusA = FocusNode(debugLabel: 'focusA');
        final focusB = FocusNode(debugLabel: 'focusB');
        addTearDown(focusA.dispose);
        addTearDown(focusB.dispose);

        await tester.pumpMaterialWidget(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: const Duration(milliseconds: 100),
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip A'),
                child: Focus(
                  focusNode: focusA,
                  child: const SizedBox(
                    width: 80,
                    height: 40,
                    child: Text('A'),
                  ),
                ),
              ),
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: const Duration(milliseconds: 100),
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip B'),
                child: Focus(
                  focusNode: focusB,
                  child: const SizedBox(
                    width: 80,
                    height: 40,
                    child: Text('B'),
                  ),
                ),
              ),
            ],
          ),
        );

        focusA.requestFocus();
        await tester.pumpAndSettle();
        expect(find.text('Tooltip A'), findsOneWidget);
        expect(find.text('Tooltip B'), findsNothing);

        // Tab to B
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(focusB.hasFocus, isTrue);
        expect(find.text('Tooltip B'), findsOneWidget);

        // Advance past A's dismissDelay
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        expect(
          find.text('Tooltip A'),
          findsNothing,
          reason:
              'Tooltip A must dismiss after losing focus and dismissDelay expiring',
        );
        expect(
          find.text('Tooltip B'),
          findsOneWidget,
          reason: 'Tooltip B remains open while B has focus',
        );
      },
    );

    testWidgets(
      'Scenario 4d: Trigger A focused AND mouse hovering A -> mouse moves directly to Trigger B (unfocused) -> Tooltip A stays open (focus-held), Tooltip B shows',
      (tester) async {
        final focusA = FocusNode(debugLabel: 'focusA');
        addTearDown(focusA.dispose);

        const triggerKeyA = Key('trigger-4d-a');
        const triggerKeyB = Key('trigger-4d-b');

        await tester.pumpMaterialWidget(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: Duration.zero,
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip A'),
                child: Focus(
                  focusNode: focusA,
                  child: const SizedBox(
                    key: triggerKeyA,
                    width: 100,
                    height: 40,
                    child: Text('Trigger A'),
                  ),
                ),
              ),
              const SizedBox(width: 50),
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: Duration.zero,
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tooltip B'),
                child: const SizedBox(
                  key: triggerKeyB,
                  width: 100,
                  height: 40,
                  child: Text('Trigger B'),
                ),
              ),
            ],
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: const Offset(-1000, -1000));
        addTearDown(mouse.removePointer);

        // 1. Focus A
        focusA.requestFocus();
        await tester.pumpAndSettle();
        expect(find.text('Tooltip A'), findsOneWidget);

        // 2. Mouse enters A
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKeyA)));
        await tester.pumpAndSettle();
        expect(find.text('Tooltip A'), findsOneWidget);

        // 3. Move directly from A to B
        await mouse.moveTo(tester.getCenter(find.byKey(triggerKeyB)));
        await tester.pumpAndSettle();

        expect(
          find.text('Tooltip A'),
          findsOneWidget,
          reason:
              'Tooltip A stays open because Trigger A retains keyboard focus',
        );
        expect(
          find.text('Tooltip B'),
          findsOneWidget,
          reason: 'Tooltip B opens on hover',
        );
      },
    );

    testWidgets(
      'Scenario 5: Rapid mouse enter and exit on focused trigger with dismissDelay does not dismiss tooltip',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        const triggerKey = Key('trigger-rapid');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedTooltip(
              hoverDelay: const Duration(milliseconds: 100),
              dismissDelay: const Duration(milliseconds: 200),
              animationStyle: AnimationStyle.noAnimation,
              overlayBuilder: (context, animation) =>
                  const Text('Rapid Tooltip'),
              child: Focus(
                focusNode: focusNode,
                child: const SizedBox(
                  key: triggerKey,
                  width: 100,
                  height: 40,
                  child: Text('Rapid Trigger'),
                ),
              ),
            ),
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);

        focusNode.requestFocus();
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();
        expect(find.text('Rapid Tooltip'), findsOneWidget);

        // Rapid jitter: enter and exit in rapid succession
        for (var i = 0; i < 5; i++) {
          await mouse.moveTo(tester.getCenter(find.byKey(triggerKey)));
          await tester.pump(const Duration(milliseconds: 10));
          await mouse.moveTo(Offset.zero);
          await tester.pump(const Duration(milliseconds: 10));
        }
        await tester.pumpAndSettle();

        expect(
          find.text('Rapid Tooltip'),
          findsOneWidget,
          reason:
              'Focused tooltip must survive rapid mouse jitter across trigger boundaries',
        );
      },
    );

    testWidgets(
      'Scenario 6: Escape key while focused closes tooltip without losing trigger focus',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        const triggerKey = Key('trigger-escape');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedTooltip(
              hoverDelay: Duration.zero,
              dismissDelay: Duration.zero,
              animationStyle: AnimationStyle.noAnimation,
              overlayBuilder: (context, animation) =>
                  const Text('Escape Tooltip'),
              child: Focus(
                focusNode: focusNode,
                child: const SizedBox(
                  key: triggerKey,
                  width: 100,
                  height: 40,
                  child: Text('Escape Trigger'),
                ),
              ),
            ),
          ),
        );

        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(find.text('Escape Tooltip'), findsOneWidget);
        expect(focusNode.hasFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(
          find.text('Escape Tooltip'),
          findsNothing,
          reason: 'Escape must close the tooltip',
        );
        expect(
          focusNode.hasFocus,
          isTrue,
          reason:
              'Focus must remain on the trigger after closing tooltip with Escape',
        );
      },
    );

    testWidgets(
      'Scenario 7: Hovering trigger, then focusing another widget: tooltip dismisses',
      (tester) async {
        final otherFocus = FocusNode();
        addTearDown(otherFocus.dispose);

        const triggerKey = Key('trigger-hover-blur');
        await tester.pumpMaterialWidget(
          Column(
            children: [
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: Duration.zero,
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) =>
                    const Text('Hovered Tooltip'),
                child: const SizedBox(
                  key: triggerKey,
                  width: 100,
                  height: 40,
                  child: Text('Hover Trigger'),
                ),
              ),
              Focus(
                focusNode: otherFocus,
                child: const SizedBox(
                  width: 100,
                  height: 40,
                  child: Text('Other'),
                ),
              ),
            ],
          ),
        );

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);

        await mouse.moveTo(tester.getCenter(find.byKey(triggerKey)));
        await tester.pumpAndSettle();
        expect(find.text('Hovered Tooltip'), findsOneWidget);

        // Move mouse away outside viewport
        await mouse.moveTo(const Offset(-1000, -1000));
        otherFocus.requestFocus();
        await tester.pumpAndSettle();

        expect(find.text('Hovered Tooltip'), findsNothing);
      },
    );
  });
}
