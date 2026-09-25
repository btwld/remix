import 'package:flutter/material.dart';
import 'package:naked_ui/naked_ui.dart';

import '../src/example_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExampleApp(child: Center(child: ScrollbarExample()));
  }
}

class ScrollbarExample extends StatefulWidget {
  const ScrollbarExample({super.key});

  @override
  State<ScrollbarExample> createState() => _ScrollbarExampleState();
}

class _ScrollbarExampleState extends State<ScrollbarExample> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: 280,
      child: NakedScrollbar(
        thumbVisibility: true,
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(8),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) return Colors.blue.shade700;
          if (states.contains(WidgetState.hovered)) return Colors.blue;
          return Colors.blue.shade200;
        }),
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text('Row $index'),
          ),
        ),
      ),
    );
  }
}
