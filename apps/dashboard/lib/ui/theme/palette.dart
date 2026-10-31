import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// One appearance of a Ui palette: twelve steps and their semantic roles.
@immutable
class UiColor {
  const UiColor(
    this.scale,
    this.surface,
    this.indicator,
    this.track,
    this.contrast,
  );

  final UiColorScale scale;
  final Color surface;
  final Color indicator;
  final Color track;
  final Color contrast;
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
