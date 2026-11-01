import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'progress.g.dart';

/// HeroUI progress heights: `h-1`, `h-2`, `h-3`.
enum HeroUiProgressSize { sm, md, lg }

/// HeroUI recipe for [RemixProgress], also the look of HeroUI's Meter, which
/// shares every progress-bar style.
///
/// The label and value output beside the bar are the app's composition.
@MixWidget(target: RemixProgress.new)
ProgressStyler heroUiProgressStyle({
  HeroUiProgressSize size = .md,
  HeroUiColor color = .accent,
  ProgressStyler style = const ProgressStyler.create(),
}) {
  // `.progress-bar` `h-2 rounded-sm`; `--sm` is `h-1 rounded-xs` and `--lg`
  // is `h-3 rounded-md`.
  final (height, radius) = switch (size) {
    .sm => (4.0, HeroUiTokens.radiusXs()),
    .md => (8.0, HeroUiTokens.radiusSm()),
    .lg => (12.0, HeroUiTokens.radiusMd()),
  };
  final fill = switch (color) {
    .defaultColor => HeroUiTokens.defaultForeground,
    .accent => HeroUiTokens.accent,
    .success => HeroUiTokens.success,
    .warning => HeroUiTokens.warning,
    .danger => HeroUiTokens.danger,
  };

  return ProgressStyler(
    container: .width(
      .infinity,
    ).height(height).borderRadius(.all(radius)).clipBehavior(.antiAlias),
    track: .width(.infinity).height(height),
    indicator: .height(height).borderRadius(.all(radius)),
  ).trackColor(HeroUiTokens.defaultColor()).indicatorColor(fill()).merge(style);
}
