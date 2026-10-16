import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Switch', type: VanillaSwitch)
Widget buildVanillaSwitchUseCase(BuildContext context) => Scaffold(
  body: Center(child: StatefulBuilder(builder: (context, setState) { var v = true; return VanillaSwitch(selected: v, semanticLabel: 'Notifications', onChanged: (value) => setState(() => v = value)); })),
);
