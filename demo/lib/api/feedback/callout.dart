import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: const Scaffold(
        body: const Center(
          child: const RemixCallout(
            text: 'Hello, world!',
            icon: Icons.info,
          ),
        ),
      ),
    );
  }
}
