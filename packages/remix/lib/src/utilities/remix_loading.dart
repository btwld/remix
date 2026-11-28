import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';

import 'remix_reduced_motion.dart';

/// Lays [control] out exactly as it would alone and, while [announcement] is
/// set, adds a live region that reads it.
///
/// The Stack is always present, so toggling loading neither remounts the
/// control nor changes the constraints it lays out under.
@internal
Widget remixLoadingAnnouncer({
  required Widget control,
  required String? announcement,
}) => Stack(
  fit: .passthrough,
  children: [
    control,
    if (announcement != null)
      PositionedDirectional(
        start: 0,
        top: 0,
        child: Semantics(
          liveRegion: true,
          label: announcement,
          child: const SizedBox.square(dimension: 1),
        ),
      ),
  ],
);

/// Wraps one part of a control while it enters or leaves its loading state.
///
/// `animation` runs from `0.0` to `1.0` when loading starts and back to `0.0`
/// when it ends. It is linear: apply a curve in the builder. Read
/// `animation.status` to tell the way in from the way out.
typedef RemixLoadingTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

/// How a control moves between its content and its loading spinner.
///
/// Set it from a style, so a preset's recipe owns the motion:
///
/// ```dart
/// Widget scaleIn(BuildContext context, Animation<double> animation, Widget child) =>
///     ScaleTransition(
///       scale: Tween(begin: 0.7, end: 1.0).animate(animation),
///       child: FadeTransition(opacity: animation, child: child),
///     );
///
/// ButtonStyler().loadingTransition(
///   const RemixLoadingTransition(spinnerBuilder: scaleIn),
/// )
/// ```
///
/// Builders compare by identity, so pass top-level functions or static
/// tear-offs rather than inline closures. The content keeps its size while it
/// is hidden, and the spinner stays mounted until its exit has played. While
/// the user asks to reduce motion both parts switch at once, whatever the
/// durations.
@immutable
final class RemixLoadingTransition {
  const RemixLoadingTransition({
    this.duration = const Duration(milliseconds: 150),
    this.reverseDuration,
    this.contentBuilder = fadeOut,
    this.spinnerBuilder = fadeIn,
  });

  /// How long loading takes to start.
  final Duration duration;

  /// How long loading takes to end. Defaults to [duration].
  final Duration? reverseDuration;

  /// Wraps each part of the content, such as the label and each icon.
  final RemixLoadingTransitionBuilder contentBuilder;

  /// Wraps the spinner.
  final RemixLoadingTransitionBuilder spinnerBuilder;

  /// Fades [child] out as loading starts. The default [contentBuilder].
  static Widget fadeOut(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) => FadeTransition(opacity: ReverseAnimation(animation), child: child);

  /// Fades [child] in as loading starts. The default [spinnerBuilder].
  static Widget fadeIn(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) => FadeTransition(opacity: animation, child: child);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixLoadingTransition &&
          duration == other.duration &&
          reverseDuration == other.reverseDuration &&
          contentBuilder == other.contentBuilder &&
          spinnerBuilder == other.spinnerBuilder;

  @override
  int get hashCode =>
      Object.hash(duration, reverseDuration, contentBuilder, spinnerBuilder);

  @override
  String toString() =>
      'RemixLoadingTransition(duration: $duration, '
      'reverseDuration: $reverseDuration)';
}

/// Owns the loading animation of one control, above its interactive widget.
///
/// Naked controls rebuild their subtree when they become disabled, and
/// loading disables them, so the animation must live above them. The styled
/// subtree hands its resolved transition up with [adopt].
@internal
final class RemixLoadingTransitionHost extends StatefulWidget {
  const RemixLoadingTransitionHost({
    super.key,
    required this.loading,
    required this.child,
  });

  final bool loading;
  final Widget child;

  /// Paces the nearest host with [transition] and returns its animation, or
  /// `null` when there is no host. Rebuilds [context] when the spinner mounts
  /// or unmounts.
  static Animation<double>? adopt(
    BuildContext context,
    RemixLoadingTransition transition,
  ) => context
      .dependOnInheritedWidgetOfExactType<_RemixLoadingScope>()
      ?.notifier
      ?._adopt(transition);

  @override
  State<RemixLoadingTransitionHost> createState() =>
      _RemixLoadingTransitionHostState();
}

final class _RemixLoadingScope extends InheritedNotifier<_RemixLoadingMotion> {
  const _RemixLoadingScope({required super.notifier, required super.child});
}

/// Notifies when the animation becomes dismissed or stops being dismissed,
/// which is when the spinner mounts or unmounts.
final class _RemixLoadingMotion extends ChangeNotifier {
  _RemixLoadingMotion(this._vsync, {required this.loading});

  final TickerProvider _vsync;
  bool loading;
  AnimationController? _controller;
  bool _dismissed = true;

  Animation<double> _adopt(RemixLoadingTransition transition) {
    final controller = _controller ??= AnimationController(
      vsync: _vsync,
      value: loading ? 1 : 0,
    )..addStatusListener(_onStatusChanged);
    _dismissed = controller.isDismissed;
    controller
      ..duration = transition.duration
      ..reverseDuration = transition.reverseDuration ?? transition.duration;
    return controller.view;
  }

  void _onStatusChanged(AnimationStatus status) {
    if (status.isDismissed == _dismissed) return;
    _dismissed = status.isDismissed;
    notifyListeners();
  }

  void play({required bool reduceMotion}) {
    final controller = _controller;
    if (controller == null) return;
    if (reduceMotion) {
      jump();
    } else if (loading) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  void jump() {
    final controller = _controller;
    if (controller == null) return;
    controller
      ..stop()
      ..value = loading ? 1 : 0;
  }

  bool get isAnimating => _controller?.isAnimating ?? false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class _RemixLoadingTransitionHostState extends State<RemixLoadingTransitionHost>
    with SingleTickerProviderStateMixin {
  late final _motion = _RemixLoadingMotion(this, loading: widget.loading);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_motion.isAnimating && remixReducedMotionOf(context)) _motion.jump();
  }

  @override
  void didUpdateWidget(RemixLoadingTransitionHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading == oldWidget.loading) return;
    _motion
      ..loading = widget.loading
      ..play(reduceMotion: remixReducedMotionOf(context));
  }

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _RemixLoadingScope(notifier: _motion, child: widget.child);
}
