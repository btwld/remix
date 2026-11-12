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
AvatarStyler vanillaAvatarStyle({
  AvatarStyler style = const AvatarStyler.create(),
}) => AvatarStyler()
    .size(VanillaTokens.controlSm, VanillaTokens.controlSm)
    .borderRadius(.all(_circular))
    // Rounds an image: Remix renders it as a child, not in the decoration.
    .clipBehavior(Clip.antiAlias)
    .color(VanillaTokens.muted())
    .label(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    .icon(.size(VanillaTokens.icon).color(VanillaTokens.mutedForeground()))
    .merge(style);

/// Large enough to round any avatar into a circle.
const _circular = Radius.circular(VanillaTokens.pill);
