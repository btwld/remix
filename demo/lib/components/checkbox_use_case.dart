import 'package:demo/helpers/use_case_state.dart';
import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
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
        child: _CheckboxPreview(
          label: context.knobs.string(label: 'Label', initialValue: 'Label'),
          enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
          selected: context.knobs.boolean(label: 'Checked', initialValue: true),
          onChanged: (value) => knobState.updateKnob('Checked', value),
        ),
      ),
    ),
  );
}

class _CheckboxPreview extends StatelessWidget {
  const _CheckboxPreview({
    required this.label,
    required this.enabled,
    required this.selected,
    this.onChanged,
  });

  final String label;
  final bool enabled;
  final bool selected;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemixCheckbox(
          enabled: enabled,
          selected: selected,
          onChanged: onChanged,
          semanticLabel: label,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
