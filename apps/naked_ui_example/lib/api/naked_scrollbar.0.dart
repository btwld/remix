import 'package:flutter/material.dart';
import 'package:naked_ui/naked_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: const Center(child: ScrollbarExample()),
      ),
    );
  }
}

class ScrollbarExample extends StatelessWidget {
  const ScrollbarExample({super.key});

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
          itemCount: 30,
          itemBuilder: (context, index) => ListTile(title: Text('Row $index')),
        ),
      ),
    );
  }
}
