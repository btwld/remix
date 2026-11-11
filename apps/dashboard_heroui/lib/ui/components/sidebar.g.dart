// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Navigation panel recipe for [RemixSidebar], styled with HeroUI tokens.
///
/// An extension: HeroUI web 3.2.6 has no sidebar to port, so this recipe is
/// built only from the theme's tokens and two mapped recipes. Remix owns the
/// rendering, the header/content/footer stacking, Tab traversal across
/// destinations, the selection semantics, and the navigation landmark.
///
/// A destination is the `sm` ghost [uiToggleButtonStyle], stretched to a
/// full-width row with its content at the start: transparent at rest,
/// `default` while hovered, `accent-soft` with `accent-soft-foreground` while
/// current, exactly as a selected toggle button. This recipe therefore
/// **depends on the `toggle_button` and `tooltip` items**. When the host
/// collapses the panel to an icon rail, each destination's label appears in
/// [uiTooltipStyle].
///
/// The panel sits on the page `background` with a `separator` line on its
/// end edge, and the footer has one along its top. Section labels are
/// `text-xs` medium `muted` text, inset like the destination labels below
/// them.
///
/// It takes no variant and no size, and sets no panel width and no header
/// padding: the host sizes the panel, because the same panel is presented
/// as a sheet at narrow widths. Give the header the app bar's
/// `uiAppBarToolbarHeight` and separator so the two rows line up.
class UiSidebar<T extends Object> extends StatelessWidget {
  const UiSidebar({
    super.key,
    this.style = const SidebarStyler.create(),
    this.header,
    this.collapsed = false,
    this.showTooltips = true,
    this.tooltipPositioning,
    this.expandedWidth,
    this.collapsedWidth,
    this.animationStyle = const AnimationStyle(),
    required this.sections,
    required this.selectedValue,
    this.onSelected,
    this.footer,
    this.enabled = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final SidebarStyler style;

  final Widget? header;

  final bool collapsed;

  final bool showTooltips;

  final OverlayPositionConfig? tooltipPositioning;

  final double? expandedWidth;

  final double? collapsedWidth;

  final AnimationStyle animationStyle;

  final List<RemixSidebarSection<T>> sections;

  final T? selectedValue;

  final ValueChanged<T>? onSelected;

  final Widget? footer;

  final bool enabled;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixSidebar<T>(
      key: this.key,
      style: uiSidebarStyle(style: this.style),
      header: this.header,
      collapsed: this.collapsed,
      showTooltips: this.showTooltips,
      tooltipPositioning: this.tooltipPositioning,
      expandedWidth: this.expandedWidth,
      collapsedWidth: this.collapsedWidth,
      animationStyle: this.animationStyle,
      sections: this.sections,
      selectedValue: this.selectedValue,
      onSelected: this.onSelected,
      footer: this.footer,
      enabled: this.enabled,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
