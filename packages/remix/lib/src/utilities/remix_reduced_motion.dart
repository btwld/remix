import 'package:flutter/widgets.dart';

/// Whether motion is reduced under [context]: [MediaQueryData.disableAnimations]
/// is set, or the platform reports its accessibility `reduceMotion` feature.
///
/// Registers [context] as a dependent of the [MediaQuery] flag and the [View].
/// Neither notifies when the platform's `reduceMotion` changes, so a widget
/// that must follow it observes
/// [WidgetsBindingObserver.didChangeAccessibilityFeatures], as
/// [RemixReducedMotionBuilder] does.
bool remixReducedMotionOf(BuildContext context) {
  final dispatcher = View.maybeOf(context)?.platformDispatcher;

  return (MediaQuery.maybeDisableAnimationsOf(context) ?? false) ||
      (dispatcher?.accessibilityFeatures.reduceMotion ?? false);
}

/// Builds with whether the user asked for reduced motion, and rebuilds when
/// that changes.
///
/// Motion is reduced when [MediaQueryData.disableAnimations] is set, which is
/// how Android and desktop report "remove animations" and how an application
/// overrides it for a subtree, or when the platform's accessibility
/// `reduceMotion` feature is set. iOS Reduce Motion only sets `reduceMotion`,
/// so reading [MediaQueryData.disableAnimations] alone misses it.
///
/// A [MediaQuery] override can force reduced motion on for a subtree. It
/// cannot turn the platform's `reduceMotion` off.
///
/// ```dart
/// RemixReducedMotionBuilder(
///   builder: (context, reduceMotion) => AnimatedOpacity(
///     opacity: visible ? 1 : 0,
///     duration: reduceMotion
///         ? Duration.zero
///         : const Duration(milliseconds: 200),
///     child: child,
///   ),
/// )
/// ```
class RemixReducedMotionBuilder extends StatefulWidget {
  const RemixReducedMotionBuilder({super.key, required this.builder});

  /// Builds the subtree for the current preference.
  final Widget Function(BuildContext context, bool reduceMotion) builder;

  @override
  State<RemixReducedMotionBuilder> createState() =>
      _RemixReducedMotionBuilderState();
}

class _RemixReducedMotionBuilderState extends State<RemixReducedMotionBuilder>
    with WidgetsBindingObserver {
  bool? _reduceMotion;

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
  void didChangeAccessibilityFeatures() {
    if (remixReducedMotionOf(context) != _reduceMotion) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = _reduceMotion = remixReducedMotionOf(context);

    return widget.builder(context, reduceMotion);
  }
}
