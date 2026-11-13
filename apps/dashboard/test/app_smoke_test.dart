import 'dart:ui' as ui;

import 'package:dashboard/main.dart';
import 'package:dashboard/ui/ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

/// Whether the shell's compact navigation sheet is currently open.
///
/// `UiDashboardTopBar` sits inside `UiSidebarLayout`'s `header` slot in both the
/// wide and compact presentations, so its element is always a descendant of
/// the scope the layout re-provides — unlike `UiDashboardDemo`'s own element,
/// which sits above the layout it returns.
bool _isCompactSheetOpen(WidgetTester tester) => UiSidebarLayoutScope.of(
  tester.element(find.byType(UiDashboardTopBar)),
).isCompactOpen;

/// The page transition fades the entering page in over 200ms and keeps it out
/// of the semantics tree until it has opacity, so tests pump past it.
const _pageEntered = Duration(milliseconds: 250);

/// Taps a sidebar destination and lets the entering page finish its fade.
Future<void> _openPage(WidgetTester tester, UiDashboardDemoPage page) async {
  final nav = find.byKey(ValueKey(page)).first;
  await tester.ensureVisible(nav);
  await tester.tap(nav);
  await tester.pump();
  await tester.pump(_pageEntered);
}

/// Opens a Settings tab. Settings is `RemixTabs`: Profile, Notifications,
/// Appearance and Plan.
Future<void> _openSettingsTab(WidgetTester tester, String name) async {
  final tab = find.byKey(ValueKey('settings-tab-$name')).first;
  await tester.ensureVisible(tab);
  await tester.tap(tab);
  await tester.pump();
  await tester.pump(_pageEntered);
}

/// The active page's root, for finders that must not match a page kept
/// mounted behind it.
Finder _inPage(UiDashboardDemoPage page, Finder matching) => find.descendant(
  of: find.byKey(ValueKey('dashboard-page-${page.name}')),
  matching: matching,
);

