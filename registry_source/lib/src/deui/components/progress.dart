import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'progress.g.dart';

/// Deui progress heights.
enum DeuiProgressSize {
  /// `h-1`: 4px.
  sm,

  /// `h-2`: 8px. The default.
  md,

  /// `h-3`: 12px.
  lg,
}

/// Deui recipe for [RemixProgress], also the look of Deui's Meter, which
/// shares every progress-bar style.
///
/// The label and value output beside the bar are the app's composition.
@MixWidget(target: RemixProgress.new)
ProgressStyler deuiProgressStyle({
  DeuiProgressSize size = .md,
  DeuiColor color = .accent,
  ProgressStyler style = const ProgressStyler.create(),
}) {
  // `.progress-bar` `h-2 rounded-sm`; `--sm` is `h-1 rounded-xs` and `--lg`
  // is `h-3 rounded-md`.
  final (height, radius) = switch (size) {
    .sm => (4.0, DeuiTokens.radius3xl()),
    .md => (8.0, DeuiTokens.radius3xl()),
    .lg => (12.0, DeuiTokens.radius3xl()),
  };
  final fill = switch (color) {
    .defaultColor => DeuiTokens.defaultForeground,
    .accent => DeuiTokens.accent,
    .success => DeuiTokens.success,
    .warning => DeuiTokens.warning,
    .danger => DeuiTokens.danger,
  };

  return ProgressStyler(
    container: .width(
      .infinity,
    ).height(height).borderRadius(.all(radius)).clipBehavior(.antiAlias),
    track: .width(.infinity).height(height),
    indicator: .height(height).borderRadius(.all(radius)),
  ).trackColor(DeuiTokens.defaultColor()).indicatorColor(fill()).merge(style);
}
