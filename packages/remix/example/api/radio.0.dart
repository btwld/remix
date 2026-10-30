import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by olist
// https://designsystem.olist.io/latest/components/radio

void main() {
  runApp(
    WidgetsApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      textStyle: const TextStyle(color: Color(0xFF202020), fontSize: 16),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: const ColoredBox(color: Colors.white, child: RadioExample()),
    ),
  );
}

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RemixRadioGroup<String>(
        groupValue: _selectedValue,
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
        },
        child: Column(
          crossAxisAlignment: .center,
          spacing: 16,
          mainAxisSize: .min,
          children: [
            RemixRadio<String>(
              label: 'Option 1',
              value: 'option1',
              style: style,
            ),
            RemixRadio<String>(
              label: 'Option 2',
              value: 'option2',
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  RadioStyler get style {
    return RadioStyler()
        .borderRadius(.all(const Radius.circular(30)))
        .size(22, 22)
        .border(
          BoxBorderMix.all(
            BorderSideMix()
                .color(Colors.blueGrey.shade100)
                .width(2.4)
                .strokeAlign(BorderSide.strokeAlignInside),
          ),
        )
        .onHovered(
          RadioStyler().shadow(
            BoxShadowMix()
                .color(Colors.blueGrey.shade50.withValues(alpha: 0.7))
                .blurRadius(0)
                .spreadRadius(9),
          ),
        )
        .onPressed(
          RadioStyler().border(
            BoxBorderMix.all(
              BorderSideMix()
                  .color(Colors.blueGrey.shade100)
                  .width(6)
                  .strokeAlign(BorderSide.strokeAlignInside),
            ),
          ),
        )
        .onSelected(
          RadioStyler().border(
            BoxBorderMix.all(
              BorderSideMix()
                  .color(Colors.blueAccent.shade700)
                  .width(6)
                  .strokeAlign(BorderSide.strokeAlignInside),
            ),
          ),
        );
  }
}
