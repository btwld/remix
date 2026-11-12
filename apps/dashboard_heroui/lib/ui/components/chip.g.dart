// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixBadge], used as a label-like chip.
class UiChip extends StatelessWidget {
  const UiChip({
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
  const UiChip.primary({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiChipVariant.primary;

  /// The neutral `default` fill under a colored label.
  const UiChip.secondary({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiChipVariant.secondary;

  /// A tinted fill in the chip's color.
  const UiChip.soft({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiChipVariant.soft;

  /// No fill, under a colored label.
  const UiChip.tertiary({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = UiChipVariant.tertiary;

  final UiChipVariant variant;

  final UiColor color;

  final UiChipSize size;

  final BadgeStyler style;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return RemixBadge(
      key: this.key,
      style: uiChipStyle(
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
