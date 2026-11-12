import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'card.g.dart';

/// The application's Card recipe.
///
/// A surface that groups content: `card` fill (a step lighter than the page in
/// the dark theme), `border` hairline, large corners, a small shadow and a
/// 24px inset. It has no variant, size or state.
@MixWidget(target: RemixCard.new)
CardStyler playgroundCardStyle({
  CardStyler style = const CardStyler.create(),
}) => CardStyler()
    .color(PlaygroundTokens.card())
    .border(
      .color(PlaygroundTokens.border()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusXl()))
    .shadows(PlaygroundShadow.sm.box)
    .padding(.all(PlaygroundTokens.s6))
    .merge(style);
