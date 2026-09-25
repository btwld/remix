import 'package:flutter/material.dart';
import 'package:naked_ui/naked_ui.dart';

import '../src/example_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExampleApp(child: Center(child: ComboboxExample()));
  }
}

class ComboboxExample extends StatelessWidget {
  const ComboboxExample({super.key});

  static const fruits = ['Apple', 'Apricot', 'Banana', 'Blueberry', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: NakedCombobox<String>(
        optionsBuilder: (value) {
          final query = value.text.toLowerCase();
          return fruits.where((fruit) => fruit.toLowerCase().startsWith(query));
        },
        onSelected: (_) {},
        fieldBuilder:
            (context, state, controller, focusNode, onFieldSubmitted) {
              return NakedTextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => onFieldSubmitted(),
                builder: (context, fieldState, child) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: fieldState.isFocused
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: child,
                  );
                },
              );
            },
        overlayBuilder: (context, options) {
          return Material(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final fruit in options)
                  NakedCombobox.Option<String>(
                    value: fruit,
                    builder: (context, state, _) {
                      return Container(
                        width: double.infinity,
                        color: state.isHighlighted ? Colors.blue.shade50 : null,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(fruit),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
