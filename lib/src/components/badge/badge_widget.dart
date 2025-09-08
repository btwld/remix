part of 'badge.dart';

/// A badge widget that displays a label.
///
/// Badges are used to display small amounts of information, such as
/// notification counts, status indicators, or labels.
///
/// ## Example
///
/// ```dart
/// RemixBadge(
///   label: 'New',
/// )
/// ```
class RemixBadge extends StatelessWidget {
  /// Creates a badge widget.
  RemixBadge({
    super.key,
    String? label,
    this.style = const RemixBadgeStyle.create(),
  }) : child = Text(label ?? '');

  /// Creates a badge with custom content.
  const RemixBadge.raw({
    super.key,
    this.style = const RemixBadgeStyle.create(),
    required this.child,
  });

  /// The child widget to display in the badge.
  final Widget child;

  /// The style configuration for the badge.
  final RemixBadgeStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RemixBadgeStyles.baseStyle.merge(style),
      builder: (context, spec) {
        final Container = spec.container.createWidget;

        return Container(child: child);
      },
    );
  }
}
