import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'utilities/positioning.dart';
import 'utilities/reduced_motion.dart';

const _defaultTooltipAnimationStyle = AnimationStyle(
  curve: Curves.fastOutSlowIn,
  duration: Duration(milliseconds: 150),
  reverseDuration: Duration(milliseconds: 75),
);

/// A headless tooltip built on Flutter's [RawTooltip].
///
/// [RawTooltip] manages trigger handling, delays, feedback, animation,
/// hoverable content, and overlay lifetime. This widget provides the headless
/// overlay builder, collision-aware positioning, and optional semantics
/// filtering. [overlayBuilder] maps to [RawTooltip.tooltipBuilder], and
/// [semanticLabel] maps to [RawTooltip.semanticsTooltip].
///
/// Pass a [GlobalKey] to [tooltipKey] to show the tooltip imperatively via
/// [RawTooltipState.ensureTooltipVisible]. [onOpenChanged] reports visibility
/// and does not control it.
///
/// Only one [NakedTooltip] is visible at a time. Hover, focus, touch, or
/// [tooltipKey] activation replaces the visible tooltip without moving focus,
/// and the replaced tooltip disappears without an exit animation. Hover,
/// focus, and touch also close other [RawTooltip]s, such as Material's
/// `Tooltip`, which keep their exit animation; [tooltipKey] does not.
///
/// Keyboard focus opens the tooltip at once. Hover waits [hoverDelay], except
/// while another tooltip is visible or within [skipDelayDuration] after the
/// last one closed, so moving across neighboring triggers does not wait again.
class NakedTooltip extends StatefulWidget {
  /// Creates a headless tooltip.
  const NakedTooltip({
    super.key,
    required this.child,
    required this.overlayBuilder,
    this.tooltipKey,
    this.onOpenChanged,
    this.isFocusVisible,
    this.hoverDelay = Duration.zero,
    this.touchDelay = const Duration(milliseconds: 1500),
    this.dismissDelay = const Duration(milliseconds: 100),
    this.skipDelayDuration = const Duration(milliseconds: 300),
    this.enableTapToDismiss = true,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.enableFeedback = true,
    this.onTriggered,
    this.animationStyle = _defaultTooltipAnimationStyle,
    this.positioning = const OverlayPositionConfig(),
    this.semanticLabel,
    this.excludeSemantics = false,
    this.excludeOverlaySemantics,
  });

  /// The widget that triggers the tooltip.
  final Widget child;

  /// The builder that creates the tooltip overlay content.
  ///
  /// The animation runs from `0.0` to `1.0` while opening and reverses while
  /// closing.
  final TooltipComponentBuilder overlayBuilder;

  /// A key for imperative control via [RawTooltipState.ensureTooltipVisible].
  final GlobalKey<RawTooltipState>? tooltipKey;

  /// A callback invoked when the tooltip visible state changes.
  ///
  /// [RawTooltip] owns visibility. A tooltip replaced by another reports
  /// `false` at once. Notifications arrive after the current frame and stop
  /// when this widget is disposed.
  final ValueChanged<bool>? onOpenChanged;

  /// Reports whether focus is visible, as CSS `:focus-visible` defines it:
  /// true after keyboard navigation, false after a pointer press.
  ///
  /// Gaining focus shows the tooltip only when this returns true, so focus
  /// that a closing menu or dialog hands back to the trigger after pointer
  /// use does not open it. Hover still does. When `null`, every focus shows
  /// the tooltip.
  final ValueGetter<bool>? isFocusVisible;

  /// The semantic label attached to the trigger.
  final String? semanticLabel;

  /// The side, alignment, offset, and collision configuration for the overlay.
  final OverlayPositionConfig positioning;

  /// The delay before mouse hover requests the tooltip to open.
  ///
  /// Keyboard focus does not wait for it. Hover skips it while another tooltip
  /// is visible or closing, and within [skipDelayDuration] after the last one
  /// closed.
  final Duration hoverDelay;

  /// The duration a touch-triggered tooltip remains open after activation ends.
  final Duration touchDelay;

  /// The delay before pointer exit requests the tooltip to close.
  final Duration dismissDelay;

  /// How long after this tooltip closes, when no other is visible, hovering
  /// any trigger still opens its tooltip without [hoverDelay].
  ///
  /// While a tooltip is visible or closing, the next hovered tooltip opens at
  /// once regardless; [RawTooltip] does that itself. [Duration.zero] leaves
  /// only that, which suits dense grids of triggers where tooltips would flash
  /// while the pointer passes over them.
  final Duration skipDelayDuration;

