// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popover.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixPopover], the overlay surface.
///
/// Anchoring, dismissal, and focus return stay with Remix. To open the popover
/// from a button, set `openOnTap: false`, open it from the button's `onPressed`
/// with the popover's `controller`, and pass one `FocusNode` as both the
/// popover's `triggerFocusNode` and the button's `focusNode`, so the button is
/// the only tab stop and takes focus back on close.
class UiPopover extends StatelessWidget {
  const UiPopover({
    super.key,
    this.style = const PopoverStyler.create(),
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
  });

  final PopoverStyler style;

  final Widget popoverChild;

  final Widget child;

  final OverlayPositionConfig positioning;

  final bool consumeOutsideTaps;

  final bool useRootOverlay;

  final bool openOnTap;

  final FocusNode? triggerFocusNode;

  final FocusNode? initialFocusNode;

  final bool constrainToAvailableSpace;

  final bool avoidViewInsets;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  final MenuController? controller;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixPopover(
      style: uiPopoverStyle(style: style),
      popoverChild: popoverChild,
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
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      controller: controller,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }
}
