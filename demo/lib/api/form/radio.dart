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
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RemixRadio<Options>(
                label: 'Banana',
                value: Options.banana,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              RemixRadio<Options>(
                label: 'Apple',
                value: Options.apple,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              RemixRadio<Options>(
                label: 'Orange',
                value: Options.orange,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
