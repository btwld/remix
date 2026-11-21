// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popover.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Popover recipe: a raised, blurred panel in a 1px frame.
///
/// The generated [FortalPopover] defaults to [FortalPopoverSize.size2], a
/// 480-pixel maximum width, and no arrow.
class FortalPopover extends StatelessWidget {
  const FortalPopover({
    super.key,
    this.size = .size2,
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

  final FortalPopoverSize size;

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
      style: fortalPopoverStyle(size: size, style: style),
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
