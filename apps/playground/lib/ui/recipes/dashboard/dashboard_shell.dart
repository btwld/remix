import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/app_bar.dart';
import '../../components/icon_button.dart';
import '../../components/sidebar.dart';
import '../../components/sidebar_layout.dart';
import '../../components/textfield.dart';
import '../../theme/tokens.dart';
import 'dashboard_shell_base.dart';

/// A dashboard shell styled with the Playground preset.
///
/// The host manages navigation values and page state. Provide [onSearchChanged]
/// to display the search field.
class PlaygroundDashboardShell<T extends Object> extends StatelessWidget {
  const PlaygroundDashboardShell({
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
    // height, surface, and bottom hairline as the `app_bar` recipe.
    final sidebarHeaderStyle = BoxStyler()
        .height(playgroundAppBarToolbarHeight)
        .alignment(AlignmentDirectional.centerStart)
        .padding(.horizontal(PlaygroundTokens.s3))
        .color(PlaygroundTokens.background())
        .border(
          .bottom(
            .color(
              PlaygroundTokens.border(),
            ).width(PlaygroundTokens.strokeHairline),
          ),
        );
    return PlaygroundDashboardShellBase<T>(
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
            style: _sidebarMotionStyle(
              context,
              collapsed: collapsed,
              collapsedWidth: collapsedWidth,
            ),
            collapsed: collapsed,
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
          }) => PlaygroundAppBar(
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
            semanticLabel: hintText,
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

SidebarStyler _sidebarMotionStyle(
  BuildContext context, {
  required bool collapsed,
  required double collapsedWidth,
}) {
  final leftPadding = collapsedWidth == 72
      ? (collapsed
            ? _destinationLeftPaddingCollapsed
            : _destinationLeftPaddingExpanded)
      : ContextToken<double>(
          (context) => _resolveDestinationPadding(
            context,
            collapsed: collapsed,
            collapsedWidth: collapsedWidth,
            left: true,
          ),
        );
  final rightPadding = collapsedWidth == 72
      ? (collapsed
            ? _destinationRightPaddingCollapsed
            : _destinationRightPaddingExpanded)
      : ContextToken<double>(
          (context) => _resolveDestinationPadding(
            context,
            collapsed: collapsed,
            collapsedWidth: collapsedWidth,
            left: false,
          ),
        );
  final footerVerticalPadding = collapsed
      ? _footerVerticalPaddingCollapsed
      : _footerVerticalPaddingExpanded;
  final footerBorderWidth = collapsed
      ? _footerBorderWidthCollapsed
      : _footerBorderWidthExpanded;

  return SidebarStyler()
      .padding(EdgeInsetsGeometryMix.value(MediaQuery.paddingOf(context)))
      .destination(
        ToggleStyler().padding(
          .only(
            left: leftPadding(),
            right: rightPadding(),
            top: PlaygroundTokens.s1_5,
            bottom: PlaygroundTokens.s1_5,
          ),
        ),
      )
      .footer(
        BoxStyler()
            .border(
              .top(
                .color(
                  PlaygroundTokens.sidebarBorder(),
                ).width(footerBorderWidth()),
              ),
            )
            .padding(
              .symmetric(
                horizontal: PlaygroundTokens.s2,
                vertical: footerVerticalPadding(),
              ),
            ),
      );
}

double _resolveDestinationPadding(
  BuildContext context, {
  required bool collapsed,
  required double collapsedWidth,
  required bool left,
}) {
  final leading = (Directionality.of(context) == TextDirection.ltr) == left;
  if (!leading) return PlaygroundTokens.s2;
  final expansion =
      RemixSidebar.maybeAnimationOf(context)?.expansion ??
      (collapsed ? 0.0 : 1.0);
  final railLeading = math.max(
    PlaygroundTokens.s2,
    (collapsedWidth - PlaygroundTokens.s2 * 2 - PlaygroundTokens.iconSm) / 2,
  );
  return railLeading + (PlaygroundTokens.s2 - railLeading) * expansion;
}

double _resolveDestinationLeftPaddingExpanded(BuildContext context) =>
    _resolveDestinationPadding(
      context,
      collapsed: false,
      collapsedWidth: 72,
      left: true,
    );

double _resolveDestinationLeftPaddingCollapsed(BuildContext context) =>
    _resolveDestinationPadding(
      context,
      collapsed: true,
      collapsedWidth: 72,
      left: true,
    );

double _resolveDestinationRightPaddingExpanded(BuildContext context) =>
    _resolveDestinationPadding(
      context,
      collapsed: false,
      collapsedWidth: 72,
      left: false,
    );

double _resolveDestinationRightPaddingCollapsed(BuildContext context) =>
    _resolveDestinationPadding(
      context,
      collapsed: true,
      collapsedWidth: 72,
      left: false,
    );

double _resolveFooterVerticalPadding(
  BuildContext context, {
  required bool collapsed,
}) {
  final expansion =
      RemixSidebar.maybeAnimationOf(context)?.expansion ??
      (collapsed ? 0.0 : 1.0);
  return PlaygroundTokens.s2 * expansion;
}

double _resolveFooterVerticalPaddingExpanded(BuildContext context) =>
    _resolveFooterVerticalPadding(context, collapsed: false);

double _resolveFooterVerticalPaddingCollapsed(BuildContext context) =>
    _resolveFooterVerticalPadding(context, collapsed: true);

double _resolveFooterBorderWidth(
  BuildContext context, {
  required bool collapsed,
}) {
  final expansion =
      RemixSidebar.maybeAnimationOf(context)?.expansion ??
      (collapsed ? 0.0 : 1.0);
  return expansion > 0 ? PlaygroundTokens.strokeHairline : 0.0;
}

double _resolveFooterBorderWidthExpanded(BuildContext context) =>
    _resolveFooterBorderWidth(context, collapsed: false);

double _resolveFooterBorderWidthCollapsed(BuildContext context) =>
    _resolveFooterBorderWidth(context, collapsed: true);

const _destinationLeftPaddingExpanded = ContextToken<double>(
  _resolveDestinationLeftPaddingExpanded,
);

const _destinationLeftPaddingCollapsed = ContextToken<double>(
  _resolveDestinationLeftPaddingCollapsed,
);

const _destinationRightPaddingExpanded = ContextToken<double>(
  _resolveDestinationRightPaddingExpanded,
);

const _destinationRightPaddingCollapsed = ContextToken<double>(
  _resolveDestinationRightPaddingCollapsed,
);

const _footerVerticalPaddingExpanded = ContextToken<double>(
  _resolveFooterVerticalPaddingExpanded,
);

const _footerVerticalPaddingCollapsed = ContextToken<double>(
  _resolveFooterVerticalPaddingCollapsed,
);

const _footerBorderWidthExpanded = ContextToken<double>(
  _resolveFooterBorderWidthExpanded,
);

const _footerBorderWidthCollapsed = ContextToken<double>(
  _resolveFooterBorderWidthCollapsed,
);
