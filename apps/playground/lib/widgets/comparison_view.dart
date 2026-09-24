import 'package:flutter/material.dart';
import 'spaced_column.dart';

const _sideBySideBreakpoint = 520.0;

class ComparisonView extends StatelessWidget {
  final List<Widget> remix;
  final List<Widget> material;
  final double spacing;
  final double sectionSpacing;

  const ComparisonView({
    super.key,
    required this.remix,
    required this.material,
    this.spacing = 12.0,
    this.sectionSpacing = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final sections = [
      _ComparisonSection(title: 'Remix', spacing: spacing, children: remix),
      _ComparisonSection(
        title: 'Material',
        spacing: spacing,
        children: material,
      ),
    ];

    // Side by side needs room for both columns. The mobile preset is 375
    // logical pixels, which several entries overflow, so stack there instead
    // of clipping content the preview exists to show.
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _sideBySideBreakpoint) {
          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              sections.first,
              SizedBox(height: sectionSpacing),
              sections.last,
            ],
          );
        }

        return Row(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            sections.first,
            SizedBox(width: sectionSpacing),
            sections.last,
          ],
        );
      },
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final double spacing;

  const _ComparisonSection({
    required this.title,
    required this.children,
    required this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing),
        SpacedColumn(
          spacing: spacing,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: children,
        ),
      ],
    );
  }
}
