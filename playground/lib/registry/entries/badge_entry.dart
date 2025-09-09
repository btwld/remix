import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildBadgeExample() {
  return SizedBox(
    width: 360,
    child: ComparisonView(
      remix: [
        RemixBadge(label: 'New'),
        const RemixBadge.raw(child: Text('Beta')),
      ],
      material: const [
        Chip(label: Text('New')),
        Chip(label: Text('Beta')),
      ],
    ),
  );
}
