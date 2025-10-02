import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildSpinnerExample() {
  return SizedBox(
    width: 360,
    child: ComparisonView(
      remix: [
        RemixSpinner(
          style: RemixSpinnerStyle(
            strokeWidth: 2,
          ),
        ),
        RemixSpinner(
          style: RemixSpinnerStyle(
            size: 32,
            strokeWidth: 2,
          ),
        ),
      ],
      material: const [
        CircularProgressIndicator(strokeWidth: 2),
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ],
    ),
  );
}
