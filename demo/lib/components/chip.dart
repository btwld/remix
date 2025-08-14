import 'package:demo/addons/icon_data_knob.dart';
import 'package:demo/helpers/use_case_state.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Chip Component',
  type: RemixChip,
)
Widget buildChipUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);

  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: RemixChip(
          selected: context.knobs.boolean(label: 'Checked', initialValue: true),
          onSelected: (value) => knobState.updateKnob('Checked', value),
          label: context.knobs.string(
            label: 'Label',
            initialValue: 'Chip',
          ),
          enabled: context.knobs.boolean(
            label: 'Enabled',
            initialValue: true,
          ),
          leadingIcon: context.knobs.iconData(
            label: 'Leading Icon',
            initialValue: null,
          ),
          // Note: deleteIcon can be used for trailing icon
          deleteIcon: context.knobs.iconData(
            label: 'Delete Icon',
            initialValue: null,
          ),
        ),
      ),
    ),
  );
}
