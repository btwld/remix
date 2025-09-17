import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

enum Options {
  banana,
  apple,
  orange,
}

class _MyAppState extends State<MyApp> {
  Options? _value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RemixRadioGroup<Options>(
            groupValue: _value,
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
            child: const Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledRadio(option: Options.banana, label: 'Banana'),
                _LabeledRadio(option: Options.apple, label: 'Apple'),
                _LabeledRadio(option: Options.orange, label: 'Orange'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledRadio extends StatelessWidget {
  const _LabeledRadio({required this.option, required this.label});

  final Options option;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemixRadio<Options>(
          value: option,
          semanticLabel: label,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
