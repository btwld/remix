// The deprecated parameters are read here to route them to the 1.1.0
// implementation.
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'legacy_naked_tooltip.dart';
import 'utilities/positioning.dart';

const _defaultTooltipAnimationStyle = AnimationStyle(
  curve: Curves.fastOutSlowIn,
  duration: Duration(milliseconds: 150),
  reverseDuration: Duration(milliseconds: 75),
);

/// A headless tooltip built directly on Flutter's [RawTooltip].
///
/// [RawTooltip] owns trigger handling, delays, feedback, animation, hoverable
/// content, and overlay lifetime. This widget supplies the headless overlay
/// builder, the package's collision-aware positioning, and optional semantics
/// filtering. [overlayBuilder] keeps Naked UI's shipped name for
/// [RawTooltip.tooltipBuilder], and [semanticLabel] keeps its shipped name for
/// [RawTooltip.semanticsTooltip].
///
/// Pass a [GlobalKey] through [tooltipKey] to call
/// [RawTooltipState.ensureTooltipVisible] for a command-triggered show. The
/// [onOpenChanged] callback reports the animation's visible state; it does not
/// control whether the tooltip is shown.
///
/// The deprecated [open], [useRootOverlay], and [disableHoverableContent]
/// parameters still work: setting any of them runs the naked_ui 1.1.0
/// implementation, because [RawTooltip] provides none of them on the Flutter
/// 3.41 floor. They are removed in 2.0.0.
class NakedTooltip extends StatefulWidget {
  /// Creates a headless tooltip.
  const NakedTooltip({
    super.key,
    required this.child,
    required this.overlayBuilder,
    this.tooltipKey,
    @Deprecated(
      'Use tooltipKey to show on command and onOpenChanged to observe '
      'visibility. Controlled open runs the naked_ui 1.1.0 implementation. '
      'Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
    )
    this.open,
    this.onOpenChanged,
    this.hoverDelay = Duration.zero,
    this.touchDelay = const Duration(milliseconds: 1500),
    this.dismissDelay = const Duration(milliseconds: 100),
    @Deprecated(
      'RawTooltip keeps the tooltip visible while its content is hovered. '
      'Setting this runs the naked_ui 1.1.0 implementation. '
      'Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
    )
    this.disableHoverableContent = false,
    this.enableTapToDismiss = true,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.enableFeedback = true,
    this.onTriggered,
    this.animationStyle = _defaultTooltipAnimationStyle,
    this.positioning = const OverlayPositionConfig(),
    @Deprecated(
      'RawTooltip uses the nearest Overlay. Setting this runs the naked_ui '
      '1.1.0 implementation. Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
    )
    this.useRootOverlay = false,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.excludeOverlaySemantics,
  }) : assert(
         tooltipKey == null ||
             (open == null && !useRootOverlay && !disableHoverableContent),
         'tooltipKey has no effect with the deprecated open, '
         'useRootOverlay, or disableHoverableContent parameters.',
       );

  /// The widget that triggers the tooltip.
  final Widget child;

  /// Builds the tooltip content displayed in the overlay.
  ///
  /// The animation runs from zero to one while opening and reverses while
  /// closing.
  final TooltipComponentBuilder overlayBuilder;

  /// A key whose state can call [RawTooltipState.ensureTooltipVisible].
  final GlobalKey<RawTooltipState>? tooltipKey;

  /// Whether the tooltip is open when controlled, or null when uncontrolled.
  @Deprecated(
    'Use tooltipKey to show on command and onOpenChanged to observe '
    'visibility. Controlled open runs the naked_ui 1.1.0 implementation. '
    'Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
  )
  final bool? open;

  /// Reports the visible state after the raw tooltip's animation changes.
  ///
  /// This is a notification only. Visibility is owned by [RawTooltip].
  /// Notifications arrive after the frame and stop when this widget is disposed.
  ///
  /// When the deprecated [open] is non-null, this keeps its naked_ui 1.1.0
  /// meaning: user input requests a change, and the owner accepts it by
  /// updating [open].
  final ValueChanged<bool>? onOpenChanged;

  /// The semantic label attached to the trigger.
  final String? semanticLabel;

  /// Side, alignment, offset, and collision configuration for the overlay.
  final OverlayPositionConfig positioning;

  /// The delay before mouse hover requests the tooltip to open.
  final Duration hoverDelay;

  /// How long a touch-triggered tooltip remains open after activation ends.
  final Duration touchDelay;

  /// The delay before pointer exit requests the tooltip to close.
  final Duration dismissDelay;

