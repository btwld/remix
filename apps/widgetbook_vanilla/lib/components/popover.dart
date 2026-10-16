import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Popover', type: VanillaPopover)
Widget buildVanillaPopoverUseCase(BuildContext context) => Scaffold(
  body: Center(child: const VanillaPopover(popoverChild: Text('Quick note'), child: Text('Open popover'))),
);
