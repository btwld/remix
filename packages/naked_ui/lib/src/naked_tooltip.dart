import 'package:flutter/widgets.dart';

import 'utilities/positioning.dart';

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
class NakedTooltip extends StatefulWidget {
  /// Creates a headless tooltip.
  const NakedTooltip({
    super.key,
    required this.child,
    required this.overlayBuilder,
    this.tooltipKey,
    this.onOpenChanged,
    this.hoverDelay = Duration.zero,
    this.touchDelay = const Duration(milliseconds: 1500),
    this.dismissDelay = const Duration(milliseconds: 100),
    this.enableTapToDismiss = true,
    this.triggerMode = TooltipTriggerMode.longPress,
    this.enableFeedback = true,
    this.onTriggered,
    this.animationStyle = const AnimationStyle(
      curve: Curves.fastOutSlowIn,
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 75),
    ),
    this.positioning = const OverlayPositionConfig(),
    this.semanticLabel,
    this.excludeSemantics = false,
    this.excludeOverlaySemantics,
  });

  /// The widget that triggers the tooltip.
  final Widget child;

  /// Builds the tooltip content displayed in the overlay.
  ///
  /// The animation runs from zero to one while opening and reverses while
  /// closing.
  final TooltipComponentBuilder overlayBuilder;

  /// A key whose state can call [RawTooltipState.ensureTooltipVisible].
  final GlobalKey<RawTooltipState>? tooltipKey;

  /// Reports the visible state after the raw tooltip's animation changes.
  ///
  /// This is a notification only. Visibility is owned by [RawTooltip].
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

  /// Whether tapping outside an open tooltip dismisses it.
  final bool enableTapToDismiss;

  /// How non-hover pointer input triggers the tooltip.
  final TooltipTriggerMode triggerMode;

  /// Whether touch activation provides platform feedback.
  final bool enableFeedback;

  /// Called when tap or long-press input triggers the tooltip.
  final TooltipTriggeredCallback? onTriggered;

  /// The show and hide curves and durations.
  final AnimationStyle animationStyle;

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
  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final rawTooltip = RawTooltip(
      key: widget.tooltipKey,
      // RawTooltip treats an empty semantics label as "no tooltip". Preserve
      // NakedTooltip's ability to show visual content without a label.
      semanticsTooltip:
          widget.excludeSemantics || widget.semanticLabel?.isEmpty == true
          ? null
          : widget.semanticLabel,
      tooltipBuilder: (context, animation) => _NakedTooltipOverlay(
        animation: animation,
        overlayBuilder: widget.overlayBuilder,
        onOpenChanged: widget.onOpenChanged,
        excludeSemantics: widget.excludeSemantics,
        excludeOverlaySemantics: widget.excludeOverlaySemantics,
        semanticLabel: widget.semanticLabel,
      ),
      hoverDelay: widget.hoverDelay,
      touchDelay: widget.touchDelay,
      dismissDelay: widget.dismissDelay,
      enableTapToDismiss: widget.enableTapToDismiss,
      triggerMode: widget.triggerMode,
      enableFeedback: widget.enableFeedback,
      onTriggered: widget.onTriggered,
      animationStyle: widget.animationStyle,
      positionDelegate: (position) {
        final placement = _resolvePlacement(
          position,
          widget.positioning,
          textDirection,
        );
        return placement.offset;
      },
      child: widget.child,
    );

    return widget.excludeSemantics
        ? ExcludeSemantics(child: rawTooltip)
        : rawTooltip;
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
  final ValueChanged<bool>? onOpenChanged;
  final bool excludeSemantics;
  final bool? excludeOverlaySemantics;
  final String? semanticLabel;

  @override
  State<_NakedTooltipOverlay> createState() => _NakedTooltipOverlayState();
}

class _NakedTooltipOverlayState extends State<_NakedTooltipOverlay> {
  bool? _pendingVisibility;
  bool _notificationScheduled = false;
  bool? _lastNotified;

  void _handleStatusChanged(AnimationStatus status) {
    if (status.isDismissed) {
      _deferVisibility(false);
    } else if (status == AnimationStatus.forward) {
      _deferVisibility(true);
    }
  }

  void _deferVisibility(bool visible) {
    if (widget.onOpenChanged == null) return;
    if (_lastNotified == visible && _pendingVisibility == null) return;
    _pendingVisibility = visible;
    if (_notificationScheduled) return;
    _notificationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;
      final next = _pendingVisibility;
      _pendingVisibility = null;
      if (next == null || _lastNotified == next) return;
      _lastNotified = next;
      widget.onOpenChanged?.call(next);
    });
  }

  @override
  void initState() {
    super.initState();
    widget.animation.addStatusListener(_handleStatusChanged);
    if (widget.animation.status == AnimationStatus.forward ||
        widget.animation.status == AnimationStatus.completed) {
      _deferVisibility(true);
    }
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
