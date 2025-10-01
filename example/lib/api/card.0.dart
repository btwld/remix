import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by dell design system
// https://www.delldesignsystem.com/components/card/?tab=Design

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: CardExample(),
      ),
    ),
  );
}

class CardExample extends StatelessWidget {
  const CardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          RemixCard(
            style: style,
          ),
        ],
      ),
    );
  }

  RemixCardStyle get style {
    return RemixCardStyle()
        .size(300, 200)
        .color(Colors.white)
        .borderRadiusAll(const Radius.circular(4))
        .borderAll(color: Colors.grey.shade300);
  }
}
