import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Card', type: VanillaCard)
Widget buildVanillaCardUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: const VanillaCard(
      child: Padding(padding: EdgeInsets.all(16), child: Text('Card')),
    ),
  ),
);
