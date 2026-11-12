import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'typography.dart';

part 'text.g.dart';

/// The Fortal Text recipe: body text on the nine-step text scale.
///
/// Neutral text is gray 12; [accent] takes the accent's text color, and
/// [highContrast] moves that to accent step 12. [truncate] wins over
/// [softWrap] and forces one ellipsized line.
@MixWidget()
TextStyler fortalTextStyle({
  FortalTextSize? size,
  FortalTextWeight? weight,
  TextAlign? align,
  bool softWrap = true,
  bool truncate = false,
  bool accent = false,
  bool highContrast = false,
  TextStyler style = const TextStyler.create(),
}) {
  final text = TextStyler()
      .style(fortalTextSizeToken(size ?? FortalTextSize.size3).mix())
      .fontWeight(fortalTextWeightToken(weight ?? FortalTextWeight.regular)());
  final colored = accent
      ? fortalAccentForeground(text, highContrast: highContrast)
      : text.color(FortalTokens.gray12());

  return fortalApplyTextFlow(
    colored.inherit(false),
    align: align,
    softWrap: softWrap,
    truncate: truncate,
  ).merge(style);
}
