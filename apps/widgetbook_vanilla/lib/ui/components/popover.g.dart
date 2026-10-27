// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popover.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Popover recipe.
///
/// Remix owns the rendering, the overlay, the anchor positioning, the
/// dismiss-on-outside-tap behavior, focus, and the popover accessibility
/// semantics; this recipe supplies only the floating panel's surface.
///
/// A popover sits *over* arbitrary content, so its edge is doing real work: it
/// is what tells a reader where the panel stops and the page resumes. That edge
/// is a `border` hairline plus the `md` shadow. The fill is `popover`, the
/// surface every floating panel shares: the page color in the light theme and a
/// step lighter than the page in the dark one.
///
/// `RemixPopover` opens on a tap of its own `child`, which a button with its
/// own `onPressed` consumes first. For a button trigger, set `openOnTap:
/// false`, toggle a `MenuController` from the button, and give the popover and
/// the button one `FocusNode`, so the button is the only tab stop and takes
/// focus back when the popover closes. Keep the controller and the node in a
/// `State` and dispose the node there:
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
///   Widget build(BuildContext context) => VanillaPopover(
///     controller: _controller,
///     openOnTap: false,
///     triggerFocusNode: _triggerFocus,
///     popoverChild: const Text('Filters go here.'),
///     child: VanillaButton.outline(
///       label: 'Filter',
///       focusNode: _triggerFocus,
///       onPressed: () =>
///           _controller.isOpen ? _controller.close() : _controller.open(),
///     ),
///   );
/// }
/// ```
class VanillaPopover extends StatelessWidget {
  const VanillaPopover({
    super.key,
    this.style = const PopoverStyler.create(),
    required this.popoverChild,
    required this.child,
    this.positioning = const OverlayPositionConfig(),
    this.consumeOutsideTaps = true,
    this.useRootOverlay = false,
    this.openOnTap = true,
    this.triggerFocusNode,
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
      style: vanillaPopoverStyle(style: this.style),
      popoverChild: this.popoverChild,
      child: this.child,
      positioning: this.positioning,
      consumeOutsideTaps: this.consumeOutsideTaps,
      useRootOverlay: this.useRootOverlay,
      openOnTap: this.openOnTap,
      triggerFocusNode: this.triggerFocusNode,
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
