part of 'badge.dart';

/// Builder for rendering badge label content with the resolved text spec.
typedef RemixBadgeLabelBuilder =
    Widget Function(BuildContext context, TextSpec spec, String label);

/// A badge widget that displays compact text or custom content.
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
  /// Creates a badge widget. Provide [label] for a text badge or [child] for
  /// fully custom content. When nothing is provided, an empty label is used.
  const RemixBadge({
    super.key,
    this.label,
    this.child,
    this.labelBuilder,
    this.style = const RemixBadgeStyler.create(),
    this.styleSpec,
  });

  static final styleFrom = RemixBadgeStyler.new;

  /// Optional text label rendered with the badge text style.
  final String? label;

  /// Optional fully custom badge content. When provided the badge style is
  /// applied only to the container.
  final Widget? child;

  /// Optional builder that receives the resolved [TextSpec] so callers can
  /// render text with custom widgets while preserving badge typography.
  final RemixBadgeLabelBuilder? labelBuilder;

  /// The style configuration for the badge.
  final RemixBadgeStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final RemixBadgeSpec? styleSpec;

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<RemixBadgeSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        Widget? content = child;
        final resolvedLabel = label ?? '';

        if (content == null) {
          content = labelBuilder == null
              ? StyledText(resolvedLabel, styleSpec: spec.label)
              : StyleSpecBuilder<TextSpec>(
                  styleSpec: spec.label,
                  builder: (context, textSpec) =>
                      labelBuilder!(context, textSpec, resolvedLabel),
                );
        }

        return Box(styleSpec: spec.container, child: content);
      },
    );
  }
}
