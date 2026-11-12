// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Badge recipe.
///
/// A badge is a static label, so it has no state fragments and no size: it
/// sits inline and reads at one scale.
class PlaygroundBadge extends StatelessWidget {
  const PlaygroundBadge({
    super.key,
    this.variant = .primary,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  });

  /// Highest emphasis: a solid `primary` fill.
  const PlaygroundBadge.primary({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = PlaygroundBadgeVariant.primary;

  /// Medium emphasis: a solid `secondary` fill.
  const PlaygroundBadge.secondary({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = PlaygroundBadgeVariant.secondary;

  /// Low emphasis: no fill, with the `border` hairline around it.
  const PlaygroundBadge.outline({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = PlaygroundBadgeVariant.outline;

  /// Highest emphasis for a problem the reader must notice.
  const PlaygroundBadge.destructive({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = PlaygroundBadgeVariant.destructive;

  final PlaygroundBadgeVariant variant;

  final BadgeStyler style;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return RemixBadge(
      key: this.key,
      style: playgroundBadgeStyle(variant: this.variant, style: this.style),
      label: this.label,
      child: this.child,
      labelBuilder: this.labelBuilder,
    );
  }
}
