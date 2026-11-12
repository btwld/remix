import 'dart:ui' show Color;

import 'tokens.dart';

/// HeroUI's semantic colour axis, shared by chip, badge, avatar, and progress.
enum UiColor { defaultColor, accent, success, warning, danger }

/// A fill and the foreground drawn on it.
typedef UiColorPair = ({Color fill, Color foreground});

/// `--<color>` over `--<color>-foreground`: the `primary` compound variants.
UiColorPair uiSolid(UiColor color) => switch (color) {
  .defaultColor => (
    fill: UiTokens.defaultColor(),
    foreground: UiTokens.defaultForeground(),
  ),
  .accent => (fill: UiTokens.accent(), foreground: UiTokens.accentForeground()),
  .success => (
    fill: UiTokens.success(),
    foreground: UiTokens.successForeground(),
  ),
  .warning => (
    fill: UiTokens.warning(),
    foreground: UiTokens.warningForeground(),
  ),
  .danger => (fill: UiTokens.danger(), foreground: UiTokens.dangerForeground()),
};

/// `--<color>-soft` over `--<color>-soft-foreground`: the `soft` compound
/// variants.
UiColorPair uiSoft(UiColor color) => switch (color) {
  .defaultColor => (
    fill: UiTokens.defaultSoft(),
    foreground: UiTokens.defaultSoftForeground(),
  ),
  .accent => (
    fill: UiTokens.accentSoft(),
    foreground: UiTokens.accentSoftForeground(),
  ),
  .success => (
    fill: UiTokens.successSoft(),
    foreground: UiTokens.successSoftForeground(),
  ),
  .warning => (
    fill: UiTokens.warningSoft(),
    foreground: UiTokens.warningSoftForeground(),
  ),
  .danger => (
    fill: UiTokens.dangerSoft(),
    foreground: UiTokens.dangerSoftForeground(),
  ),
};

/// The label colour `secondary` and `tertiary` keep (`chip.css`, `badge.css`):
/// `default-foreground` for the default colour, the soft foreground otherwise.
Color uiLabelColor(UiColor color) => color == .defaultColor
    ? UiTokens.defaultForeground()
    : uiSoft(color).foreground;
