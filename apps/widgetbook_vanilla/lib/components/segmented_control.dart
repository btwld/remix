import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'SegmentedControl', type: VanillaSegmentedControl)
Widget buildVanillaSegmentedControlUseCase(BuildContext context) {
  var selected = 'day';
  return Scaffold(
    body: Center(
      child: StatefulBuilder(
        builder: (context, setState) => VanillaSegmentedControl<String>(
          selectedValue: selected,
          onChanged: (value) => setState(() => selected = value),
          items: const [
            RemixSegmentedControlItem(value: 'day', label: 'Day'),
            RemixSegmentedControlItem(value: 'week', label: 'Week'),
            RemixSegmentedControlItem(value: 'month', label: 'Month'),
          ],
        ),
      ),
    ),
  );
}
