import 'package:flutter/material.dart';

/// High-contrast color filters aligned with CSS semantics.
class HighContrastFilters {
  const HighContrastFilters._();

  /// CSS: contrast(0.88) saturate(1.3) brightness(1.18)
  /// For hover states in high-contrast UIs.
  static ColorFilter hover() => ColorFilter.matrix(hoverMatrix());

  /// CSS: brightness(0.95) saturate(1.2)
  /// For active/pressed states in high-contrast UIs.
  static ColorFilter active() => ColorFilter.matrix(activeMatrix());

  /// Raw hover matrix (useful for direct color transforms).
  static List<double> hoverMatrix() => _compose([
        _contrast(0.88),
        _saturation(1.3),
        _brightness(1.18),
      ]);

  /// Raw active matrix (useful for direct color transforms).
  static List<double> activeMatrix() => _compose([
        _brightness(0.95),
        _saturation(1.2),
      ]);

  // Matrix generators

  static List<double> _brightness(double v) => [
        v,
        0,
        0,
        0,
        0,
        0,
        v,
        0,
        0,
        0,
        0,
        0,
        v,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];

  static List<double> _contrast(double c) {
    final t = (1 - c) * 127.5;

    return [c, 0, 0, 0, t, 0, c, 0, 0, t, 0, 0, c, 0, t, 0, 0, 0, 1, 0];
  }

  static List<double> _saturation(double s) {
    const lumR = 0.2126;
    const lumG = 0.7152;
    const lumB = 0.0722;

    final inv = 1 - s;
    final r = inv * lumR;
    final g = inv * lumG;
    final b = inv * lumB;

    return [
      r + s,
      g,
      b,
      0,
      0,
      r,
      g + s,
      b,
      0,
      0,
      r,
      g,
      b + s,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  // Compose matrices in CSS order (left → right)
  static List<double> _compose(List<List<double>> matrices) {
    if (matrices.isEmpty) return _identity();

    var result = _identity();
    for (final m in matrices) {
      result = _multiply(m, result);
    }

    return result;
  }

  // 4x5 matrix multiplication
  static List<double> _multiply(List<double> a, List<double> b) {
    final out = List<double>.filled(20, 0);

    for (int row = 0; row < 4; row++) {
      final r = row * 5;
      for (int col = 0; col < 5; col++) {
        double sum = 0;
        for (int k = 0; k < 4; k++) {
          sum += a[r + k] * b[k * 5 + col];
        }
        if (col == 4) sum += a[r + 4];
        out[r + col] = sum;
      }
    }

    return out;
  }

  static List<double> _identity() => [
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ];
}

/// Apply a 4×5 color matrix directly to a Color.
extension ColorMatrixExtension on Color {
  Color applyMatrix(List<double> m) {
    assert(m.length == 20, 'Color matrix must be 4×5 (20 values)');

    // Using Flutter 3.27+ double properties (already in 0-1 range)
    final r = this.r;
    final g = this.g;
    final b = this.b;
    final a = this.a;

    double apply(int row) {
      // Matrix multiplication + offset (already in 0-255 scale)
      final value = m[row] * r +
          m[row + 1] * g +
          m[row + 2] * b +
          m[row + 3] * a +
          m[row + 4] / 255.0;

      return value.clamp(0.0, 1.0);
    }

    return Color.fromARGB(
      (apply(15) * 255).round(),
      (apply(0) * 255).round(),
      (apply(5) * 255).round(),
      (apply(10) * 255).round(),
    );
  }

  Color withHoverFilter() => applyMatrix(HighContrastFilters.hoverMatrix());
  Color withActiveFilter() => applyMatrix(HighContrastFilters.activeMatrix());
}

/// Filter entire widget subtrees.
extension WidgetColorFilterExtension on Widget {
  Widget withColorFilter(ColorFilter filter) =>
      ColorFiltered(colorFilter: filter, child: this);

  Widget withHoverFilter() => withColorFilter(HighContrastFilters.hover());

  Widget withActiveFilter() => withColorFilter(HighContrastFilters.active());
}
