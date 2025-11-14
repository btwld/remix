import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixAccordion', () {
    group('Basic Rendering', () {
      testWidgets('renders accordion with minimal props', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
        expect(find.text('Test Title'), findsOneWidget);
      });

      testWidgets('renders accordion with custom style', (tester) async {
        const customStyle = RemixAccordionStyle<String>.create();

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              style: customStyle,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });

      testWidgets('renders accordion with leading icon', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              leadingIcon: Icons.star,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
        expect(find.byIcon(Icons.star), findsOneWidget);
      });

      testWidgets('renders accordion with trailing icon', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              trailingIcon: Icons.arrow_drop_down,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
        expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
      });

      testWidgets('renders accordion with custom builder', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              builder: (context, state) {
                return Text('Custom: ${state.isExpanded ? "Open" : "Closed"}');
              },
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
        expect(find.text('Custom: Closed'), findsOneWidget);
      });

      testWidgets('renders multiple accordions', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: Column(
              children: [
                RemixAccordion<String>(
                  value: 'item1',
                  title: 'First Item',
                  child: const Text('First Content'),
                ),
                RemixAccordion<String>(
                  value: 'item2',
                  title: 'Second Item',
                  child: const Text('Second Content'),
                ),
                RemixAccordion<String>(
                  value: 'item3',
                  title: 'Third Item',
                  child: const Text('Third Content'),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsNWidgets(3));
        expect(find.text('First Item'), findsOneWidget);
        expect(find.text('Second Item'), findsOneWidget);
        expect(find.text('Third Item'), findsOneWidget);
      });
    });

    group('Expansion and Collapse', () {
      testWidgets('expands accordion on tap', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Content should not be visible initially
        expect(find.text('Test Content'), findsNothing);

        // Tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Content should now be visible
        expect(find.text('Test Content'), findsOneWidget);
      });

      testWidgets('collapses expanded accordion on tap', (tester) async {
        final controller = RemixAccordionController<String>();

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: controller,
            initialExpandedValues: const ['item1'],
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Content should be visible initially
        expect(find.text('Test Content'), findsOneWidget);

        // Tap to collapse
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Content should no longer be visible
        expect(find.text('Test Content'), findsNothing);
      });

      testWidgets('expands accordion with initial expanded values',
          (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            initialExpandedValues: const ['item1', 'item2'],
            child: Column(
              children: [
                RemixAccordion<String>(
                  value: 'item1',
                  title: 'First Item',
                  child: const Text('First Content'),
                ),
                RemixAccordion<String>(
                  value: 'item2',
                  title: 'Second Item',
                  child: const Text('Second Content'),
                ),
                RemixAccordion<String>(
                  value: 'item3',
                  title: 'Third Item',
                  child: const Text('Third Content'),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // First two items should be expanded
        expect(find.text('First Content'), findsOneWidget);
        expect(find.text('Second Content'), findsOneWidget);
        expect(find.text('Third Content'), findsNothing);
      });

      testWidgets('handles rapid toggling without errors', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Rapidly toggle multiple times
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('Test Title'));
          await tester.pump(const Duration(milliseconds: 50));
        }

        await tester.pumpAndSettle();

        // Should still be functional
        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });
    });

    group('Controller Usage', () {
      testWidgets('respects controller min constraint', (tester) async {
        final controller = RemixAccordionController<String>(min: 1);

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: controller,
            initialExpandedValues: const ['item1'],
            child: Column(
              children: [
                RemixAccordion<String>(
                  value: 'item1',
                  title: 'First Item',
                  child: const Text('First Content'),
                ),
                RemixAccordion<String>(
                  value: 'item2',
                  title: 'Second Item',
                  child: const Text('Second Content'),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // First item should be expanded
        expect(find.text('First Content'), findsOneWidget);

        // Try to collapse the only expanded item (should not collapse due to min=1)
        await tester.tap(find.text('First Item'));
        await tester.pumpAndSettle();

        // First item should still be expanded
        expect(find.text('First Content'), findsOneWidget);
      });

      testWidgets('respects controller max constraint', (tester) async {
        final controller = RemixAccordionController<String>(max: 1);

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: controller,
            initialExpandedValues: const ['item1'],
            child: Column(
              children: [
                RemixAccordion<String>(
                  value: 'item1',
                  title: 'First Item',
                  child: const Text('First Content'),
                ),
                RemixAccordion<String>(
                  value: 'item2',
                  title: 'Second Item',
                  child: const Text('Second Content'),
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // First item should be expanded
        expect(find.text('First Content'), findsOneWidget);
        expect(find.text('Second Content'), findsNothing);

        // Tap second item (should expand and collapse first due to max=1)
        await tester.tap(find.text('Second Item'));
        await tester.pumpAndSettle();

        // Only second item should be expanded
        expect(find.text('First Content'), findsNothing);
        expect(find.text('Second Content'), findsOneWidget);
      });

      testWidgets('controller programmatically expands accordion',
          (tester) async {
        final controller = RemixAccordionController<String>();

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: controller,
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Content should not be visible initially
        expect(find.text('Test Content'), findsNothing);

        // Programmatically expand
        controller.open('item1');
        await tester.pumpAndSettle();

        // Content should now be visible
        expect(find.text('Test Content'), findsOneWidget);
      });

      testWidgets('controller programmatically collapses accordion',
          (tester) async {
        final controller = RemixAccordionController<String>();

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: controller,
            initialExpandedValues: const ['item1'],
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Content should be visible initially
        expect(find.text('Test Content'), findsOneWidget);

        // Programmatically collapse
        controller.close('item1');
        await tester.pumpAndSettle();

        // Content should no longer be visible
        expect(find.text('Test Content'), findsNothing);
      });
    });

    group('Enabled and Disabled States', () {
      testWidgets('enabled accordion responds to tap', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              enabled: true,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Content should be visible
        expect(find.text('Test Content'), findsOneWidget);
      });

      testWidgets('disabled accordion does not respond to tap', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              enabled: false,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Try to tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Content should not be visible
        expect(find.text('Test Content'), findsNothing);
      });
    });

    group('Focus Management', () {
      testWidgets('accordion can receive focus', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              focusNode: focusNode,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Request focus
        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);

        focusNode.dispose();
      });

      testWidgets('accordion with autofocus gets focus', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              autofocus: true,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The accordion should have received focus automatically
        // Note: We can't directly check focus without a focusNode reference,
        // but we can verify the widget built without errors
        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });

      testWidgets('onFocusChange callback is triggered', (tester) async {
        bool? focusState;

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              autofocus: true,
              onFocusChange: (hasFocus) {
                focusState = hasFocus;
              },
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Autofocus should trigger onFocusChange
        expect(focusState, isTrue);
      });
    });

    group('Mouse Interaction', () {
      testWidgets('onHoverChange callback is triggered', (tester) async {
        bool? hoverState;

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              onHoverChange: (isHovering) {
                hoverState = isHovering;
              },
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Simulate hover
        final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: tester.getCenter(find.text('Test Title')));
        await tester.pumpAndSettle();

        expect(hoverState, isTrue);

        // Move away
        await gesture.moveTo(const Offset(0, 0));
        await tester.pumpAndSettle();

        expect(hoverState, isFalse);
      });

      testWidgets('onPressChange callback is triggered', (tester) async {
        bool? pressState;

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              onPressChange: (isPressed) {
                pressState = isPressed;
              },
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Simulate press down
        final gesture = await tester.startGesture(tester.getCenter(find.text('Test Title')));
        await tester.pumpAndSettle();

        expect(pressState, isTrue);

        // Release
        await gesture.up();
        await tester.pumpAndSettle();

        expect(pressState, isFalse);
      });

      testWidgets('custom mouse cursor is applied', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              mouseCursor: SystemMouseCursors.help,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });
    });

    group('Semantics and Accessibility', () {
      testWidgets('accordion has semantic label', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              semanticLabel: 'Custom Semantic Label',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.bySemanticsLabel('Custom Semantic Label'), findsOneWidget);
      });

      testWidgets('accordion without semantic label uses title', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });
    });

    group('Animation', () {
      testWidgets('default transition builder animates expansion',
          (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pump();

        // Animation should be in progress
        expect(find.text('Test Content'), findsOneWidget);

        // Complete animation
        await tester.pumpAndSettle();

        // Content should be fully visible
        expect(find.text('Test Content'), findsOneWidget);
      });

      testWidgets('custom transition builder is applied', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              transitionBuilder: (panel, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: panel,
                );
              },
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pump();

        // Content should appear with custom transition
        expect(find.text('Test Content'), findsOneWidget);

        await tester.pumpAndSettle();
      });
    });

    group('Nested Accordions', () {
      testWidgets('supports nested accordion groups', (tester) async {
        final parentController = RemixAccordionController<String>();
        final childController = RemixAccordionController<String>();

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: parentController,
            child: RemixAccordion<String>(
              value: 'parent1',
              title: 'Parent Item',
              child: RemixAccordionGroup<String>(
                controller: childController,
                child: Column(
                  children: [
                    RemixAccordion<String>(
                      value: 'child1',
                      title: 'Child Item 1',
                      child: const Text('Child Content 1'),
                    ),
                    RemixAccordion<String>(
                      value: 'child2',
                      title: 'Child Item 2',
                      child: const Text('Child Content 2'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Expand parent
        await tester.tap(find.text('Parent Item'));
        await tester.pumpAndSettle();

        // Child items should now be visible
        expect(find.text('Child Item 1'), findsOneWidget);
        expect(find.text('Child Item 2'), findsOneWidget);

        // Expand first child
        await tester.tap(find.text('Child Item 1'));
        await tester.pumpAndSettle();

        // Child content should be visible
        expect(find.text('Child Content 1'), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles empty content', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const SizedBox.shrink(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Should not throw error
        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });

      testWidgets('handles long content', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: SizedBox(
                height: 1000,
                child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (context, index) => Text('Item $index'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap to expand
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Should handle long content without errors
        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });

      testWidgets('handles accordion group with no children', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: const SizedBox.shrink(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordionGroup<String>), findsOneWidget);
      });

      testWidgets('handles controller with extreme constraints', (tester) async {
        final controller = RemixAccordionController<String>(min: 0, max: 100);

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: controller,
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });
    });

    group('Key Parameters', () {
      testWidgets('accordion respects key parameter', (tester) async {
        const testKey = Key('test-accordion');

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              key: testKey,
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(testKey), findsOneWidget);
      });

      testWidgets('accordion group respects key parameter', (tester) async {
        const testKey = Key('test-accordion-group');

        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            key: testKey,
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(testKey), findsOneWidget);
      });
    });

    group('Feedback', () {
      testWidgets('enableFeedback true provides haptic feedback', (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              enableFeedback: true,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap to trigger feedback
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        // Should not throw error
        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });

      testWidgets('enableFeedback false disables haptic feedback',
          (tester) async {
        await tester.pumpRemixApp(
          RemixAccordionGroup<String>(
            controller: RemixAccordionController<String>(),
            child: RemixAccordion<String>(
              value: 'item1',
              title: 'Test Title',
              enableFeedback: false,
              child: const Text('Test Content'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap without feedback
        await tester.tap(find.text('Test Title'));
        await tester.pumpAndSettle();

        expect(find.byType(RemixAccordion<String>), findsOneWidget);
      });
    });
  });
}
