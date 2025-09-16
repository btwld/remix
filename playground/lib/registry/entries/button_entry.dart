import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildButtonExample() {
  return ComparisonView(
    remix: [
      RemixButton(
        label: 'Primary Button',
        onPressed: () {},
      ),
      RemixButton(
        label: 'Disabled',
        onPressed: null,
      ),
      RemixButton(
        label: 'Loading',
        loading: true,
        onPressed: null,
      ),
      RemixButton(
        label: 'With Icon',
        icon: Icons.star,
        onPressed: () {},
      ),
      RemixIconButton(
        icon: Icons.star,
        onPressed: () {},
        semanticLabel: 'Favorite',
      ),
    ],
    material: [
      FilledButton(
        onPressed: () {},
        child: const Text('Primary Button'),
      ),
      const FilledButton(
        onPressed: null,
        child: Text('Disabled'),
      ),
      // Simulated loading state for Material (no built-in loading flag)
      const FilledButton(
        onPressed: null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 8),
            Text('Loading'),
          ],
        ),
      ),
      FilledButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.star, size: 18),
        label: const Text('With Icon'),
      ),
      IconButton.filled(
        onPressed: () {},
        tooltip: 'Favorite',
        iconSize: 16,
        icon: const Icon(Icons.star, size: 16),
      ),
    ],
  );
}
