import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'dialog.g.dart';

/// The application's Dialog recipe.
///
/// Remix owns the rendering, the modal barrier, focus trapping, the escape
/// and barrier dismissal rules, and the dialog accessibility semantics; this
/// recipe supplies the panel, the two text roles, and the action row.
///
/// It is shadcn's dialog: the page's `background` fill with a `border`
/// hairline, `radiusLg` corners, the heaviest shadow in the scale, a 24px
/// inset, and at most 512px wide. The title is `textLg` semibold and set
/// tight, the description `textSm` in `mutedForeground` 8px below it, and the
/// decisions sit at the trailing edge 16px below that.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
@MixWidget(target: RemixDialog.new)
DialogStyler vanillaDialogStyle({
  DialogStyler style = const DialogStyler.create(),
}) => DialogStyler()
    .color(VanillaTokens.background())
    .border(.color(VanillaTokens.border()).width(VanillaStroke.hairline))
    .borderRadius(.all(VanillaTokens.radiusLg()))
    .padding(.all(VanillaSpace.s6))
    .maxWidth(VanillaSize.dialogMaxWidth)
    .shadows(VanillaShadow.lg.box)
    .title(
      .style(VanillaTokens.textLg.mix())
          // shadcn's `leading-none`: the title sits on its own size, so the
          // gap below it is the 8px the recipe says rather than 8 plus the
          // line box's leading.
          .height(1)
          .fontWeight(FontWeight.w600)
          .color(VanillaTokens.foreground())
          .wrap(.padding(.only(bottom: VanillaSpace.s2))),
    )
    .description(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    // The actions sit at the trailing edge, which is where a reader looks for
    // the decision once they have read the description.
    .actions(
      FlexBoxStyler()
          .direction(.horizontal)
          .mainAxisAlignment(.end)
          .spacing(VanillaSpace.s2)
          .margin(.top(VanillaSpace.s4)),
    )
    .merge(style);
