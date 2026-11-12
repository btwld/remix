import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'skeleton.g.dart';

/// The application's Skeleton recipe.
///
/// An `accent` block with `radiusMd` corners that pulses to half strength, so a
/// loading block reads as scenery rather than content. It takes no size: the
/// child it wraps, or explicit constraints on [style], measure it:
///
/// ```dart
/// VanillaSkeleton(
///   style: SkeletonStyler().container(.size(160, 20)),
/// )
/// ```
@MixWidget(target: RemixSkeleton.new)
SkeletonStyler vanillaSkeletonStyle({
  SkeletonStyler style = const SkeletonStyler.create(),
}) => SkeletonStyler()
    .container(
      BoxStyler()
          .color(VanillaTokens.accent())
          .borderRadius(.all(VanillaTokens.radiusMd())),
    )
    .pulseColor(vanillaTint(VanillaTokens.accent, 0.5)())
    // One leg; the reverse takes as long, so a full pulse is two seconds. Slow
    // on purpose, so it does not compete with the content arriving beside it.
    .duration(const Duration(milliseconds: 1000))
    .merge(style);
