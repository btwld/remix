import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'dialog.g.dart';

/// The application's Dialog recipe.
///
/// The page's `background` fill with a `border` hairline, `radiusLg` corners,
/// the heaviest shadow in the scale and a 24px inset. The panel is centered
/// with 16px to spare and fills the width up to 512px. The title is `textLg`
/// semibold, the description `textSm` in `mutedForeground` 8px below it, and
/// the actions sit at the trailing edge 16px below that.
@MixWidget(target: RemixDialog.new)
DialogStyler vanillaDialogStyle({
  DialogStyler style = const DialogStyler.create(),
}) => DialogStyler()
    // A dialog route hands its page the whole viewport: the padding leaves
    // room at the edges and the alignment lets the panel keep its own size.
    .wrap(
      .padding(.all(VanillaTokens.s4))
          .align(alignment: .center)
          .orderOfModifiers([PaddingModifier, AlignModifier]),
    )
    .color(VanillaTokens.background())
    .border(.color(VanillaTokens.border()).width(VanillaTokens.strokeHairline))
    .borderRadius(.all(VanillaTokens.radiusLg()))
    .padding(.all(VanillaTokens.s6))
    .width(VanillaTokens.dialogMaxWidth)
    .shadows(VanillaShadow.lg.box)
    .title(
      .style(VanillaTokens.textLg.mix())
          // Line height 1, so the gap below is 8px, not 8 plus leading.
          .height(1)
          .fontWeight(FontWeight.w600)
          .color(VanillaTokens.foreground())
          .wrap(.padding(.bottom(VanillaTokens.s2))),
    )
    .description(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    .actions(
      FlexBoxStyler()
          .direction(.horizontal)
          .mainAxisAlignment(.end)
          .spacing(VanillaTokens.s2)
          .margin(.top(VanillaTokens.s4)),
    )
    .merge(style);
