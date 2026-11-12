import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'skeleton.g.dart';

/// The Fortal Skeleton recipe: a gray placeholder block that pulses.
@MixWidget(target: RemixSkeleton.new)
SkeletonStyler fortalSkeletonStyle({
  SkeletonStyler style = const SkeletonStyler.create(),
}) {
  return SkeletonStyler()
      .container(
        BoxStyler()
            .minHeight(FortalTokens.space3())
            .color(FortalTokens.grayA3())
            .borderRadius(.all(FortalTokens.radius1())),
      )
      .pulseColor(FortalTokens.grayA4())
      .duration(FortalTokens.skeletonPulseDuration())
      .merge(style);
}
