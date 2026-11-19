import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/widgets.dart';

import 'remix_reduced_motion.dart';

/// What a [RemixPanelTransitionBuilder] receives for one overlay panel.
@immutable
final class RemixPanelTransitionInfo {
  const RemixPanelTransitionInfo({
    required this.animation,
    required this.anchorRect,
  });

  /// Runs from `0.0` to `1.0` while the panel opens and back to `0.0` while it
  /// closes. It is paced by [RemixPanelTransition.duration] and
  /// [RemixPanelTransition.reverseDuration] and is linear: apply a curve in
  /// the builder, so one recipe can use a different curve for each part of the
  /// motion.
  ///
  /// The panel stays mounted until the animation is dismissed.
  final Animation<double> animation;

  /// The bounds of the trigger, in the overlay's coordinate space.
  ///
  /// Read `OverlayPlacement.maybeOf(context)` in the builder for the side the
  /// panel was placed on after collision handling.
  final Rect anchorRect;
}

/// Wraps an overlay panel in an open and close transition.
///
/// `context` is inside the overlay, below the panel's placement, so
/// `OverlayPlacement.maybeOf(context)` gives the side and alignment the panel
/// resolved to. `panel` is the whole styled panel.
typedef RemixPanelTransitionBuilder =
    Widget Function(
      BuildContext context,
      RemixPanelTransitionInfo info,
      Widget panel,
    );

/// A motion for an overlay panel: how long it runs and how it paints.
///
/// Set it from a style, so a preset's recipe owns the motion:
///
/// ```dart
/// MenuStyler().panelTransition(
///   RemixPanelTransition(
///     duration: const Duration(milliseconds: 360),
///     reverseDuration: const Duration(milliseconds: 260),
///     builder: (context, info, panel) => FadeTransition(
///       opacity: info.animation,
///       child: panel,
///     ),
///   ),
/// )
/// ```
///
/// While the user asks to reduce motion the panel opens and closes at once,
/// whatever the durations. Without a transition a panel shows and hides at
/// once, as before.
@immutable
final class RemixPanelTransition {
  const RemixPanelTransition({
    required this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
  });

  /// Wraps the panel.
  final RemixPanelTransitionBuilder builder;

  /// How long the panel takes to open.
  final Duration duration;

  /// How long the panel takes to close. Defaults to [duration].
  final Duration? reverseDuration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixPanelTransition &&
          builder == other.builder &&
          duration == other.duration &&
          reverseDuration == other.reverseDuration;

  @override
  int get hashCode => Object.hash(builder, duration, reverseDuration);

  @override
  String toString() =>
      'RemixPanelTransition(duration: $duration, '
      'reverseDuration: $reverseDuration)';
}

/// Lets a component's close request reach the panel it opened.
///
/// The component owns one, passes [closeRequested] as the anchor's
/// `onCloseRequested`, and builds its panel with [RemixPanelTransitionHost].
@internal
final class RemixPanelTransitionHandle {
  _RemixPanelTransitionHostState? _host;

  /// Plays the exit, then calls [hideOverlay]; hides at once when no panel
  /// with a transition is mounted.
  void _close(VoidCallback hideOverlay) {
    final host = _host;
    if (host == null) {
      hideOverlay();
    } else {
      host._close(hideOverlay);
    }
  }

  /// An `onCloseRequested` that plays the exit before the panel hides.
  ///
  /// A caller-supplied [userRequested] runs first and keeps its contract: the
  /// panel stays open until it calls `hideOverlay`, and that call plays the
  /// exit.
  void closeRequested(
    VoidCallback hideOverlay,
    void Function(VoidCallback hideOverlay)? userRequested,
  ) {
    if (userRequested == null) {
      _close(hideOverlay);
    } else {
      userRequested(() => _close(hideOverlay));
    }
  }
}

/// Owns the open and close animation of one mounted overlay panel.
///
/// Builds [child] through [transition] when set, and otherwise returns it
/// unchanged. The animation starts after the first frame, so the panel is
/// painted at `0.0` before it opens.
@internal
final class RemixPanelTransitionHost extends StatefulWidget {
  const RemixPanelTransitionHost({
    super.key,
    required this.handle,
    required this.transition,
    required this.anchorRect,
    required this.child,
  });

  final RemixPanelTransitionHandle handle;
  final RemixPanelTransition? transition;
  final Rect anchorRect;
  final Widget child;

  @override
  State<RemixPanelTransitionHost> createState() =>
      _RemixPanelTransitionHostState();
}

class _RemixPanelTransitionHostState extends State<RemixPanelTransitionHost>
    with SingleTickerProviderStateMixin {
  // Created only for a panel that has a transition, so a plain panel never
  // builds a ticker.
  AnimationController? _animation;
  AnimationController get _controller =>
      _animation ??= AnimationController(vsync: this);
  bool _closing = false;
  bool _started = false;

  RemixPanelTransition? get _transition => widget.transition;

  @override
  void initState() {
    super.initState();
    widget.handle._host = this;
    if (_transition == null) return;
    _syncDurations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_closing) _open();
    });
  }

  @override
  void didUpdateWidget(RemixPanelTransitionHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.handle != widget.handle) {
      oldWidget.handle._host = null;
      widget.handle._host = this;
    }
    _syncDurations();
    if (oldWidget.transition == null && widget.transition != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_closing) _open();
      });
    }
  }

  @override
  void dispose() {
    if (widget.handle._host == this) widget.handle._host = null;
    _animation?.dispose();
    super.dispose();
  }

  void _syncDurations() {
    final transition = _transition;
    if (transition == null) return;
    _controller.duration = transition.duration;
    _controller.reverseDuration =
        transition.reverseDuration ?? transition.duration;
  }

  void _open() {
    _started = true;
    if (remixReducedMotionOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  void _close(VoidCallback hideOverlay) {
    if (_transition == null || remixReducedMotionOf(context)) {
      hideOverlay();
      return;
    }
    // A second request while the exit plays keeps the first one's hide.
    if (_closing) return;
    setState(() => _closing = true);
    // Closed before the open frame ran: nothing is visible to animate.
    if (!_started) {
      hideOverlay();
      return;
    }
    _controller.reverse().then((_) {
      if (mounted) hideOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transition = _transition;
    if (transition == null) return widget.child;

    // A closing panel takes no input, so a click cannot select an item that
    // is already leaving.
    return IgnorePointer(
      ignoring: _closing,
      child: Builder(
        builder: (context) => transition.builder(
          context,
          RemixPanelTransitionInfo(
            animation: _controller,
            anchorRect: widget.anchorRect,
          ),
          widget.child,
        ),
      ),
    );
  }
}
