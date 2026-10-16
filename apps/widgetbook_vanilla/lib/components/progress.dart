import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Progress', type: VanillaProgress)
Widget buildVanillaProgressUseCase(BuildContext context) => Scaffold(
  body: Center(child: const SizedBox(width: 240, child: VanillaProgress(value: 0.68, semanticsLabel: '68 percent'))),
);
