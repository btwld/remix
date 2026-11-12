import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'progress.g.dart';

/// HeroUI progress heights.
enum UiProgressSize {
  /// `h-1`: 4px.
  sm,

  /// `h-2`: 8px. The default.
  md,

  /// `h-3`: 12px.
  lg,
}

/// HeroUI recipe for [RemixProgress], also the look of HeroUI's Meter, which
/// shares every progress-bar style.
///
/// The label and value output beside the bar are the app's composition.
@MixWidget(target: RemixProgress.new)
ProgressStyler uiProgressStyle({
  UiProgressSize size = .md,
  UiColor color = .accent,
  ProgressStyler style = const ProgressStyler.create(),
}) {
  // `.progress-bar` `h-2 rounded-sm`; `--sm` is `h-1 rounded-xs` and `--lg`
  // is `h-3 rounded-md`.
  final (height, radius) = switch (size) {
    .sm => (4.0, UiTokens.radiusXs()),
    .md => (8.0, UiTokens.radiusSm()),
    .lg => (12.0, UiTokens.radiusMd()),
  };
  final fill = switch (color) {
    .defaultColor => UiTokens.defaultForeground,
    .accent => UiTokens.accent,
    .success => UiTokens.success,
    .warning => UiTokens.warning,
    .danger => UiTokens.danger,
  };

  return ProgressStyler(
    container: .width(
      .infinity,
    ).height(height).borderRadius(.all(radius)).clipBehavior(.antiAlias),
    track: .width(.infinity).height(height),
    indicator: .height(height).borderRadius(.all(radius)),
  ).trackColor(UiTokens.defaultColor()).indicatorColor(fill()).merge(style);
}
