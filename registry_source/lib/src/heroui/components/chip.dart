import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'chip.g.dart';

/// HeroUI chip variants: solid (`primary`), default fill with a coloured label
/// (`secondary`), tinted (`soft`), and unfilled (`tertiary`).
enum HeroUiChipVariant { primary, secondary, soft, tertiary }

/// HeroUI chip sizes: `sm` is 20px tall, `md` 24px, `lg` 28px.
enum HeroUiChipSize { sm, md, lg }

/// HeroUI recipe for [RemixBadge], used as a label-like chip.
@MixWidget(target: RemixBadge.new)
BadgeStyler heroUiChipStyle({
  HeroUiChipVariant variant = .secondary,
  HeroUiColor color = .defaultColor,
  HeroUiChipSize size = .md,
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
      .borderRadius(.all(HeroUiTokens.radius2xl()))
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
_Metrics _metrics(HeroUiChipSize size) => switch (size) {
  .sm => (paddingX: 4, paddingY: 0, text: HeroUiTokens.textXs, fontSize: 12),
  .md => (paddingX: 8, paddingY: 2, text: HeroUiTokens.textXs, fontSize: 12),
  .lg => (paddingX: 12, paddingY: 4, text: HeroUiTokens.textSm, fontSize: 14),
};

/// `leading-5`, kept by every size. The font size repeats the `text` token's so
/// the line height can be a ratio.
const _lineHeight = 20.0;

/// `.chip__label` adds `px-0.5` around the text.
const _labelInset = 2.0;

/// The `--chip-bg` and `--chip-fg` variables for a variant and colour.
HeroUiColorPair _palette(HeroUiChipVariant variant, HeroUiColor color) =>
    switch (variant) {
      .primary => heroUiSolid(color),
      .secondary => (
        fill: HeroUiTokens.defaultColor(),
        foreground: heroUiLabelColor(color),
      ),
      .soft => heroUiSoft(color),
      .tertiary => (
        fill: HeroUiTokens.transparent,
        foreground: heroUiLabelColor(color),
      ),
    };
