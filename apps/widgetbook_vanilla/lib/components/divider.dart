import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Divider', type: VanillaDivider)
Widget buildVanillaDividerUseCase(BuildContext context) => Scaffold(
  body: Center(child: const SizedBox(width: 200, child: VanillaDivider())),
);
