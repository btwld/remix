// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui Badge recipe.
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
  Widget build(BuildContext context) {
    return RemixBadge(
      key: this.key,
      style: uiBadgeStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      label: this.label,
      child: this.child,
      labelBuilder: this.labelBuilder,
    );
  }
}
