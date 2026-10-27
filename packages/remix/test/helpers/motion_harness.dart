import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

/// The ways a user asks for reduced motion.
enum MotionRequest {
  /// `MediaQueryData.disableAnimations`: Android and desktop settings, or an
  /// application override for a subtree.
  mediaQuery,

  /// The platform's accessibility `reduceMotion` feature, the only one iOS
  /// Reduce Motion sets.
  platform,
}

/// Hosts a widget under a `MaterialApp` and turns reduced motion on and off
/// while the widget stays mounted.
final class MotionHarness {
  MotionHarness._(this._tester, this._disableAnimations);

  final WidgetTester _tester;
  final ValueNotifier<bool> _disableAnimations;

  /// Pumps [child] with reduced motion off.
  static Future<MotionHarness> pump(WidgetTester tester, Widget child) async {
    final disableAnimations = ValueNotifier(false);
    addTearDown(disableAnimations.dispose);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

    await tester.pumpWidget(
      MixScope.empty(
        child: MaterialApp(
          home: ValueListenableBuilder<bool>(
            valueListenable: disableAnimations,
            builder: (context, disabled, _) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(disableAnimations: disabled),
              child: Scaffold(body: Center(child: child)),
            ),
          ),
        ),
      ),
    );

    return MotionHarness._(tester, disableAnimations);
  }

  /// Turns [request] on or off and pumps one frame.
  Future<void> set(MotionRequest request, {required bool enabled}) async {
    switch (request) {
      case MotionRequest.mediaQuery:
        _disableAnimations.value = enabled;
      case MotionRequest.platform:
        _tester.platformDispatcher.accessibilityFeaturesTestValue =
            FakeAccessibilityFeatures(reduceMotion: enabled);
    }
    await _tester.pump();
  }
}

/// The opacity at which [finder] is painted, combining every ancestor
/// [Opacity] and [FadeTransition].
double effectiveOpacity(WidgetTester tester, Finder finder) {
  final fades = find.ancestor(
    of: finder,
    matching: find.byWidgetPredicate(
      (widget) => widget is Opacity || widget is FadeTransition,
    ),
  );

  return fades.evaluate().fold(1.0, (opacity, element) {
    final widget = element.widget;

    return opacity *
        switch (widget) {
          Opacity(:final opacity) => opacity,
          FadeTransition(:final opacity) => opacity.value,
          _ => 1.0,
        };
  });
}
