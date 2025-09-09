import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import '../../widgets/comparison_view.dart';

Widget buildSelectExample() {
  const items = ['One', 'Two', 'Three'];

  List<DropdownMenuItem<String>> materialItems() => items
      .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
      .toList();

  return SizedBox(
    width: 320,
    child: ComparisonView(
      remix: [
        RemixSelect<String>(
          selectedValue: 'Two',
          onChanged: (_) {},
          items: items
              .map((e) => RemixSelectItem<String>(value: e, label: e))
              .toList(),
          child: const RemixSelectTrigger(label: 'Two'),
        ),
        RemixSelect<String>(
          enabled: false,
          selectedValue: 'Two',
          onChanged: (_) {},
          items: items
              .map((e) => RemixSelectItem<String>(value: e, label: e))
              .toList(),
          child: const RemixSelectTrigger(label: 'Two'),
        ),
      ],
      material: [
        DropdownButton<String>(
          value: 'Two',
          items: materialItems(),
          onChanged: (_) {},
        ),
        DropdownButton<String>(
          value: 'Two',
          items: materialItems(),
          onChanged: null,
        ),
      ],
    ),
  );
}
