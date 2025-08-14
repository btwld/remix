import 'package:demo/helpers/use_case_state.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix_new.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Checkbox Component',
  type: RemixCheckbox,
)
Widget buildCheckboxUseCase(BuildContext context) {
  final knobState = WidgetbookState.of(context);

  return Scaffold(
    body: KeyedSubtree(
      key: _key,
      child: Center(
        child: RemixCheckbox(
          label: context.knobs.string(label: 'Label', initialValue: 'Label'),
          enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
          selected: context.knobs.boolean(label: 'Checked', initialValue: true),
          onChanged: (value) => knobState.updateKnob('Checked', value),
        ),
      ),
    ),
  );
}
