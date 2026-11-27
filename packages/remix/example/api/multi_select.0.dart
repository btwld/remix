import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

void main() {
  runApp(
    WidgetsApp(
      color: Color(0xFFECEFEB),
      debugShowCheckedModeBanner: false,
      textStyle: const TextStyle(color: Color(0xFF202020), fontSize: 16),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: const ColoredBox(
        color: Color(0xFFECEFEB),
        child: MultiSelectExample(),
      ),
    ),
  );
}

class MultiSelectExample extends StatefulWidget {
  const MultiSelectExample({super.key});

  @override
  State<MultiSelectExample> createState() => _MultiSelectExampleState();
}

class _MultiSelectExampleState extends State<MultiSelectExample> {
  Set<String> _fruits = {'apple'};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemixMultiSelect<String>(
        trigger: const RemixSelectTrigger(placeholder: 'Select fruits'),
        items: const [
          RemixSelectItem(value: 'apple', label: 'Apple'),
          RemixSelectItem(value: 'banana', label: 'Banana'),
          RemixSelectItem(value: 'cherry', label: 'Cherry', enabled: false),
          RemixSelectItem(value: 'date', label: 'Date'),
        ],
        selectedValues: _fruits,
        onChanged: (next) => setState(() => _fruits = next),
        style: RemixMultiSelect.styleFrom().trigger(
          SelectTriggerStyler()
              .padding(.all(8))
              .chip(BoxStyler().padding(.symmetric(horizontal: 8, vertical: 4)))
              .onSelected(SelectTriggerStyler().color(Color(0xFFDDE3DA))),
        ),
      ),
    );
  }
}
