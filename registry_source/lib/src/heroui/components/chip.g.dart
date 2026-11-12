// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixBadge], used as a label-like chip.
class HeroUiChip extends StatelessWidget {
  const HeroUiChip({
    super.key,
    this.variant = .secondary,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  });

  /// The solid fill in the chip's color.
  const HeroUiChip.primary({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = HeroUiChipVariant.primary;

  /// The neutral `default` fill under a colored label.
  const HeroUiChip.secondary({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = HeroUiChipVariant.secondary;

  /// A tinted fill in the chip's color.
  const HeroUiChip.soft({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = HeroUiChipVariant.soft;

  /// No fill, under a colored label.
  const HeroUiChip.tertiary({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = HeroUiChipVariant.tertiary;

  final HeroUiChipVariant variant;

  final HeroUiColor color;

  final HeroUiChipSize size;

  final BadgeStyler style;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return RemixBadge(
      key: this.key,
      style: heroUiChipStyle(
        variant: this.variant,
        color: this.color,
        size: this.size,
        style: this.style,
      ),
      label: this.label,
      child: this.child,
      labelBuilder: this.labelBuilder,
    );
  }
}
