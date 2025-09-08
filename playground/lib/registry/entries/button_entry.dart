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
      const RemixButton(
        label: 'Disabled',
        enabled: false,
        onPressed: null,
      ),
      const RemixButton(
        label: 'Loading',
        loading: true,
        onPressed: null,
      ),
      RemixIconButton(
        icon: Icons.star,
        onPressed: () {},
        semanticLabel: 'Favorite',
      ),
    ],
    material: [
      ElevatedButton(
        onPressed: () {},
        child: const Text('Primary Button'),
      ),
      const ElevatedButton(
        onPressed: null,
        child: Text('Disabled'),
      ),
      // Simulated loading state for Material (no built-in loading flag)
      const ElevatedButton(
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
      IconButton(
        onPressed: () {},
        tooltip: 'Favorite',
        icon: const Icon(Icons.star),
      ),
    ],
  );
}

