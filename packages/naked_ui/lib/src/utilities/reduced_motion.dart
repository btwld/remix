import 'package:flutter/widgets.dart';

/// Whether motion under [context] should be skipped.
///
/// True when [MediaQueryData.disableAnimations] is set or the platform reports
/// `AccessibilityFeatures.reduceMotion`. iOS Reduce Motion sets only the
/// latter, and [MediaQuery] does not notify its dependents when it changes, so
/// a widget that must react to a change also observes
/// [WidgetsBindingObserver.didChangeAccessibilityFeatures].
///
/// Registers [context] as a dependent of the [MediaQuery] flag and the [View].
bool reducedMotionOf(BuildContext context) {
  final dispatcher = View.maybeOf(context)?.platformDispatcher;

  return (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
      (dispatcher?.accessibilityFeatures.reduceMotion ?? false);
}
