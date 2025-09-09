import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildCheckboxExample() {
  return SizedBox(
    width: 360,
    child: ComparisonView(
      remix: const [
        RemixCheckbox(selected: true, onChanged: _noopNullable),
        RemixCheckbox(selected: false, onChanged: _noopNullable),
        RemixCheckbox(tristate: true, selected: null, onChanged: _noopNullable),
        RemixCheckbox(
            selected: true, label: 'With label', onChanged: _noopNullable),
        RemixCheckbox(selected: false, enabled: false),
      ],
      material: [
        Checkbox(value: true, onChanged: (_) {}),
        Checkbox(value: false, onChanged: (_) {}),
        Checkbox(tristate: true, value: null, onChanged: (_) {}),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: true, onChanged: (_) {}),
            const SizedBox(width: 8),
            const Text('With label'),
          ],
        ),
        const Checkbox(value: false, onChanged: null),
      ],
    ),
  );
}

void _noopNullable(bool? _) {}
