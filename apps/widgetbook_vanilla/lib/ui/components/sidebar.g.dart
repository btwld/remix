// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Sidebar recipe.
///
/// The navigation panel down one edge of a shell: the `sidebar` surface with a
/// `sidebarBorder` edge, 32px destinations that sit on `sidebarAccent` while
/// hovered or current, and one 8px inset so labels, destinations and the footer
/// share a left edge.
///
/// It sets no width: the host sizes the panel, which is often also a drawer. It
/// does not pad the header either, whose metrics should line up with the app
/// bar: give it the `app_bar` item's toolbar height and bottom hairline.
///
/// It depends on the `toggle` and `tooltip` items. A destination is a toggle
/// (`SidebarSpec` takes a `ToggleStyler`), so the ghost toggle recipe keeps a
/// selected destination and a selected toggle the same color; in a collapsed
/// icon rail each label appears in the application's tooltip recipe.
class VanillaSidebar<T extends Object> extends StatelessWidget {
  const VanillaSidebar({
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
      style: vanillaSidebarStyle(style: this.style),
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
