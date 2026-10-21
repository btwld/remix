// The deprecated parameters are read here to route them to the 1.1.0
// implementation.
// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'legacy_naked_tooltip.dart';
import 'utilities/positioning.dart';

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
/// and the replaced tooltip disappears without an exit animation. Tooltips
/// using the deprecated parameters below are not replaced.
///
/// Setting any of the deprecated [open], [useRootOverlay], or
/// [disableHoverableContent] parameters uses the legacy 1.1.0 implementation.
/// These parameters will be removed in 2.0.0.
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

  /// The builder that creates the tooltip overlay content.
  ///
  /// The animation runs from `0.0` to `1.0` while opening and reverses while
  /// closing.
  final TooltipComponentBuilder overlayBuilder;

  /// A key for imperative control via [RawTooltipState.ensureTooltipVisible].
  final GlobalKey<RawTooltipState>? tooltipKey;

  /// Whether the tooltip is open when controlled, or `null` when uncontrolled.
  @Deprecated(
    'Use tooltipKey to show on command and onOpenChanged to observe '
    'visibility. Controlled open runs the naked_ui 1.1.0 implementation. '
    'Deprecated in naked_ui 1.2.0; removed in 2.0.0.',
  )
  final bool? open;

  /// A callback invoked when the tooltip visible state changes.
  ///
  /// [RawTooltip] owns visibility. A tooltip replaced by another reports
  /// `false` at once. Notifications arrive after the current frame and stop
  /// when this widget is disposed.
  ///
  /// When the deprecated [open] parameter is non-null, this callback requests a
  /// state change that the caller applies by updating [open].
  final ValueChanged<bool>? onOpenChanged;

  /// The semantic label attached to the trigger.
  final String? semanticLabel;

  /// The side, alignment, offset, and collision configuration for the overlay.
  final OverlayPositionConfig positioning;

  /// The delay before mouse hover requests the tooltip to open.
  final Duration hoverDelay;

  /// The duration a touch-triggered tooltip remains open after activation ends.
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
  /// When `null`, the overlay is excluded only when the trigger exposes a
  /// non-empty [semanticLabel]. Set to `true` to always exclude the overlay,
  /// or `false` to always include it.
  ///
  /// [excludeSemantics] takes precedence and hides the entire tooltip.
  final bool? excludeOverlaySemantics;

  @override
  State<NakedTooltip> createState() => _NakedTooltipState();
}

class _NakedTooltipState extends State<NakedTooltip> {
  static final Set<_NakedTooltipState> _mountedTooltips =
      <_NakedTooltipState>{};

  // The most recently activated tooltip. Hover, focus, touch, and command
  // activation each supersede the previous one, hiding it.
  static _NakedTooltipState? _current;

  final _childKey = GlobalKey();
  final _internalTooltipKey = GlobalKey<RawTooltipState>();
  // Hides the overlay content as soon as another tooltip takes over, so the
  // previous bubble's exit animation never overlaps the next bubble.
  final _superseded = ValueNotifier<bool>(false);
  // Whether RawTooltip's animation is not dismissed, including while closing.
  bool _rawOpen = false;
  bool _visible = false;
  CurvedAnimation? _rawAnimation;

  // RawTooltip has no focus trigger, Escape binding, or placement callback.
  // The fields below keep naked_ui 1.1.0's focus, Escape, and placement
  // behavior on top of it.
  Timer? _focusTimer;
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
  void initState() {
    super.initState();
    _mountedTooltips.add(this);
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
    if (_usesLegacyTooltip && identical(_current, this)) _current = null;
    if (oldWidget.open != null && widget.open == null && _usesLegacyTooltip) {
      _visible = oldWidget.open!;
    }
    if (_usesLegacy(oldWidget) && !_usesLegacyTooltip) {
      // 1.1.0 kept the last accepted state when a controlled tooltip became
      // uncontrolled. The RawTooltip path starts closed, so reopen it.
      if (oldWidget.open == true) {
        _visible = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_usesLegacyTooltip) _show();
        });
      } else if (_visible) {
        _setVisible(false);
      }
    }
  }

  @override
  void dispose() {
    _mountedTooltips.remove(this);
    if (identical(_current, this)) _current = null;
    _focusTimer?.cancel();
    _superseded.dispose();
    super.dispose();
  }

  void _show() => _tooltipKey.currentState?.ensureTooltipVisible();

  Iterable<_NakedTooltipState> get _others => _mountedTooltips.where(
    (tooltip) => !identical(tooltip, this) && !tooltip._usesLegacyTooltip,
  );

  // Makes this the only tooltip that may be visible. RawTooltip already
  // dismisses unhovered tooltips when another trigger is hovered, so hover
  // passes dismissOthers: false. Focus and touch activation pass true.
  void _activate({required bool dismissOthers}) {
    _current = this;
    _superseded.value = false;
    var othersOpen = false;
    for (final tooltip in _others) {
      tooltip._supersede();
      othersOpen = othersOpen || tooltip._rawOpen;
    }
    if (dismissOthers && othersOpen) {
      // RawTooltip can only dismiss every tooltip. The others are hidden
      // already, so reopen this one if it was open.
      final wasOpen = _rawOpen;
      RawTooltip.dismissAllToolTips();
      if (wasOpen) _show();
    }
    _syncVisibility();
  }

  void _supersede() {
    // A pending focus show must not take over from the new tooltip.
    _focusTimer?.cancel();
    _focusTimer = null;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onOpenChanged?.call(visible);
    });
  }

  void _handleFocusChange(bool focused) {
    if (focused == _focusWithin) return;
    _focusWithin = focused;
    _focusTimer?.cancel();
    _focusTimer = null;
    if (focused) {
      if (_visible || widget.hoverDelay == Duration.zero) {
        _holdForFocus();
      } else {
        _focusTimer = Timer(widget.hoverDelay, _holdForFocus);
      }
    } else if (widget.dismissDelay == Duration.zero) {
      _closeForBlur();
    } else {
      _focusTimer = Timer(widget.dismissDelay, _closeForBlur);
    }
  }

  void _holdForFocus() {
    _focusTimer = null;
    if (!mounted || !_focusWithin) return;
    _activate(dismissOthers: true);
    // Also cancels a dismissal RawTooltip has already scheduled.
    _show();
  }

  void _closeForBlur() {
    _focusTimer = null;
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

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Leave Escape to enclosing dismiss actions while no tooltip is visible.
    // Otherwise close the visible tooltip, which may belong to another
    // trigger, and keep focus from reopening the focused trigger's tooltip.
    if (!(_current?._visible ?? false) ||
        !_escapeActivator.accepts(event, HardwareKeyboard.instance)) {
      return KeyEventResult.ignored;
    }
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

  static bool _usesLegacy(NakedTooltip widget) =>
      widget.open != null ||
      widget.useRootOverlay ||
      widget.disableHoverableContent;

  bool get _usesLegacyTooltip => _usesLegacy(widget);

  Widget _buildLegacyTooltip(Widget child) => LegacyNakedTooltip(
    overlayBuilder: widget.overlayBuilder,
    open: widget.open,
    onOpenChanged: (open) {
      if (widget.open == null) _visible = open;
      widget.onOpenChanged?.call(open);
    },
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
      hoverDelay: widget.hoverDelay,
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
      child: child,
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
