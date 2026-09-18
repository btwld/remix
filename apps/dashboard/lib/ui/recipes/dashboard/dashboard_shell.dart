import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/sidebar_layout.dart';
import '../../components/text.dart';
import '../../components/textfield.dart';
import '../../icons.dart';
import '../../theme/theme.dart';
import 'dashboard_shell_base.dart';

const _headerHeight = 64.0;

/// A reusable Ui dashboard shell.
///
/// The host owns navigation values and page state. Supply [onSearchChanged]
/// only when the host has real search behavior; otherwise no field is shown.
class UiDashboardShell<T extends Object> extends StatelessWidget {
  const UiDashboardShell({
    super.key,
    required this.sections,
    required this.selectedValue,
    required this.onSelected,
    required this.body,
    required this.title,
    required this.brand,
    this.headerTitle,
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
  final Widget? headerTitle;
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
        .padding(.horizontal(UiTokens.space4()))
        .color(UiTokens.colorPanelSolid())
        .border(
          .bottom(.color(UiTokens.grayA6()).width(UiTokens.borderWidth1())),
        );
    final sidebarHeaderStyle = topBarStyle.padding(
      .horizontal(UiTokens.space2()),
    );
    return UiDashboardShellBase<T>(
      sections: sections,
      selectedValue: selectedValue,
      onSelected: onSelected,
      body: body,
      title: title,
      headerTitle: headerTitle,
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
      titleStyle: uiTextStyle(size: .size4, weight: .bold),
      menuIcon: UiIcons.hamburgerMenu,
      searchIcon: UiIcons.magnifyingGlass,
      backwardIcon: UiIcons.doubleArrowLeft,
      forwardIcon: UiIcons.doubleArrowRight,
      layoutBuilder:
          (
            context, {
            required collapsed,
            required body,
            required sidebarBuilder,
            required headerBuilder,
          }) => UiSidebarLayout(
            compactBreakpoint: compactBreakpoint,
            sidebarWidth: sidebarWidth,
            collapsedWidth: collapsedWidth,
            collapsed: collapsed,
            sidebar: Builder(
              builder: (context) => sidebarBuilder(
                context,
                _UiDashboardLayoutControls(UiSidebarLayoutScope.of(context)),
              ),
            ),
            header: Builder(
              builder: (context) => headerBuilder(
                context,
                _UiDashboardLayoutControls(UiSidebarLayoutScope.of(context)),
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
          }) => UiSidebar<T>(
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
          }) => UiIconButton.ghost(
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
          }) => UiTextField.surface(
            key: key,
            size: .size2,
            hintText: hintText,
            leading: leading,
            onChanged: onChanged,
          ),
    );
  }
}

final class _UiDashboardLayoutControls implements UiDashboardLayoutControls {
  const _UiDashboardLayoutControls(this.scope);

  final UiSidebarLayoutScope scope;

  @override
  bool get isCompact => scope.isCompact;

  @override
  void closeCompact() => scope.closeCompact();

  @override
  void openCompact() => scope.openCompact();
}
