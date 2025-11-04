import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

/// Mixin that provides convenient icon styling methods for component styles.
///
/// This mixin requires the implementing class to provide a method that accepts
/// an IconStyler and returns the modified component style.
mixin IconStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  /// Should merge the provided IconStyler with the component's icon style
  T icon(IconStyler value);

  /// Sets icon color
  T iconColor(Color value) {
    return icon(IconStyler(color: value));
  }

  /// Sets icon size
  T iconSize(double value) {
    return icon(IconStyler(size: value));
  }

  /// Sets icon opacity
  T iconOpacity(double value) {
    return icon(IconStyler(opacity: value));
  }

  /// Sets icon weight (useful for variable icons like Material Symbols)
  T iconWeight(double value) {
    return icon(IconStyler(weight: value));
  }

  /// Sets icon grade (useful for Material Icons)
  T iconGrade(double value) {
    return icon(IconStyler(grade: value));
  }

  /// Sets icon fill (useful for Material Icons filled variants)
  T iconFill(double value) {
    return icon(IconStyler(fill: value));
  }

  /// Sets icon optical size (useful for Material Icons)
  T iconOpticalSize(double value) {
    return icon(IconStyler(opticalSize: value));
  }

  /// Sets icon blend mode
  T iconBlendMode(BlendMode value) {
    return icon(IconStyler(blendMode: value));
  }

  /// Sets icon text direction
  T iconTextDirection(TextDirection value) {
    return icon(IconStyler(textDirection: value));
  }

  /// Sets icon shadows
  T iconShadows(List<ShadowMix> value) {
    return icon(IconStyler(shadows: value));
  }

  /// Sets single icon shadow
  T iconShadow(ShadowMix value) {
    return icon(IconStyler(shadows: [value]));
  }
}
