import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Select Component',
  type: RemixSelect,
)
Widget buildSelectUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown(
    label: 'variant',
    options: FortalSelectVariant.values,
    labelBuilder: (variant) => variant.name,
  );
  final size = context.knobs.object.dropdown(
    label: 'size',
    options: FortalSelectSize.values,
    labelBuilder: (size) => size.name,
    initialOption: FortalSelectSize.size3,
  );

  final styleSelect = FortalSelectStyles.create(variant: variant, size: size);
  final styleItems =
      FortalSelectItemStyles.create(variant: variant, size: size);
  String selectedValue = 'Apple';
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: StatefulBuilder(builder: (context, setState) {
            return RemixSelect<String>(
              style: styleSelect,
              trigger: RemixSelectTrigger(
                placeholder: context.knobs.string(
                  label: 'Placeholder',
                  initialValue: 'Select item...',
                ),
              ),
              selectedValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value ?? 'Apple';
                });
              },
              items: [
                RemixSelectItem<String>(
                  value: 'Apple',
                  label: 'Apple',
                  style: styleItems,
                ),
                RemixSelectItem<String>(
                  value: 'Banana',
                  label: 'Banana',
                  style: styleItems,
                ),
                RemixSelectItem<String>(
                  value: 'Orange',
                  label: 'Orange',
                  style: styleItems,
                ),
              ],
            );
          }),
        ),
      ),
    ),
  );
}
