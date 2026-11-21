// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Badge recipe.
///
/// It reads top to bottom: the size, then the variant's colors.
///
/// [highContrast] strengthens a variant: the solid fill, and the text of every
/// other variant, move to accent step 12.
class UiBadge extends StatelessWidget {
  const UiBadge({
    super.key,
    this.variant = .soft,
    this.size = .size1,
    this.highContrast = false,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  });

  /// The accent's solid fill under its contrast label.
  const UiBadge.solid({
    super.key,
    this.size = .size1,
    this.highContrast = false,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiBadgeVariant.solid;

  /// A tinted accent fill under accent text.
  const UiBadge.soft({
    super.key,
    this.size = .size1,
    this.highContrast = false,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiBadgeVariant.soft;

  /// A faint accent surface inside a 1px accent frame.
  const UiBadge.surface({
    super.key,
    this.size = .size1,
    this.highContrast = false,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiBadgeVariant.surface;

  /// No fill inside a 1px accent frame.
  const UiBadge.outline({
    super.key,
    this.size = .size1,
    this.highContrast = false,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiBadgeVariant.outline;

  final UiBadgeVariant variant;

  final UiBadgeSize size;

  final bool highContrast;

  final BadgeStyler style;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext _) {
    return RemixBadge(
      style: uiBadgeStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      label: label,
      labelBuilder: labelBuilder,
      child: child,
    );
  }
}