  /// Whether tapping outside an open tooltip dismisses it.
  final bool enableTapToDismiss;

  /// The trigger mode for non-hover pointer input.
  final TooltipTriggerMode triggerMode;

  /// Whether touch activation provides platform feedback.
  final bool enableFeedback;

  /// A callback invoked when tap or long-press input triggers the tooltip.
  final TooltipTriggeredCallback? onTriggered;

  /// The show and hide curves and durations.
  ///
  /// Missing durations default to 150ms for showing and 75ms for hiding.
  /// The reverse curve defaults to the flipped show curve.
  ///
  /// While the user asks to reduce motion, the tooltip shows and hides at once
  /// whatever the durations. That is when [MediaQueryData.disableAnimations]
  /// is set or the platform reports `AccessibilityFeatures.reduceMotion`,
  /// which iOS sets for Reduce Motion. A change applies to the next show or
  /// hide. A tooltip that has not been shown yet when the setting is turned
  /// off may still show once without motion.
  final AnimationStyle animationStyle;

  /// Whether to hide the trigger and overlay subtrees from the semantics tree.
  final bool excludeSemantics;

  /// Whether to hide the visual overlay subtree from the semantics tree.
  ///
  /// When `null`, the overlay is excluded only when the trigger exposes a
  /// non-empty [semanticLabel]. Set to `true` to always exclude the overlay,
  /// or `false` to always include it.
  ///
  /// [excludeSemantics] takes precedence and hides the entire tooltip.
  final bool? excludeOverlaySemantics;

  @override
  State<NakedTooltip> createState() => _NakedTooltipState();
}

