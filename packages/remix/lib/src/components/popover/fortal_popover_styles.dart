part of 'popover.dart';

/// Fortal-themed preset for [RemixPopover].
RemixPopoverStyler fortalPopoverStyler() {
  return RemixPopoverStyler()
      .paddingAll(FortalTokens.space4())
      .marginTop(FortalTokens.space2())
      .constraints(BoxConstraintsMix(maxWidth: 360))
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .backgroundColor(FortalTokens.colorPanel())
      // Uses the mode-aware stroke with neutral deferred layers. Exact Radix
      // gray-alpha layer swaps for these overlay stylers remain follow-up work.
      .shadows([
        BoxShadowMix()
            .color(FortalTokens.shadowStroke())
            .offset(x: 0, y: 0)
            .blurRadius(0)
            .spreadRadius(1),
        BoxShadowMix()
            .color(FortalTokens.blackA5())
            .offset(x: 0, y: 12)
            .blurRadius(60)
            .spreadRadius(0),
        BoxShadowMix()
            .color(FortalTokens.blackA7())
            .offset(x: 0, y: 12)
            .blurRadius(32)
            .spreadRadius(-16),
      ]);
}

/// Fortal-themed preset for [RemixPopover].
class FortalPopover extends StatelessWidget {
  const FortalPopover({
    super.key,
    this.color,
    this.radius,
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

  final Widget popoverChild;

  final FortalAccentColor? color;

  final FortalRadius? radius;

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
    return FortalOverride(
      color: this.color,
      radius: this.radius,
      child: fortalPopoverStyler().call(
        key: this.key,
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
      ),
    );
  }
}
