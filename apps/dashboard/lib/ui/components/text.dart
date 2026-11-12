import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'typography.dart';

part 'text.g.dart';

/// The Ui Text recipe: body text on the nine-step text scale.
///
/// Neutral text is gray 12; [accent] takes the accent's text color, and
/// [highContrast] moves that to accent step 12. [truncate] wins over
/// [softWrap] and forces one ellipsized line.
@MixWidget()
TextStyler uiTextStyle({
  UiTextSize? size,
  UiTextWeight? weight,
  TextAlign? align,
  bool softWrap = true,
  bool truncate = false,
  bool accent = false,
  bool highContrast = false,
  TextStyler style = const TextStyler.create(),
}) {
  final text = TextStyler()
      .style(uiTextSizeToken(size ?? UiTextSize.size3).mix())
      .fontWeight(uiTextWeightToken(weight ?? UiTextWeight.regular)());
  final colored = accent
      ? uiAccentForeground(text, highContrast: highContrast)
      : text.color(UiTokens.gray12());

  return uiApplyTextFlow(
    colored.inherit(false),
    align: align,
    softWrap: softWrap,
    truncate: truncate,
  ).merge(style);
}
