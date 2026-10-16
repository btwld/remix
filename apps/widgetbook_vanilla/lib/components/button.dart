import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Button', type: VanillaButton)
Widget buildVanillaButtonUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: VanillaButton(label: 'Button', onPressed: () {}),
  ),
);
