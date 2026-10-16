import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Checkbox', type: VanillaCheckbox)
Widget buildVanillaCheckboxUseCase(BuildContext context) => Scaffold(
  body: Center(child: StatefulBuilder(builder: (context, setState) { var v = true; return VanillaCheckbox(selected: v, onChanged: (value) => setState(() => v = value ?? false), semanticLabel: 'Label'); })),
);
