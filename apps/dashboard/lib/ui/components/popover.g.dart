// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popover.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Popover recipe: a floating panel in a 1px border, 192 to 352px
/// wide.
///
/// It opens over 440ms: it fades in over the first 150ms while it slides 5px
/// from its trigger and grows from 97% around the trigger-side corner on the
/// transform spring. It closes in 150ms, halfway back and to 98%. Under
/// reduced motion it only fades, over 100ms.
///
/// The generated [UiPopover] defaults to [UiPopoverSize.size2] and no
/// arrow.
class UiPopover extends StatelessWidget {
  const UiPopover({
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

  final UiPopoverSize size;

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
      style: uiPopoverStyle(size: size, style: style),
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
