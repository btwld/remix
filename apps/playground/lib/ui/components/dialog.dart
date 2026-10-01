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
/// It is the page's `background` fill with a `border` hairline, `radiusLg`
/// corners, the heaviest shadow in the scale, and a 24px inset. The panel is
/// centered in the viewport with 16px to spare on every side, and fills the
/// width up to 512px. The title is `textLg` semibold and set tight, the description `textSm`
/// in `mutedForeground` 8px below it, and the decisions sit at the trailing
/// edge 16px below that.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
@MixWidget(target: RemixDialog.new)
DialogStyler playgroundDialogStyle({
  DialogStyler style = const DialogStyler.create(),
}) => DialogStyler()
    // A dialog route hands its page the whole viewport; without the wrap the
    // panel would take all of it. The padding leaves room at the edges, and
    // the alignment lets the panel keep its own size.
    .wrap(
      .padding(.all(PlaygroundSpace.s4))
          .align(alignment: .center)
          .orderOfModifiers([PaddingModifier, AlignModifier]),
    )
    .color(PlaygroundTokens.background())
    .border(.color(PlaygroundTokens.border()).width(PlaygroundStroke.hairline))
    .borderRadius(.all(PlaygroundTokens.radiusLg()))
    .padding(.all(PlaygroundSpace.s6))
    .width(PlaygroundSize.dialogMaxWidth)
    .shadows(PlaygroundShadow.lg.box)
    .title(
      .style(PlaygroundTokens.textLg.mix())
          // A line height of 1: the title sits on its own size, so the gap
          // below it is the 8px the recipe says rather than 8 plus the line
          // box's leading.
          .height(1)
          .fontWeight(FontWeight.w600)
          .color(PlaygroundTokens.foreground())
          .wrap(.padding(.only(bottom: PlaygroundSpace.s2))),
    )
    .description(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    // The actions sit at the trailing edge, which is where a reader looks for
    // the decision once they have read the description.
    .actions(
      FlexBoxStyler()
          .direction(.horizontal)
          .mainAxisAlignment(.end)
          .spacing(PlaygroundSpace.s2)
          .margin(.top(PlaygroundSpace.s4)),
    )
    .merge(style);
