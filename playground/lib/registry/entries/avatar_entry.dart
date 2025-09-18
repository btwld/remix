import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildAvatarExample() {
  return SizedBox(
    width: 360,
    child: ComparisonView(
      remix: [
        RemixAvatar(label: 'AB'),
        RemixAvatar(child: const Icon(Icons.person)),
      ],
      material: const [
        CircleAvatar(child: Text('AB')),
        CircleAvatar(child: Icon(Icons.person)),
      ],
    ),
  );
}
