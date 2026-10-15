import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/app_bar.dart';
import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/sidebar_layout.dart';
import '../../components/textfield.dart';
import '../../theme/theme.dart';
import 'dashboard_shell_base.dart';

/// A dashboard shell styled with the Ui preset.
///
/// The host manages navigation values and page state. Provide [onSearchChanged]
/// to display the search field.
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
    // The brand row lines up with the app bar beside it: the same toolbar
    // height, surface, and bottom edge as the `app_bar` recipe.
    final sidebarHeaderStyle = BoxStyler()
        .height(UiTokens.space9())
        .alignment(AlignmentDirectional.centerStart)
        .padding(.horizontal(UiTokens.space2()))
        .color(UiTokens.colorPanelSolid())
        .border(
          .bottom(.color(UiTokens.grayA6()).width(UiTokens.borderWidth1())),
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
      menuIcon: RemixIcons.hamburgerMenu,
      searchIcon: RemixIcons.magnifyingGlass,
      backwardIcon: RemixIcons.doubleArrowLeft,
      forwardIcon: RemixIcons.doubleArrowRight,
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
            header: header,
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            footer: footer,
            semanticLabel: semanticLabel,
          ),
      appBarBuilder:
          (
            context, {
            required leading,
            required title,
            required titleChild,
            required actions,
          }) => UiAppBar(
            leading: leading,
            title: title,
            titleChild: titleChild,
            actions: actions,
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
            semanticLabel: hintText,
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
