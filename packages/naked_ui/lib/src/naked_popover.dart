import 'dart:async';

import 'package:flutter/widgets.dart';

import 'base/overlay_base.dart';
import 'mixins/naked_mixins.dart';
import 'naked_button.dart';
import 'utilities/anchored_overlay.dart';
import 'utilities/intents.dart';
import 'utilities/naked_state_scope.dart';
import 'utilities/positioning.dart';
import 'utilities/state.dart';

/// Immutable view passed to [NakedPopover.builder].
class NakedPopoverState extends NakedState {
  /// Whether the overlay is currently open.
  final bool isOpen;

  /// Creates an immutable snapshot of popover interaction state.
  NakedPopoverState({required super.states, required this.isOpen});

  @override
  List<Object?> get props => [...super.props, isOpen];

  /// Returns the nearest [NakedPopoverState] provided by [NakedStateScope].
  static NakedPopoverState of(BuildContext context) => NakedState.of(context);

  /// Returns the nearest [NakedPopoverState] if available.
  static NakedPopoverState? maybeOf(BuildContext context) =>
      NakedState.maybeOf(context);

  /// Returns the [WidgetStatesController] from the nearest scope.
  static WidgetStatesController controllerOf(BuildContext context) =>
      NakedState.controllerOf<NakedPopoverState>(context);

  /// Returns the [WidgetStatesController] from the nearest scope, if any.
  static WidgetStatesController? maybeControllerOf(BuildContext context) =>
      NakedState.maybeControllerOf<NakedPopoverState>(context);
}