void main() {
  testWidgets('renders the dashboard inside one app and one shell', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());

    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(UiSidebarLayout), findsOneWidget);
    expect(find.byKey(const ValueKey('dashboard-theme-scope')), findsOneWidget);
    expect(find.text('Overview'), findsWidgets);
  });

  testWidgets('uses a mark and the Northstar brand', (tester) async {
    await tester.pumpWidget(const DashboardApp());

    final app = tester.widget<WidgetsApp>(find.byType(WidgetsApp));
    expect(app.title, 'Northstar');

    final brand = find.byKey(const ValueKey('dashboard-brand'));
    expect(brand, findsOneWidget);
    expect(
      find.descendant(of: brand, matching: find.text('Northstar')),
      findsOneWidget,
    );
    // The mark is painted from boxes, not an icon glyph.
    expect(
      find.descendant(of: brand, matching: find.byType(Icon)),
      findsNothing,
    );
  });

  testWidgets('account surfaces preserve their avatar and profile triggers', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());

    final sidebar = find.byKey(const ValueKey('sidebar-account-trigger'));
    final topBar = find.byKey(const ValueKey('topbar-account-trigger'));
    expect(sidebar, findsOneWidget);
    expect(topBar, findsOneWidget);
    expect(tester.getSize(topBar).width, lessThanOrEqualTo(48));
    expect(find.text('Account actions'), findsNothing);

    await tester.tap(sidebar);
    await tester.pump();

    expect(find.text('View profile'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('customer rows retain compact kebab actions', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.customers);

    final trigger = find.byKey(const ValueKey('customer-actions-cus_024'));
    expect(trigger, findsOneWidget);
    expect(tester.getSize(trigger).width, lessThanOrEqualTo(46));

    await tester.ensureVisible(trigger);
    await tester.tap(trigger);
    await tester.pump();

    expect(find.text('View profile'), findsOneWidget);
    expect(find.text('Send email'), findsOneWidget);
    expect(find.text('Archive'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('order rows retain compact kebab actions', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.orders);

    final trigger = find.byKey(const ValueKey('order-actions-ORD-1048'));
    expect(trigger, findsOneWidget);
    expect(tester.getSize(trigger).width, lessThanOrEqualTo(46));

    await tester.ensureVisible(trigger);
    await tester.tap(trigger);
    await tester.pump();

    expect(find.text('View order'), findsOneWidget);
    expect(find.text('Download receipt'), findsOneWidget);
    expect(find.text('Issue refund'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact layout uses a sheet without rendering overflows', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());

    expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(_isCompactSheetOpen(tester), isTrue);

    await tester.tap(
      find.byKey(const ValueKey(UiDashboardDemoPage.settings)).first,
    );
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(
      find.text('Your profile, your notifications and how it all looks.'),
      findsOneWidget,
    );
    expect(_isCompactSheetOpen(tester), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact sheet exposes one dashboard navigation name', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.bySemanticsLabel('Dashboard navigation'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('compact selection restores focus to the menu trigger', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    final menuTrigger = find.semantics.byLabel('Open navigation');
    ui.Tristate menuFocusState() => menuTrigger
        .evaluate()
        .single
        .getSemanticsData()
        .flagsCollection
        .isFocused;
    expect(menuFocusState(), ui.Tristate.isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(_isCompactSheetOpen(tester), isTrue);

    await tester.tap(
      find.byKey(const ValueKey(UiDashboardDemoPage.settings)).first,
    );
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(_isCompactSheetOpen(tester), isFalse);
    expect(menuFocusState(), ui.Tristate.isTrue);
    semantics.dispose();
  });

  testWidgets('compact settings render without horizontal overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    await tester.tap(
      find.byKey(const ValueKey(UiDashboardDemoPage.settings)).first,
    );
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await _openSettingsTab(tester, 'appearance');

    expect(find.byKey(const ValueKey('theme-panel')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sidebar destinations expose one accessible name', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const DashboardApp());

    final overviewSemantics = find
        .descendant(
          of: find.byKey(const ValueKey(UiDashboardDemoPage.overview)).first,
          matching: find.byType(Semantics),
        )
        .first;
    final overviewNode = tester.getSemantics(overviewSemantics);
    expect(overviewNode.label, 'Overview');

    // A destination is one of a mutually exclusive set, so it must announce
    // `selected` — not the toggled on/off state RemixToggle emits by default.
    final data = overviewNode.getSemanticsData();
    expect(data.hasAction(ui.SemanticsAction.tap), isTrue);
    expect(data.flagsCollection.isSelected, ui.Tristate.isTrue);
    expect(data.flagsCollection.isToggled, ui.Tristate.none);
    expect(data.flagsCollection.isFocused, ui.Tristate.isFalse);

    for (var tabs = 0; tabs < 20; tabs++) {
      if (tester
              .getSemantics(overviewSemantics)
              .getSemanticsData()
              .flagsCollection
              .isFocused ==
          ui.Tristate.isTrue) {
        break;
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }

    expect(
      tester
          .getSemantics(overviewSemantics)
          .getSemanticsData()
          .flagsCollection
          .isFocused,
      ui.Tristate.isTrue,
    );

    final customersSemantics = find
        .descendant(
          of: find.byKey(const ValueKey(UiDashboardDemoPage.customers)).first,
          matching: find.byType(Semantics),
        )
        .first;
    final customersNode = tester.getSemantics(customersSemantics);
    customersNode.owner!.performAction(
      customersNode.id,
      ui.SemanticsAction.tap,
    );
    await tester.pump();

    expect(
      tester
          .getSemantics(customersSemantics)
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      ui.Tristate.isTrue,
    );
    expect(
      tester
          .getSemantics(overviewSemantics)
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      ui.Tristate.isFalse,
    );
    semantics.dispose();
  });

  testWidgets('customers page renders an interactive paginated grid', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());

    await _openPage(tester, UiDashboardDemoPage.customers);

    // UiDataTable forwards the key to the Remix widget it builds, so the
    // key matches both.
    expect(find.byKey(const ValueKey('data-grid-customers')), findsWidgets);
    expect(find.text('1–10 of 24'), findsOneWidget);
  });

  testWidgets(
    'overview presents metrics, charts, activity, and recent orders',
    (tester) async {
      await tester.pumpWidget(const DashboardApp());

      // The lead card totals the week's revenue (in thousands of dollars).
      // UiText forwards its key to the widget it builds, so it matches twice.
      expect(
        find.byKey(const ValueKey('overview-revenue-total')),
        findsWidgets,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('overview-revenue')),
          matching: find.text('\$84.4K'),
        ),
        findsOneWidget,
      );
      expect(find.text('Sales by channel'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('dashboard-revenue-chart')),
        findsWidgets,
      );
      expect(find.byType(UiLineChart), findsOneWidget);
      expect(find.byType(PieChart), findsOneWidget);
      expect(
        find.byKey(const ValueKey('overview-channel-chart')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('overview-channel-legend')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('dashboard-metrics')), findsOneWidget);
      expect(find.text('Activity'), findsOneWidget);
      expect(find.text('Recent orders'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('dashboard-records-table')),
        findsWidgets,
      );
      // "View all" opens the collection from Top editions and the orders
      // page from Recent orders.
      expect(find.text('View all'), findsNWidgets(2));
    },
  );

  testWidgets('a status reads the same on every page that shows it', (
    tester,
  ) async {
    // ORD-1045 is refunded and appears in the overview's six-row preview, so
    // an overview-local status mapping would disagree with the orders page.
    await tester.pumpWidget(const DashboardApp());
    Finder inTable(String key, String text) => find.descendant(
      of: find.byKey(ValueKey(key)),
      matching: find.text(text),
    );
    expect(inTable('dashboard-records-table', 'ORD-1045'), findsOneWidget);
    expect(inTable('dashboard-records-table', 'Refunded'), findsOneWidget);

    await _openPage(tester, UiDashboardDemoPage.orders);

    // The filter and the summary offer "Refunded" too, so scope to the table.
    expect(inTable('data-grid-orders', 'ORD-1045'), findsOneWidget);
    expect(inTable('data-grid-orders', 'Refunded'), findsOneWidget);
  });

  testWidgets('settings exposes every live Fortal theme parameter', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());

    await _openPage(tester, UiDashboardDemoPage.settings);
    await _openSettingsTab(tester, 'appearance');

    final panel = find.byKey(const ValueKey('theme-panel'));
    expect(panel, findsOneWidget);
    for (final control in const [
      'Appearance',
      'Theme',
      'Panel background',
      'Radius',
      'Scaling',
    ]) {
      expect(
        find.descendant(of: panel, matching: find.text(control)),
        findsOneWidget,
        reason: control,
      );
    }
  });

  testWidgets('the panel background control reaches the Fortal scope', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.settings);
    await _openSettingsTab(tester, 'appearance');

    final translucent = find.text('Translucent');
    await tester.ensureVisible(translucent);
    await tester.tap(translucent);
    await tester.pump();

    expect(
      UiTheme.of(tester.element(find.byType(UiDashboardDemo))).panelBackground,
      UiPanelBackground.translucent,
    );
  });

  testWidgets('dashboard action menus expose menu semantics and width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const DashboardApp());
    await tester.tap(find.byKey(const ValueKey('sidebar-account-trigger')));
    await tester.pump();

    expect(
      tester.getSemantics(find.text('View profile')).getSemanticsData().role,
      ui.SemanticsRole.menuItem,
    );
    expect(
      find.byKey(const ValueKey('dashboard-action-profile')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('dashboard-action-preferences')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('dashboard-action-signout')),
      findsOneWidget,
    );
    expect(
      tester.getTopLeft(find.text('View profile')).dy,
      lessThan(tester.getTopLeft(find.text('Preferences')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Preferences')).dy,
      lessThan(tester.getTopLeft(find.text('Sign out')).dy),
    );

    final panel = find
        .ancestor(
          of: find.text('View profile'),
          matching: find.byType(ColumnBox),
        )
        .first;
    final divider = find.descendant(
      of: panel,
      matching: find.byType(RemixDivider),
    );
    expect(divider, findsOneWidget);
    final dividerY = tester.getCenter(divider).dy;
    expect(
      dividerY,
      greaterThan(tester.getTopLeft(find.text('Preferences')).dy),
    );
    expect(dividerY, lessThan(tester.getTopLeft(find.text('Sign out')).dy));

    final overlay = find
        .ancestor(
          of: find
              .ancestor(
                of: find.text('View profile'),
                matching: find.byType(ColumnBox),
              )
              .first,
          matching: find.byType(Box),
        )
        .first;
    expect(tester.getSize(overlay).width, 180);
    expect(tester.getSize(overlay).height, lessThan(180));
    final contentInset = UiTokens.space1.resolve(
      tester.element(find.text('View profile')),
    );
    expect(
      tester
          .getSize(find.byKey(const ValueKey('dashboard-action-profile')))
          .width,
      180 - contentInset * 2,
    );

    await tester.tap(find.text('View profile'));
    await tester.pump();

    expect(find.text('View profile'), findsNothing);
    expect(find.text('Profile opened'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('notification popover shrink-wraps its activity', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await tester.tap(find.byIcon(RemixIcons.bell));
    await tester.pump();

    final content = find.byKey(const ValueKey('topbar-notifications-content'));
    expect(content, findsOneWidget);
    expect(tester.getSize(content).width, 330);
    expect(tester.getSize(content).height, lessThan(300));
  });

  testWidgets('settings confirmation dialog is centered', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.settings);

    final dangerZone = find.byKey(const ValueKey('settings-danger-zone'));
    await tester.ensureVisible(dangerZone.first);
    await tester.tap(find.text('Danger zone'));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    final trigger = find.text('Delete workspace');
    await tester.ensureVisible(trigger);
    await tester.tap(trigger);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    final rect = _dialogSurfaceRect(tester);
    expect(rect.height, lessThan(240));
    expect(rect.center.dx, closeTo(700, 0.01));
    expect(rect.center.dy, closeTo(_dialogCenterY, 0.01));
  });

  testWidgets('every sidebar destination renders without replacing the shell', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());
    final shell = tester.element(find.byType(UiDashboardDemo));

    // Each destination's own root, and a line only that page shows. Chat has
    // no page header: its composer is the proof.
    final destinations = <UiDashboardDemoPage, (Finder, Finder)>{
      .overview: (
        find.byKey(const ValueKey('dashboard-overview')),
        find.text('How the studio is doing, as of a moment ago.'),
      ),
      .analytics: (
        find.byKey(const ValueKey('dashboard-analytics')),
        find.text('Where revenue comes from and how each edition sells.'),
      ),
      .schedule: (
        find.byKey(const ValueKey('dashboard-schedule')),
        find.byKey(const ValueKey('schedule-calendar')),
      ),
      .chat: (find.byType(UiDashboardChatPage), find.byType(AgentComposer)),
      .collection: (
        find.byKey(const ValueKey('dashboard-collection')),
        find.byKey(const ValueKey('collection-spotlight')),
      ),
      .customers: (
        find.byKey(const ValueKey('dashboard-customers')),
        find.byKey(const ValueKey('data-grid-customers')),
      ),
      .orders: (
        find.byKey(const ValueKey('dashboard-orders')),
        find.byKey(const ValueKey('data-grid-orders')),
      ),
      .themes: (
        find.byKey(const ValueKey('dashboard-themes')),
        find.byKey(const ValueKey('themes-palettes')),
      ),
      .settings: (
        find.byKey(const ValueKey('dashboard-settings')),
        find.text('Your profile, your notifications and how it all looks.'),
      ),
    };
    expect(destinations.keys, UiDashboardDemoPage.values);

    for (final entry in destinations.entries) {
      await _openPage(tester, entry.key);
      final (root, marker) = entry.value;

      // The shell, the app and the theme scope are the ones mounted at the
      // start: a destination swaps the page, not the shell.
      expect(
        find.byType(UiDashboardDemo),
        findsOneWidget,
        reason: '${entry.key}',
      );
      expect(
        tester.element(find.byType(UiDashboardDemo)),
        same(shell),
        reason: '${entry.key}',
      );
      expect(find.byType(WidgetsApp), findsOneWidget);
      expect(find.byType(UiSidebarLayout), findsOneWidget);
      expect(root, findsOneWidget, reason: '${entry.key}');
      expect(marker, findsWidgets, reason: '${entry.key}');
      expect(
        tester
            .getRect(find.byKey(ValueKey('dashboard-page-${entry.key.name}')))
            .isEmpty,
        isFalse,
        reason: '${entry.key}',
      );
      expect(tester.takeException(), isNull, reason: '${entry.key}');
    }
  });

  testWidgets(
    'quick toggle changes Fortal brightness without a Material host',
    (tester) async {
      await tester.pumpWidget(const DashboardApp());
      final shell = tester.element(find.byType(UiDashboardDemo));

      final before = UiTheme.of(shell).isDark;

      await tester.tap(find.byKey(const ValueKey('theme-quick-toggle')).first);
      await tester.pump();

      final updatedShell = tester.element(find.byType(UiDashboardDemo));
      expect(UiTheme.of(updatedShell).isDark, isNot(before));
    },
  );

  testWidgets(
    'system appearance follows the platform and resumes after reset',
    (tester) async {
      final platform = tester.binding.platformDispatcher;
      addTearDown(platform.clearPlatformBrightnessTestValue);
      platform.platformBrightnessTestValue = Brightness.light;
      await tester.pumpWidget(const DashboardApp());

      bool isDark() =>
          UiTheme.of(tester.element(find.byType(UiDashboardDemo))).isDark;
      expect(isDark(), isFalse);

      platform.platformBrightnessTestValue = Brightness.dark;
      await tester.pump();
      expect(isDark(), isTrue);

      await tester.tap(find.byKey(const ValueKey('theme-quick-toggle')).first);
      await tester.pump();
      expect(isDark(), isFalse);
      platform.platformBrightnessTestValue = Brightness.light;
      await tester.pump();
      platform.platformBrightnessTestValue = Brightness.dark;
      await tester.pump();
      expect(isDark(), isFalse);

      await _openPage(tester, UiDashboardDemoPage.settings);
      await _openSettingsTab(tester, 'appearance');
      final reset = find.byKey(const ValueKey('theme-reset')).first;
      await tester.ensureVisible(reset);
      await tester.tap(reset);
      await tester.pump();
      expect(isDark(), isTrue);
      platform.platformBrightnessTestValue = Brightness.light;
      await tester.pump();
      expect(isDark(), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('supports an explicit dark initial theme', (tester) async {
    await tester.pumpWidget(
      const DashboardApp(initialSettings: UiThemeSettings(appearance: .dark)),
    );

    final shell = tester.element(find.byType(UiDashboardDemo));
    expect(UiTheme.of(shell).isDark, isTrue);
  });

  testWidgets('theme panel changes the resolved accent live', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.settings);
    await _openSettingsTab(tester, 'appearance');

    final serra = find.byKey(const ValueKey('accent-serra'));
    await tester.ensureVisible(serra);
    await tester.tap(serra);
    await tester.pump();

    final shell = tester.element(find.byType(UiDashboardDemo));
    expect(UiTheme.of(shell).accent, UiAccentColor.serra);
  });

  testWidgets('theme swatch centers its selected checkmark', (tester) async {
    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.settings);
    await _openSettingsTab(tester, 'appearance');

    final swatch = find.byKey(const ValueKey('accent-orla'));
    final toggle = find.descendant(
      of: swatch,
      matching: find.byType(RemixToggle),
    );
    final check = find.descendant(
      of: swatch,
      matching: find.byIcon(RemixIcons.check),
    );

    expect(tester.getCenter(check), tester.getCenter(toggle));
  });

  testWidgets('top bar icon buttons stay square while hovered and open', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    final topBar = find.byType(UiDashboardTopBar);
    final surfaces = find.descendant(
      of: topBar,
      matching: find.byKey(const ValueKey('remix-icon-button-surface')),
    );
    // Appearance, notifications, theme panel, and the account menu; the
    // collapse control lives in the sidebar header.
    expect(surfaces, findsNWidgets(4));

    void expectSquareSurfaces() {
      for (final surface in surfaces.evaluate()) {
        final size = tester.getSize(
          find.byElementPredicate((element) => element == surface),
        );
        expect(size.width, size.height);
      }
    }

    expectSquareSurfaces();
    final notifications = find.byIcon(RemixIcons.bell);
    final mouse = await tester.createGesture(kind: ui.PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: tester.getCenter(notifications));
    await tester.pump();
    expectSquareSurfaces();

    await tester.tap(notifications);
    await tester.pump();
    expectSquareSurfaces();
  });

  testWidgets('grid sorts, selects the page, and paginates', (tester) async {
    // The summary cards push the table below the fold of the default window;
    // a tall one keeps the header and pager under the pointer.
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.customers);

    // Overview keeps its own "Customer" column mounted behind this page.
    final sortName = _inPage(.customers, find.text('Customer')).first;
    await tester.tap(sortName);
    await tester.pump();
    // Ascending by name: Sofia Young is past the first ten.
    expect(_inPage(.customers, find.text('Sofia Young')), findsNothing);
    await tester.tap(sortName);
    await tester.pump();
    expect(_inPage(.customers, find.text('Sofia Young')), findsOneWidget);

    final selectAll = _inPage(
      .customers,
      find.byKey(const ValueKey('remix-data-table-select-all')),
    ).first;
    await tester.tap(selectAll);
    await tester.pump();
    expect(find.text('10 selected'), findsOneWidget);

    final next = _inPage(
      .customers,
      find.byKey(const ValueKey('remix-data-table-next-page')),
    ).first;
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pump();
    expect(find.text('11–20 of 24'), findsOneWidget);
  });

  testWidgets('grid checkboxes fill their cell around a 14 square', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await _openPage(tester, UiDashboardDemoPage.customers);

    final selectAll = find
        .byKey(const ValueKey('remix-data-table-select-all'))
        .first;
    // The header checkbox comes first, so the next one belongs to row one.
    final rowCheckbox = find.byType(RemixCheckbox).at(1);

    // The interaction target fills the scale-aligned 48px selection cell;
    // the compact painted checkbox stays 14px square.
    expect(tester.getSize(selectAll), const Size(48, 48));
    expect(tester.getSize(rowCheckbox), const Size(48, 48));
    expect(
      tester.getSize(
        find
            .descendant(of: selectAll, matching: find.byType(DecoratedBox))
            .first,
      ),
      const Size.square(14),
    );
    expect(
      tester.getSize(
        find
            .descendant(of: rowCheckbox, matching: find.byType(DecoratedBox))
            .first,
      ),
      const Size.square(14),
    );
  });

  testWidgets('page and section titles publish one heading tree', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const DashboardApp());

    // The page title is level 1 and every card section under it is level 2,
    // independent of the visual size each one picks.
    final title = tester.getSemantics(
      find.descendant(
        of: find.byType(UiPageHeader),
        matching: find.text('Overview'),
      ),
    );
    expect(title.getSemanticsData().flagsCollection.isHeader, isTrue);
    expect(title.getSemanticsData().headingLevel, 1);

    for (final section in const ['Revenue', 'Recent orders', 'Activity']) {
      final node = tester.getSemantics(find.text(section));
      expect(
        node.getSemanticsData().flagsCollection.isHeader,
        isTrue,
        reason: section,
      );
      expect(node.getSemanticsData().headingLevel, 2, reason: section);
    }
    semantics.dispose();
  });

  testWidgets(
    'dashboard-owned strong text follows light and dark neutral roles',
    (tester) async {
      await tester.pumpWidget(const DashboardApp());

      // Both titles are Fortal typography, which resolves `gray12` from the
      // active scope's tokens rather than from any inherited `DefaultTextStyle`.
      // That is what makes them repaint when the appearance changes, and it is
      // why the assertion reads the painted colour rather than the widget's.
      final pageTitle = find.descendant(
        of: find.byType(UiPageHeader),
        matching: find.text('Overview'),
      );
      final activityTitle = find.text('Payment received');
      Color painted(Finder finder) =>
          tester.renderObject<RenderParagraph>(finder).text.style!.color!;
      Color gray12() => MixScope.tokenOf(
        UiTokens.gray12,
        tester.element(find.byType(UiDashboardDemo)),
      );

      final light = gray12();
      expect(painted(pageTitle), light);
      expect(painted(activityTitle), light);

      final themeScope = tester.widget<UiDashboardThemeScope>(
        // The application's scope. Each kept page holds one below it.
        find.byType(UiDashboardThemeScope).first,
      );
      themeScope.onChanged(
        themeScope.settings.copyWith(appearance: UiThemeMode.dark),
      );
      await tester.pump();

      final dark = gray12();
      expect(dark, isNot(light));
      expect(painted(pageTitle), dark);
      expect(painted(activityTitle), dark);
    },
  );

  testWidgets('compact sheet sidebar text follows the gray theme too', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const DashboardApp());
    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    final brand = find.descendant(
      of: find.byKey(const ValueKey('dashboard-brand')),
      matching: find.text('Northstar'),
    );
    expect(
      tester.renderObject<RenderParagraph>(brand).text.style!.color,
      MixScope.tokenOf(
        UiTokens.gray12,
        tester.element(find.byType(UiDashboardDemo)),
      ),
    );
  });

  testWidgets(
    'quick find jumps to the chosen record and fills that page\'s search',
    (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const DashboardApp());

      // UiCombobox forwards its key to the Remix widget it builds.
      final search = find.byKey(const ValueKey('dashboard-search')).first;
      expect(search, findsOneWidget);
      await tester.enterText(
        find.descendant(of: search, matching: find.byType(EditableText)),
        'olivia',
      );
      await tester.pump();

      // The only match is the customer; choosing it opens Customers with the
      // name in that page's own search field.
      // The option's detail line is unique; the name also sits in Recent
      // orders on the Overview behind it.
      final option = find.text('Customer · Lisbon');
      expect(option, findsOneWidget);
      await tester.tap(option);
      await tester.pump();
      await tester.pump(_pageEntered);

      final page = find.byKey(const ValueKey('dashboard-page-customers'));
      expect(page, findsOneWidget);
      final field = find.descendant(
        of: find.byKey(const ValueKey('customer-search')),
        matching: find.byType(EditableText),
      );
      expect(
        tester.widget<EditableText>(field).controller.text,
        'Olivia Martin',
      );
      expect(_inPage(.customers, find.text('1–1 of 1')), findsOneWidget);
      expect(
        _inPage(.customers, find.text('olivia@northstar.co')),
        findsOneWidget,
      );

      // The quick-find field clears, ready for the next search.
      expect(
        tester
            .widget<EditableText>(
              find.descendant(of: search, matching: find.byType(EditableText)),
            )
            .controller
            .text,
        isEmpty,
      );
    },
  );

  testWidgets('quick find lists pages and opens the chosen one', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const DashboardApp());

    await tester.enterText(
      find.descendant(
        of: find.byKey(const ValueKey('dashboard-search')).first,
        matching: find.byType(EditableText),
      ),
      'analyt',
    );
    await tester.pump();
    final option = find.text('Analytics');
    expect(find.text('Page'), findsOneWidget);
    await tester.tap(option.last);
    await tester.pump();
    await tester.pump(_pageEntered);

    expect(
      find.byKey(const ValueKey('dashboard-page-analytics')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('dashboard-analytics')).hitTestable(),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('dashboard-overview')).hitTestable(),
      findsNothing,
    );
  });
}

/// The bounds of the dialog panel itself.
///
/// `UiDialog` wraps its surface in padding and align modifiers that carry
/// the safe viewport insets, so the widget's own rect is the whole viewport.
/// The panel is the align's child, which is what the size and centring
/// assertions are about.
Rect _dialogSurfaceRect(WidgetTester tester) {
  final align = find.descendant(
    of: find.byType(RemixDialog),
    matching: find.byType(Align),
  );
  final surface = tester.widget<Align>(align.first).child!;

  return tester.getRect(find.byWidget(surface));
}

/// Where a centred dialog panel actually sits vertically.
///
/// The dialog centres inside its safe padded viewport, not the raw one. The
/// bottom inset is `viewportHeight * 0.06` (54 at this height) while the top is
/// `space6` (32), so the panel rides 11 logical pixels above the true centre.
const _dialogCenterY = 439.0;
