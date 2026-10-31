import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The ways a user can ask an app to reduce motion.
enum ReducedMotionRequest {
  mediaQuery('MediaQuery.disableAnimations'),
  platformDisableAnimations('the platform disableAnimations flag'),
  platformReduceMotion('the platform reduceMotion flag');

  const ReducedMotionRequest(this.label);

  final String label;
}

/// Turns a [ReducedMotionRequest] on and off while a test runs.
///
/// Place [wrap] above the widgets under test so the [MediaQuery] request can
/// change without remounting them. Pump after [set] to deliver the change.
class ReducedMotionSwitch {
  ReducedMotionSwitch(this._tester) {
    addTearDown(_mediaQueryDisables.dispose);
    addTearDown(_tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  }

  final WidgetTester _tester;
  final _mediaQueryDisables = ValueNotifier<bool>(false);

  Widget wrap(Widget child) => ValueListenableBuilder<bool>(
    valueListenable: _mediaQueryDisables,
    builder: (context, disabled, _) {
      final data = MediaQuery.of(context);
      return MediaQuery(
        data: data.copyWith(
          disableAnimations: data.disableAnimations || disabled,
        ),
        child: child,
      );
    },
  );

  void set(ReducedMotionRequest request, {required bool on}) {
    switch (request) {
      case ReducedMotionRequest.mediaQuery:
        _mediaQueryDisables.value = on;
      case ReducedMotionRequest.platformDisableAnimations:
        _tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(disableAnimations: on);
      case ReducedMotionRequest.platformReduceMotion:
        _tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(reduceMotion: on);
    }
  }
}
