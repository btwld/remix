import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Carbon design system
// https://carbondesignsystem.com/components/checkbox/usage/

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: DividerExample(),
      ),
    ),
  );
}

class DividerExample extends StatelessWidget {
  const DividerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemixDivider(
        style: style,
      ),
    );
  }

  RemixDividerStyle get style {
    return RemixDividerStyle()
        .height(1)
        .textColor(Colors.grey.shade400)
        .width(300);
  }
}
