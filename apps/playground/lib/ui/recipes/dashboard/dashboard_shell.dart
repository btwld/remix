import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/sidebar_layout.dart';
import '../../components/textfield.dart';
import '../../icons.dart';
import '../../theme/tokens.dart';
import 'dashboard_shell_base.dart';

const _headerHeight = 64.0;

/// A reusable default-preset dashboard shell.
///
/// The host owns navigation values and page state. Supply [onSearchChanged]
/// only when the host has real search behavior; otherwise no field is shown.
class PlaygroundDashboardShell<T extends Object> extends StatelessWidget {
  const PlaygroundDashboardShell({
    super.key,
    required this.sections,
    required this.selectedValue,
    required this.onSelected,
    required this.body,
    required this.title,
    required this.brand,
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.searchHintText = 'Search…',
    this.collapsed,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
    this.compactBreakpoint = 720,
    this.sidebarWidth = 256,
    this.collapsedWidth = 72,
  });

  final List<RemixSidebarSection<T>> sections;
  final T? selectedValue;
  final ValueChanged<T> onSelected;
  final Widget body;
  final String title;
  final Widget brand;
  final Widget? account;
  final List<Widget> headerActions;
  final ValueChanged<String>? onSearchChanged;
  final String searchHintText;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final double compactBreakpoint;
  final double sidebarWidth;
  final double collapsedWidth;

  @override
  Widget build(BuildContext context) {
    final topBarStyle = BoxStyler()
        .height(_headerHeight)
        .alignment(AlignmentDirectional.centerStart)
        .padding(.horizontal(16))
        .color(PlaygroundTokens.background())
        .border(.bottom(.color(PlaygroundTokens.border()).width(1)));
    final sidebarHeaderStyle = topBarStyle.padding(.horizontal(12));
    return PlaygroundDashboardShellBase<T>(
      sections: sections,
      selectedValue: selectedValue,
      onSelected: onSelected,
      body: body,
      title: title,
      brand: brand,
      account: account,
      headerActions: headerActions,
      onSearchChanged: onSearchChanged,
      searchHintText: searchHintText,
      collapsed: collapsed,
      initiallyCollapsed: initiallyCollapsed,
      onCollapsedChanged: onCollapsedChanged,
      sidebarHeaderStyle: sidebarHeaderStyle,
      topBarStyle: topBarStyle,
      titleStyle: TextStyler()
          .fontSize(18)
          .fontWeight(FontWeight.w600)
          .color(PlaygroundTokens.foreground()),
      menuIcon: PlaygroundIcons.hamburgerMenu,
      searchIcon: PlaygroundIcons.magnifyingGlass,
      backwardIcon: PlaygroundIcons.doubleArrowLeft,
      forwardIcon: PlaygroundIcons.doubleArrowRight,
      layoutBuilder:
          (
            context, {
            required collapsed,
            required body,
            required sidebarBuilder,
            required headerBuilder,
          }) => PlaygroundSidebarLayout(
            compactBreakpoint: compactBreakpoint,
            sidebarWidth: sidebarWidth,
            collapsedWidth: collapsedWidth,
            collapsed: collapsed,
            sidebar: Builder(
              builder: (context) => sidebarBuilder(
                context,
                _PlaygroundDashboardLayoutControls(
                  PlaygroundSidebarLayoutScope.of(context),
                ),
              ),
            ),
            header: Builder(
              builder: (context) => headerBuilder(
                context,
                _PlaygroundDashboardLayoutControls(
                  PlaygroundSidebarLayoutScope.of(context),
                ),
              ),
            ),
            body: body,
          ),
      sidebarBuilder:
          (
            context, {
            required collapsed,
            required sections,
            required selectedValue,
            required onSelected,
            required header,
            required footer,
            required semanticLabel,
          }) => PlaygroundSidebar<T>(
            key: const ValueKey('dashboard-sidebar'),
            style: SidebarStyler().padding(
              EdgeInsetsGeometryMix.value(MediaQuery.paddingOf(context)),
            ),
            collapsed: collapsed,
            expandedWidth: sidebarWidth,
            collapsedWidth: collapsedWidth,
            header: header,
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            footer: footer,
            semanticLabel: semanticLabel,
          ),
      iconButtonBuilder:
          (
            context, {
            required key,
            required icon,
            required semanticLabel,
            required onPressed,
          }) => PlaygroundIconButton.ghost(
            key: key,
            size: .large,
            icon: icon,
            semanticLabel: semanticLabel,
            onPressed: onPressed,
          ),
      searchBuilder:
          (
            context, {
            required key,
            required hintText,
            required leading,
            required onChanged,
          }) => PlaygroundTextField(
            key: key,
            hintText: hintText,
            leading: leading,
            onChanged: onChanged,
          ),
    );
  }
}

final class _PlaygroundDashboardLayoutControls
    implements PlaygroundDashboardLayoutControls {
  const _PlaygroundDashboardLayoutControls(this.scope);

  final PlaygroundSidebarLayoutScope scope;

  @override
  bool get isCompact => scope.isCompact;

  @override
  void closeCompact() => scope.closeCompact();

  @override
  void openCompact() => scope.openCompact();
}
