import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'ToggleGroup', type: VanillaToggleGroup)
Widget buildVanillaToggleGroupUseCase(BuildContext context) {
  String? selected = 'list';
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => VanillaToggleGroup<String>(
          variant: VanillaToggleGroupVariant.outline,
          selectedValue: selected,
          onChanged: (value) => setState(() => selected = value),
          items: const [
            RemixToggleGroupItem(value: 'list', label: 'List'),
            RemixToggleGroupItem(value: 'grid', label: 'Grid'),
            RemixToggleGroupItem(value: 'board', label: 'Board'),
          ],
        ),
      ),
    ),
  );
}
