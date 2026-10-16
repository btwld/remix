import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_shell_base.dart';
import '../../components/app_bar.dart';
import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/sidebar_layout.dart';
import '../../components/textfield.dart';
import '../../theme/theme.dart';

/// A dashboard shell styled with the Fortal preset.
///
/// The host manages navigation values and page state. Provide [onSearchChanged]
/// to display the search field.
class FortalDashboardShell<T extends Object> extends StatelessWidget {
  const FortalDashboardShell({
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
        .height(FortalTokens.space9())
        .alignment(AlignmentDirectional.centerStart)
        .padding(.horizontal(FortalTokens.space2()))
        .color(FortalTokens.colorPanelSolid())
        .border(
          .bottom(
            .color(FortalTokens.grayA6()).width(FortalTokens.borderWidth1()),
          ),
        );
    return RegistryDashboardShellBase<T>(
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
            style: SidebarStyler().footer(
              BoxStyler().border(
                .top(
                  .color(FortalTokens.gray6()).width(
                    (collapsed
                        ? _footerBorderWidthCollapsed
                        : _footerBorderWidthExpanded)(),
                  ),
                ),
              ),
            ),
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
          }) => FortalAppBar(
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
            semanticLabel: hintText,
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

double _resolveFooterBorderWidth(
  BuildContext context, {
  required bool collapsed,
}) {
  final expansion =
      RemixSidebar.maybeAnimationOf(context)?.expansion ??
      (collapsed ? 0.0 : 1.0);
  return expansion > 0 ? FortalTokens.borderWidth1.resolve(context) : 0.0;
}

double _resolveFooterBorderWidthExpanded(BuildContext context) =>
    _resolveFooterBorderWidth(context, collapsed: false);

double _resolveFooterBorderWidthCollapsed(BuildContext context) =>
    _resolveFooterBorderWidth(context, collapsed: true);

const _footerBorderWidthExpanded = ContextToken<double>(
  _resolveFooterBorderWidthExpanded,
);

const _footerBorderWidthCollapsed = ContextToken<double>(
  _resolveFooterBorderWidthCollapsed,
);
