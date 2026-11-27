// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Menu recipe: the trigger, the floating panel, its items,
/// submenu items and dividers.
///
/// [highContrast] moves the highlighted item of the solid variant to accent
/// step 12.
class UiMenu<T> extends StatelessWidget {
  const UiMenu({
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

  /// The accent's solid fill under its contrast text.
  const UiMenu.solid({
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
  }) : variant = UiMenuVariant.solid;

  /// A tinted accent fill.
  const UiMenu.soft({
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
  }) : variant = UiMenuVariant.soft;

  final UiMenuVariant variant;

  final UiMenuSize size;

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
      style: uiMenuStyle(
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
