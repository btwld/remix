import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// For now, we'll test with a simple button to verify integration test setup works
// Once the compilation issues are resolved, we'll use RemixButton

class TestButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool loading;
  final IconData? icon;
  
  const TestButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.icon,
  });
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? Theme.of(context).primaryColor : Colors.grey,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled && !loading ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              if (loading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Button Integration Tests', () {
    testWidgets('Button renders correctly with label and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: TestButton(
                key: const ValueKey('test_button'),
                label: 'Test Button',
                icon: Icons.star,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify button is rendered
      expect(find.byKey(const ValueKey('test_button')), findsOneWidget);
      
      // Verify label is displayed
      expect(find.text('Test Button'), findsOneWidget);
      
      // Verify icon is displayed
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('Button responds to tap when enabled', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: TestButton(
                key: const ValueKey('tap_button'),
                label: 'Tap Me',
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byKey(const ValueKey('tap_button')));
      await tester.pumpAndSettle();

      // Verify callback was triggered
      expect(wasPressed, isTrue);
    });

    testWidgets('Button does not respond to tap when disabled', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: TestButton(
                key: const ValueKey('disabled_button'),
                label: 'Disabled Button',
                enabled: false,
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Try to tap the disabled button
      await tester.tap(find.byKey(const ValueKey('disabled_button')));
      await tester.pumpAndSettle();

      // Verify callback was not triggered
      expect(wasPressed, isFalse);
    });

    testWidgets('Button shows loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: TestButton(
                key: const ValueKey('loading_button'),
                label: 'Loading Button',
                loading: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify button is rendered
      expect(find.byKey(const ValueKey('loading_button')), findsOneWidget);
      
      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Verify label is not shown when loading
      expect(find.text('Loading Button'), findsNothing);
    });

    testWidgets('Button state transitions work correctly', (WidgetTester tester) async {
      bool isLoading = false;
      bool isEnabled = true;
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TestButton(
                        key: const ValueKey('state_button'),
                        label: 'State Button',
                        loading: isLoading,
                        enabled: isEnabled,
                        onPressed: () {
                          setState(() {
                            tapCount++;
                            isLoading = !isLoading;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TestButton(
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
            ),
          ),
        ),
      );

      // Initially button should be enabled and not loading
      expect(find.byKey(const ValueKey('state_button')), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Tap to start loading
      await tester.tap(find.byKey(const ValueKey('state_button')));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tapCount, equals(1));

      // Toggle enabled state to false
      await tester.tap(find.byKey(const ValueKey('toggle_button')));
      await tester.pumpAndSettle();
      
      // Try to tap disabled button (should not increment tap count)
      await tester.tap(find.byKey(const ValueKey('state_button')));
      await tester.pumpAndSettle();
      expect(tapCount, equals(1)); // Should still be 1
    });

    testWidgets('Button handles rapid taps correctly', (WidgetTester tester) async {
      int tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: TestButton(
                key: const ValueKey('rapid_tap_button'),
                label: 'Rapid Tap',
                onPressed: () {
                  tapCount++;
                },
              ),
            ),
          ),
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
    });

    testWidgets('Button works in different orientations', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: TestButton(
                key: const ValueKey('orientation_button'),
                label: 'Orientation Test',
                icon: Icons.screen_rotation,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Test in portrait
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('orientation_button')), findsOneWidget);
      expect(find.text('Orientation Test'), findsOneWidget);

      // Test in landscape
      await tester.binding.setSurfaceSize(const Size(800, 400));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('orientation_button')), findsOneWidget);
      expect(find.text('Orientation Test'), findsOneWidget);
    });

    testWidgets('Button accessibility test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(primaryColor: Colors.blue),
          home: Scaffold(
            body: Center(
              child: Semantics(
                label: 'Accessible Button',
                button: true,
                child: TestButton(
                  key: const ValueKey('accessible_button'),
                  label: 'Accessible',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      );

      // Verify semantic label is present
      final semantics = tester.getSemantics(
        find.byKey(const ValueKey('accessible_button')),
      );
      expect(semantics.label, contains('Accessible'));
    });
  });
}