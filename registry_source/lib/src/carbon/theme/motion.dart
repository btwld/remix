// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';

import 'generated/carbon_motion.dart';

/// Carbon motion intent.
enum CarbideMotionIntent { standard, entrance, exit }

/// Carbon motion mode. Productive is calm and utilitarian; expressive is used
/// sparingly for moments that deserve emphasis.
enum CarbideMotionMode { productive, expressive }

/// Access to Carbon easing curves and reduced-motion-aware helpers.
///
/// Component recipes should route durations and curves through these helpers so
/// they honor the platform "reduce motion" accessibility setting instead of
/// treating every state change as expressive.
class CarbideMotion {
  const CarbideMotion._();

  /// The Carbon [Cubic] curve for an [intent] and [mode].
  static Cubic curve(CarbideMotionIntent intent, CarbideMotionMode mode) {
    return switch ((intent, mode)) {
      (CarbideMotionIntent.standard, CarbideMotionMode.productive) =>
        CarbideEasings.standardProductive,
      (CarbideMotionIntent.standard, CarbideMotionMode.expressive) =>
        CarbideEasings.standardExpressive,
      (CarbideMotionIntent.entrance, CarbideMotionMode.productive) =>
        CarbideEasings.entranceProductive,
      (CarbideMotionIntent.entrance, CarbideMotionMode.expressive) =>
        CarbideEasings.entranceExpressive,
      (CarbideMotionIntent.exit, CarbideMotionMode.productive) =>
        CarbideEasings.exitProductive,
      (CarbideMotionIntent.exit, CarbideMotionMode.expressive) =>
        CarbideEasings.exitExpressive,
    };
  }

  /// Whether the platform requests reduced motion for [context].
  static bool reducedMotionOf(BuildContext context) =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;

  /// Collapses [value] to [Duration.zero] when reduced motion is requested.
  static Duration duration(BuildContext context, Duration value) =>
      reducedMotionOf(context) ? .zero : value;

  /// Returns a linear curve when reduced motion is requested, else [value].
  static Curve resolveCurve(BuildContext context, Curve value) =>
      reducedMotionOf(context) ? Curves.linear : value;
}
