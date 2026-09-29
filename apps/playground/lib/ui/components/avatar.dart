import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'avatar.g.dart';

/// The application's Avatar recipe.
///
/// Remix owns the fallback chain — image, then label, then icon — and the
/// clipping; this recipe supplies the circle, the neutral surface behind it,
/// and the scale of whatever fallback shows through.
///
/// The surface is `muted`, so an avatar with no image reads as a placeholder
/// rather than as a filled control. An image covers all of it, which is why
/// the fill only ever shows in the fallback case. The recipe sets no
/// alignment: Remix already centers whichever fallback it renders.
///
/// The fallback is `textSm` in `mutedForeground`, or a 16px icon. The shipped
/// light theme sets `mutedForeground` dark enough that initials on the `muted`
/// circle clear the 4.5:1 text floor.
///
/// It is 32px across; a call site that wants a profile header sets `.size(...)`
/// through [style].
///
/// The shape is a full circle rather than the theme's control radius. An
/// avatar stands for a person or an organisation, and that is a circle in
/// every system this application is likely to sit beside; a theme that wants
/// squircles overrides `borderRadius` in one place.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
@MixWidget(target: RemixAvatar.new)
AvatarStyler playgroundAvatarStyle({
  AvatarStyler style = const AvatarStyler.create(),
}) => AvatarStyler()
    .size(PlaygroundSize.controlSm, PlaygroundSize.controlSm)
    .borderRadius(.all(_circular))
    // The clip is what rounds an image: Remix renders `backgroundImage` as
    // a child of the container, not as part of its decoration.
    .clipBehavior(Clip.antiAlias)
    .color(PlaygroundTokens.muted())
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .icon(.size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()))
    .merge(style);

/// A radius large enough to round any avatar in this scale into a circle.
const _circular = Radius.circular(PlaygroundSize.pill);
