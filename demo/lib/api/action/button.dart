import 'dart:developer';

import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              RemixButton(
                label: 'Click Me',
                onPressed: () {
                  log('Button pressed!');
                },
                style: ButtonStyle()
                  .color(Colors.black)
                  .animate(AnimationConfig.linear(const Duration(milliseconds: 100)))
                  .onHovered(
                    ButtonStyle()
                      .color(Colors.grey.shade800)
                  ),
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
