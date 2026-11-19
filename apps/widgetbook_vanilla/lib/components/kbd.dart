import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Kbd', type: VanillaKbd)
Widget buildVanillaKbdUseCase(BuildContext context) => Scaffold(
  body: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        const VanillaKbdGroup(
          children: [
            VanillaKbd('⌘'),
            VanillaKbd('⇧'),
            VanillaKbd('⌥'),
            VanillaKbd('⌃'),
          ],
        ),
        const VanillaKbdGroup(
          children: [VanillaKbd('Ctrl'), Text('+'), VanillaKbd('B')],
        ),
        // Inside a tooltip's inverted content, the key takes its tooltip cap.
        VanillaTooltip(
          tooltipChild: const Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [Text('Save changes'), VanillaKbd.tooltip('S')],
          ),
          child: VanillaButton.outline(label: 'Save', onPressed: () {}),
        ),
      ],
    ),
  ),
);
