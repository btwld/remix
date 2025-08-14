import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simple mock of RemixSelect for testing
class MockSelect<T> extends StatefulWidget {
  final T? selectedValue;
  final ValueChanged<T?>? onSelectedValueChanged;
  final List<MockSelectItem<T>> items;
  final bool enabled;

  const MockSelect({
    super.key,
    this.selectedValue,
    this.onSelectedValueChanged,
    required this.items,
    this.enabled = true,
  });

  @override
  State<MockSelect<T>> createState() => _MockSelectState<T>();
}

class _MockSelectState<T> extends State<MockSelect<T>> {
  bool _isOpen = false;

  void _toggleDropdown() {
    if (!widget.enabled) return;
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  void _selectItem(T value) {
    widget.onSelectedValueChanged?.call(value);
    setState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.selectedValue?.toString() ?? 'Select'),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_isOpen)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: widget.items.map((item) {
                return InkWell(
                  onTap: () => _selectItem(item.value),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(item.label),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class MockSelectItem<T> {
  final T value;
  final String label;

  const MockSelectItem({
    required this.value,
    required this.label,
  });
}

void main() {
  group('Select Tests (with Mock)', () {
    testWidgets('opens dropdown and selects item', (tester) async {
      String? selectedValue = 'Apple';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return MockSelect<String>(
                    selectedValue: selectedValue,
                    onSelectedValueChanged: (value) {
                      setState(() {
                        selectedValue = value;
                      });
                    },
                    items: [
                      MockSelectItem(value: 'Apple', label: 'Apple'),
                      MockSelectItem(value: 'Banana', label: 'Banana'),
                      MockSelectItem(value: 'Orange', label: 'Orange'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Initially shows selected value
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);

      // Open dropdown
      await tester.tap(find.byType(MockSelect<String>));
      await tester.pumpAndSettle();

      // All options visible
      expect(find.text('Apple'), findsNWidgets(2)); // In trigger and dropdown
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Orange'), findsOneWidget);

      // Select Banana
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();

      // Dropdown closes, value changes
      expect(selectedValue, 'Banana');
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Orange'), findsNothing); // Dropdown closed
    });

    testWidgets('respects disabled state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MockSelect<String>(
                selectedValue: 'Apple',
                enabled: false,
                onSelectedValueChanged: (_) {},
                items: [
                  MockSelectItem(value: 'Apple', label: 'Apple'),
                  MockSelectItem(value: 'Banana', label: 'Banana'),
                ],
              ),
            ),
          ),
        ),
      );

      // Try to open dropdown
      await tester.tap(find.byType(MockSelect<String>));
      await tester.pumpAndSettle();

      // Dropdown should not open
      expect(find.text('Banana'), findsNothing);
    });
  });
}