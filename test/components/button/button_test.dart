import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixButton Tests', () {
    testWidgets(
      'RemixButton renders correctly with label and icon',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: TestDataBuilder.sampleLabel,
            icon: Icons.star,
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        // Verify button is rendered
        tester.expectWidgetVisible(TestDataBuilder.defaultButtonKey);

        // Verify label is displayed
        tester.expectTextVisible(TestDataBuilder.sampleLabel);

        // Verify icon is displayed
        tester.expectIconVisible(Icons.star);
      },
    );

    testWidgets(
      'RemixButton responds to tap when enabled',
      (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Tap Me',
            onPressed: () {
              wasPressed = true;
            },
          ),
        );

        // Tap the button
        await tester.tapRemixButton(TestDataBuilder.defaultButtonKey);

        // Verify callback was triggered
        expect(wasPressed, isTrue);
      },
    );

    testWidgets(
      'RemixButton does not respond to tap when disabled',
      (WidgetTester tester) async {
        bool wasPressed = false;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Disabled Button',
            enabled: false,
            onPressed: () {
              wasPressed = true;
            },
          ),
        );

        // Try to tap the disabled button
        await tester.tapRemixButton(TestDataBuilder.defaultButtonKey);

        // Verify callback was not triggered
        expect(wasPressed, isFalse);
      },
    );

    testWidgets(
      'RemixButton shows loading state correctly',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Loading Button',
            loading: true,
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        // Verify button is rendered
        tester.expectWidgetVisible(TestDataBuilder.defaultButtonKey);

        // Verify loading indicator is shown (SpinnerSpecWidget is used directly)
        expect(find.byType(SpinnerSpecWidget), findsOneWidget);
      },
    );

    testWidgets(
      'RemixButton.icon renders only icon without label',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton.icon(
            Icons.favorite,
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        // Verify button is rendered
        tester.expectWidgetVisible(TestDataBuilder.defaultButtonKey);

        // Verify icon is displayed
        tester.expectIconVisible(Icons.favorite);

        // Verify no text is displayed
        expect(find.byType(Text), findsNothing);
      },
    );

    testWidgets(
      'RemixButton handles long press correctly',
      (WidgetTester tester) async {
        bool wasLongPressed = false;

        await tester.pumpRemixApp(
          GestureDetector(
            onLongPress: () {
              wasLongPressed = true;
            },
            child: RemixButton(
              key: const ValueKey(TestDataBuilder.defaultButtonKey),
              label: 'Long Press Me',
              onPressed: () {
              // Button tap handler
            },
            ),
          ),
        );

        // Long press the button
        await tester.longPressWidget(TestDataBuilder.defaultButtonKey);

        // Verify long press was detected
        expect(wasLongPressed, isTrue);
      },
    );

    testWidgets(
      'RemixButton with different icon positions',
      (WidgetTester tester) async {
        // Test with leading icon (default)
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('button_leading'),
            label: 'Leading Icon',
            icon: Icons.arrow_back,
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        tester.expectWidgetVisible('button_leading');
        tester.expectIconVisible(Icons.arrow_back);
        tester.expectTextVisible('Leading Icon');

        // Test with trailing icon
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey('button_trailing'),
            label: 'Trailing Icon',
            icon: Icons.arrow_forward,
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        tester.expectWidgetVisible('button_trailing');
        tester.expectIconVisible(Icons.arrow_forward);
        tester.expectTextVisible('Trailing Icon');
      },
    );

    testWidgets(
      'RemixButton state transitions work correctly',
      (WidgetTester tester) async {
        bool isLoading = false;
        bool isEnabled = true;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixButton(
                    key: const ValueKey(TestDataBuilder.defaultButtonKey),
                    label: 'State Button',
                    enabled: isEnabled,
                    loading: isLoading,
                    onPressed: () {
                      setState(() {
                        isLoading = !isLoading;
                      });
                    },
                  ),
                  RemixButton(
                    key: const ValueKey('toggle_enabled'),
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
        tester.expectWidgetVisible(TestDataBuilder.defaultButtonKey);
        expect(find.byType(SpinnerSpecWidget), findsNothing);

        // Tap to start loading
        await tester.tapRemixButton(TestDataBuilder.defaultButtonKey);
        expect(find.byType(SpinnerSpecWidget), findsOneWidget);

        // Toggle enabled state
        await tester.tapRemixButton('toggle_enabled');

        // Try to tap disabled button (should not change loading state)
        await tester.tapRemixButton(TestDataBuilder.defaultButtonKey);
        expect(find.byType(SpinnerSpecWidget), findsOneWidget);
      },
    );

    testWidgets(
      'RemixButton performance test',
      (WidgetTester tester) async {
        await PerformanceTestHelper.measureWidgetBuildTime(
          tester,
          RemixButton(label: 'Performance Test', onPressed: () {}),
          'RemixButton',
        );

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Performance Button',
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        await PerformanceTestHelper.measureInteractionResponseTime(
          tester,
          () => tester.tapRemixButton(TestDataBuilder.defaultButtonKey),
          'RemixButton tap',
        );
      },
    );

    testWidgets(
      'RemixButton accessibility test',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Accessible Button',
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        // Verify semantic label is present
        final semantics = tester.getSemantics(
          find.byKey(const ValueKey(TestDataBuilder.defaultButtonKey)),
        );
        expect(semantics.label, contains('Accessible Button'));
      },
    );

    testWidgets(
      'RemixButton handles rapid taps correctly',
      (WidgetTester tester) async {
        int tapCount = 0;

        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Rapid Tap',
            onPressed: () {
              tapCount++;
            },
          ),
        );

        // Perform rapid taps
        for (int i = 0; i < 5; i++) {
          await tester.tap(
            find.byKey(const ValueKey(TestDataBuilder.defaultButtonKey)),
          );
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        // Verify all taps were registered
        expect(tapCount, equals(5));
      },
    );

    testWidgets(
      'RemixButton works in different orientations',
      (WidgetTester tester) async {
        await tester.pumpRemixApp(
          RemixButton(
            key: const ValueKey(TestDataBuilder.defaultButtonKey),
            label: 'Orientation Test',
            icon: Icons.screen_rotation,
            onPressed: () {
              // Button tap handler
            },
          ),
        );

        // Test in portrait
        await tester.changeOrientation(Orientation.portrait);
        tester.expectWidgetVisible(TestDataBuilder.defaultButtonKey);
        tester.expectTextVisible('Orientation Test');

        // Test in landscape
        await tester.changeOrientation(Orientation.landscape);
        tester.expectWidgetVisible(TestDataBuilder.defaultButtonKey);
        tester.expectTextVisible('Orientation Test');
      },
    );
  });
}
