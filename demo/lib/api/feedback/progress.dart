import 'package:flutter/material.dart';
import 'package:remix/remix_new.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 200,
            child: RemixProgress(
              value: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
