// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixBadge]: a pill with a quiet border and a 12px label.
///
/// [DeuiColor.defaultColor] is the plain badge, muted text in a hairline
/// border. Any other colour tints the fill to 10% and the border to 25% and
/// colours the label, as deui's status badges do. [style] merges last.
class DeuiBadge extends StatelessWidget {
  const DeuiBadge({
    super.key,
    this.color = .defaultColor,
    this.style = const BadgeStyler.create(),
    this.label,
    this.child,
    this.labelBuilder,
  });

  final DeuiColor color;

  final BadgeStyler style;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return RemixBadge(
      key: this.key,
      style: deuiBadgeStyle(color: this.color, style: this.style),
      label: this.label,
      child: this.child,
      labelBuilder: this.labelBuilder,
    );
  }
}