class _NakedTooltipState extends State<NakedTooltip>
    with WidgetsBindingObserver {
  static final Set<_NakedTooltipState> _mountedTooltips =
      <_NakedTooltipState>{};

  // The most recently activated tooltip. Hover, focus, touch, and command
  // activation each supersede the previous one, hiding it.
  static _NakedTooltipState? _current;

  // Whether a tooltip is visible, or the last one closed less than its
  // skipDelayDuration ago. Hover opens tooltips without hoverDelay meanwhile.
  // Changes only after frames and in timers, when every tooltip can rebuild.
  static final _warm = ValueNotifier<bool>(false);
  static Timer? _coolDown;

  final _internalTooltipKey = GlobalKey<RawTooltipState>();
  // Hides the overlay content as soon as another tooltip takes over, so the
  // previous bubble's exit animation never overlaps the next bubble.
  final _superseded = ValueNotifier<bool>(false);
  // Whether RawTooltip's animation is not dismissed, including while closing.
  bool _rawOpen = false;
  bool _visible = false;
  bool _reducedMotion = false;
  CurvedAnimation? _rawAnimation;

  // Focus trigger, Escape dismissal, and placement state layered over RawTooltip.
  Timer? _blurTimer;
  bool _focusWithin = false;
  bool _triggerHovered = false;
  bool _contentHovered = false;
  late OverlayPlacement _placement = _initialPlacement(widget.positioning);
  OverlayPlacement? _pendingPlacement;

  GlobalKey<RawTooltipState> get _tooltipKey =>
      widget.tooltipKey ?? _internalTooltipKey;

  static OverlayPlacement _initialPlacement(OverlayPositionConfig config) =>
      OverlayPlacement(
        side: config.side,
        alignment: config.alignment,
        offset: Offset.zero,
        wasFlipped: false,
        wasShifted: false,
      );

  AnimationStyle get _animationStyle {
    final style = widget.animationStyle;
    final curve = style.curve ?? _defaultTooltipAnimationStyle.curve!;
    return _defaultTooltipAnimationStyle.copyWith(
      curve: curve,
      reverseCurve: style.reverseCurve ?? curve.flipped,
      duration: _reducedMotion ? Duration.zero : style.duration,
      reverseDuration: _reducedMotion ? Duration.zero : style.reverseDuration,
    );
  }

  void _syncAnimationStyle() {
    final animation = _rawAnimation;
    if (animation == null) return;
    final style = _animationStyle;
    animation
      ..curve = style.curve!
      ..reverseCurve = style.reverseCurve;
    if (animation.parent case AnimationController controller) {
      controller
        ..duration = style.duration
        ..reverseDuration = style.reverseDuration;
    }
  }

  void _captureRawAnimation(Animation<double> animation) {
    // Flutter 3.41–3.47 caches these settings and ignores reverseCurve.
    // Update the supplied animation through its public properties; RawTooltip
    // still drives and disposes it and its controller, even when hidden.
    if (animation is! CurvedAnimation || animation == _rawAnimation) return;
    _rawAnimation = animation;
    final controller = animation.parent;
    final startedWith = controller is AnimationController
        ? controller.duration
        : null;
    _syncAnimationStyle();
    // RawTooltip may have created the controller, and started this show,
    // before the latest style reached it. Rerun the show from its current
    // value at the new pace.
    if (controller is AnimationController &&
        controller.status == AnimationStatus.forward &&
        controller.duration != startedWith) {
      controller.forward();
    }
  }

  void _updateReducedMotion() {
    _reducedMotion = reducedMotionOf(context);
    _syncAnimationStyle();
  }

  @override
  void initState() {
    super.initState();
    if (_mountedTooltips.isEmpty) {
      HardwareKeyboard.instance.addHandler(_handleHardwareKey);
    }
    _mountedTooltips.add(this);
    _warm.addListener(_handleWarmChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateReducedMotion();
  }

  @override
  void didChangeAccessibilityFeatures() {
    if (reducedMotionOf(context) != _reducedMotion) {
      setState(_updateReducedMotion);
    }
  }

  @override
  void didUpdateWidget(covariant NakedTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tooltipKey != oldWidget.tooltipKey) {
      _rawAnimation = null;
    } else if (widget.animationStyle != oldWidget.animationStyle) {
      _syncAnimationStyle();
    }
    if (widget.positioning.side != oldWidget.positioning.side ||
        widget.positioning.alignment != oldWidget.positioning.alignment) {
      _placement = _initialPlacement(widget.positioning);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _warm.removeListener(_handleWarmChanged);
    _mountedTooltips.remove(this);
    if (identical(_current, this)) _current = null;
    if (_mountedTooltips.isEmpty) {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
      _updateWarmth(Duration.zero);
    } else if (_visible) {
      final skipDelay = widget.skipDelayDuration;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _updateWarmth(skipDelay),
      );
    }
    _blurTimer?.cancel();
    _superseded.dispose();
    super.dispose();
  }

  void _handleWarmChanged() {
    // Only the hover delay given to RawTooltip depends on warmth.
    if (widget.hoverDelay > Duration.zero) setState(() {});
  }

  // Warms up while a tooltip is visible and cools down skipDelay after the
  // last one closes, or at once when no tooltip remains.
  static void _updateWarmth(Duration skipDelay) {
    if (_mountedTooltips.any((tooltip) => tooltip._visible)) {
      _coolDown?.cancel();
      _coolDown = null;
      _warm.value = true;
    } else if (_mountedTooltips.isEmpty || skipDelay == Duration.zero) {
      _coolDown?.cancel();
      _coolDown = null;
      _warm.value = false;
    } else if (_warm.value) {
      _coolDown ??= Timer(skipDelay, () {
        _coolDown = null;
        _warm.value = false;
      });
    }
  }

  void _show() => _tooltipKey.currentState?.ensureTooltipVisible();

  Iterable<_NakedTooltipState> get _others =>
      _mountedTooltips.where((tooltip) => !identical(tooltip, this));

  // Makes this the only tooltip that may be visible. RawTooltip already
  // dismisses unhovered tooltips when another trigger is hovered, so hover
  // passes dismissOthers: false. Focus, touch, and command activation pass
  // true.
  void _activate({required bool dismissOthers}) {
    _current = this;
    _superseded.value = false;
    var othersOpen = false;
    for (final tooltip in _others) {
      tooltip._supersede();
      othersOpen = othersOpen || tooltip._rawOpen;
    }
    final wasOpen = _rawOpen;
    // RawTooltip can only dismiss every tooltip. Before this one opens, that
    // also closes tooltips outside NakedTooltip, such as Material's. Once it
    // is open, dismissing would close it too, at once without animation, so
    // only do so for other NakedTooltips, which are hidden already, and reopen
    // this one.
    if (dismissOthers && (!wasOpen || othersOpen)) {
      RawTooltip.dismissAllToolTips();
      if (wasOpen) _show();
    }
    _syncVisibility();
  }

  void _supersede() {
    if (_rawOpen) _superseded.value = true;
    _syncVisibility();
  }

  // RawTooltip opened this tooltip without an activation seen here, such as a
  // command through tooltipKey.
  void _claim() {
    _current = this;
    if (!_others.any((tooltip) => tooltip._rawOpen)) {
      _superseded.value = false;
      return;
    }
    // This can run while the overlay builds, when the other tooltips cannot
    // rebuild. Stay hidden for this frame and take over after it.
    _superseded.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _rawOpen && identical(_current, this)) {
        _activate(dismissOthers: true);
      }
    });
  }

  void _handleRawStatus(AnimationStatus status) {
    final open = !status.isDismissed;
    // RawTooltip can also reopen a tooltip that is still closing.
    final reopened = open && (!_rawOpen || status == AnimationStatus.forward);
    _rawOpen = open;
    if (!open) {
      _contentHovered = false;
      _superseded.value = false;
    } else if (reopened && !identical(_current, this)) {
      _claim();
    }
    _syncVisibility();
  }

  void _syncVisibility() => _setVisible(_rawOpen && !_superseded.value);

  void _setVisible(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    // The overlay can first report its status during build. Deliver from the
    // owner so closing survives overlay removal, but not tooltip disposal.
    final skipDelay = widget.skipDelayDuration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onOpenChanged?.call(visible);
      _updateWarmth(skipDelay);
    });
  }

  void _handleFocusChange(bool focused) {
    // Focus that is not visible, such as focus a menu hands back after a
    // click, neither shows the tooltip nor holds it open.
    final holds = focused && (widget.isFocusVisible?.call() ?? true);
    if (holds == _focusWithin) return;
    _focusWithin = holds;
    _blurTimer?.cancel();
    _blurTimer = null;
    if (holds) {
      // Keyboard focus opens at once; hoverDelay paces only the pointer.
      _activate(dismissOthers: true);
      // Also cancels a dismissal RawTooltip has already scheduled.
      _show();
    } else if (widget.dismissDelay == Duration.zero) {
      _closeForBlur();
    } else {
      _blurTimer = Timer(widget.dismissDelay, _closeForBlur);
    }
  }

  void _closeForBlur() {
    _blurTimer = null;
    if (!mounted || _focusWithin || _triggerHovered || _contentHovered) return;
    // A replaced tooltip is hidden, so this cannot close its replacement.
    if (_visible) RawTooltip.dismissAllToolTips();
  }

  void _handlePointerExit() {
    // RawTooltip schedules, or with a zero dismissDelay performs, its own
    // dismissal on pointer exit. Reopen afterwards while focus holds it,
    // unless another tooltip has taken over or Escape dismissed it.
    if (!_focusWithin) return;
    scheduleMicrotask(() {
      if (mounted && _focusWithin && identical(_current, this)) _show();
    });
  }

  static const _escapeActivator = SingleActivator(LogicalKeyboardKey.escape);

  static bool _isEscapeForVisibleTooltip(KeyEvent event) =>
      _mountedTooltips.any((tooltip) => tooltip._visible) &&
      _escapeActivator.accepts(event, HardwareKeyboard.instance);

  // Runs before any focus handling. From Flutter 3.50, RawTooltip dismisses
  // tooltips on Escape before focus handlers see the key, so record the
  // dismissal here too: no current tooltip, which keeps focus from reopening
  // the focused trigger's tooltip when the pointer leaves.
  static bool _handleHardwareKey(KeyEvent event) {
    if (_isEscapeForVisibleTooltip(event)) _current = null;

    return false;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Leave Escape to enclosing dismiss actions while no tooltip is visible.
    // Otherwise close the visible tooltip, which may belong to another
    // trigger.
    if (!_isEscapeForVisibleTooltip(event)) return KeyEventResult.ignored;
    _current = null;
    RawTooltip.dismissAllToolTips();

    return KeyEventResult.handled;
  }

  void _reportPlacement(OverlayPlacement placement) {
    // Resolved during layout, so descendants see it from the next frame.
    if (placement == _placement || placement == _pendingPlacement) return;
    final scheduled = _pendingPlacement != null;
    _pendingPlacement = placement;
    if (scheduled) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final next = _pendingPlacement;
      _pendingPlacement = null;
      if (mounted && next != null && next != _placement) {
        setState(() => _placement = next);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final animationStyle = _animationStyle;
    Widget result = RawTooltip(
      key: _tooltipKey,
      // RawTooltip treats an empty semantics label as "no tooltip". Preserve
      // NakedTooltip's ability to show visual content without a label.
      semanticsTooltip:
          widget.excludeSemantics ||
              widget.semanticLabel?.trim().isEmpty == true
          ? null
          : widget.semanticLabel,
      tooltipBuilder: (context, animation) {
        _captureRawAnimation(animation);
        return OverlayPlacementScope(
          placement: _placement,
          child: MouseRegion(
            opaque: false,
            onEnter: (_) => _contentHovered = true,
            onExit: (_) {
              _contentHovered = false;
              _handlePointerExit();
            },
            child: _NakedTooltipOverlay(
              animation: animation,
              superseded: _superseded,
              overlayBuilder: widget.overlayBuilder,
              onStatusChanged: _handleRawStatus,
              excludeSemantics: widget.excludeSemantics,
              excludeOverlaySemantics: widget.excludeOverlaySemantics,
              semanticLabel: widget.semanticLabel,
            ),
          ),
        );
      },
      hoverDelay: _warm.value ? Duration.zero : widget.hoverDelay,
      touchDelay: widget.touchDelay,
      dismissDelay: widget.dismissDelay,
      enableTapToDismiss: widget.enableTapToDismiss,
      triggerMode: widget.triggerMode,
      enableFeedback: widget.enableFeedback,
      onTriggered: () {
        // RawTooltip shows the tooltip right after this callback.
        _activate(dismissOthers: true);
        widget.onTriggered?.call();
      },
      animationStyle: animationStyle,
      positionDelegate: (position) {
        final placement = _resolvePlacement(
          position,
          widget.positioning,
          textDirection,
        );
        _reportPlacement(placement);

        return placement.offset;
      },
      child: widget.child,
    );
    result = MouseRegion(
      opaque: false,
      onEnter: (_) {
        _triggerHovered = true;
        _activate(dismissOthers: false);
      },
      onExit: (_) {
        _triggerHovered = false;
        _handlePointerExit();
      },
      child: result,
    );
    // Outside RawTooltip, so the overlay content shares this focus ancestry
    // and Escape from either the trigger or the content reaches it.
    result = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: _handleFocusChange,
      onKeyEvent: _handleKeyEvent,
      child: result,
    );

    return widget.excludeSemantics ? ExcludeSemantics(child: result) : result;
  }
}

