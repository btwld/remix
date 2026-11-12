import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'spinner.g.dart';

/// HeroUI spinner sizes.
enum HeroUiSpinnerSize {
  /// 16px.
  sm,

  /// 24px. The default.
  md,

  /// 32px.
  lg,

  /// 40px.
  xl,
}

/// HeroUI spinner colors.
enum HeroUiSpinnerColor {
  /// The `accent` color.
  accent,

  /// Inherits the surrounding icon color, like CSS `color: inherit`.
  current,

  /// The `danger` color.
  danger,

  /// The `success` color.
  success,

  /// The `warning` color.
  warning,
}

/// HeroUI recipe for [RemixSpinner].
///
/// Remix's arc sits on the same ring as HeroUI's icon (radius and thickness
/// scale with the size); HeroUI fades a full ring where Remix draws a solid
/// arc.
@MixWidget(target: RemixSpinner.new)
SpinnerStyler heroUiSpinnerStyle({
  HeroUiSpinnerSize size = .md,
  HeroUiSpinnerColor color = .accent,
  SpinnerStyler style = const SpinnerStyler.create(),
}) {
  final dimension = switch (size) {
    .sm => 16.0,
    .md => 24.0,
    .lg => 32.0,
    .xl => 40.0,
  };
  final indicator = switch (color) {
    .accent => HeroUiTokens.accent,
    .current => null,
    .danger => HeroUiTokens.danger,
    .success => HeroUiTokens.success,
    .warning => HeroUiTokens.warning,
  };

  return SpinnerStyler()
      .size(dimension)
      .strokeWidth(dimension / 16)
      // `--animate-spin-fast: spin 0.75s linear infinite`.
      .duration(const Duration(milliseconds: 750))
      .merge(
        indicator == null ? null : SpinnerStyler().indicatorColor(indicator()),
      )
      .merge(style);
}

/// HeroUI's `<Spinner color="current" size="sm"/>` inside a pending control.
///
/// `.current` skips the accent default; [color] explicitly overrides the
/// inherited icon color that Remix's spinner otherwise uses.
SpinnerStyler heroUiInlineSpinnerStyle(Color color) =>
    heroUiSpinnerStyle(size: .sm, color: .current).indicatorColor(color);
