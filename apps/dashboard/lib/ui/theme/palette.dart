import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// One appearance of a Ui palette: twelve steps and their semantic roles.
///
/// Labels and marks are separate jobs. [indicator] and [track] are mark fills
/// (selected checkbox and radio, switch track, slider and progress range) that
/// carry white or derived ink at 3:1. [solid] and [solidHover] are the
/// labelled fills of buttons, badges, avatars and highlighted menu items, and
/// [contrast] is the label colour fitted to them at 4.5:1.
@immutable
class UiColor {
  /// Creates a palette appearance.
  ///
  /// Without [solid] and [solidHover], labelled fills are scale steps 9 and
  /// 10, so palettes written before the split keep pairing [contrast] with
  /// those steps. A [solid] without [solidHover] also serves as its own hover,
  /// keeping the label pairing intact; supply both for a visible hover step.
  const UiColor(
    this.scale,
    this.surface,
    this.indicator,
    this.track,
    this.contrast, {
    this._solid,
    this._solidHover,
  });

  final UiColorScale scale;
  final Color surface;
  final Color indicator;
  final Color track;

  /// Label colour on [solid] and [solidHover].
  final Color contrast;

  final Color? _solid;
  final Color? _solidHover;

  /// Labelled solid fill; scale step 9 unless supplied.
  Color get solid => _solid ?? scale.step(9);

  /// Hovered labelled solid fill; [solid] when only that was supplied,
  /// otherwise scale step 10.
  Color get solidHover => _solidHover ?? _solid ?? scale.step(10);
}

/// A palette's paired light and dark appearances, including custom brands.
@immutable
class UiColorTheme {
  const UiColorTheme(this.light, this.dark);

  final UiColor light;
  final UiColor dark;
}

/// Fixed-role, one-based color steps. Invalid steps are programming errors.
@immutable
class UiColorScale {
  const UiColorScale(this.solid, this.alpha);

  final ColorSwatch<int> solid;
  final ColorSwatch<int> alpha;

  Color step(int step) => _at(solid, step);
  Color alphaStep(int step) => _at(alpha, step);

  Color _at(ColorSwatch<int> swatch, int step) {
    if (step < 1 || step > 12) {
      throw RangeError.range(step, 1, 12, 'step');
    }
    return swatch[step]!;
  }
}
