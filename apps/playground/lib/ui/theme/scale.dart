import 'package:remix/remix.dart';

/// Spacing steps on a four-pixel grid, named by step.
///
/// `s2` is two steps, 8px; `s1_5` is one and a half, 6px. Recipes take every
/// padding, gap, and margin from here, so a layout reads as one rhythm and a
/// value off the grid stands out in review.
///
/// These are plain constants rather than tokens on purpose. Spacing is not
/// something a theme changes, and arithmetic on an unresolved token (half a
/// gap, a gap minus a border) cannot be written until the token resolves.
abstract final class PlaygroundSpace {
  /// 2px.
  static const double s0_5 = 2;

  /// 4px.
  static const double s1 = 4;

  /// 6px.
  static const double s1_5 = 6;

  /// 8px.
  static const double s2 = 8;

  /// 10px.
  static const double s2_5 = 10;

  /// 12px.
  static const double s3 = 12;

  /// 14px.
  static const double s3_5 = 14;

  /// 16px.
  static const double s4 = 16;

  /// 20px.
  static const double s5 = 20;

  /// 24px.
  static const double s6 = 24;

  /// 32px.
  static const double s8 = 32;

  /// 40px.
  static const double s10 = 40;

  /// 48px.
  static const double s12 = 48;

  /// 64px.
  static const double s16 = 64;
}

/// Control heights and icon sizes shared across recipes.
abstract final class PlaygroundSize {
  /// A small control.
  static const double controlSm = 32;

  /// The default control.
  static const double controlMd = 36;

  /// A large control.
  static const double controlLg = 40;

  /// A small glyph beside `xs` text.
  static const double iconXs = 12;

  /// A check or indicator glyph.
  static const double iconSm = 14;

  /// The default glyph.
  static const double icon = 16;

  /// The narrowest a floating list gets, so a one-word menu is still a target.
  static const double panelMinWidth = 128;

  /// A popover's width.
  static const double popoverWidth = 288;

  /// A toast's width.
  static const double toastWidth = 356;

  /// The widest a dialog gets.
  static const double dialogMaxWidth = 512;

  /// A corner radius that rounds any control into a pill or a circle.
  static const double pill = 9999;
}

/// Stroke widths.
abstract final class PlaygroundStroke {
  /// A border or a separator.
  static const double hairline = 1;

  /// A selection mark: the line under the current tab.
  static const double indicator = 2;

  /// The keyboard focus ring.
  static const double ring = 3;
}

/// Opacities shared across recipes.
abstract final class PlaygroundOpacity {
  /// A disabled control fades to half strength, and keeps its colors.
  static const double disabled = 0.5;
}

/// Motion shared across recipes.
abstract final class PlaygroundMotion {
  /// Every state change: 150ms on `Curves.fastOutSlowIn`, `cubic-bezier(0.4, 0,
  /// 0.2, 1)`, the curve the web's standard transitions use.
  static const standard = CurveAnimationConfig.fastOutSlowIn(
    Duration(milliseconds: 150),
  );
}
