import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildRadioExample() {
  return const SizedBox(
    width: 360,
    child: ComparisonView(
      remix: [
        _RemixRadioGroupPreview(),
      ],
      material: [
        _MaterialRadioGroupPreview(),
      ],
    ),
  );
}

class _RemixRadioGroupPreview extends StatelessWidget {
  const _RemixRadioGroupPreview();

  @override
  Widget build(BuildContext context) {
    const groupValue = 'B';
    return RemixRadioGroup<String>(
      groupValue: groupValue,
      onChanged: (_) {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _RemixLabeledRadio(value: 'A', label: 'Option A'),
          _RemixLabeledRadio(value: 'B', label: 'Option B'),
          _RemixLabeledRadio(
            value: 'C',
            label: 'Disabled',
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _RemixLabeledRadio extends StatelessWidget {
  const _RemixLabeledRadio({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  final String value;
  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemixRadio<String>(
          value: value,
          enabled: enabled,
          semanticLabel: label,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}

class _MaterialRadioGroupPreview extends StatelessWidget {
  const _MaterialRadioGroupPreview();

  @override
  Widget build(BuildContext context) {
    const groupValue = 'B';
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LabeledRadio(
                value: 'A', label: 'Option A', groupValue: groupValue),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LabeledRadio(
                value: 'B', label: 'Option B', groupValue: groupValue),
          ],
        ),
        _LabeledRadio(
            value: 'C',
            label: 'Disabled',
            groupValue: groupValue,
            enabled: false),
      ],
    );
  }
}

class _LabeledRadio extends StatelessWidget {
  const _LabeledRadio({
    required this.value,
    required this.label,
    required this.groupValue,
    this.enabled = true,
  });

  final String value;
  final String label;
  final String groupValue;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: enabled ? (_) {} : null,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
