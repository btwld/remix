import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixButton Basic Tests', () {
    testWidgets(
      'Button renders correctly with label and icon',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('test_button'),
            label: 'Test Button',
            onPressed: () {
              // Button tap handler
            },
            leading: Icons.star,
          ),
        );

        // Verify button is rendered
        expect(find.byKey(const ValueKey('test_button')), findsOneWidget);

        // Verify label is displayed
        expect(find.text('Test Button'), findsOneWidget);

        // Verify icon is displayed
        expect(find.byIcon(Icons.star), findsOneWidget);
      },
    );

    testWidgets(
      'Button responds to tap when enabled',
      (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('tap_button'),
            label: 'Tap Me',
            onPressed: () {
              wasPressed = true;
            },
          ),
        );

        // Tap the button
        await tester.tap(find.byKey(const ValueKey('tap_button')));
        await tester.pumpAndSettle();

        // Verify callback was triggered
        expect(wasPressed, isTrue);
      },
    );

    testWidgets(
      'Button does not respond to tap when disabled',
      (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('disabled_button'),
            label: 'Disabled Button',
            onPressed: () {
              wasPressed = true;
            },
            enabled: false,
          ),
        );

        // Try to tap the disabled button
        await tester.tap(find.byKey(const ValueKey('disabled_button')));
        await tester.pumpAndSettle();

        // Verify callback was not triggered
        expect(wasPressed, isFalse);
      },
    );

    testWidgets(
      'Button shows loading state correctly',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('loading_button'),
            label: 'Loading Button',
            onPressed: () {
              // Loading button handler
            },
            loading: true,
          ),
        );

        // Verify button is rendered
        expect(find.byKey(const ValueKey('loading_button')), findsOneWidget);

        // Verify loading indicator is shown
        expect(find.byType(RemixSpinner), findsOneWidget);

        // Verify label is still shown when loading
        expect(find.text('Loading Button'), findsOneWidget);
      },
    );

    testWidgets(
      'Button state transitions work correctly',
      (WidgetTester tester) async {
        bool isLoading = false;
        bool isEnabled = true;
        int tapCount = 0;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixButton(
                    key: const ValueKey('state_button'),
                    label: 'State Button',
                    enabled: isEnabled,
                    loading: isLoading,
                    onPressed: () {
                      setState(() {
                        tapCount++;
                        isLoading = !isLoading;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RemixButton(
                    key: const ValueKey('toggle_button'),
                    label: 'Toggle Enabled',
                    onPressed: () {
                      setState(() {
                        isEnabled = !isEnabled;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        );

        // Initially button should be enabled and not loading
        expect(find.byKey(const ValueKey('state_button')), findsOneWidget);
        expect(find.byType(RemixSpinner), findsNothing);

        // Tap to start loading
        await tester.tap(find.byKey(const ValueKey('state_button')));
        await tester.pump();
        expect(find.byType(RemixSpinner), findsOneWidget);
        expect(tapCount, equals(1));

        // Toggle enabled state to false
        await tester.tap(find.byKey(const ValueKey('toggle_button')));
        await tester.pump();

        // Try to tap disabled button (should not increment tap count)
        await tester.tap(find.byKey(const ValueKey('state_button')));
        await tester.pump();
        expect(tapCount, equals(1)); // Should still be 1 (button is disabled)
      },
    );

    testWidgets(
      'Button handles rapid taps correctly',
      (WidgetTester tester) async {
        int tapCount = 0;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('rapid_tap_button'),
            label: 'Rapid Tap',
            onPressed: () {
              tapCount++;
            },
          ),
        );

        // Perform rapid taps
        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byKey(const ValueKey('rapid_tap_button')));
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        // Verify all taps were registered
        expect(tapCount, equals(5));
      },
    );

    testWidgets(
      'Button works in different orientations',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('orientation_button'),
            label: 'Orientation Test',
            onPressed: () {
              // Orientation test handler
            },
            leading: Icons.screen_rotation,
          ),
        );

        // Test in portrait
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpAndSettle();
        expect(
            find.byKey(const ValueKey('orientation_button')), findsOneWidget);
        expect(find.text('Orientation Test'), findsOneWidget);

        // Test in landscape
        await tester.binding.setSurfaceSize(const Size(800, 400));
        await tester.pumpAndSettle();
        expect(
            find.byKey(const ValueKey('orientation_button')), findsOneWidget);
        expect(find.text('Orientation Test'), findsOneWidget);
        expect(find.byIcon(Icons.screen_rotation), findsOneWidget);
      },
    );

    testWidgets(
      'Button accessibility test',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          Semantics(
            button: true,
            label: 'Accessible Button',
            child: RemixButton(
              key: const ValueKey('accessible_button'),
              label: 'Accessible',
              onPressed: () {
                // Accessibility test handler
              },
            ),
          ),
        );

        // Verify semantic label is present
        final semantics = tester.getSemantics(
          find.byKey(const ValueKey('accessible_button')),
        );
        expect(semantics.label, contains('Accessible'));
      },
    );

    testWidgets(
      'RemixButton.icon renders only icon without label',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton.icon(
            Icons.favorite,
            key: const ValueKey('icon_button'),
            onPressed: () {
              // Icon button handler
            },
          ),
        );

        // Verify button is rendered
        expect(find.byKey(const ValueKey('icon_button')), findsOneWidget);

        // Verify icon is displayed
        expect(find.byIcon(Icons.favorite), findsOneWidget);

        // Verify no text is displayed
        expect(find.byType(Text), findsNothing);
      },
    );

    testWidgets(
      'Button with custom style',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('styled_button'),
            label: 'Styled Button',
            onPressed: () {
              // Styled button handler
            },
            style: const RemixButtonStyle.create(),
          ),
        );

        // Verify button renders with custom style
        expect(find.byKey(const ValueKey('styled_button')), findsOneWidget);
        expect(find.text('Styled Button'), findsOneWidget);
      },
    );

    testWidgets(
      'Button loading state prevents taps',
      (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('loading_tap_button'),
            label: 'Loading',
            loading: true,
            onPressed: () {
              wasPressed = true;
            },
          ),
        );

        // Try to tap the loading button
        await tester.tap(find.byKey(const ValueKey('loading_tap_button')));
        await tester.pump();

        // Verify callback was not triggered
        expect(wasPressed, isFalse);
      },
    );

    testWidgets(
      'Button handles long press',
      (WidgetTester tester) async {
        bool wasLongPressed = false;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('long_press_button'),
            label: 'Long Press Me',
            onPressed: () {
              // Regular press handler
            },
            onLongPress: () {
              wasLongPressed = true;
            },
          ),
        );

        // Long press the button
        await tester.longPress(find.byKey(const ValueKey('long_press_button')));
        await tester.pump();

        // Verify long press was detected
        expect(wasLongPressed, isTrue);
      },
    );
  });
}
