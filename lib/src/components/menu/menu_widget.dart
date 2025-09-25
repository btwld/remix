part of 'menu.dart';

/// A customizable menu component that provides dropdown functionality.
///
/// ## Example
///
/// ```dart
/// RemixMenu<String>(
///   onSelected: (value) => print('Selected: $value'),
///   child: Text('Menu'),
///   overlayBuilder: (context, info) => Column(
///     children: [
///       RemixMenuItem(value: 'copy', label: 'Copy'),
///       RemixMenuItem(value: 'paste', label: 'Paste'),
///       RemixMenuItem(value: 'delete', label: 'Delete'),
///     ],
///   ),
/// )
/// ```
class RemixMenu<T> extends StatelessWidget {
  const RemixMenu({
    super.key,
    this.child,
    this.builder,
    required this.overlayBuilder,
    required this.controller,
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
    this.style = const RemixMenuStyle.create(),
    this.icon,
    this.label,
  }) : assert(
         child != null || builder != null || label != null,
         'Either child, builder, or label must be provided',
       );

  /// The static trigger widget.
  final Widget? child;

  /// Builds the trigger surface.
  final ValueWidgetBuilder<NakedMenuState>? builder;

  /// Builds the overlay panel.
  final RawMenuAnchorOverlayBuilder overlayBuilder;

  /// Controls show/hide of the menu.
  final NakedMenuController controller;

  /// Called when an item is selected.
  final ValueChanged<T>? onSelected;

  /// Called when the menu opens.
  final VoidCallback? onOpen;

  /// Called when the menu closes.
  final VoidCallback? onClose;

  /// Called when the menu closes without a selection.
  final VoidCallback? onCanceled;

  /// Open/close interceptors (for example, to drive animations).
  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;
  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  /// Whether taps outside the overlay close the menu.
  final bool closeOnClickOutside;

  /// Whether outside taps on the trigger are consumed.
  final bool consumeOutsideTaps;

  /// Whether to target the root overlay instead of the nearest ancestor.
  final bool useRootOverlay;

  /// Optional focus node for the trigger.
  final FocusNode? triggerFocusNode;

  /// Overlay positioning configuration.
  final OverlayPositionConfig positioning;

  /// The style configuration for the menu.
  final RemixMenuStyle style;

  /// Optional icon to display in the trigger.
  final IconData? icon;

  /// Optional label text for the trigger.
  final String? label;

  static late final styleFrom = RemixMenuStyle.new;

  @override
  Widget build(BuildContext context) {
    return NakedMenu<T>(
      controller: controller,
      overlayBuilder: overlayBuilder,
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
      builder: (context, state, _) {
        return StyleBuilder(
          style: style,
          controller: NakedMenuState.controllerOf(context),
          builder: (context, spec) {
            // Use custom builder if provided
            if (builder != null) {
              return builder!(context, state, child);
            }

            // Use custom child if provided
            if (child != null) {
              return child!;
            }

            // Default content with label and icon
            return FlexBox(
              styleSpec: spec.trigger,
              children: [
                if (icon != null)
                  StyledIcon(icon: icon!, styleSpec: spec.triggerIcon),
                if (label != null)
                  StyledText(label!, styleSpec: spec.triggerLabel),
              ],
            );
          },
        );
      },
    );
  }
}

/// An individual menu item.
class RemixMenuItem<T> extends StatelessWidget {
  const RemixMenuItem({
    super.key,
    required this.value,
    this.child,
    this.builder,
    this.enabled = true,
    this.closeOnActivate = true,
    this.semanticLabel,
    this.style = const RemixMenuItemStyle.create(),
    this.label,
    this.leadingIcon,
    this.trailingIcon,
  }) : assert(
         child != null || builder != null || label != null,
         'Either child, builder, or label must be provided',
       );

  /// The value of this menu item.
  final T value;

  /// The static content widget.
  final Widget? child;

  /// Custom builder for the menu item content.
  final ValueWidgetBuilder<NakedMenuItemState<T>>? builder;

  /// Whether this item is enabled.
  final bool enabled;

  /// Whether the menu closes when this item is activated.
  final bool closeOnActivate;

  /// Semantic label for accessibility.
  final String? semanticLabel;

  /// The style configuration for this menu item.
  final RemixMenuItemStyle style;

  /// Optional label text for the item.
  final String? label;

  /// Optional leading icon for the item.
  final IconData? leadingIcon;

  /// Optional trailing icon for the item.
  final IconData? trailingIcon;

  static late final styleFrom = RemixMenuItemStyle.new;

  @override
  Widget build(BuildContext context) {
    return NakedMenuItem<T>(
      value: value,
      enabled: enabled,
      closeOnActivate: closeOnActivate,
      semanticLabel: semanticLabel ?? label,
      builder: (context, state, _) {
        return StyleBuilder(
          style: style,
          controller: NakedMenuItemState.controllerOf(context),
          builder: (context, spec) {
            // Use custom builder if provided
            if (builder != null) {
              return builder!(context, state, child);
            }

            // Use custom child if provided
            if (child != null) {
              return child!;
            }

            // Default content with label and icons
            return FlexBox(
              styleSpec: spec.container,
              children: [
                if (leadingIcon != null)
                  StyledIcon(icon: leadingIcon!, styleSpec: spec.leadingIcon),
                if (label != null)
                  StyledText(label!, styleSpec: spec.label),
                if (trailingIcon != null)
                  StyledIcon(icon: trailingIcon!, styleSpec: spec.trailingIcon),
              ],
            );
          },
        );
      },
    );
  }
}