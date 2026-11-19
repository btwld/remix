import 'dart:ui' show Color;

import 'tokens.dart';

/// Deui's semantic colour axis, shared by chip, badge, avatar, and progress.
enum DeuiColor { defaultColor, accent, success, warning, danger }

/// A fill and the foreground drawn on it.
typedef DeuiColorPair = ({Color fill, Color foreground});

/// `--<color>` over `--<color>-foreground`: the `primary` compound variants.
DeuiColorPair deuiSolid(DeuiColor color) => switch (color) {
  .defaultColor => (
    fill: DeuiTokens.defaultColor(),
    foreground: DeuiTokens.defaultForeground(),
  ),
  .accent => (
    fill: DeuiTokens.accent(),
    foreground: DeuiTokens.accentForeground(),
  ),
  .success => (
    fill: DeuiTokens.success(),
    foreground: DeuiTokens.successForeground(),
  ),
  .warning => (
    fill: DeuiTokens.warning(),
    foreground: DeuiTokens.warningForeground(),
  ),
  .danger => (
    fill: DeuiTokens.danger(),
    foreground: DeuiTokens.dangerForeground(),
  ),
};

/// `--<color>-soft` over `--<color>-soft-foreground`: the `soft` compound
/// variants.
DeuiColorPair deuiSoft(DeuiColor color) => switch (color) {
  .defaultColor => (
    fill: DeuiTokens.defaultSoft(),
    foreground: DeuiTokens.defaultSoftForeground(),
  ),
  .accent => (
    fill: DeuiTokens.accentSoft(),
    foreground: DeuiTokens.accentSoftForeground(),
  ),
  .success => (
    fill: DeuiTokens.successSoft(),
    foreground: DeuiTokens.successSoftForeground(),
  ),
  .warning => (
    fill: DeuiTokens.warningSoft(),
    foreground: DeuiTokens.warningSoftForeground(),
  ),
  .danger => (
    fill: DeuiTokens.dangerSoft(),
    foreground: DeuiTokens.dangerSoftForeground(),
  ),
};

/// The label colour `secondary` and `tertiary` keep (`chip.css`, `badge.css`):
/// `default-foreground` for the default colour, the soft foreground otherwise.
Color deuiLabelColor(DeuiColor color) => color == .defaultColor
    ? DeuiTokens.defaultForeground()
    : deuiSoft(color).foreground;
