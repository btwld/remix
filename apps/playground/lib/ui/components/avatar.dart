import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'avatar.g.dart';

/// The application's Avatar recipe.
///
/// A 32px circle on `muted`, so an avatar without an image reads as a
/// placeholder. Remix picks the fallback (image, then label, then icon) and
/// centers it; the label is `textSm` in `mutedForeground` and the icon is 16px.
/// Set a larger size through [style].
@MixWidget(target: RemixAvatar.new)
AvatarStyler playgroundAvatarStyle({
  AvatarStyler style = const AvatarStyler.create(),
}) => AvatarStyler()
    .size(PlaygroundTokens.controlSm, PlaygroundTokens.controlSm)
    .borderRadius(.all(_circular))
    // Rounds an image: Remix renders it as a child, not in the decoration.
    .clipBehavior(Clip.antiAlias)
    .color(PlaygroundTokens.muted())
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .icon(
      .size(PlaygroundTokens.icon).color(PlaygroundTokens.mutedForeground()),
    )
    .merge(style);

/// Large enough to round any avatar into a circle.
const _circular = Radius.circular(PlaygroundTokens.pill);
