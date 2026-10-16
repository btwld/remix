import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Text Area', type: VanillaTextArea)
Widget buildVanillaTextAreaUseCase(BuildContext context) => Scaffold(
  body: Center(child: const SizedBox(width: 280, child: VanillaTextArea(label: 'Notes', hintText: 'Write a note'))),
);
