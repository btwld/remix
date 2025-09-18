import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import '../../widgets/comparison_view.dart';

Widget buildDividerExample() {
  Widget listWithDividers({required bool remix}) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Item 1'),
          remix ? const RemixDivider() : const Divider(),
          const Text('Item 2'),
          remix ? const RemixDivider() : const Divider(),
          const Text('Item 3'),
        ],
      );

  return SizedBox(
    width: 360,
    child: ComparisonView(
      remix: [listWithDividers(remix: true)],
      material: [listWithDividers(remix: false)],
    ),
  );
}
