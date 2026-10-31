import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'typography.dart';

part 'text.g.dart';

/// Ui-themed body text on the Ui nine-step scale.
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
  var recipe = TextStyler().style(
    uiTextSizeToken(size ?? UiTextSize.size3).mix(),
  );
  recipe = recipe.fontWeight(
    uiTextWeightToken(weight ?? UiTextWeight.regular)(),
  );
  recipe = accent
      ? uiAccentForeground(recipe, highContrast: highContrast)
      : recipe.color(UiTokens.gray12());
  recipe = recipe.inherit(false);

  return uiApplyTextFlow(
    recipe,
    align: align,
    softWrap: softWrap,
    truncate: truncate,
  ).merge(style);
}
