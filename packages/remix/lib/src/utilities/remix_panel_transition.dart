import 'dart:async' show scheduleMicrotask;

import 'package:flutter/foundation.dart' show ChangeNotifier, internal;
import 'package:flutter/widgets.dart';
import 'package:naked_ui/src/base/overlay_base.dart' show OverlayTriggerScope;

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
  final Rect anchorRect;
}

/// Wraps an overlay panel in an open and close transition.
///
/// `context` is inside the overlay and `panel` is the whole styled panel.
/// Menu, popover and select provide their resolved side and alignment through
/// `OverlayPlacement.maybeOf(context)`. A combobox using Flutter's autocomplete
/// overlay does not establish its own placement scope. Shared builders should
/// use a fallback instead of requiring placement.
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
/// whatever the durations. Without a transition the component keeps its
/// default motion.
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
/// The transition comes from the mounted panel, never from the anchor.
@internal
final class RemixPanelTransitionHandle extends ChangeNotifier {
  RemixPanelTransitionHandle({required this.vsync});

  final TickerProvider vsync;

  AnimationController? _controller;
  RemixPanelTransition? _panelTransition;
  RemixPanelTransition? _exitTransition;
  Object? _openRequest;
  Object? _closeRequest;
  Offset? _openPosition;
  bool _reduceMotion = false;
  bool _disposed = false;

  RemixPanelTransition? get _transition => _exitTransition ?? _panelTransition;

  bool get isExiting => _exitTransition != null;

  Widget wrapAnchor(Widget child) =>
      OverlayTriggerScope(isExiting: () => isExiting, child: child);

  /// Shows the overlay, or reverses an exit without reopening the portal.
  ///
  /// A newer request supersedes a deferred show. When [isOpen] is supplied,
  /// only requests with a different position are forwarded to an open anchor.
  void openRequested(
    Offset? position,
    VoidCallback showOverlay,
    void Function(Offset? position, VoidCallback showOverlay)? userRequested, {
    bool Function()? isOpen,
  }) {
    if (_disposed) return;
    final request = _openRequest = Object();
    void show() {
      if (!identical(_openRequest, request)) return;
      _openRequest = null;
      _closeRequest = null;
      if (isExiting) {
        _exitTransition = null;
        final transition = _panelTransition;
        if (transition == null) {
          _controller?.stop();
        } else {
          _open(transition);
        }
        notifyListeners();
        return;
      }
      if (isOpen?.call() ?? false) {
        if (_openPosition == position) return;
      } else {
        _panelTransition = null;
        _controller?.stop();
      }
      _openPosition = position;
      showOverlay();
    }

    if (userRequested == null) {
      show();
    } else {
      userRequested(position, show);
    }
  }

  void _open(RemixPanelTransition transition, {double? from}) {
    final controller = _controller ??= AnimationController(
      vsync: vsync,
      animationBehavior: AnimationBehavior.preserve,
    );
    _pace(controller, transition);
    if (_reduceMotion) {
      controller.value = 1;
    } else {
      controller.forward(from: from);
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

  /// Starts or updates the transition the mounted panel resolved.
  void adopt(RemixPanelTransition? transition) {
    final previous = _panelTransition;
    _panelTransition = transition;
    if (isExiting) return;
    if (transition == null) {
      _controller?.stop();
      return;
    }
    final controller = _controller;
    if (previous == null || controller == null) {
      _open(transition, from: 0);
      return;
    }
    _pace(controller, transition);
  }

  void updateReducedMotion(bool reduceMotion) {
    _reduceMotion = reduceMotion;
    final controller = _controller;
    if (!reduceMotion || controller == null || !controller.isAnimating) {
      return;
    }
    controller.stop(canceled: false);
    controller.value = isExiting ? 0 : 1;
  }

  /// An `onCloseRequested` that plays the exit before the panel hides.
  ///
  /// A caller-supplied [userRequested] runs first and keeps its contract: the
  /// panel stays open until it calls `hideOverlay`, and that call plays the
  /// exit. New requests supersede a deferred hide until the exit starts.
  void closeRequested(
    VoidCallback hideOverlay,
    void Function(VoidCallback hideOverlay)? userRequested,
  ) {
    if (_disposed || isExiting) return;
    final request = _closeRequest = Object();
    _openRequest = null;

    void hide() {
      if (!identical(_closeRequest, request)) return;
      _closeRequest = null;
      _panelTransition = null;
      _exitTransition = null;
      _controller?.stop();
      hideOverlay();
    }

    void startExit() {
      if (!identical(_closeRequest, request) || isExiting) return;
      final controller = _controller;
      final transition = _panelTransition;
      if (transition == null ||
          controller == null ||
          controller.value == 0 ||
          _reduceMotion) {
        hide();
        return;
      }
      _exitTransition = transition;
      controller.reverse().then((_) => hide());
      notifyListeners();
    }

    if (userRequested == null) {
      startExit();
    } else {
      userRequested(startExit);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _openRequest = null;
    _closeRequest = null;
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

class _RemixPanelTransitionHostState extends State<RemixPanelTransitionHost>
    with WidgetsBindingObserver {
  FocusNode? _focusGate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.handle.addListener(_onExitChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncReducedMotion();
    widget.handle.adopt(widget.transition);
  }

  @override
  void didUpdateWidget(RemixPanelTransitionHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.handle != oldWidget.handle) {
      oldWidget.handle.removeListener(_onExitChanged);
      widget.handle.addListener(_onExitChanged);
      _focusGate?.descendantsAreFocusable = !widget.handle.isExiting;
      _syncReducedMotion();
    }
    widget.handle.adopt(widget.transition);
  }

  @override
  void didChangeAccessibilityFeatures() => _syncReducedMotion();

  void _syncReducedMotion() =>
      widget.handle.updateReducedMotion(remixReducedMotionOf(context));

  void _onExitChanged() {
    final handle = widget.handle;
    scheduleMicrotask(() {
      if (!mounted || widget.handle != handle) return;
      FocusManager.instance.applyFocusChangesIfNeeded();
      _focusGate?.descendantsAreFocusable = !handle.isExiting;
    });
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.handle.removeListener(_onExitChanged);
    _focusGate?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final handle = widget.handle;
    final transition = handle._transition;
    final animation = handle._controller;
    if (animation == null || transition == null) return widget.child;
    final exiting = handle.isExiting;
    return Focus.withExternalFocusNode(
      focusNode: _focusGate ??= FocusNode(
        canRequestFocus: false,
        skipTraversal: true,
        descendantsAreFocusable: !exiting,
      ),
      includeSemantics: false,
      child: ExcludeSemantics(
        excluding: exiting,
        child: IgnorePointer(
          ignoring: exiting,
          child: Builder(
            builder: (context) => transition.builder(
              context,
              RemixPanelTransitionInfo(
                animation: animation.view,
                anchorRect: widget.anchorRect,
              ),
              widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
