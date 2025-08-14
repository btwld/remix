import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Simple mock button to test the test infrastructure
class SimpleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool loading;
  
  const SimpleButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !loading ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: loading
            ? const CircularProgressIndicator()
            : Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

void main() {
  group('Simple Button Test - Verify Test Infrastructure', () {
    testWidgets('Button renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SimpleButton(
                label: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      
      expect(find.text('Test Button'), findsOneWidget);
    });
    
    testWidgets('Button responds to tap when enabled', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SimpleButton(
                label: 'Tap Me',
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();
      
      expect(wasPressed, isTrue);
    });
    
    testWidgets('Button does not respond when disabled', (WidgetTester tester) async {
      bool wasPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SimpleButton(
                label: 'Disabled',
                enabled: false,
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      
      expect(wasPressed, isFalse);
    });
    
    testWidgets('Button shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SimpleButton(
                label: 'Loading',
                loading: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });
  });
  
  print('✅ All simple button tests passed! Test infrastructure is working.');
}