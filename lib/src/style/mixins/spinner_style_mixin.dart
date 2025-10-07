import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import '../../components/spinner/spinner.dart';

/// Mixin that provides convenient spinner styling methods for component styles.
///
/// This mixin requires the implementing class to provide a method that accepts
/// a RemixSpinnerStyle and returns the modified component style.
mixin SpinnerStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  /// Should merge the provided RemixSpinnerStyle with the component's spinner style
  T spinner(RemixSpinnerStyle value);

  /// Sets spinner indicator color
  T spinnerIndicatorColor(Color value) {
    return spinner(RemixSpinnerStyle(indicatorColor: value));
  }

  /// Sets spinner track color
  T spinnerTrackColor(Color value) {
    return spinner(RemixSpinnerStyle(trackColor: value));
  }

  /// Sets spinner size
  T spinnerSize(double value) {
    return spinner(RemixSpinnerStyle(size: value));
  }

  /// Sets spinner stroke width
  T spinnerStrokeWidth(double value) {
    return spinner(RemixSpinnerStyle(strokeWidth: value));
  }

  /// Sets spinner track stroke width
  T spinnerTrackStrokeWidth(double value) {
    return spinner(RemixSpinnerStyle(trackStrokeWidth: value));
  }

  /// Sets spinner animation duration
  T spinnerDuration(Duration value) {
    return spinner(RemixSpinnerStyle(duration: value));
  }

  /// Sets spinner animation to fast (500ms)
  T spinnerFast() {
    return spinner(RemixSpinnerStyle(duration: const Duration(milliseconds: 500)));
  }

  /// Sets spinner animation to normal (1000ms)
  T spinnerNormal() {
    return spinner(RemixSpinnerStyle(duration: const Duration(milliseconds: 1000)));
  }

  /// Sets spinner animation to slow (1500ms)
  T spinnerSlow() {
    return spinner(RemixSpinnerStyle(duration: const Duration(milliseconds: 1500)));
  }
}
