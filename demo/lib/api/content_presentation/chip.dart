import 'dart:developer';

import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';
// Using exported API from remix package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              RemixChip(
                label: 'Click Me',
                selected: selected,
                onChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
                leading: Icons.add,
                style: RemixChipStyle()
                    .onHovered(RemixChipStyle(
                        container: BoxStyle(
                            decoration:
                                BoxDecorationMix(color: Colors.grey.shade100))))
                    .onSelected(RemixChipStyle(
                        container: BoxStyle(
                            decoration: BoxDecorationMix(color: Colors.blue)))),
              ),
              RemixButton.icon(
                Icons.add,
                onPressed: () {
                  log('Button pressed!');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
