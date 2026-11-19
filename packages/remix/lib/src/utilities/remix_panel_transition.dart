import 'package:flutter/foundation.dart' show ChangeNotifier, internal;
import 'package:flutter/widgets.dart';

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

/// Runs the open and close animation of one overlay component's panel.
///
/// The component owns one (it is the [TickerProvider]), passes [openRequested]
/// and [closeRequested] as the anchor's request callbacks, and builds its
/// panel with [RemixPanelTransitionHost].
///
/// The animation starts when the open is requested, so it is in step with the
/// panel rather than a frame behind it. That moment is before the panel
/// exists, so [resolve] reads the style where the component is. The panel then
/// resolves its own style, in its own scope, and [RemixPanelTransitionHost]
/// reports it through [adopt]: the panel's builder is the one that runs, and
/// its durations pace the rest of the animation and the exit. A style whose
/// transition differs between the two scopes therefore opens with the
/// component's durations and closes with the panel's.
@internal
final class RemixPanelTransitionHandle extends ChangeNotifier {
  RemixPanelTransitionHandle({
    required this.vsync,
    required this.resolve,
    required this.reduceMotion,
  });

  final TickerProvider vsync;

  /// The transition the style gives the panel about to open, read where the
  /// component is, or `null`.
  final RemixPanelTransition? Function() resolve;

  /// Whether the user asks to reduce motion.
  final bool Function() reduceMotion;

  AnimationController? _controller;
  RemixPanelTransition? _transition;
  bool _closing = false;

  /// The animation of the open or closing panel, or `null` without a
  /// transition.
  Animation<double>? get animation => _transition == null ? null : _controller;

  /// Whether the exit is playing.
  bool get closing => _closing;

  /// An `onOpenRequested` that starts the transition when the panel shows.
  ///
  /// A caller-supplied [userRequested] runs first and keeps its contract: the
  /// panel shows when it calls `showOverlay`, and that call starts the open.
  void openRequested(
    Offset? position,
    VoidCallback showOverlay,
    void Function(Offset? position, VoidCallback showOverlay)? userRequested,
  ) {
    void show() {
      _start(resolve());
      showOverlay();
    }

    if (userRequested == null) {
      show();
    } else {
      userRequested(position, show);
    }
  }

  void _start(RemixPanelTransition? transition) {
    _closing = false;
    _transition = transition;
    if (transition == null) return;
    final controller = _controller ??= AnimationController(vsync: vsync);
    _pace(controller, transition);
    if (reduceMotion()) {
      controller.value = 1;
    } else {
      controller.forward(from: 0);
    }
  }

  static void _pace(
    AnimationController controller,
    RemixPanelTransition transition,
  ) {
    controller
      ..duration = transition.duration
      ..reverseDuration = transition.reverseDuration ?? transition.duration;
  }

  /// Takes the transition the panel resolved in its own scope.
  ///
  /// Called by [RemixPanelTransitionHost] when the panel mounts or its
  /// transition changes. It starts the animation when the request did not, and
  /// stops it when the panel has none.
  void adopt(RemixPanelTransition? transition) {
    if (_closing) return;
    if (transition == null) {
      _transition = null;
      _controller?.stop();
      return;
    }
    final controller = _controller;
    if (_transition == null || controller == null) {
      _start(transition);
      return;
    }
    _transition = transition;
    _pace(controller, transition);
  }

  /// Completes an animation in flight at its end when the user starts asking
  /// to reduce motion.
  void settleWhenReduced() {
    final controller = _controller;
    if (controller == null || !controller.isAnimating || !reduceMotion()) {
      return;
    }
    final closing = controller.status == AnimationStatus.reverse;
    // Complete the exit future before setting the endpoint. A canceled ticker
    // would strand the close callback that unmounts the overlay.
    controller.stop(canceled: false);
    controller.value = closing ? 0 : 1;
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

  void _close(VoidCallback hideOverlay) {
    final controller = _controller;
    if (_transition == null ||
        controller == null ||
        controller.value == 0 ||
        reduceMotion()) {
      _transition = null;
      hideOverlay();
      return;
    }
    // A second request while the exit plays keeps the first one's hide.
    if (_closing) return;
    _closing = true;
    notifyListeners();
    controller.reverse().then((_) {
      _transition = null;
      _closing = false;
      hideOverlay();
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

/// Builds [child] through the transition the [handle] is running, and returns
/// it unchanged when there is none.
///
/// [transition] is what the panel resolved in its own scope. The host hands it
/// to the [handle], so the builder and the exit follow the panel's style.
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

class _RemixPanelTransitionHostState extends State<RemixPanelTransitionHost> {
  @override
  void initState() {
    super.initState();
    widget.handle.adopt(widget.transition);
  }

  @override
  void didUpdateWidget(RemixPanelTransitionHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.transition != oldWidget.transition) {
      widget.handle.adopt(widget.transition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final handle = widget.handle;
    final animation = handle.animation;
    final transition = widget.transition;
    if (animation == null || transition == null) return widget.child;

    // A closing panel takes no input, so a click cannot select an item that
    // is already leaving.
    return ListenableBuilder(
      listenable: handle,
      builder: (context, _) => IgnorePointer(
        ignoring: handle.closing,
        child: Builder(
          builder: (context) => transition.builder(
            context,
            RemixPanelTransitionInfo(
              animation: animation,
              anchorRect: widget.anchorRect,
            ),
            widget.child,
          ),
        ),
      ),
    );
  }
}
