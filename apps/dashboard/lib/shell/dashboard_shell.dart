import 'package:flutter/widgets.dart';
import '../ui/ui.dart';

import '../pages/charts_page.dart';
import '../pages/chat_page.dart';
import '../pages/customers_page.dart';
import '../pages/gallery/gallery_actions_page.dart';
import '../pages/gallery/gallery_display_page.dart';
import '../pages/gallery/gallery_forms_page.dart';
import '../pages/gallery/gallery_navigation_page.dart';
import '../pages/gallery/gallery_overlays_page.dart';
import '../pages/gallery/gallery_typography_page.dart';
import '../pages/orders_page.dart';
import '../pages/overview_page.dart';
import '../pages/settings_page.dart';
import 'dashboard_page.dart';
import 'sidebar.dart';
import 'sidebar_sections.dart';
import 'top_bar.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  DashboardPage _selected = .overview;
  String _searchQuery = '';
  bool _sidebarCollapsed = false;
  // The sidebar layout reparents its body when crossing the compact breakpoint.
  // Keep page state (including an active conversation) through that move.
  final _pageStackKey = GlobalKey();

  void _select(DashboardPage page) => setState(() => _selected = page);

  @override
  Widget build(BuildContext context) {
    // IndexedStack is keyed by DashboardPage.index, so this list must stay in
    // enum order.
    final pages = <Widget>[
      OverviewPage(onViewOrders: () => _select(.orders)),
      const ChatPage(),
      CustomersPage(globalQuery: _searchQuery),
      OrdersPage(globalQuery: _searchQuery),
      const SettingsPage(),
      const ChartsPage(),
      const GalleryActionsPage(),
      const GalleryFormsPage(),
      const GalleryDisplayPage(),
      const GalleryOverlaysPage(),
      const GalleryNavigationPage(),
      const GalleryTypographyPage(),
    ];

    return UiDashboardShell<DashboardPage>(
      sections: dashboardSidebarSections,
      selectedValue: _selected,
      onSelected: _select,
      title: _selected.label,
      brand: const DashboardBrand(),
      account: const DashboardSidebarAccount(),
      headerActions: const [TopBar()],
      onSearchChanged: (value) =>
          setState(() => _searchQuery = value.trim().toLowerCase()),
      collapsed: _sidebarCollapsed,
      onCollapsedChanged: (value) => setState(() => _sidebarCollapsed = value),
      body: IndexedStack(
        key: _pageStackKey,
        index: _selected.index,
        children: pages,
      ),
    );
  }
}
