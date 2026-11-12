import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'badge.g.dart';

/// The visual weights this application offers for a badge.
enum PlaygroundBadgeVariant {
  /// Highest emphasis: a solid `primary` fill.
  primary,

  /// Medium emphasis: a solid `secondary` fill.
  secondary,

  /// Low emphasis: no fill, with the `border` hairline around it.
  outline,

  /// Highest emphasis for a problem the reader must notice.
  destructive,
}

/// The application's Badge recipe.
///
/// A badge is a static label, so it has no state fragments and no size: it
/// sits inline and reads at one scale.
@MixWidget(target: RemixBadge.new)
BadgeStyler playgroundBadgeStyle({
  PlaygroundBadgeVariant variant = .primary,
  BadgeStyler style = const BadgeStyler.create(),
}) {
  // Every variant draws the same hairline, transparent unless `outline`, so
  // badges of different variants share one height.
  final (:fill, :foreground, :outline) = switch (variant) {
    .primary => (
      fill: PlaygroundTokens.primary(),
      foreground: PlaygroundTokens.primaryForeground(),
      outline: _transparent,
    ),
    .secondary => (
      fill: PlaygroundTokens.secondary(),
      foreground: PlaygroundTokens.secondaryForeground(),
      outline: _transparent,
    ),
    // 60% in the dark theme, where `destructive` is too light to carry a
    // white label as a solid fill.
    .destructive => (
      fill: playgroundTint(PlaygroundTokens.destructive, 1, dark: 0.6)(),
      foreground: PlaygroundTokens.destructiveForeground(),
      outline: _transparent,
    ),
    .outline => (
      fill: _transparent,
      foreground: PlaygroundTokens.foreground(),
      outline: PlaygroundTokens.border(),
    ),
  };

  return BadgeStyler()
      .padding(
        .symmetric(
          horizontal: PlaygroundTokens.s2,
          vertical: PlaygroundTokens.s0_5,
        ),
      )
      .borderRadius(.all(_pill))
      .color(fill)
      .border(.color(outline).width(PlaygroundTokens.strokeHairline))
      .label(
        .style(
          PlaygroundTokens.textXs.mix(),
        ).fontWeight(FontWeight.w500).color(foreground),
      )
      .merge(style);
}

const _pill = Radius.circular(PlaygroundTokens.pill);

const _transparent = Color(0x00000000);
