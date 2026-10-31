import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'card.g.dart';

/// HeroUI card fills: `defaultCard` is HeroUI's `default` on the surface
/// colour; `transparent` has neither fill nor shadow.
enum HeroUiCardVariant { defaultCard, secondary, tertiary, transparent }

/// HeroUI recipe for [RemixCard].
///
/// Lay the content out with a column spaced 12px (`gap-3`); [HeroUiCardTitle]
/// and [HeroUiCardDescription] carry the header's text styles.
@MixWidget(target: RemixCard.new)
CardStyler heroUiCardStyle({
  HeroUiCardVariant variant = .defaultCard,
  CardStyler style = const CardStyler.create(),
}) {
  var result = CardStyler()
      .padding(.all(_padding))
      .borderRadius(.all(HeroUiTokens.radiusPanel()));
  final fill = switch (variant) {
    .defaultCard => HeroUiTokens.surface(),
    .secondary => HeroUiTokens.surfaceSecondary(),
    .tertiary => HeroUiTokens.surfaceTertiary(),
    .transparent => null,
  };
  // The transparent card has neither fill nor `shadow-surface`.
  if (fill != null) {
    result = result.color(fill).containerEffects(heroUiSurfaceEffects());
  }
  return result.merge(style);
}

/// `p-4`.
const _padding = 16.0;

/// `leading-6` over the `text-sm` token's 14px.
const _titleHeight = 24 / 14;

/// `.card__title`: `text-sm leading-6 font-medium text-foreground`.
class HeroUiCardTitle extends StatelessWidget {
  const HeroUiCardTitle(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  });

  final String text;
  final TextStyler style;

  @override
  Widget build(BuildContext context) => StyledText(
    text,
    style: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .height(_titleHeight)
        .fontWeight(.w500)
        .color(HeroUiTokens.foreground())
        .merge(style),
  );
}

/// `.card__description`: `text-sm leading-5 text-muted`; the `text-sm` token
/// already carries `leading-5`.
class HeroUiCardDescription extends StatelessWidget {
  const HeroUiCardDescription(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  });

  final String text;
  final TextStyler style;

  @override
  Widget build(BuildContext context) => StyledText(
    text,
    style: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .color(HeroUiTokens.muted())
        .merge(style),
  );
}
