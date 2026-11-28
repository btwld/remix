// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dropdown.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixMenu]: the dropdown trigger and its popover menu.
///
/// Style a single row with [heroUiDropdownItemStyle], for example a danger item
/// in `RemixMenuItem.style`.
class HeroUiDropdown<T> extends StatelessWidget {
  const HeroUiDropdown({
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
    this.positioning,
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

  final OverlayPositionConfig? positioning;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixMenu<T>(
      style: heroUiDropdownStyle(style: style),
      trigger: trigger,
      items: items,
      controller: controller,
      onSelected: onSelected,
      onOpen: onOpen,
      onClose: onClose,
      onCanceled: onCanceled,
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      consumeOutsideTaps: consumeOutsideTaps,
      useRootOverlay: useRootOverlay,
      closeOnClickOutside: closeOnClickOutside,
      triggerFocusNode: triggerFocusNode,
      positioning: positioning,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
    );
  }
}