  /// Whether hovering the overlay content does not preserve visibility.
  @Deprecated(
    'RawTooltip keeps the tooltip visible while its content is hovered. '
    'Setting this runs the naked_ui 1.1.0 implementation. '
    'Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
  )
  final bool disableHoverableContent;

  /// Whether tapping outside an open tooltip dismisses it.
  final bool enableTapToDismiss;

  /// How non-hover pointer input triggers the tooltip.
  final TooltipTriggerMode triggerMode;

  /// Whether touch activation provides platform feedback.
  final bool enableFeedback;

  /// Called when tap or long-press input triggers the tooltip.
  final TooltipTriggeredCallback? onTriggered;

  /// The show and hide curves and durations.
  ///
  /// Missing durations default to 150ms for showing and 75ms for hiding.
  /// The reverse curve defaults to the flipped show curve.
  final AnimationStyle animationStyle;

  /// Whether the tooltip is inserted into the root overlay.
  @Deprecated(
    'RawTooltip uses the nearest Overlay. Setting this runs the naked_ui '
    '1.1.0 implementation. Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
  )
  final bool useRootOverlay;

  /// Whether to hide the trigger and overlay subtrees from the semantics tree.
  final bool excludeSemantics;

  /// Whether to hide the visual overlay subtree from the semantics tree.
  ///
  /// When null, the overlay is excluded only when a non-empty [semanticLabel]
  /// is exposed on the trigger. Set this to true to always exclude the overlay
  /// or false to always include independently meaningful custom content.
  ///
  /// [excludeSemantics] takes precedence and hides the entire tooltip.
  final bool? excludeOverlaySemantics;

  @override
  State<NakedTooltip> createState() => _NakedTooltipState();
}

class _NakedTooltipState extends State<NakedTooltip> {
  final _childKey = GlobalKey();
  final _internalTooltipKey = GlobalKey<RawTooltipState>();
  bool _visible = false;
  CurvedAnimation? _rawAnimation;

