import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// A test TextField widget that mimics RemixTextField functionality
/// This follows Flutter best practices for input components
class TestTextField extends StatefulWidget {
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool obscureText;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const TestTextField({
    super.key,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.controller,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
  });

  @override
  State<TestTextField> createState() => _TestTextFieldState();
}

class _TestTextFieldState extends State<TestTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _errorText = widget.errorText;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleChanged(String value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _errorText != null
                  ? Colors.red
                  : _focusNode.hasFocus
                      ? Colors.blue
                      : Colors.grey,
              width: _focusNode.hasFocus ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: widget.enabled ? Colors.white : Colors.grey[100],
          ),
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: widget.prefix!,
                ),
              ],
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  obscureText: widget.obscureText,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  onChanged: _handleChanged,
                  onEditingComplete: widget.onEditingComplete,
                  onSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: widget.enabled ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              if (widget.suffix != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: widget.suffix!,
                ),
              ],
            ],
          ),
        ),
        if (_errorText != null || widget.helperText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _errorText ?? widget.helperText ?? '',
              style: TextStyle(
                fontSize: 12,
                color: _errorText != null ? Colors.red : Colors.grey[600],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

void main() {
  group('TextField Integration Tests (as Widget Tests)', () {
    // Test 1: Basic Rendering
    testWidgets('renders correctly with hint text and helper text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('test_field'),
                hintText: 'Enter your name',
                helperText: 'This field is required',
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('test_field')), findsOneWidget);
      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('This field is required'), findsOneWidget);
    });

    // Test 2: Text Input
    testWidgets('accepts and displays text input correctly', (tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('input_field'),
                hintText: 'Type here',
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'Hello World');
      await tester.pump();

      // Verify text is displayed
      expect(find.text('Hello World'), findsOneWidget);
      expect(changedValue, equals('Hello World'));
    });

    // Test 3: Disabled State
    testWidgets('does not accept input when disabled', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('disabled_field'),
                hintText: 'Disabled field',
                enabled: false,
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );

      // Try to enter text in disabled field
      await tester.enterText(find.byType(TextField), 'Should not work');
      await tester.pump();

      // Verify no text was entered
      expect(find.text('Should not work'), findsNothing);
      expect(changedValue, isNull);
    });

    // Test 4: Validation
    testWidgets('shows validation error correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('validated_field'),
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(find.byType(TextField), 'notanemail');
      await tester.pump();

      // Verify error message is shown
      expect(find.text('Invalid email format'), findsOneWidget);

      // Enter valid email
      await tester.enterText(find.byType(TextField), 'user@example.com');
      await tester.pump();

      // Verify error message is gone
      expect(find.text('Invalid email format'), findsNothing);
    });

    // Test 5: Focus Management
    testWidgets('handles focus correctly', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TestTextField(
                    key: const ValueKey('focus_field'),
                    hintText: 'Focus me',
                    focusNode: focusNode,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => focusNode.requestFocus(),
                    child: const Text('Focus Field'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially not focused
      expect(focusNode.hasFocus, isFalse);

      // Tap button to focus field
      await tester.tap(find.text('Focus Field'));
      await tester.pump();

      // Verify field is focused
      expect(focusNode.hasFocus, isTrue);

      // Unfocus by calling unfocus() directly
      // In a real app, tapping outside would unfocus, but in tests we need to be explicit
      focusNode.unfocus();
      await tester.pump();

      // Verify field is unfocused
      expect(focusNode.hasFocus, isFalse);

      // Clean up
      focusNode.dispose();
    });

    // Test 6: Prefix and Suffix Widgets
    testWidgets('displays prefix and suffix widgets correctly', (tester) async {
      bool suffixPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('decorated_field'),
                hintText: 'Search',
                prefix: const Icon(Icons.search, size: 20),
                suffix: IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => suffixPressed = true,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify prefix and suffix are displayed
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap suffix button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // Verify suffix button was pressed
      expect(suffixPressed, isTrue);
    });

    // Test 7: Max Length
    testWidgets('respects maxLength constraint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('limited_field'),
                hintText: 'Max 5 chars',
                maxLength: 5,
              ),
            ),
          ),
        ),
      );

      // Try to enter more than 5 characters
      await tester.enterText(find.byType(TextField), '123456789');
      await tester.pump();

      // Verify only 5 characters are displayed
      expect(find.text('12345'), findsOneWidget);
      expect(find.text('123456789'), findsNothing);
    });

    // Test 8: Obscure Text (Password Field)
    testWidgets('handles obscure text for passwords', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('password_field'),
                hintText: 'Password',
                obscureText: true,
              ),
            ),
          ),
        ),
      );

      // Enter password
      await tester.enterText(find.byType(TextField), 'secret123');
      await tester.pump();

      // Verify text is obscured (dots/bullets are shown)
      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    // Test 9: Multi-line Text
    testWidgets('handles multi-line text input', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('multiline_field'),
                hintText: 'Enter description',
                maxLines: 3,
              ),
            ),
          ),
        ),
      );

      // Enter multi-line text
      const multilineText = 'Line 1\nLine 2\nLine 3';
      await tester.enterText(find.byType(TextField), multilineText);
      await tester.pump();

      // Verify multi-line text is displayed
      expect(find.text(multilineText), findsOneWidget);
      
      // Verify TextField is configured for multiple lines
      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.maxLines, equals(3));
    });

    // Test 10: Input Formatters
    testWidgets('applies input formatters correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('formatted_field'),
                hintText: 'Numbers only',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ),
        ),
      );

      // Try to enter mixed text and numbers
      await tester.enterText(find.byType(TextField), 'abc123def456');
      await tester.pump();

      // Verify only numbers are displayed
      expect(find.text('123456'), findsOneWidget);
      expect(find.text('abc123def456'), findsNothing);
    });

    // Test 11: onSubmitted Callback
    testWidgets('triggers onSubmitted when Enter is pressed', (tester) async {
      String? submittedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('submit_field'),
                hintText: 'Press Enter to submit',
                onSubmitted: (value) => submittedValue = value,
              ),
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'Test submission');
      
      // Simulate Enter key press
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Verify onSubmitted was called
      expect(submittedValue, equals('Test submission'));
    });

    // Test 12: Controller Value Updates
    testWidgets('updates with controller value changes', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TestTextField(
                    key: const ValueKey('controlled_field'),
                    hintText: 'Controlled field',
                    controller: controller,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.text = 'Updated by button';
                    },
                    child: const Text('Update Field'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially empty
      expect(find.text('Updated by button'), findsNothing);

      // Tap button to update field
      await tester.tap(find.text('Update Field'));
      await tester.pump();

      // Verify field is updated
      expect(find.text('Updated by button'), findsOneWidget);
      expect(controller.text, equals('Updated by button'));

      // Clean up
      controller.dispose();
    });

    // Test 13: Accessibility
    testWidgets('provides correct semantics for accessibility', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Semantics(
                label: 'Email input field',
                hint: 'Enter your email address',
                child: TestTextField(
                  key: const ValueKey('accessible_field'),
                  hintText: 'Email',
                  helperText: 'We will not share your email',
                ),
              ),
            ),
          ),
        ),
      );

      // Verify semantics
      final semantics = tester.getSemantics(find.byKey(const ValueKey('accessible_field')));
      expect(semantics.label, contains('Email input field'));
      expect(semantics.hint, contains('Enter your email address'));
    });

    // Test 14: Performance - Rapid Text Updates
    testWidgets('handles rapid text updates efficiently', (tester) async {
      int changeCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('performance_field'),
                hintText: 'Type fast',
                onChanged: (_) => changeCount++,
              ),
            ),
          ),
        ),
      );

      // Simulate rapid typing
      const rapidText = 'abcdefghijklmnopqrstuvwxyz';
      for (int i = 1; i <= rapidText.length; i++) {
        await tester.enterText(find.byType(TextField), rapidText.substring(0, i));
        await tester.pump(const Duration(milliseconds: 10));
      }

      // Verify all changes were captured
      expect(changeCount, equals(rapidText.length));
      expect(find.text(rapidText), findsOneWidget);
    });

    // Test 15: Error State Visual Feedback
    testWidgets('shows visual feedback for error state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('error_field'),
                hintText: 'Username',
                errorText: 'Username already taken',
              ),
            ),
          ),
        ),
      );

      // Verify error text is displayed
      expect(find.text('Username already taken'), findsOneWidget);
      
      // Verify error styling (red text)
      final Text errorText = tester.widget(
        find.text('Username already taken'),
      );
      expect(errorText.style?.color, equals(Colors.red));
    });
  });

  // Additional test group for edge cases and best practices
  group('TextField Edge Cases and Best Practices', () {
    testWidgets('properly disposes of resources', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('dispose_field'),
                hintText: 'Test disposal',
              ),
            ),
          ),
        ),
      );

      // Widget is rendered
      expect(find.byKey(const ValueKey('dispose_field')), findsOneWidget);

      // Replace with empty container to trigger disposal
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Widget is removed and disposed
      expect(find.byKey(const ValueKey('dispose_field')), findsNothing);
    });

    testWidgets('handles empty and null values gracefully', (tester) async {
      String? receivedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestTextField(
                key: const ValueKey('null_field'),
                hintText: 'Can be empty',
                onChanged: (value) => receivedValue = value,
              ),
            ),
          ),
        ),
      );

      // Enter text then clear it
      await tester.enterText(find.byType(TextField), 'text');
      await tester.pump();
      expect(receivedValue, equals('text'));

      await tester.enterText(find.byType(TextField), '');
      await tester.pump();
      expect(receivedValue, equals(''));
    });

    testWidgets('maintains state during widget rebuild', (tester) async {
      bool showHelper = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TestTextField(
                        key: const ValueKey('stateful_field'),
                        hintText: 'Stateful field',
                        helperText: showHelper ? 'Helper text' : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => setState(() => showHelper = !showHelper),
                        child: const Text('Toggle Helper'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextField), 'Persistent text');
      await tester.pump();

      // Toggle helper text (causes rebuild)
      await tester.tap(find.text('Toggle Helper'));
      await tester.pump();

      // Verify text persists after rebuild
      expect(find.text('Persistent text'), findsOneWidget);
      expect(find.text('Helper text'), findsOneWidget);
    });
  });
}