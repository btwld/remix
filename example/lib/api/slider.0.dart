import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

// Inspired by Uber design system
// https://base.uber.com/6d2425e9f/p/30cac1-slider

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SliderExample(),
      ),
    ),
  );
}

class SliderExample extends StatefulWidget {
  const SliderExample({super.key});

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _selectedValue = 0.3;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: RemixSlider(
          value: _selectedValue,
          style: style,
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
        ),
      ),
    );
  }

  RemixSliderStyle get style {
    return RemixSliderStyle()
        .thumb(
          BoxStyler().width(24).shapeCircle().shadow(
                BoxShadowMix()
                    .color(Colors.black54)
                    .blurRadius(4)
                    .offset(Offset(0, 2)),
              ),
        )
        .thumbColor(Colors.white)
        .baseTrackColor(Colors.grey.shade300)
        .activeTrackColor(Colors.blue);
  }
}
