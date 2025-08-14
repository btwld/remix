import 'dart:math';

import 'package:flutter/material.dart';
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
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            width: 300,
            child: RemixAccordion(
              defaultTrailingIcon: Icons.keyboard_arrow_down_rounded,
              style: AccordionStyle(
                animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
              ).onSelected(
                AccordionStyle(
                  itemContainer: BoxMix(
                    decoration: BoxDecorationMix(color: Colors.grey.shade50),
                    transform: Matrix4.rotationZ(pi),
                  ),
                ),
              ),
              children: [
                RemixAccordionItem(
                  title: 'Section 1',
                  value: 'section1',
                  child: const Text('Content for section 1'),
                ),
                RemixAccordionItem(
                  title: 'Section 2',
                  value: 'section2',
                  child: const Text('Content for section 2'),
                ),
                RemixAccordionItem(
                  title: 'Section 3',
                  value: 'section3',
                  child: const Text('Content for section 3'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
