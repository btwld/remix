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
typedef RemixBadgeLabelBuilder = Widget Function(
  BuildContext context,
  TextSpec spec,
  String label,
);

class RemixBadge extends StatelessWidget {
  /// Creates a badge widget. Provide [label] for a text badge or [child] for
  /// fully custom content. When nothing is provided, an empty label is used.
  const RemixBadge({
    super.key,
    this.label,
    this.child,
    this.labelBuilder,
    this.style = const RemixBadgeStyle.create(),
  });

  /// Optional text label rendered with the badge text style.
  final String? label;

  /// Optional fully custom badge content. When provided the badge style is
  /// applied only to the container.
  final Widget? child;

  /// Optional builder that receives the resolved [TextSpec] so callers can
  /// render text with custom widgets while preserving badge typography.
  final RemixBadgeLabelBuilder? labelBuilder;

  /// The style configuration for the badge.
  final RemixBadgeStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder<BadgeSpec>(
      style: style,
      builder: (context, spec) {
        final containerBuilder = spec.container.createWidget;

        Widget? content = child;
        final resolvedLabel = label ?? '';

        if (content == null) {
          content = StyleSpecBuilder<TextSpec>(
            styleSpec: spec.text,
            builder: (context, textSpec) {
              if (labelBuilder != null) {
                return labelBuilder!(context, textSpec, resolvedLabel);
              }

              return textSpec.createWidget(resolvedLabel);
            },
          );
        }

        return containerBuilder(child: content);
      },
    );
  }
}
