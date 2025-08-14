import 'package:demo/helpers/string.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

enum Options {
  banana,
  apple,
  orange,
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Options? _value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select Demo - Simplified for Migration'),
              const SizedBox(height: 20),
              // Simple select implementation for demo purposes
              RemixSelect<Options>(
                selectedValue: _value,
                onSelectedValueChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
                items: Options.values
                    .map((e) =>
                        RemixSelectItem(value: e, label: e.name.capitalize()))
                    .toList(),
                child: RemixSelectTrigger(
                  label: _value?.name.capitalize() ?? 'Select an item',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}