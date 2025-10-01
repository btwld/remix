import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Shadcn
// https://ui.shadcn.com/docs/components/progress

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: ProgressExample(),
      ),
    ),
  );
}

class ProgressExample extends StatelessWidget {
  const ProgressExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemixProgress(
        value: 0.3,
        style: style,
      ),
    );
  }

  RemixProgressStyle get style {
    return RemixProgressStyle()
        .container(BoxStyler())
        .wrapClipRRect(borderRadius: BorderRadius.circular(10))
        .trackColor(Colors.grey.shade300)
        .indicatorColor(Colors.grey.shade900)
        .width(300)
        .height(10);
  }
}