OverlayPlacement _resolvePlacement(
  TooltipPositionContext context,
  OverlayPositionConfig positioning,
  TextDirection textDirection,
) {
  final targetRect = Rect.fromCenter(
    center: context.target,
    width: context.targetSize.width,
    height: context.targetSize.height,
  );
  return resolveOverlayPlacement(
    targetRect: targetRect,
    overlaySize: context.tooltipSize,
    boundsSize: context.overlaySize,
    positioning: positioning,
    textDirection: textDirection,
  );
}

class _NakedTooltipOverlay extends StatefulWidget {
  const _NakedTooltipOverlay({
    required this.animation,
    required this.superseded,
    required this.overlayBuilder,
    required this.onStatusChanged,
    required this.excludeSemantics,
    required this.excludeOverlaySemantics,
    required this.semanticLabel,
  });

  final Animation<double> animation;
  final ValueListenable<bool> superseded;
  final TooltipComponentBuilder overlayBuilder;
  final ValueChanged<AnimationStatus> onStatusChanged;
  final bool excludeSemantics;
  final bool? excludeOverlaySemantics;
  final String? semanticLabel;

  @override
  State<_NakedTooltipOverlay> createState() => _NakedTooltipOverlayState();
}

class _NakedTooltipOverlayState extends State<_NakedTooltipOverlay> {
  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(widget.onStatusChanged);
    if (!widget.animation.isDismissed) {
      widget.onStatusChanged(widget.animation.status);
    }
  }

  @override
  void didUpdateWidget(covariant _NakedTooltipOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation.removeStatusListener(widget.onStatusChanged);
      widget.animation.addStatusListener(widget.onStatusChanged);
    }
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(widget.onStatusChanged);
    // Replacing the raw tooltip's key removes its overlay without reversing.
    widget.onStatusChanged(AnimationStatus.dismissed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.superseded,
      builder: (context, superseded, _) {
        if (superseded) return const SizedBox.shrink();
        final child = widget.overlayBuilder(context, widget.animation);
        final excludeOverlaySemantics =
            widget.excludeSemantics ||
            (widget.excludeOverlaySemantics ??
                (widget.semanticLabel?.trim().isNotEmpty ?? false));
        return excludeOverlaySemantics ? ExcludeSemantics(child: child) : child;
      },
    );
  }
}
