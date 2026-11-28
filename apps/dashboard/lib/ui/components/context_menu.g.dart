// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_menu.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal context menu recipe: the floating panel opened at the pointer,
/// its rows, and their motion.
///
/// The panel grows from the point it opened at and fades in; rows rise into
/// place one after another. Mark a destructive row with
/// [uiContextMenuItemStyle] and `destructive: true`.
///
/// [highContrast] draws the focus ring on the keyboard-focused row, on top of
/// the highlight fill.
class UiContextMenu<T> extends StatelessWidget {
  const UiContextMenu({
    super.key,
    this.highContrast = false,
    this.style = const MenuStyler.create(),
    required this.child,
    required this.items,
    this.controller,
    this.onSelected,
    this.onOpen,
    this.onClose,
    this.onCanceled,
    this.onOpenRequested,
    this.onCloseRequested,
    this.enabled = true,
    this.focusNode,
    this.useRootOverlay = false,
    this.positioning,
  });

  final bool highContrast;

  final MenuStyler style;

  final Widget child;

  final List<RemixMenuItemData<T>> items;

  final MenuController? controller;

  final ValueChanged<T>? onSelected;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final VoidCallback? onCanceled;

  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  final bool enabled;

  final FocusNode? focusNode;

  final bool useRootOverlay;

  final OverlayPositionConfig? positioning;

  @override
  Widget build(BuildContext _) {
    return RemixContextMenu<T>(
      style: uiContextMenuStyle(highContrast: highContrast, style: style),
      items: items,
      controller: controller,
      onSelected: onSelected,
      onOpen: onOpen,
      onClose: onClose,
      onCanceled: onCanceled,
      onOpenRequested: onOpenRequested,
      onCloseRequested: onCloseRequested,
      enabled: enabled,
      focusNode: focusNode,
      useRootOverlay: useRootOverlay,
      positioning: positioning,
      child: child,
    );
  }
}
