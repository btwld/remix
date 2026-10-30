import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// One appearance of a Fortal palette: twelve steps and their semantic roles.
@immutable
class FortalColor {
  const FortalColor(
    this.scale,
    this.surface,
    this.indicator,
    this.track,
    this.contrast,
  );

  final FortalColorScale scale;
  final Color surface;
  final Color indicator;
  final Color track;
  final Color contrast;
}

/// A palette's paired light and dark appearances, including custom brands.
@immutable
class FortalColorTheme {
  const FortalColorTheme(this.light, this.dark);

  final FortalColor light;
  final FortalColor dark;
}

/// Fixed-role, one-based color steps. Invalid steps are programming errors.
@immutable
class FortalColorScale {
  const FortalColorScale(this.solid, this.alpha);

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
