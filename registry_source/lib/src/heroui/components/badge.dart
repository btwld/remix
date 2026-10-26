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
    // `.badge--top-right`: `absolute top-0 right-0` shifted by a quarter of
    // the badge's own size, outward.
    final (top, bottom, left, right, shift) = switch (placement) {
      .topRight => (0.0, null, null, 0.0, const Offset(.25, -.25)),
      .topLeft => (0.0, null, 0.0, null, const Offset(-.25, -.25)),
      .bottomRight => (null, 0.0, null, 0.0, const Offset(.25, .25)),
      .bottomLeft => (null, 0.0, 0.0, null, const Offset(-.25, .25)),
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: FractionalTranslation(
            translation: shift,
            // The badge centres its label in its minimum size, which would
            // otherwise fill the stack's loose constraints.
            child: UnconstrainedBox(
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

/// `.badge`, with the caller's [style] merged last.
BadgeStyler _style({
  required HeroUiBadgeVariant variant,
  required HeroUiColor color,
  required HeroUiBadgeSize size,
  required BadgeStyler style,
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant, color);

  return BadgeStyler()
      .alignment(.center)
      .minWidth(metrics.minSize)
      .minHeight(metrics.minSize)
      .padding(.horizontal(_labelInset))
      .borderRadius(.all(metrics.radius))
      .border(.color(HeroUiTokens.background()).width(_borderWidth))
      .color(palette.fill)
      .label(
        .style(metrics.text.mix())
            .fontSize(metrics.fontSize)
            .height(metrics.lineHeight)
            .fontWeight(.w500)
            .color(palette.foreground),
      )
      .merge(style);
}

typedef _Metrics = ({
  double minSize,
  Radius radius,
  TextStyleToken text,
  double fontSize,
  double lineHeight,
});

/// `.badge` (`min-h-7 min-w-7 rounded-3xl text-xs leading-[1.34]`) and the
/// `--sm` / `--lg` overrides.
_Metrics _metrics(HeroUiBadgeSize size) => switch (size) {
  .sm => (
    minSize: 16,
    radius: HeroUiTokens.radiusXl(),
    text: HeroUiTokens.textXs,
    fontSize: 10,
    lineHeight: 1.34,
  ),
  .md => (
    minSize: 28,
    radius: HeroUiTokens.radius3xl(),
    text: HeroUiTokens.textXs,
    fontSize: 12,
    lineHeight: 1.34,
  ),
  .lg => (
    minSize: 32,
    radius: HeroUiTokens.radius2xl(),
    text: HeroUiTokens.textSm,
    fontSize: 14,
    lineHeight: 1.43,
  ),
};

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
