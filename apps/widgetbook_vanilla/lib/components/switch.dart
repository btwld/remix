import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Switch', type: VanillaSwitch)
Widget buildVanillaSwitchUseCase(BuildContext context) {
  var v = true;
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => VanillaSwitch(
          selected: v,
          semanticLabel: 'Notifications',
          onChanged: (value) => setState(() => v = value),
        ),
      ),
    ),
  );
}
