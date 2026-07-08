import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import '../../components/spinner/spinner.dart';

/// Mixin that provides convenient spinner styling methods for component styles.
///
/// This mixin requires the implementing class to provide a method that accepts
/// a RemixSpinnerStyler and returns the modified component style.
mixin SpinnerStyleMixin<T extends Mix<Object?>> {
  /// Must be implemented by the class using this mixin
  /// Should merge the provided RemixSpinnerStyler with the component's spinner style
  T spinner(RemixSpinnerStyler value);

  /// Sets spinner indicator color
  T spinnerIndicatorColor(Color value) {
    return spinner(RemixSpinnerStyler(indicatorColor: value));
  }

  /// Sets spinner track color
  T spinnerTrackColor(Color value) {
    return spinner(RemixSpinnerStyler(trackColor: value));
  }

  /// Sets spinner size
  T spinnerSize(double value) {
    return spinner(RemixSpinnerStyler(size: value));
  }

  /// Sets spinner stroke width
  T spinnerStrokeWidth(double value) {
    return spinner(RemixSpinnerStyler(strokeWidth: value));
  }

  /// Sets spinner track stroke width
  T spinnerTrackStrokeWidth(double value) {
    return spinner(RemixSpinnerStyler(trackStrokeWidth: value));
  }

  /// Sets spinner animation duration
  T spinnerDuration(Duration value) {
    return spinner(RemixSpinnerStyler(duration: value));
  }

  /// Sets spinner animation to fast (500ms)
  T spinnerFast() {
    return spinner(
      RemixSpinnerStyler(duration: const Duration(milliseconds: 500)),
    );
  }

  /// Sets spinner animation to normal (1000ms)
  T spinnerNormal() {
    return spinner(
      RemixSpinnerStyler(duration: const Duration(milliseconds: 1000)),
    );
  }

  /// Sets spinner animation to slow (1500ms)
  T spinnerSlow() {
    return spinner(
      RemixSpinnerStyler(duration: const Duration(milliseconds: 1500)),
    );
  }
}
