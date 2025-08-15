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

class _MyAppState extends State<MyApp> {
  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: RemixCheckbox(
            label: 'Checkbox',
            selected: _value,
            style: RemixCheckboxStyle()
              .color(Colors.blue)
              .onHovered(
                RemixCheckboxStyle()
                  .color(Colors.blue.shade700)
              ),
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
        ),
      ),
    );
  }
}
