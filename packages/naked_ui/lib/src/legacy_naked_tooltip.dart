import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'naked_tooltip.dart';
import 'utilities/positioning.dart';

/// The legacy 1.1.0 tooltip retained for deprecated [NakedTooltip] parameters.
///
/// This widget is not exported and will be removed in 2.0.0.
///
/// [NakedTooltip] builds this widget when a caller sets [NakedTooltip.open],
/// [NakedTooltip.useRootOverlay], or [NakedTooltip.disableHoverableContent],
/// because [RawTooltip] does not support controlled visibility, the root
/// overlay, or non-hoverable content.
///
/// Tooltips open on hover, focus, or the configured touch [triggerMode]. By
/// default, moving the pointer from the trigger into the tooltip keeps it
/// visible. Set [disableHoverableContent] to `true` when hovering the content
/// should not preserve visibility.
///
/// [open] and [onOpenChanged] form a controlled state contract. When [open] is
/// non-null, user input requests changes through [onOpenChanged], and the
/// overlay reflects the [open] value provided by the caller.
///
/// [OverlayPositionConfig] positions the overlay. Descendants can read the
/// collision-resolved placement via [OverlayPlacement.of].
class LegacyNakedTooltip extends StatefulWidget {
  /// Creates a legacy headless tooltip.
  const LegacyNakedTooltip({
    super.key,
    required this.child,
    required this.overlayBuilder,
    this.open,
    this.onOpenChanged,
    this.hoverDelay = Duration.zero,
    this.touchDelay = const Duration(milliseconds: 1500),
    this.dismissDelay = const Duration(milliseconds: 100),
    this.disableHoverableContent = false,
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
    this.useRootOverlay = false,
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

  /// Whether the tooltip is open when controlled, or `null` when uncontrolled.
  final bool? open;

  /// A callback invoked when user input requests a visibility change.
  final ValueChanged<bool>? onOpenChanged;

  /// The semantic tooltip text attached to the trigger.
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
  final bool disableHoverableContent;

  /// Whether tapping outside an open tooltip requests dismissal.
  final bool enableTapToDismiss;

  /// The trigger mode for non-hover pointer input.
  final TooltipTriggerMode triggerMode;

  /// Whether touch activation provides platform feedback.
  final bool enableFeedback;

  /// A callback invoked when tap or long-press input triggers the tooltip.
  final TooltipTriggeredCallback? onTriggered;

  /// The show and hide curves and durations.
  final AnimationStyle animationStyle;

  /// Whether the tooltip is inserted into the root overlay.
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
  State<LegacyNakedTooltip> createState() {
    assert(!hoverDelay.isNegative, 'hoverDelay must not be negative');
    assert(!touchDelay.isNegative, 'touchDelay must not be negative');
    assert(!dismissDelay.isNegative, 'dismissDelay must not be negative');

    return _LegacyNakedTooltipState();
  }
}

class _LegacyNakedTooltipState extends State<LegacyNakedTooltip>
    with SingleTickerProviderStateMixin {
  final MenuController _menuController = MenuController();

  Timer? _showTimer;
  Timer? _hideTimer;
  Timer? _touchTimer;
  LongPressGestureRecognizer? _longPressRecognizer;
  TapGestureRecognizer? _tapRecognizer;

  late final AnimationController _animationController;
  late CurvedAnimation _animation;

  bool _uncontrolledOpen = false;
  bool _triggerHovered = false;
  bool _contentHovered = false;
  bool _focusWithin = false;
  int _transitionGeneration = 0;

  bool get _isControlled => widget.open != null;

  bool get _desiredOpen => widget.open ?? _uncontrolledOpen;

  Duration get _forwardDuration =>
      widget.animationStyle.duration ?? const Duration(milliseconds: 150);

  Duration get _reverseDuration =>
      widget.animationStyle.reverseDuration ?? const Duration(milliseconds: 75);

  Curve get _forwardCurve =>
      widget.animationStyle.curve ?? Curves.fastOutSlowIn;

  Curve get _reverseCurve =>
      widget.animationStyle.reverseCurve ?? _forwardCurve.flipped;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _forwardDuration,
      reverseDuration: _reverseDuration,
      vsync: this,
    );
    _animation = _createAnimation();
    if (_desiredOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _desiredOpen) _applyDesiredOpen();
      });
    }
  }

  CurvedAnimation _createAnimation() => CurvedAnimation(
    parent: _animationController,
    curve: _forwardCurve,
    reverseCurve: _reverseCurve,
  );

  @override
  void didUpdateWidget(covariant LegacyNakedTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(!widget.hoverDelay.isNegative, 'hoverDelay must not be negative');
    assert(!widget.touchDelay.isNegative, 'touchDelay must not be negative');
    assert(
      !widget.dismissDelay.isNegative,
      'dismissDelay must not be negative',
    );
    if (widget.animationStyle != oldWidget.animationStyle) {
      _animationController
        ..duration = _forwardDuration
        ..reverseDuration = _reverseDuration;
      _animation.dispose();
      _animation = _createAnimation();
    }
    if (widget.open != oldWidget.open && widget.open != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _applyDesiredOpen();
      });
    } else if (oldWidget.open != null && widget.open == null) {
      _uncontrolledOpen = oldWidget.open!;
    }
    if (widget.disableHoverableContent && !oldWidget.disableHoverableContent) {
      _contentHovered = false;
      _scheduleHoverClose();
    }
  }

  void _cancelTimers() {
    _showTimer?.cancel();
    _hideTimer?.cancel();
    _touchTimer?.cancel();
    _showTimer = null;
    _hideTimer = null;
    _touchTimer = null;
  }

  void _cancelShowTimer() {
    _showTimer?.cancel();
    _showTimer = null;
  }

  void _cancelHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  void _requestOpen(bool value) {
    if (_desiredOpen == value) return;
    widget.onOpenChanged?.call(value);
    if (!mounted) return;
    if (_isControlled) return;
    _uncontrolledOpen = value;
    _applyDesiredOpen();
  }

  void _applyDesiredOpen() {
    final generation = ++_transitionGeneration;
    if (_desiredOpen) {
      _cancelHideTimer();
      if (!_menuController.isOpen) _menuController.open();
      _animationController.forward();

      return;
    }

    _cancelShowTimer();
    () async {
      await _animationController.reverse();
      if (!mounted || generation != _transitionGeneration || _desiredOpen) {
        return;
      }
      if (_menuController.isOpen) _menuController.close();
    }();
  }

  void _scheduleHoverOpen() {
    _cancelHideTimer();
    _touchTimer?.cancel();
    _touchTimer = null;
    if (_desiredOpen || _showTimer?.isActive == true) return;
    if (widget.hoverDelay == Duration.zero) {
      _requestOpen(true);

      return;
    }
    _showTimer = Timer(widget.hoverDelay, () {
      _showTimer = null;
      if (mounted && (_triggerHovered || _focusWithin)) _requestOpen(true);
    });
  }

  void _scheduleHoverClose() {
    _cancelShowTimer();
    if (_triggerHovered || _focusWithin || _contentHovered) return;
    if (!_desiredOpen || _hideTimer?.isActive == true) return;
    if (widget.dismissDelay == Duration.zero) {
      _requestOpen(false);

      return;
    }
    _hideTimer = Timer(widget.dismissDelay, () {
      _hideTimer = null;
      if (mounted && !_triggerHovered && !_focusWithin && !_contentHovered) {
        _requestOpen(false);
      }
    });
  }

  void _handleTriggerEnter(PointerEnterEvent event) {
    _triggerHovered = true;
    _scheduleHoverOpen();
  }

  void _handleTriggerExit(PointerExitEvent event) {
    _triggerHovered = false;
    _scheduleHoverClose();
  }

  void _handleContentEnter(PointerEnterEvent event) {
    if (widget.disableHoverableContent) return;
    _contentHovered = true;
    _cancelHideTimer();
  }

  void _handleContentExit(PointerExitEvent event) {
    if (widget.disableHoverableContent) return;
    _contentHovered = false;
    _scheduleHoverClose();
  }

  void _handleFocusChange(bool focused) {
    _focusWithin = focused;
    if (focused) {
      _scheduleHoverOpen();
    } else {
      _scheduleHoverClose();
    }
  }

  void _scheduleTouchClose() {
    _touchTimer?.cancel();
    _touchTimer = Timer(widget.touchDelay, () {
      _touchTimer = null;
      if (mounted && !_triggerHovered && !_contentHovered && !_focusWithin) {
        _requestOpen(false);
      }
    });
  }

  void _handleTap() {
    if (widget.enableFeedback) Feedback.forTap(context);
    widget.onTriggered?.call();
    _requestOpen(true);
    _scheduleTouchClose();
  }

  void _handleLongPress() {
    if (widget.enableFeedback) Feedback.forLongPress(context);
    widget.onTriggered?.call();
    _requestOpen(true);
  }

  void _handleLongPressEnd() => _scheduleTouchClose();

  void _handlePointerDown(PointerDownEvent event) {
    const supportedDevices = <PointerDeviceKind>{
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.stylus,
      PointerDeviceKind.touch,
      PointerDeviceKind.unknown,
      PointerDeviceKind.trackpad,
    };
    switch (widget.triggerMode) {
      case TooltipTriggerMode.manual:
        break;
      case TooltipTriggerMode.longPress:
        final recognizer = _longPressRecognizer ??= LongPressGestureRecognizer(
          debugOwner: this,
          supportedDevices: supportedDevices,
        );
        recognizer
          ..onLongPress = _handleLongPress
          ..onLongPressUp = _handleLongPressEnd
          ..onLongPressCancel = _scheduleHoverClose
          ..addPointer(event);
      case TooltipTriggerMode.tap:
        final recognizer = _tapRecognizer ??= TapGestureRecognizer(
          debugOwner: this,
          supportedDevices: supportedDevices,
        );
        recognizer
          ..onTap = _handleTap
          ..onTapCancel = _scheduleHoverClose
          ..addPointer(event);
    }
  }

  void _dismiss() => _requestOpen(false);

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Leave Escape to enclosing dismiss actions while the tooltip is closed.
    if ((!_desiredOpen && !_menuController.isOpen) ||
        !const SingleActivator(
          LogicalKeyboardKey.escape,
        ).accepts(event, HardwareKeyboard.instance)) {
      return KeyEventResult.ignored;
    }
    _dismiss();

    return KeyEventResult.handled;
  }

  Widget _buildOverlay(BuildContext context, RawMenuOverlayInfo info) {
    Widget result = widget.overlayBuilder(context, _animation);
    final excludeOverlaySemantics =
        widget.excludeSemantics ||
        (widget.excludeOverlaySemantics ??
            (widget.semanticLabel?.trim().isNotEmpty ?? false));
    if (excludeOverlaySemantics) {
      result = ExcludeSemantics(child: result);
    }
    result = MouseRegion(
      opaque: false,
      onEnter: _handleContentEnter,
      onExit: _handleContentExit,
      child: result,
    );
    result = TapRegion(
      groupId: info.tapRegionGroupId,
      onTapOutside: widget.enableTapToDismiss ? (_) => _dismiss() : null,
      child: result,
    );
    result = CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _dismiss},
      child: result,
    );

    return OverlayPositioner(
      targetRect: info.anchorRect,
      positioning: widget.positioning,
      child: result,
    );
  }

  @override
  void dispose() {
    _transitionGeneration++;
    _cancelTimers();
    _longPressRecognizer
      ?..onLongPress = null
      ..onLongPressUp = null
      ..onLongPressCancel = null
      ..dispose();
    _tapRecognizer
      ?..onTap = null
      ..onTapCancel = null
      ..dispose();
    _animation.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget trigger = Semantics(
      tooltip:
          widget.excludeSemantics ||
              widget.semanticLabel?.trim().isEmpty == true
          ? null
          : widget.semanticLabel,
      child: widget.child,
    );
    trigger = Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onFocusChange: _handleFocusChange,
      onKeyEvent: _handleKeyEvent,
      child: trigger,
    );
    trigger = MouseRegion(
      onEnter: _handleTriggerEnter,
      onExit: _handleTriggerExit,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        child: trigger,
      ),
    );

    Widget result = RawMenuAnchor(
      controller: _menuController,
      useRootOverlay: widget.useRootOverlay,
      consumeOutsideTaps: false,
      onOpenRequested: (_, showOverlay) => showOverlay(),
      onCloseRequested: (hideOverlay) => hideOverlay(),
      overlayBuilder: _buildOverlay,
      child: trigger,
    );

    if (widget.excludeSemantics) result = ExcludeSemantics(child: result);

    return result;
  }
}
