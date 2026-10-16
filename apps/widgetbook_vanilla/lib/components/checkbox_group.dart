import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'CheckboxGroup', type: VanillaCheckboxGroupItem)
Widget buildVanillaCheckboxGroupUseCase(BuildContext context) {
  var values = <String>{'design'};
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => RemixCheckboxGroup<String>(
          values: values,
          onChanged: (next) => setState(() => values = next),
          semanticLabel: 'Interests',
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              VanillaCheckboxGroupItem<String>(
                value: 'design',
                label: 'Design',
              ),
              VanillaCheckboxGroupItem<String>(value: 'code', label: 'Code'),
              VanillaCheckboxGroupItem<String>(
                value: 'research',
                label: 'Research',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
