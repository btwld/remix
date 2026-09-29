import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'card.g.dart';

/// The application's Card recipe.
///
/// A card is a surface that groups related content. Everything visual about
/// it lives in this function; Remix owns nothing but the rendering, because a
/// card has no interaction and no state of its own.
///
/// It takes no variant and no size. A card is one surface, and its content
/// decides how tall it is — an axis with nothing behind it would only be one
/// more thing to keep consistent.
///
/// It is the `card` surface — the page color in the light theme and a step
/// lighter than the page in the dark one — with a `border` hairline, large
/// corners, a small shadow, and a 24px inset. `card` is one of the vocabulary's
/// thirty-three tokens precisely so a theme can set cards apart from the page
/// without touching this recipe.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// PlaygroundCard(
///   style: CardStyler().color(PlaygroundTokens.muted()),
///   child: summary,
/// )
/// ```
@MixWidget(target: RemixCard.new)
CardStyler playgroundCardStyle({
  CardStyler style = const CardStyler.create(),
}) => CardStyler()
    .color(PlaygroundTokens.card())
    .border(.color(PlaygroundTokens.border()).width(PlaygroundStroke.hairline))
    .borderRadius(.all(PlaygroundTokens.radiusXl()))
    .shadows(PlaygroundShadow.sm.box)
    .padding(.all(PlaygroundSpace.s6))
    .merge(style);
