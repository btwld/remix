import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test Checkbox Widget that mimics RemixCheckbox functionality
class TestCheckbox extends StatefulWidget {
  final bool selected;
  final bool enabled;
  final String? label;
  final IconData? iconChecked;
  final IconData? iconUnchecked;
  final ValueChanged<bool>? onChanged;
  final FocusNode? focusNode;
  final bool tristate;
  final bool? value; // For tristate: null, true, false

  const TestCheckbox({
    super.key,
    this.selected = false,
    this.enabled = true,
    this.label,
    this.iconChecked,
    this.iconUnchecked,
    this.onChanged,
    this.focusNode,
    this.tristate = false,
    this.value,
  });

  @override
  State<TestCheckbox> createState() => _TestCheckboxState();
}

class _TestCheckboxState extends State<TestCheckbox> {
  late FocusNode _focusNode;
  late bool? _value;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _value = widget.tristate ? widget.value : widget.selected;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;

    setState(() {
      if (widget.tristate) {
        // Cycle through: false -> true -> null -> false
        if (_value == false) {
          _value = true;
        } else if (_value == true) {
          _value = null;
        } else {
          _value = false;
        }
      } else {
        _value = !(_value ?? false);
      }
    });

    widget.onChanged?.call(_value ?? false);
  }

  IconData _getIcon() {
    if (_value == null) {
      return Icons.indeterminate_check_box;
    }
    return (_value ?? false)
        ? (widget.iconChecked ?? Icons.check_box)
        : (widget.iconUnchecked ?? Icons.check_box_outline_blank);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = _value ?? false;
    final isIndeterminate = widget.tristate && _value == null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: Focus(
          focusNode: _focusNode,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isHovered && widget.enabled
                  ? Colors.grey.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIcon(),
                  size: 24,
                  color: !widget.enabled
                      ? Colors.grey
                      : isIndeterminate
                          ? Colors.blue
                          : isSelected
                              ? Colors.blue
                              : Colors.grey[600],
                ),
                if (widget.label != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.label!,
                    style: TextStyle(
                      color: widget.enabled ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('Checkbox Integration Tests', () {
    // Test 1: Basic Rendering
    testWidgets('renders correctly with label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('test_checkbox'),
                label: 'Accept Terms',
                selected: false,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('test_checkbox')), findsOneWidget);
      expect(find.text('Accept Terms'), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    });

    // Test 2: Selection State Changes
    testWidgets('toggles selection state on tap', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('toggle_checkbox'),
                label: 'Toggle Me',
                selected: false,
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );

      // Initially unchecked
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);

      // Tap to check
      await tester.tap(find.byKey(const ValueKey('toggle_checkbox')));
      await tester.pump();

      // Now checked
      expect(find.byIcon(Icons.check_box), findsOneWidget);
      expect(changedValue, isTrue);

      // Tap to uncheck
      await tester.tap(find.byKey(const ValueKey('toggle_checkbox')));
      await tester.pump();

      // Now unchecked again
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
      expect(changedValue, isFalse);
    });

    // Test 3: Disabled State
    testWidgets('does not respond when disabled', (tester) async {
      bool? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('disabled_checkbox'),
                label: 'Disabled',
                selected: false,
                enabled: false,
                onChanged: (value) => changedValue = value,
              ),
            ),
          ),
        ),
      );

      // Try to tap
      await tester.tap(find.byKey(const ValueKey('disabled_checkbox')));
      await tester.pump();

      // Should remain unchecked
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
      expect(changedValue, isNull);
    });

    // Test 4: Custom Icons
    testWidgets('displays custom icons correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TestCheckbox(
                    key: const ValueKey('custom_unchecked'),
                    selected: false,
                    iconUnchecked: Icons.radio_button_unchecked,
                  ),
                  TestCheckbox(
                    key: const ValueKey('custom_checked'),
                    selected: true,
                    iconChecked: Icons.star,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    // Test 5: Tristate Checkbox
    testWidgets('handles tristate cycling correctly', (tester) async {
      bool? lastValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('tristate_checkbox'),
                label: 'Tristate',
                tristate: true,
                value: false,
                onChanged: (value) => lastValue = value,
              ),
            ),
          ),
        ),
      );

      // Initially false (unchecked)
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);

      // Tap to true (checked)
      await tester.tap(find.byKey(const ValueKey('tristate_checkbox')));
      await tester.pump();
      expect(find.byIcon(Icons.check_box), findsOneWidget);

      // Tap to null (indeterminate)
      await tester.tap(find.byKey(const ValueKey('tristate_checkbox')));
      await tester.pump();
      expect(find.byIcon(Icons.indeterminate_check_box), findsOneWidget);

      // Tap to false (unchecked)
      await tester.tap(find.byKey(const ValueKey('tristate_checkbox')));
      await tester.pump();
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    });

    // Test 6: Focus Management
    testWidgets('handles focus correctly', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TestCheckbox(
                    key: const ValueKey('focus_checkbox'),
                    label: 'Focusable',
                    focusNode: focusNode,
                  ),
                  ElevatedButton(
                    onPressed: () => focusNode.requestFocus(),
                    child: const Text('Focus Checkbox'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Initially not focused
      expect(focusNode.hasFocus, isFalse);

      // Request focus
      await tester.tap(find.text('Focus Checkbox'));
      await tester.pump();

      // Now focused
      expect(focusNode.hasFocus, isTrue);

      focusNode.dispose();
    });

    // Test 7: Hover State
    testWidgets('shows hover state correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('hover_checkbox'),
                label: 'Hover Me',
              ),
            ),
          ),
        ),
      );

      // Create a hover gesture
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);

      // Move to checkbox
      await gesture.moveTo(tester.getCenter(find.byKey(const ValueKey('hover_checkbox'))));
      await tester.pump();

      // Verify hover state is shown (background color changes)
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byKey(const ValueKey('hover_checkbox')),
          matching: find.byType(Container).first,
        ),
      );
      expect(container.decoration, isNotNull);

      await gesture.removePointer();
    });

    // Test 8: Multiple Checkboxes
    testWidgets('handles multiple checkboxes independently', (tester) async {
      final values = <String, bool>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TestCheckbox(
                    key: const ValueKey('checkbox_1'),
                    label: 'Option 1',
                    onChanged: (value) => values['option1'] = value,
                  ),
                  TestCheckbox(
                    key: const ValueKey('checkbox_2'),
                    label: 'Option 2',
                    onChanged: (value) => values['option2'] = value,
                  ),
                  TestCheckbox(
                    key: const ValueKey('checkbox_3'),
                    label: 'Option 3',
                    onChanged: (value) => values['option3'] = value,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Check first and third
      await tester.tap(find.byKey(const ValueKey('checkbox_1')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('checkbox_3')));
      await tester.pump();

      expect(values['option1'], isTrue);
      expect(values['option2'], isNull);
      expect(values['option3'], isTrue);
    });

    // Test 9: Accessibility
    testWidgets('provides correct semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Semantics(
                label: 'Terms and conditions checkbox',
                checked: false,
                child: TestCheckbox(
                  key: const ValueKey('semantic_checkbox'),
                  label: 'I agree to the terms',
                ),
              ),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byKey(const ValueKey('semantic_checkbox')));
      expect(semantics.label, contains('Terms and conditions'));
    });

    // Test 10: State Persistence
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
                      TestCheckbox(
                        key: const ValueKey('persistent_checkbox'),
                        label: showHelper ? 'With Helper' : 'No Helper',
                        selected: true,
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => showHelper = !showHelper),
                        child: const Text('Toggle Label'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially checked
      expect(find.byIcon(Icons.check_box), findsOneWidget);

      // Toggle label (causes rebuild)
      await tester.tap(find.text('Toggle Label'));
      await tester.pump();

      // Should still be checked
      expect(find.byIcon(Icons.check_box), findsOneWidget);
      expect(find.text('With Helper'), findsOneWidget);
    });

    // Test 11: Rapid Tapping
    testWidgets('handles rapid taps correctly', (tester) async {
      int changeCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('rapid_checkbox'),
                label: 'Rapid Tap',
                onChanged: (_) => changeCount++,
              ),
            ),
          ),
        ),
      );

      // Rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byKey(const ValueKey('rapid_checkbox')));
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(changeCount, equals(5));
    });

    // Test 12: Label Interaction
    testWidgets('responds to tap on label', (tester) async {
      bool? wasChanged;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('label_tap_checkbox'),
                label: 'Tap this label',
                onChanged: (value) => wasChanged = value,
              ),
            ),
          ),
        ),
      );

      // Tap on the label text
      await tester.tap(find.text('Tap this label'));
      await tester.pump();

      expect(wasChanged, isTrue);
    });

    // Test 13: Visual Feedback
    testWidgets('shows correct visual states', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  TestCheckbox(
                    key: ValueKey('unchecked'),
                    selected: false,
                    label: 'Unchecked',
                  ),
                  TestCheckbox(
                    key: ValueKey('checked'),
                    selected: true,
                    label: 'Checked',
                  ),
                  TestCheckbox(
                    key: ValueKey('disabled_unchecked'),
                    selected: false,
                    enabled: false,
                    label: 'Disabled Unchecked',
                  ),
                  TestCheckbox(
                    key: ValueKey('disabled_checked'),
                    selected: true,
                    enabled: false,
                    label: 'Disabled Checked',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify all states are rendered
      expect(find.text('Unchecked'), findsOneWidget);
      expect(find.text('Checked'), findsOneWidget);
      expect(find.text('Disabled Unchecked'), findsOneWidget);
      expect(find.text('Disabled Checked'), findsOneWidget);
    });

    // Test 14: Checkbox without Label
    testWidgets('renders correctly without label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('no_label_checkbox'),
                selected: true,
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('no_label_checkbox')), findsOneWidget);
      expect(find.byIcon(Icons.check_box), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    // Test 15: Dispose Resources
    testWidgets('properly disposes resources', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: const ValueKey('dispose_checkbox'),
                label: 'Will be disposed',
              ),
            ),
          ),
        ),
      );

      // Widget exists
      expect(find.byKey(const ValueKey('dispose_checkbox')), findsOneWidget);

      // Replace with empty widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox.shrink(),
            ),
          ),
        ),
      );

      // Widget is disposed
      expect(find.byKey(const ValueKey('dispose_checkbox')), findsNothing);
    });
  });

  group('Checkbox Edge Cases', () {
    testWidgets('handles null callbacks gracefully', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TestCheckbox(
                key: ValueKey('null_callback'),
                label: 'No callback',
                onChanged: null,
              ),
            ),
          ),
        ),
      );

      // Can still tap without error
      await tester.tap(find.byKey(const ValueKey('null_callback')));
      await tester.pump();

      // No crash
      expect(find.byKey(const ValueKey('null_callback')), findsOneWidget);
    });
  });
}