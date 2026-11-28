// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Menu recipe: the trigger, the floating panel, its items,
/// submenu items and dividers.
///
/// The trigger is a 32px framed control with a chevron that turns over while
/// the menu is open. The panel opens below the trigger's end edge, rising and
/// growing in from it while its rows fade in one after another, and leaves
/// faster than it came.
///
/// [highContrast] marks the highlighted item with a focus ring as well and
/// draws the trigger frame in the strong border.
class FortalMenu<T> extends StatelessWidget {
  const FortalMenu({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    this.highContrast = false,
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

  /// The muted neutral fill.
  const FortalMenu.solid({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = FortalMenuVariant.solid;

  /// A faint accent tint.
  const FortalMenu.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = FortalMenuVariant.soft;

  final FortalMenuVariant variant;

  final FortalMenuSize size;

  final bool highContrast;

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
      style: fortalMenuStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
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
