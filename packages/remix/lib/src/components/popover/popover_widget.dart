part of 'popover.dart';

/// A styled, anchored overlay for supplementary interactive content.
///
/// The popover opens when [child] is tapped or activated from the keyboard.
/// [popoverChild] is rendered in the overlay using [style].
class RemixPopover extends StatefulWidget {
  const RemixPopover({
    super.key,
    required this.popoverChild,
    required this.child,
    this.positioning = const OverlayPositionConfig(),
    this.consumeOutsideTaps = true,
    this.useRootOverlay = false,
    this.openOnTap = true,
    this.triggerFocusNode,
    this.initialFocusNode,
    this.constrainToAvailableSpace = false,
    this.avoidViewInsets = false,
    this.onOpen,
    this.onClose,
    this.onOpenRequested,
    this.onCloseRequested,
    this.controller,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.style = const PopoverStyler.create(),
    this.styleSpec,
  });

  /// Content displayed inside the popover overlay.
  final Widget popoverChild;

  /// Trigger that opens and closes the popover.
  final Widget child;

  /// Position of the overlay relative to [child].
  final OverlayPositionConfig positioning;

  /// Whether an outside tap is consumed after closing the popover.
  final bool consumeOutsideTaps;

  /// Whether to render in the root overlay.
  final bool useRootOverlay;

  /// Whether tapping or activating [child] toggles the popover.
  ///
  /// When false, [child] is the caller's own control, such as a button. The
  /// popover adds no tap or keyboard activation and no focus stop, so the
  /// control opens and closes it through [controller].
  final bool openOnTap;

  /// Optional focus node for the trigger.
  ///
  /// When [openOnTap] is false, attach it to the control in [child] so that
  /// closing the popover returns focus to it.
  ///
  /// Close-time focus return is owned by [RawMenuAnchor]. Unlike Select/Menu,
  /// it is not limited to cases where focus is still inside the panel.
  final FocusNode? triggerFocusNode;

  /// Preferred focus target after the panel attaches, revealed in its scrollables.
  ///
  /// Attach this node to a focusable descendant of the panel. If it is detached
  /// or cannot request focus, the first focusable descendant is used instead.
  /// Existing focus inside the panel is preserved. With no eligible descendant,
  /// focus remains on the panel container. Null keeps the default container focus.
  final FocusNode? initialFocusNode;

  /// Whether to fit the panel into the space its placement can use. For top and bottom
  /// placements, caps height beside the trigger; with collision avoidance,
  /// also caps width inside the padded overlay. Content must handle scrolling.
  final bool constrainToAvailableSpace;

  /// Whether to keep the panel inside the view padding (safe area) and above
  /// the view insets (keyboard).
  ///
  /// These view-coordinate exclusions are intersected with the actual Overlay
  /// bounds, including smaller or offset nested overlays, and cap both axes.
  /// Fixed-size content larger than the cap overflows unless it adapts or
  /// scrolls. The open panel re-fits when safe-area or keyboard insets change.
  /// Defaults to false.
  final bool avoidViewInsets;

  /// Called after the popover opens.
  final VoidCallback? onOpen;

  /// Called after the popover closes.
  final VoidCallback? onClose;

  /// Intercepts a request to open the popover.
  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  /// Intercepts a request to close the popover.
  ///
  /// With a [PopoverStyler.panelTransition], the `hideOverlay` passed here
  /// plays the exit transition before the panel hides.
  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  /// Optional controller for programmatic open and close operations.
  final MenuController? controller;

  /// Accessibility label for the built-in trigger.
  ///
  /// When [openOnTap] is false, [child] owns its accessible label and actions.
  final String? semanticLabel;

  /// Whether to hide the trigger subtree from accessibility.
  final bool excludeSemantics;

  /// Style configuration for the overlay container.
  final PopoverStyler style;

  /// Optional resolved style that bypasses [style].
  final PopoverSpec? styleSpec;

  static final styleFrom = PopoverStyler.new;

  @override
  State<RemixPopover> createState() => _RemixPopoverState();
}

class _RemixPopoverState extends State<RemixPopover>
    with SingleTickerProviderStateMixin {
  late final _panelTransition = RemixPanelTransitionHandle(
    vsync: this,
    resolve: _resolvePanelTransition,
    reduceMotion: () => remixReducedMotionOf(context),
  );

  @override
  void dispose() {
    _panelTransition.dispose();
    super.dispose();
  }

  /// The transition the style gives the panel about to open, read where the
  /// popover is: the panel itself has not been built yet. The panel reads its
  /// own style again and hands that to the handle.
  RemixPanelTransition? _resolvePanelTransition() {
    final styleSpec = widget.styleSpec;
    if (styleSpec != null) return styleSpec.panelTransition;
    final inherited = Style.maybeOf<PopoverSpec>(context);
    final style = widget.style;
    final effective = inherited is PopoverStyler
        ? inherited.merge(style)
        : style;
    return effective.build(context).spec.panelTransition;
  }

  @override
  Widget build(BuildContext context) {
    final RemixPopover(
      :popoverChild,
      :child,
      :positioning,
      :consumeOutsideTaps,
      :useRootOverlay,
      :openOnTap,
      :triggerFocusNode,
      :initialFocusNode,
      :constrainToAvailableSpace,
      :avoidViewInsets,
      :onOpen,
      :onClose,
      :onOpenRequested,
      :onCloseRequested,
      :controller,
      :semanticLabel,
      :excludeSemantics,
      :style,
      :styleSpec,
    ) = widget;

    return RemixStyleSpecBuilder<PopoverSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        return NakedPopover(
          popoverBuilder: (context, info) {
            return RemixPanelTransitionHost(
              handle: _panelTransition,
              transition: spec.panelTransition,
              anchorRect: info.anchorRect,
              child: RemixBoxAdapter(
                styleSpec: spec.container,
                containerEffects: spec.containerEffects,
                child: popoverChild,
              ),
            );
          },
          positioning: positioning,
          consumeOutsideTaps: consumeOutsideTaps,
          useRootOverlay: useRootOverlay,
          openOnTap: openOnTap,
          triggerFocusNode: triggerFocusNode,
          initialFocusNode: initialFocusNode,
          constrainToAvailableSpace: constrainToAvailableSpace,
          avoidViewInsets: avoidViewInsets,
          onOpen: onOpen,
          onClose: onClose,
          onOpenRequested: (position, showOverlay) => _panelTransition
              .openRequested(position, showOverlay, onOpenRequested),
          onCloseRequested: (hideOverlay) =>
              _panelTransition.closeRequested(hideOverlay, onCloseRequested),
          controller: controller,
          excludeSemantics: excludeSemantics,
          child: child,
          builder: (context, state, trigger) {
            final label = openOnTap ? semanticLabel : null;
            final semantics = Semantics(
              excludeSemantics: label != null,
              expanded: state.isOpen,
              label: label,
              child: trigger!,
            );

            return openOnTap ? semantics : MergeSemantics(child: semantics);
          },
        );
      },
    );
  }
}
