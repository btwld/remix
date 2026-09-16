import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../../dashboard/dashboard_shell_base.dart';
import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/sidebar_layout.dart';
import '../../components/text.dart';
import '../../components/textfield.dart';
import '../../icons.dart';
import '../../theme/theme.dart';

const _headerHeight = 64.0;

/// A reusable Fortal dashboard shell.
///
/// The host owns navigation values and page state. Supply [onSearchChanged]
/// only when the host has real search behavior; otherwise no field is shown.
class FortalDashboardShell<T extends Object> extends StatelessWidget {
  const FortalDashboardShell({
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
        .padding(.horizontal(FortalTokens.space4()))
        .color(FortalTokens.colorPanelSolid())
        .border(
          .bottom(
            .color(FortalTokens.grayA6()).width(FortalTokens.borderWidth1()),
          ),
        );
    final sidebarHeaderStyle = topBarStyle.padding(
      .horizontal(FortalTokens.space2()),
    );
    return RegistryDashboardShellBase<T>(
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
      titleStyle: fortalTextStyle(size: .size4, weight: .bold),
      menuIcon: FortalIcons.hamburgerMenu,
      searchIcon: FortalIcons.magnifyingGlass,
      backwardIcon: FortalIcons.doubleArrowLeft,
      forwardIcon: FortalIcons.doubleArrowRight,
      layoutBuilder:
          (
            context, {
            required collapsed,
            required body,
            required sidebarBuilder,
            required headerBuilder,
          }) => FortalSidebarLayout(
            compactBreakpoint: compactBreakpoint,
            sidebarWidth: sidebarWidth,
            collapsedWidth: collapsedWidth,
            collapsed: collapsed,
            sidebar: Builder(
              builder: (context) => sidebarBuilder(
                context,
                _FortalDashboardLayoutControls(
                  FortalSidebarLayoutScope.of(context),
                ),
              ),
            ),
            header: Builder(
              builder: (context) => headerBuilder(
                context,
                _FortalDashboardLayoutControls(
                  FortalSidebarLayoutScope.of(context),
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
          }) => FortalSidebar<T>(
            key: const ValueKey('dashboard-sidebar'),
            collapsed: collapsed,
            panelPadding: MediaQuery.paddingOf(context),
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
          }) => FortalIconButton.ghost(
            key: key,
            size: .size3,
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
          }) => FortalTextField.surface(
            key: key,
            size: .size2,
            hintText: hintText,
            leading: leading,
            onChanged: onChanged,
          ),
    );
  }
}

final class _FortalDashboardLayoutControls
    implements RegistryDashboardLayoutControls {
  const _FortalDashboardLayoutControls(this.scope);

  final FortalSidebarLayoutScope scope;

  @override
  bool get isCompact => scope.isCompact;

  @override
  void closeCompact() => scope.closeCompact();

  @override
  void openCompact() => scope.openCompact();
}
