import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Tooltip', type: VanillaTooltip)
Widget buildVanillaTooltipUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: const VanillaTooltip(
      tooltipChild: Text('Search'),
      child: Text('Hover me'),
    ),
  ),
);
