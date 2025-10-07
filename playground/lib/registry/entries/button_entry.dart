import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../../widgets/comparison_view.dart';

Widget buildButtonExample() {
  return ComparisonView(
    remix: [
      RemixButton(
        label: 'Primary Button',
        onPressed: () {},
        style: RemixButtonStyle()
            .paddingX(16)
            .paddingY(10)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFF1F2937))
            .labelColor(Colors.white),
      ),
      RemixButton(
        label: 'Disabled',
        onPressed: null,
        style: RemixButtonStyle()
            .paddingX(16)
            .paddingY(10)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFFE5E7EB))
            .labelColor(const Color(0xFF9CA3AF)),
      ),
      RemixButton(
        label: 'Loading',
        loading: true,
        onPressed: () {},
        style: RemixButtonStyle()
            .paddingX(16)
            .paddingY(10)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFF1F2937).withValues(alpha: 0.6))
            .labelColor(Colors.white.withValues(alpha: 0.7))
            .spinnerIndicatorColor(Colors.white),
      ),
      RemixButton(
        label: 'With Icon',
        icon: Icons.star,
        onPressed: () {},
        style: RemixButtonStyle()
            .paddingX(16)
            .paddingY(10)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFF1F2937))
            .labelColor(Colors.white)
            .iconColor(Colors.white),
      ),
      RemixIconButton(
        icon: Icons.star,
        onPressed: () {},
        semanticLabel: 'Favorite',
        style: RemixIconButtonStyle()
            .paddingAll(10)
            .borderRadiusAll(const Radius.circular(8))
            .color(const Color(0xFF1F2937))
            .iconColor(Colors.white),
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
