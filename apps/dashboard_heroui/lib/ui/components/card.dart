import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'card.g.dart';

/// HeroUI card fills, each a surface level of the theme.
enum UiCardVariant {
  /// The `surface` fill.
  defaultCard,

  /// The slightly darker `surface-secondary` fill.
  secondary,

  /// The darkest `surface-tertiary` fill.
  tertiary,

  /// No fill and no shadow.
  transparent,
}

/// HeroUI recipe for [RemixCard].
///
/// Lay the content out with a column spaced 12px (`gap-3`); [UiCardTitle]
/// and [UiCardDescription] carry the header's text styles.
@MixWidget(target: RemixCard.new)
CardStyler uiCardStyle({
  UiCardVariant variant = .defaultCard,
  CardStyler style = const CardStyler.create(),
}) {
  final fill = switch (variant) {
    .defaultCard => UiTokens.surface(),
    .secondary => UiTokens.surfaceSecondary(),
    .tertiary => UiTokens.surfaceTertiary(),
    .transparent => null,
  };

  return CardStyler()
      .padding(.all(_padding))
      .borderRadius(.all(UiTokens.radiusPanel()))
      // The transparent card has neither fill nor `shadow-surface`.
      .merge(
        fill == null
            ? null
            : CardStyler().color(fill).containerEffects(uiSurfaceEffects()),
      )
      .merge(style);
}

/// `p-4`.
const _padding = 16.0;

/// `leading-6` over the `text-sm` token's 14px.
const _titleHeight = 24 / 14;

/// `.card__title`: `text-sm leading-6 font-medium text-foreground`.
class UiCardTitle extends StatelessWidget {
  const UiCardTitle(
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
        .style(UiTokens.textSm.mix())
        .height(_titleHeight)
        .fontWeight(.w500)
        .color(UiTokens.foreground())
        .merge(style),
  );
}

/// `.card__description`: `text-sm leading-5 text-muted`; the `text-sm` token
/// already carries `leading-5`.
class UiCardDescription extends StatelessWidget {
  const UiCardDescription(
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
        .style(UiTokens.textSm.mix())
        .color(UiTokens.muted())
        .merge(style),
  );
}
