import 'package:flutter/widgets.dart';

/// Builds with whether the user asked for reduced motion, and rebuilds when
/// that changes.
///
/// Motion is reduced when [MediaQueryData.disableAnimations] is set, which is
/// how Android and desktop report "remove animations" and how an application
/// overrides it for a subtree, or when the platform's accessibility
/// `reduceMotion` feature is set. iOS Reduce Motion only sets `reduceMotion`,
/// so reading [MediaQueryData.disableAnimations] alone misses it, and
/// [MediaQuery] does not notify its dependents when it changes.
///
/// ```dart
/// RemixReducedMotion(
///   builder: (context, reduceMotion) => AnimatedSwitcher(
///     duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 200),
///     child: child,
///   ),
/// )
/// ```
class RemixReducedMotion extends StatefulWidget {
  const RemixReducedMotion({super.key, required this.builder});

  /// Builds the subtree for the current preference.
  final Widget Function(BuildContext context, bool reduceMotion) builder;

  /// Whether motion is reduced at the moment of the call.
  ///
  /// Use this where a transition starts, such as showing a route or handling
  /// a tap. Called from `build`, it rebuilds for [MediaQueryData] changes but
  /// not for the platform's `reduceMotion`; use [RemixReducedMotion] when the
  /// UI itself depends on the preference.
  static bool of(BuildContext context) {
    final dispatcher = View.maybeOf(context)?.platformDispatcher;

    return (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
        (dispatcher?.accessibilityFeatures.reduceMotion ?? false);
  }

  @override
  State<RemixReducedMotion> createState() => _RemixReducedMotionState();
}

class _RemixReducedMotionState extends State<RemixReducedMotion>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAccessibilityFeatures() => setState(() {});

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, RemixReducedMotion.of(context));
}
