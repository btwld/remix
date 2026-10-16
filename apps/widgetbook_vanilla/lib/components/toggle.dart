import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Toggle', type: VanillaToggle)
Widget buildVanillaToggleUseCase(BuildContext context) {
  var v = false;
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => VanillaToggle(
          selected: v,
          label: 'Bold',
          onChanged: (value) => setState(() => v = value),
        ),
      ),
    ),
  );
}
