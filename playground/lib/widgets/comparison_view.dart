// ABOUTME: ComparisonView widget for displaying side-by-side component comparisons
// ABOUTME: Shows Remix components alongside their Material Design equivalents with consistent spacing and labeling
import 'package:flutter/material.dart';
import 'spaced_column.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ComparisonSection(
          title: 'Remix',
          spacing: spacing,
          children: remix,
        ),
        SizedBox(width: sectionSpacing),
        _ComparisonSection(
          title: 'Material',
          spacing: spacing,
          children: material,
        ),
      ],
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: spacing),
        SpacedColumn(
          spacing: spacing,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ],
    );
  }
}