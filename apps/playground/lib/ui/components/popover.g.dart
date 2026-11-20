// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popover.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Popover recipe.
///
/// The floating panel's surface: the `popover` fill, a `border` hairline and
/// the `md` shadow, which together tell a reader where the panel stops and the
/// page resumes.
///
/// `RemixPopover` opens on a tap of its own `child`, which a button with its
/// own `onPressed` consumes first. For a button trigger, set `openOnTap:
/// false`, toggle a `MenuController` from the button, and share one `FocusNode`
/// so the button is the only tab stop and regains focus on close:
///
/// ```dart
/// class _FiltersState extends State<Filters> {
///   final _controller = MenuController();
///   final _triggerFocus = FocusNode();
///
///   @override
///   void dispose() {
///     _triggerFocus.dispose();
///     super.dispose();
///   }
///
///   @override
///   Widget build(BuildContext context) => PlaygroundPopover(
///     controller: _controller,
///     openOnTap: false,
///     triggerFocusNode: _triggerFocus,
///     popoverChild: const Text('Filters go here.'),
///     child: PlaygroundButton.outline(
///       label: 'Filter',
///       focusNode: _triggerFocus,
///       onPressed: () =>
///           _controller.isOpen ? _controller.close() : _controller.open(),
///     ),
///   );
/// }
/// ```
class PlaygroundPopover extends StatelessWidget {
  const PlaygroundPopover({
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
  Widget build(BuildContext context) {
    return RemixPopover(
      key: this.key,
      style: playgroundPopoverStyle(style: this.style),
      popoverChild: this.popoverChild,
      child: this.child,
      positioning: this.positioning,
      consumeOutsideTaps: this.consumeOutsideTaps,
      useRootOverlay: this.useRootOverlay,
      openOnTap: this.openOnTap,
      triggerFocusNode: this.triggerFocusNode,
      initialFocusNode: this.initialFocusNode,
      constrainToAvailableSpace: this.constrainToAvailableSpace,
      avoidViewInsets: this.avoidViewInsets,
      onOpen: this.onOpen,
      onClose: this.onClose,
      onOpenRequested: this.onOpenRequested,
      onCloseRequested: this.onCloseRequested,
      controller: this.controller,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
