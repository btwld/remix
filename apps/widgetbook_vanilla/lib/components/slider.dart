import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Slider', type: VanillaSlider)
Widget buildVanillaSliderUseCase(BuildContext context) {
  var v = 0.6;
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: 240,
        child: StatefulBuilder(
          builder: (context, setState) => VanillaSlider(
            value: v,
            onChanged: (value) => setState(() => v = value),
          ),
        ),
      ),
    ),
  );
}
