import 'dart:ui' show Color;

import 'tokens.dart';

/// HeroUI's semantic colour axis, shared by chip, badge, avatar, and progress.
enum HeroUiColor { defaultColor, accent, success, warning, danger }

/// A fill and the foreground drawn on it.
typedef HeroUiColorPair = ({Color fill, Color foreground});

/// `--<color>` over `--<color>-foreground`: the `primary` compound variants.
HeroUiColorPair heroUiSolid(HeroUiColor color) => switch (color) {
  .defaultColor => (
    fill: HeroUiTokens.defaultColor(),
    foreground: HeroUiTokens.defaultForeground(),
  ),
  .accent => (
    fill: HeroUiTokens.accent(),
    foreground: HeroUiTokens.accentForeground(),
  ),
  .success => (
    fill: HeroUiTokens.success(),
    foreground: HeroUiTokens.successForeground(),
  ),
  .warning => (
    fill: HeroUiTokens.warning(),
    foreground: HeroUiTokens.warningForeground(),
  ),
  .danger => (
    fill: HeroUiTokens.danger(),
    foreground: HeroUiTokens.dangerForeground(),
  ),
};

/// `--<color>-soft` over `--<color>-soft-foreground`: the `soft` compound
/// variants.
HeroUiColorPair heroUiSoft(HeroUiColor color) => switch (color) {
  .defaultColor => (
    fill: HeroUiTokens.defaultSoft(),
    foreground: HeroUiTokens.defaultSoftForeground(),
  ),
  .accent => (
    fill: HeroUiTokens.accentSoft(),
    foreground: HeroUiTokens.accentSoftForeground(),
  ),
  .success => (
    fill: HeroUiTokens.successSoft(),
    foreground: HeroUiTokens.successSoftForeground(),
  ),
  .warning => (
    fill: HeroUiTokens.warningSoft(),
    foreground: HeroUiTokens.warningSoftForeground(),
  ),
  .danger => (
    fill: HeroUiTokens.dangerSoft(),
    foreground: HeroUiTokens.dangerSoftForeground(),
  ),
};

/// The label colour `secondary` and `tertiary` keep (`chip.css`, `badge.css`):
/// `default-foreground` for the default colour, the soft foreground otherwise.
Color heroUiLabelColor(HeroUiColor color) => color == .defaultColor
    ? HeroUiTokens.defaultForeground()
    : heroUiSoft(color).foreground;
