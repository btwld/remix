// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Badge recipe.
///
/// A badge is a static label, so it has no state fragments and no size: it
/// sits inline and reads at one scale.
class VanillaBadge extends StatelessWidget {
  const VanillaBadge({
    super.key,
    this.variant = .primary,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  });

  /// Highest emphasis: a solid `primary` fill.
  const VanillaBadge.primary({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = VanillaBadgeVariant.primary;

  /// Medium emphasis: a solid `secondary` fill.
  const VanillaBadge.secondary({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = VanillaBadgeVariant.secondary;

  /// Low emphasis: no fill, with the `border` hairline around it.
  const VanillaBadge.outline({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = VanillaBadgeVariant.outline;

  /// Highest emphasis for a problem the reader must notice.
  const VanillaBadge.destructive({
    super.key,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = VanillaBadgeVariant.destructive;

  final VanillaBadgeVariant variant;

  final BadgeStyler style;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return RemixBadge(
      key: this.key,
      style: vanillaBadgeStyle(variant: this.variant, style: this.style),
      label: this.label,
      child: this.child,
      labelBuilder: this.labelBuilder,
    );
  }
}
