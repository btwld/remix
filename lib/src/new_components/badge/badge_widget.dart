part of 'badge.dart';

/// A badge widget that can display a label with an optional icon.
///
/// Badges are used to display small amounts of information, such as
/// notification counts, status indicators, or labels.
///
/// ## Example
///
/// ```dart
/// RemixBadge(
///   label: 'New',
///   icon: Icons.star,
/// )
/// ```
class RemixBadge extends StatelessWidget {
  /// Creates a badge widget.
  const RemixBadge({
    super.key,
    this.label,
    this.icon,
    this.style = const BadgeStyle.create(),
  });

  /// The text label to display in the badge.
  final String? label;

  /// The icon to display in the badge.
  final IconData? icon;

  /// The style configuration for the badge.
  final BadgeStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultBadgeStyle.merge(style),
      builder: (context, spec) {
        // Build content with label and/or icon
        Widget? content;

        if (label != null || icon != null) {
          // Use the migrated RemixLabel for consistent text/icon layout
          content = RemixLabel(
            label ?? '',
            icon: icon,
            style: LabelStyle(
              spacing: 4,
              label: TextMix.maybeValue(spec.text),
              icon: IconMix.maybeValue(spec.icon),
            ),
          );
        }

        return spec.container(child: content);
      },
    );
  }
}
