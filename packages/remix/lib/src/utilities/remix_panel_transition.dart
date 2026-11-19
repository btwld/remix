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
/// panel with [RemixPanelTransitionHost]. The animation starts when the open
/// is requested, not when the panel first builds, so it is a frame ahead of
/// the panel.
@internal
final class RemixPanelTransitionHandle extends ChangeNotifier {
  RemixPanelTransitionHandle({
    required this.vsync,
    required this.resolve,
    required this.reduceMotion,
  });

  final TickerProvider vsync;

  /// The transition the style gives the panel about to open, or `null`.
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
      _begin();
      showOverlay();
    }

    if (userRequested == null) {
      show();
    } else {
      userRequested(position, show);
    }
  }

  void _begin() {
    final transition = resolve();
    _closing = false;
    _transition = transition;
    if (transition == null) return;
    final controller = _controller ??= AnimationController(vsync: vsync);
    controller
      ..duration = transition.duration
      ..reverseDuration = transition.reverseDuration ?? transition.duration;
    if (reduceMotion()) {
      controller.value = 1;
    } else {
      controller.forward(from: 0);
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

  void _close(VoidCallback hideOverlay) {
    final controller = _controller;
    if (_transition == null || controller == null || reduceMotion()) {
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
@internal
final class RemixPanelTransitionHost extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final animation = handle.animation;
    final transition = this.transition;
    if (animation == null || transition == null) return child;

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
              anchorRect: anchorRect,
            ),
            child,
          ),
        ),
      ),
    );
  }
}
