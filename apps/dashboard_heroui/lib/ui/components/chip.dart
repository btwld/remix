import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'chip.g.dart';

/// HeroUI chip variants.
enum UiChipVariant {
  /// The solid fill in the chip's color.
  primary,

  /// The neutral `default` fill under a colored label.
  secondary,

  /// A tinted fill in the chip's color.
  soft,

  /// No fill, under a colored label.
  tertiary,
}

/// HeroUI chip sizes.
enum UiChipSize {
  /// 20px tall.
  sm,

  /// 24px tall. The default.
  md,

  /// 28px tall.
  lg,
}

/// HeroUI recipe for [RemixBadge], used as a label-like chip.
@MixWidget(target: RemixBadge.new)
BadgeStyler uiChipStyle({
  UiChipVariant variant = .secondary,
  UiColor color = .defaultColor,
  UiChipSize size = .md,
  BadgeStyler style = const BadgeStyler.create(),
}) {
  final metrics = _metrics(size);
  final palette = _palette(variant, color);

  return BadgeStyler()
      .padding(
        .symmetric(
          horizontal: metrics.paddingX + _labelInset,
          vertical: metrics.paddingY,
        ),
      )
      .borderRadius(.all(UiTokens.radius2xl()))
      .color(palette.fill)
      .label(
        .style(metrics.text.mix())
            .height(_lineHeight / metrics.fontSize)
            .fontWeight(.w500)
            .color(palette.foreground),
      )
      .merge(style);
}

typedef _Metrics = ({
  double paddingX,
  double paddingY,
  TextStyleToken text,
  double fontSize,
});

/// `.chip` (`px-2 py-0.5 text-xs`) and the `--sm` / `--lg` overrides.
_Metrics _metrics(UiChipSize size) => switch (size) {
  .sm => (paddingX: 4, paddingY: 0, text: UiTokens.textXs, fontSize: 12),
  .md => (paddingX: 8, paddingY: 2, text: UiTokens.textXs, fontSize: 12),
  .lg => (paddingX: 12, paddingY: 4, text: UiTokens.textSm, fontSize: 14),
};

/// `leading-5`, kept by every size. The font size repeats the `text` token's so
/// the line height can be a ratio.
const _lineHeight = 20.0;

/// `.chip__label` adds `px-0.5` around the text.
const _labelInset = 2.0;

/// The `--chip-bg` and `--chip-fg` variables for a variant and color.
UiColorPair _palette(UiChipVariant variant, UiColor color) => switch (variant) {
  .primary => uiSolid(color),
  .secondary => (
    fill: UiTokens.defaultColor(),
    foreground: uiLabelColor(color),
  ),
  .soft => uiSoft(color),
  .tertiary => (fill: UiTokens.transparent, foreground: uiLabelColor(color)),
};
