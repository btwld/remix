import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Button Showcase',
  type: RemixButton,
)
Widget buildButtonShowcase(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Button Variants',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Colors section
            _buildSection(
              'Colors',
              [
                _buildButtonRow('Primary', ButtonColor.primary),
                _buildButtonRow('Secondary', ButtonColor.secondary),
                _buildButtonRow('Success', ButtonColor.success),
                _buildButtonRow('Danger', ButtonColor.danger),
                _buildButtonRow('Warning', ButtonColor.warning),
                _buildButtonRow('Neutral', ButtonColor.neutral),
              ],
            ),
            
            // Sizes section
            _buildSection(
              'Sizes',
              [
                _buildSizeRow(),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}

Widget _buildButtonRow(String colorName, ButtonColor color) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          colorName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            RemixButton(
              label: 'Solid',
              icon: Icons.star,
              onPressed: () => debugPrint('$colorName solid pressed'),
              style: ButtonVariants.variant(
                variant: ButtonVariant.solid,
                color: color,
              ),
            ),
            RemixButton(
              label: 'Outline',
              icon: Icons.star_border,
              onPressed: () => debugPrint('$colorName outline pressed'),
              style: ButtonVariants.variant(
                variant: ButtonVariant.outline,
                color: color,
              ),
            ),
            RemixButton(
              label: 'Ghost',
              icon: Icons.star_outline,
              onPressed: () => debugPrint('$colorName ghost pressed'),
              style: ButtonVariants.variant(
                variant: ButtonVariant.ghost,
                color: color,
              ),
            ),
            RemixButton(
              label: 'Soft',
              icon: Icons.star_half,
              onPressed: () => debugPrint('$colorName soft pressed'),
              style: ButtonVariants.variant(
                variant: ButtonVariant.soft,
                color: color,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildSizeRow() {
  return Wrap(
    spacing: 12,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      RemixButton(
        label: 'Small',
        icon: Icons.circle,
        onPressed: () => debugPrint('Small button pressed'),
        style: ButtonVariants.variant(
          size: ButtonSize.small,
          color: ButtonColor.primary,
        ),
      ),
      RemixButton(
        label: 'Medium',
        icon: Icons.circle,
        onPressed: () => debugPrint('Medium button pressed'),
        style: ButtonVariants.variant(
          size: ButtonSize.medium,
          color: ButtonColor.primary,
        ),
      ),
      RemixButton(
        label: 'Large',
        icon: Icons.circle,
        onPressed: () => debugPrint('Large button pressed'),
        style: ButtonVariants.variant(
          size: ButtonSize.large,
          color: ButtonColor.primary,
        ),
      ),
    ],
  );
}