/// A headless popover without visuals.
///
/// Provides toggleable overlay functionality with custom content rendering.
/// Handles tap interactions, positioning, and focus management.
///
/// ```dart
/// // Static trigger
/// NakedPopover(
///   popoverBuilder: (context, info) => Container(
///     padding: EdgeInsets.all(16),
///     child: Text('Popover content'),
///   ),
///   child: Text('Click me'),
/// )
///
/// // Dynamic trigger with state
/// NakedPopover(
///   popoverBuilder: (context, info) => Container(
///     padding: EdgeInsets.all(16),
///     child: Text('Popover content'),
///   ),
///   builder: (context, state, child) => Container(
///     color: state.isPressed ? Colors.blue : Colors.grey,
///     child: Text('Click me'),
///   ),
/// )
/// ```
///
/// ### Using your own control as the trigger
/// By default the popover makes [child] or [builder] interactive. Set
/// [openOnTap] to false to use a control you already have instead, such as a
/// button from your design system. The popover then adds no activation or focus
/// stop, so the control opens and closes it through [controller] and carries
/// [triggerFocusNode] to receive focus when the popover closes.
/// ```dart
/// final popoverController = MenuController();
/// final triggerFocus = FocusNode();
/// NakedPopover(
///   controller: popoverController,
///   openOnTap: false,
///   triggerFocusNode: triggerFocus,
///   popoverBuilder: (context, info) => Text('Popover content'),
///   child: NakedButton(
///     focusNode: triggerFocus,
///     onPressed: () => popoverController.isOpen
///         ? popoverController.close()
///         : popoverController.open(),
///     child: Text('Open'),
///   ),
/// )
/// ```
///
/// See also:
/// - [NakedMenu], for dropdown menu functionality.
/// - [NakedTooltip], for hover-triggered lightweight hints.
/// - [NakedDialog], for modal dialog functionality.
class NakedPopover extends StatefulWidget {
  /// Creates a headless popover with a custom overlay builder.
  const NakedPopover({
    super.key,
    this.child,
    this.builder,
    required this.popoverBuilder,
    this.positioning = const OverlayPositionConfig(),
    this.consumeOutsideTaps = true,
    this.useRootOverlay = false,
    this.openOnTap = true,
    this.anchorKey,
    this.triggerFocusNode,
    this.onOpen,
    this.onClose,
    this.onOpenRequested,
    this.onCloseRequested,
    this.controller,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : assert(
         child != null || builder != null,
         'Either child or builder must be provided',
       );

  /// The static trigger widget.
  final Widget? child;

  /// Builds the trigger surface.
  final ValueWidgetBuilder<NakedPopoverState>? builder;

  /// The builder for popover content.
  final RawMenuAnchorOverlayBuilder popoverBuilder;

  /// Positioning configuration for the overlay.
  final OverlayPositionConfig positioning;

  /// Whether to consume taps outside the overlay.
  final bool consumeOutsideTaps;

  /// Whether to use the root overlay.
  final bool useRootOverlay;

  /// Whether the popover makes its own trigger interactive.
  ///
  /// When true, [child] or [builder] opens and closes the popover on tap, Enter,
  /// and Space, and is a focus stop of its own.
  ///
  /// When false, [child] or [builder] is the caller's own control. The popover
  /// adds no tap or keyboard activation and no focus stop, so the control must
  /// open and close the popover through [controller]. Attach [triggerFocusNode]
  /// to the control so that closing the popover moves focus back to it. The
  /// popover adds no semantics, so the control owns its label and any expanded
  /// state; [semanticLabel] has no effect.
  final bool openOnTap;

  /// Optional key for a separate widget used as the positioning anchor.
  ///
  /// When null, the trigger is the anchor. The keyed widget may be a sibling
  /// or ancestor descendant in the same overlay subtree, allowing trigger and
  /// positioning geometry to be composed independently.
  final GlobalKey? anchorKey;

  /// Focus node for the trigger widget.
  ///
  /// The popover focuses it when the popover closes. With [openOnTap] set to
  /// false, attach it to the caller's own control, and use the same node as that
  /// control's own focus node. Without it, closing the popover returns focus to
  /// whatever had it before the popover opened.
  final FocusNode? triggerFocusNode;

  /// Called when the popover opens.
  final VoidCallback? onOpen;

  /// Called when the popover closes.
  final VoidCallback? onClose;

  /// Controls whether the popover overlay is open.
  final MenuController? controller;

  /// Optional semantics label for the trigger.
  ///
  /// Ignored when [openOnTap] is false: the caller's control owns its label.
  final String? semanticLabel;

  /// Whether to hide the popover trigger subtree from accessibility.
  final bool excludeSemantics;

  /// Called when a request is made to open the popover.
  ///
  /// This callback allows you to customize the opening behavior, such as
  /// adding animations or delays. Call `showOverlay` to actually show the popover.
  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  /// Called when a request is made to close the popover.
  ///
  /// This callback allows you to customize the closing behavior, such as
  /// adding animations or delays. Call `hideOverlay` to actually hide the popover.
  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  @override
  State<NakedPopover> createState() => _NakedPopoverState();
}

class _NakedPopoverState extends State<NakedPopover>
    with WidgetStatesMixin<NakedPopover>, OverlayStateMixin<NakedPopover> {
  // ignore: dispose-fields
  final _internalMenuController = MenuController();

  // Internal node used when the child does not already provide a Focus.
  final _internalTriggerNode = FocusNode(
    debugLabel: 'NakedPopover trigger (internal)',
  );
  FocusNode? _observedChildFocusNode;
  Timer? _keyboardPressTimer;

  MenuController get _menuController =>
      widget.controller ?? _internalMenuController;

  @override
  void initState() {
    super.initState();
    _updateObservedChildFocusNode();
  }

  void _toggle() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  void _handleOpen() {
    if (mounted) setState(() {});
    widget.onOpen?.call();
  }

  void _handleClose() {
    if (mounted) setState(() {});
    widget.onClose?.call();
  }

  /// If the child is a Focus widget, extract its node so we can return focus to it.
  FocusNode? _extractChildFocusNode() {
    final c = widget.child;
    if (c is Focus) return c.focusNode;

    return null;
  }

  void _updateObservedChildFocusNode() {
    final next = _extractChildFocusNode();
    if (identical(next, _observedChildFocusNode)) return;
    _observedChildFocusNode?.removeListener(_handleChildFocusChange);
    _observedChildFocusNode = next;
    _observedChildFocusNode?.addListener(_handleChildFocusChange);
    _handleChildFocusChange();
  }

  void _handleChildFocusChange() {
    updateFocusState(_observedChildFocusNode?.hasFocus ?? false, null);
  }

  void _activate() {
    Feedback.forTap(context);
    _toggle();
  }

  void _handleKeyboardActivation() {
    _keyboardPressTimer?.cancel();
    _activate();
    updatePressState(true, null);
    _keyboardPressTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) updatePressState(false, null);
      _keyboardPressTimer = null;
    });
  }

  Widget _buildChildOwnedTrigger(FocusNode childFocusNode) {
    final state = NakedPopoverState(
      states: {
        ...widgetStates,
        if (childFocusNode.hasFocus) WidgetState.focused,
      },
      isOpen: _menuController.isOpen,
    );
    final content = NakedStateScopeBuilder(
      value: state,
      child: widget.child,
      builder: widget.builder,
    );
    final semanticContent = widget.semanticLabel == null
        ? content
        : ExcludeSemantics(child: content);

    Widget trigger = GestureDetector(
      onTapDown: (_) => updatePressState(true, null),
      onTapUp: (_) => updatePressState(false, null),
      onTapCancel: () => updatePressState(false, null),
      onTap: _activate,
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      child: semanticContent,
    );
    trigger = Semantics(
      enabled: true,
      button: true,
      // Disclosure state: announce open/closed alongside the button role, so AT
      // reports isExpanded. Matches NakedMenu/NakedSelect/NakedAccordion.
      expanded: _menuController.isOpen,
      label: widget.semanticLabel,
      onTap: _activate,
      child: trigger,
    );
    trigger = MouseRegion(
      onEnter: (_) => updateHoverState(true, null),
      onExit: (_) => updateHoverState(false, null),
      cursor: SystemMouseCursors.click,
      child: trigger,
    );

    return Shortcuts(
      shortcuts: NakedIntentActions.button.shortcuts,
      child: Actions(
        actions: NakedIntentActions.button.actions(
          onPressed: _handleKeyboardActivation,
        ),
        child: trigger,
      ),
    );
  }

  Widget _buildTrigger(FocusNode returnNode, FocusNode? childFocusNode) {
    final excludeChildTraversal =
        widget.child is Focus && !identical(returnNode, childFocusNode);

    if (widget.openOnTap) {
      if (identical(returnNode, childFocusNode)) {
        return _buildChildOwnedTrigger(childFocusNode!);
      }

      // Wrap NakedButton (rather than extend it with an `expanded` param) so the
      // disclosure state merges onto the button's node. Mirrors NakedMenu.
      return Semantics(
        expanded: _menuController.isOpen,
        child: NakedButton(
          onPressed: _toggle,
          focusNode: returnNode,
          semanticLabel: widget.semanticLabel,
          child: excludeChildTraversal
              ? ExcludeFocusTraversal(child: widget.child!)
              : widget.child,
          builder: (context, buttonState, child) {
            return NakedStateScopeBuilder(
              value: NakedPopoverState(
                states: buttonState.states,
                isOpen: _menuController.isOpen,
              ),
              child: child,
              builder: widget.builder,
            );
          },
        ),
      );
    }

    return NakedStateScopeBuilder(
      value: NakedPopoverState(
        states: const <WidgetState>{},
        isOpen: _menuController.isOpen,
      ),
      child: widget.child,
      builder: widget.builder,
    );
  }

  @override
  void didUpdateWidget(covariant NakedPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateObservedChildFocusNode();
  }

  @override
  void dispose() {
    _keyboardPressTimer?.cancel();
    _keyboardPressTimer = null;
    _observedChildFocusNode?.removeListener(_handleChildFocusChange);
    _observedChildFocusNode = null;
    _internalTriggerNode.dispose();
    super.dispose();
  }

  /// Replaces [info]'s anchor rect with the [NakedPopover.anchorKey] widget's
  /// rect in the overlay's coordinate space, when there is one.
  RawMenuOverlayInfo _anchoredInfo(
    BuildContext overlayContext,
    RawMenuOverlayInfo info,
  ) {
    final anchorBox = widget.anchorKey?.currentContext?.findRenderObject();
    final overlayBox = Overlay.maybeOf(
      overlayContext,
      rootOverlay: widget.useRootOverlay,
    )?.context.findRenderObject();
    if (anchorBox is! RenderBox || overlayBox is! RenderBox) return info;
    final topLeft = anchorBox.localToGlobal(Offset.zero, ancestor: overlayBox);

    return RawMenuOverlayInfo(
      anchorRect: topLeft & anchorBox.size,
      overlaySize: info.overlaySize,
      tapRegionGroupId: info.tapRegionGroupId,
      position: info.position,
    );
  }

  void _handleCloseRequested(VoidCallback hideOverlay) {
    handleCloseRequested(
      controller: _menuController,
      onCloseRequested: widget.onCloseRequested,
      hideOverlay: hideOverlay,
    );
  }

  @override
  Widget build(BuildContext context) {
    final childFocusNode = _extractChildFocusNode();
    final returnNode =
        widget.triggerFocusNode ?? childFocusNode ?? _internalTriggerNode;

    final result = RawMenuAnchor(
      controller: _menuController,
      childFocusNode: widget.openOnTap
          ? returnNode
          : widget.triggerFocusNode ?? childFocusNode,
      consumeOutsideTaps: widget.consumeOutsideTaps,
      onOpen: _handleOpen,
      onClose: _handleClose,
      onOpenRequested:
          widget.onOpenRequested ?? (_, showOverlay) => showOverlay(),
      onCloseRequested: _handleCloseRequested,
      useRootOverlay: widget.useRootOverlay,
      overlayBuilder: (context, info) {
        final anchored = _anchoredInfo(context, info);

        return AnchoredOverlay(
          info: anchored,
          positioning: widget.positioning,
          child: widget.popoverBuilder(context, anchored),
        );
      },
      child: _buildTrigger(returnNode, childFocusNode),
    );

    return widget.excludeSemantics ? ExcludeSemantics(child: result) : result;
  }
}
