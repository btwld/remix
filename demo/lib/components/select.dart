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

  final styleItems = FortalSelectStyle(variant).items;
  final styleSelect = FortalSelectStyle(variant).select;

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: RemixSelect<String>(
            style: styleSelect,
            trigger: RemixSelectTrigger(
              placeholder: context.knobs.string(
                label: 'Placeholder',
                initialValue: 'Select item...',
              ),
            ),
            selectedValue: context.knobs.string(
              label: 'Selected Value',
              initialValue: 'Apple',
            ),
            onChanged: (value) {
              // Handle selection change
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
          ),
        ),
      ),
    ),
  );
}
