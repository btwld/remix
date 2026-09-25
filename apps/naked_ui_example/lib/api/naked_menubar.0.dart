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
        body: const Center(child: MenubarExample()),
      ),
    );
  }
}

class MenubarExample extends StatefulWidget {
  const MenubarExample({super.key});

  @override
  State<MenubarExample> createState() => _MenubarExampleState();
}

class _MenubarExampleState extends State<MenubarExample> {
  final _file = MenuController();
  final _edit = MenuController();
  final _view = MenuController();
  String _status = 'Nothing selected';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NakedMenubar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _menu(_file, 'File', const ['New', 'Open']),
              _menu(_edit, 'Edit', const ['Copy', 'Paste']),
              _menu(_view, 'View', const ['Zoom in', 'Zoom out']),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(_status),
      ],
    );
  }

  Widget _menu(MenuController controller, String label, List<String> items) {
    return NakedMenu<String>(
      controller: controller,
      onSelected: (value) => setState(() => _status = value),
      builder: (context, state, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: state.isOpen ? Colors.blue.shade50 : Colors.white,
          child: Text(label),
        );
      },
      overlayBuilder: (context, info) {
        return Material(
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in items)
                NakedMenu.Item(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(item),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