  // RawTooltip has no focus trigger, Escape binding, or placement callback.
  // The fields below keep naked_ui 1.1.0's focus, Escape, and placement
  // behavior on top of it.
  Timer? _focusTimer;
  bool _focusWithin = false;
  bool _triggerHovered = false;
  bool _contentHovered = false;
  // Focus is holding the tooltip open; mouse exits must not close it.
  bool _heldByFocus = false;
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
      duration: style.duration,
      reverseDuration: style.reverseDuration,
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
    // 1.1.0 kept the last accepted state when a controlled tooltip became
    // uncontrolled. The RawTooltip path starts closed, so reopen it.
    if (oldWidget.open == true && !_usesLegacyTooltip) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_usesLegacyTooltip) _show();
      });
    }
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    super.dispose();
  }

  void _show() => _tooltipKey.currentState?.ensureTooltipVisible();

  // RawTooltip cannot close a single tooltip, so this closes every open one.
  void _dismiss() {
    _heldByFocus = false;
    RawTooltip.dismissAllToolTips();
  }

  void _handleFocusChange(bool focused) {
    _focusWithin = focused;
    _focusTimer?.cancel();
    _focusTimer = null;
    if (focused) {
      if (_visible || widget.hoverDelay == Duration.zero) {
        _holdForFocus();
      } else {
        _focusTimer = Timer(widget.hoverDelay, _holdForFocus);
      }
    } else {
      _heldByFocus = false;
      if (widget.dismissDelay == Duration.zero) {
        _closeForBlur();
      } else {
        _focusTimer = Timer(widget.dismissDelay, _closeForBlur);
      }
    }
  }

  void _holdForFocus() {
    _focusTimer = null;
    if (!mounted || !_focusWithin) return;
    _heldByFocus = true;
    // Also cancels a dismissal RawTooltip has already scheduled.
    _show();
  }

  void _closeForBlur() {
    _focusTimer = null;
    if (!mounted || _focusWithin || _triggerHovered || _contentHovered) return;
    if (_visible) _dismiss();
  }

  void _handlePointerExit() {
    // These regions sit inside RawTooltip's, so they see the exit first, in
    // hit-test order. RawTooltip then schedules, or with a zero dismissDelay
    // performs, its own dismissal. Reopen afterwards while focus holds it.
    if (!_heldByFocus || !_focusWithin) return;
    scheduleMicrotask(() {
      if (!mounted || !_focusWithin) return;
      _heldByFocus = true;
      _show();
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Leave Escape to enclosing dismiss actions while the tooltip is closed.
    if (!_visible ||
        !const SingleActivator(
          LogicalKeyboardKey.escape,
        ).accepts(event, HardwareKeyboard.instance)) {
      return KeyEventResult.ignored;
    }
    _dismiss();

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

  void _reportVisibility(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    if (!visible) _heldByFocus = false;
    // The overlay can first report visibility during build. Deliver from the
    // owner so closing survives overlay removal, but not tooltip disposal.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onOpenChanged?.call(visible);
    });
  }

  bool get _usesLegacyTooltip =>
      widget.open != null ||
      widget.useRootOverlay ||
      widget.disableHoverableContent;

  Widget _buildLegacyTooltip(Widget child) => LegacyNakedTooltip(
    overlayBuilder: widget.overlayBuilder,
    open: widget.open,
    onOpenChanged: widget.onOpenChanged,
    hoverDelay: widget.hoverDelay,
    touchDelay: widget.touchDelay,
    dismissDelay: widget.dismissDelay,
    disableHoverableContent: widget.disableHoverableContent,
    enableTapToDismiss: widget.enableTapToDismiss,
    triggerMode: widget.triggerMode,
    enableFeedback: widget.enableFeedback,
    onTriggered: widget.onTriggered,
    animationStyle: widget.animationStyle,
    positioning: widget.positioning,
    useRootOverlay: widget.useRootOverlay,
    semanticLabel: widget.semanticLabel,
    excludeSemantics: widget.excludeSemantics,
    excludeOverlaySemantics: widget.excludeOverlaySemantics,
    child: child,
  );

  @override
  Widget build(BuildContext context) {
    // Keep the trigger's state when a deprecated parameter switches between
    // the RawTooltip path and the 1.1.0 implementation.
    final child = KeyedSubtree(key: _childKey, child: widget.child);
    if (_usesLegacyTooltip) return _buildLegacyTooltip(child);

    final textDirection = Directionality.of(context);
    final animationStyle = _animationStyle;
    Widget result = RawTooltip(
      key: _tooltipKey,
      // RawTooltip treats an empty semantics label as "no tooltip". Preserve
      // NakedTooltip's ability to show visual content without a label.
      semanticsTooltip:
          widget.excludeSemantics || widget.semanticLabel?.isEmpty == true
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
              overlayBuilder: widget.overlayBuilder,
              onOpenChanged: _reportVisibility,
              excludeSemantics: widget.excludeSemantics,
              excludeOverlaySemantics: widget.excludeOverlaySemantics,
              semanticLabel: widget.semanticLabel,
            ),
          ),
        );
      },
      hoverDelay: widget.hoverDelay,
      touchDelay: widget.touchDelay,
      dismissDelay: widget.dismissDelay,
      enableTapToDismiss: widget.enableTapToDismiss,
      triggerMode: widget.triggerMode,
      enableFeedback: widget.enableFeedback,
      onTriggered: widget.onTriggered,
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
      child: MouseRegion(
        opaque: false,
        onEnter: (_) => _triggerHovered = true,
        onExit: (_) {
          _triggerHovered = false;
          _handlePointerExit();
        },
        child: child,
      ),
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
    required this.overlayBuilder,
    required this.onOpenChanged,
    required this.excludeSemantics,
    required this.excludeOverlaySemantics,
    required this.semanticLabel,
  });

  final Animation<double> animation;
  final TooltipComponentBuilder overlayBuilder;
  final ValueChanged<bool> onOpenChanged;
  final bool excludeSemantics;
  final bool? excludeOverlaySemantics;
  final String? semanticLabel;

  @override
  State<_NakedTooltipOverlay> createState() => _NakedTooltipOverlayState();
}

class _NakedTooltipOverlayState extends State<_NakedTooltipOverlay> {
  // A zero-duration show on a still-mounted overlay jumps from dismissed
  // straight to completed, so any status but dismissed means visible.
  void _handleStatusChanged(AnimationStatus status) =>
      widget.onOpenChanged(!status.isDismissed);

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(_handleStatusChanged);
    if (!widget.animation.isDismissed) widget.onOpenChanged(true);
  }

  @override
  void didUpdateWidget(covariant _NakedTooltipOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animation != oldWidget.animation) {
      oldWidget.animation.removeStatusListener(_handleStatusChanged);
      widget.animation.addStatusListener(_handleStatusChanged);
    }
  }

  @override
  void dispose() {
    widget.animation.removeStatusListener(_handleStatusChanged);
    // Replacing the raw tooltip's key removes its overlay without reversing.
    widget.onOpenChanged(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.overlayBuilder(context, widget.animation);
    final excludeOverlaySemantics =
        widget.excludeSemantics ||
        (widget.excludeOverlaySemantics ??
            (widget.semanticLabel?.trim().isNotEmpty ?? false));
    if (excludeOverlaySemantics) {
      result = ExcludeSemantics(child: result);
    }
    return result;
  }
}
