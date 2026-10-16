import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Spinner', type: VanillaSpinner)
Widget buildVanillaSpinnerUseCase(BuildContext context) => Scaffold(
  body: Center(child: const VanillaSpinner(semanticsLabel: 'Loading')),
);
