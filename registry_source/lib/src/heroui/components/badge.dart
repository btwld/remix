import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// HeroUI badge variants: solid (`primary`), default fill with a coloured
/// label (`secondary`), and tinted (`soft`).
enum HeroUiBadgeVariant { primary, secondary, soft }

/// HeroUI badge sizes: `sm` is 16px at least, `md` 28px, `lg` 32px.
enum HeroUiBadgeSize { sm, md, lg }

/// The corner of the anchored content a badge sits on.
enum HeroUiBadgePlacement { topRight, topLeft, bottomRight, bottomLeft }

/// HeroUI's notification badge: a [RemixBadge] pinned to a corner of [child].
///
/// A null [label] draws the empty dot.
class HeroUiBadge extends StatelessWidget {
  const HeroUiBadge({
    super.key,
    required this.child,
    this.label,
    this.variant = .primary,
    this.color = .defaultColor,
    this.size = .md,
    this.placement = .topRight,
    this.style = const BadgeStyler.create(),
  });

  final Widget child;
  final String? label;
  final HeroUiBadgeVariant variant;
  final HeroUiColor color;
  final HeroUiBadgeSize size;
  final HeroUiBadgePlacement placement;
  final BadgeStyler style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _BadgeLayout(placement, _metrics(size).minSize),
            // Preserve intrinsic count/dot sizing within the anchor's width.
            child: IntrinsicWidth(
              child: RemixBadge(
                label: label ?? '',
                style: _style(
                  variant: variant,
                  color: color,
                  size: size,
                  style: style,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Counts retain HeroUI's quarter-outward shift. Longer text stays inside
/// the anchor horizontally, so its shift cannot push it beyond the page.
class _BadgeLayout extends SingleChildLayoutDelegate {
  const _BadgeLayout(this.placement, this.minSize);

  final HeroUiBadgePlacement placement;
  final double minSize;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints(maxWidth: constraints.maxWidth);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final onRight = placement == .topRight || placement == .bottomRight;
    final onTop = placement == .topRight || placement == .topLeft;
    final shiftX =
        childSize.width < size.width && childSize.width <= minSize * 2
        ? childSize.width / 4
        : 0.0;
    return Offset(
      onRight ? size.width - childSize.width + shiftX : -shiftX,
      onTop ? -childSize.height / 4 : size.height - childSize.height * .75,
    );
  }

  @override
  bool shouldRelayout(_BadgeLayout oldDelegate) =>
      placement != oldDelegate.placement || minSize != oldDelegate.minSize;
}

/// `.badge`, with the caller's [style] merged last.
BadgeStyler _style({
  required HeroUiBadgeVariant variant,
  required HeroUiColor color,
  required HeroUiBadgeSize size,
  required BadgeStyler style,
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant, color);
  var label = TextStyler()
      .style(metrics.text.mix())
      .height(metrics.lineHeight)
      .fontWeight(.w500)
      .color(palette.foreground)
      .softWrap(false)
      .maxLines(1)
      .overflow(TextOverflow.ellipsis);
  if (size == .sm) label = label.fontSize(_smFontSize);

  return BadgeStyler()
      .alignment(.center)
      .minWidth(metrics.minSize)
      .minHeight(metrics.minSize)
      .padding(.horizontal(_labelInset))
      .borderRadius(.all(metrics.radius))
      .border(.color(HeroUiTokens.background()).width(_borderWidth))
      .color(palette.fill)
      .label(label)
      .merge(style);
}

typedef _Metrics = ({
  double minSize,
  Radius radius,
  TextStyleToken text,
  double lineHeight,
});

/// `.badge` (`min-h-7 min-w-7 rounded-3xl text-xs leading-[1.34]`) and the
/// `--sm` / `--lg` overrides.
_Metrics _metrics(HeroUiBadgeSize size) => switch (size) {
  .sm => (
    minSize: 16,
    radius: HeroUiTokens.radiusXl(),
    text: HeroUiTokens.textXs,
    lineHeight: 1.34,
  ),
  .md => (
    minSize: 28,
    radius: HeroUiTokens.radius3xl(),
    text: HeroUiTokens.textXs,
    lineHeight: 1.34,
  ),
  .lg => (
    minSize: 32,
    radius: HeroUiTokens.radius2xl(),
    text: HeroUiTokens.textSm,
    lineHeight: 1.43,
  ),
};

/// `--sm` sets `text-[10px]` over the `text-xs` token; the other sizes use
/// their token's size.
const _smFontSize = 10.0;

/// `.badge__label` adds `px-0.5`; `border: 1px solid var(--background)`.
const _labelInset = 2.0;
const _borderWidth = 1.0;

/// The `--badge-bg` and `--badge-fg` variables for a variant and colour.
HeroUiColorPair _palette(HeroUiBadgeVariant variant, HeroUiColor color) =>
    switch (variant) {
      .primary => heroUiSolid(color),
      .secondary => (
        fill: HeroUiTokens.defaultColor(),
        foreground: heroUiLabelColor(color),
      ),
      .soft => heroUiSoft(color),
    };
