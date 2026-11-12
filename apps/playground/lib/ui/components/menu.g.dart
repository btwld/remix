// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Menu recipe.
///
/// One recipe covers every row kind: `MenuSpec` falls back to `item` for
/// `checkboxItem`, `radioItem` and `submenuItem`, so styling only `item` keeps
/// the menu one list.
///
/// The panel matches the popover's `popover` fill and `border` hairline, so a
/// menu and a popover beside each other do not read as two systems.
class PlaygroundMenu<T> extends StatelessWidget {
  const PlaygroundMenu({
    super.key,
    this.style = const MenuStyler.create(),
    required this.trigger,
    required this.items,
    this.controller,
    this.onSelected,
    this.onOpen,
    this.onClose,
    this.onCanceled,
    this.onOpenRequested,
    this.onCloseRequested,
    this.consumeOutsideTaps = true,
    this.useRootOverlay = false,
    this.closeOnClickOutside = true,
    this.triggerFocusNode,
    this.positioning = const OverlayPositionConfig(),
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final MenuStyler style;

  final RemixMenuTrigger trigger;

  final List<RemixMenuItemData<T>> items;

  final MenuController? controller;

  final ValueChanged<T>? onSelected;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final VoidCallback? onCanceled;

  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  final bool consumeOutsideTaps;

  final bool useRootOverlay;

  final bool closeOnClickOutside;

  final FocusNode? triggerFocusNode;

  final OverlayPositionConfig positioning;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixMenu<T>(
      key: this.key,
      style: playgroundMenuStyle(style: this.style),
      trigger: this.trigger,
      items: this.items,
      controller: this.controller,
      onSelected: this.onSelected,
      onOpen: this.onOpen,
      onClose: this.onClose,
      onCanceled: this.onCanceled,
      onOpenRequested: this.onOpenRequested,
      onCloseRequested: this.onCloseRequested,
      consumeOutsideTaps: this.consumeOutsideTaps,
      useRootOverlay: this.useRootOverlay,
      closeOnClickOutside: this.closeOnClickOutside,
      triggerFocusNode: this.triggerFocusNode,
      positioning: this.positioning,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
