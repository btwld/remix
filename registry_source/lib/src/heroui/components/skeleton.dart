import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'skeleton.g.dart';

/// HeroUI recipe for [RemixSkeleton].
///
/// The placeholder has no size of its own, as in HeroUI: give it one through
/// [style] or its parent. Remix pulses the fill's opacity to half and back,
/// which is Tailwind's `animate-pulse`.
@MixWidget(target: RemixSkeleton.new)
SkeletonStyler heroUiSkeletonStyle({
  SkeletonStyler style = const SkeletonStyler.create(),
}) => SkeletonStyler()
    .container(
      BoxStyler().color(_fill()).borderRadius(.all(HeroUiTokens.radiusSm())),
    )
    .duration(_pulseLeg)
    .merge(style);

/// `bg-surface-tertiary/70`.
final _fill = heroUiAlpha(HeroUiTokens.surfaceTertiary, .7);

/// `animate-pulse` takes 2s to fade out and back; Remix times each leg.
const _pulseLeg = Duration(seconds: 1);
