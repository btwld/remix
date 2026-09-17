import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/src/agent/components/answer.dart';
import 'package:registry_source/src/agent/components/composer.dart';
import 'package:registry_source/src/agent/components/permission.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_base.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_charts.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_records.dart';
import 'package:registry_source/src/dashboard/dashboard_sample_data.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/default/theme/theme_data.dart';
import 'package:registry_source/src/default/theme/theme_scope.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:remix/remix.dart';

enum _Preset { defaultPreset, fortal }

void main() {
  test('shared parity contract matches the Fortal reference inventory', () {
    expect(RegistryDashboardDemoPage.values.map((page) => page.name), [
      'overview',
      'chat',
      'customers',
      'orders',
      'settings',
      'charts',
      'actions',
      'forms',
      'dataDisplay',
      'overlays',
      'navigation',
      'typography',
    ]);
    expect(
      registryDashboardDemoSectionIds.keys,
      RegistryDashboardDemoPage.values,
    );
    expect(registryDashboardDemoSectionIds.values, everyElement(isNotEmpty));
    expect(RegistryDashboardChartCase.values, hasLength(12));
    expect(RegistryDashboardChartCase.values.map((chart) => chart.title), [
      'Revenue momentum',
      'Per-series patterns',
      'Steps and gaps',
      'Viewport labels',
      'Actual versus plan',
      'Revenue mix',
      'Floating changes',
      'Tracks and labels',
      'Traffic channels',
      'Interactive product mix',
      'Badge markers',
      'Safe empty state',
    ]);
    expect(registryDashboardCustomers, hasLength(24));
    expect(registryDashboardOrders, hasLength(30));
    expect(registryDashboardDemoInteractionIds, hasLength(7));
  });

  for (final preset in _Preset.values) {
    group(preset.name, () {
      testWidgets('overview renders coherent sample data', (tester) async {
        await _pumpOverview(tester, preset: preset, width: 1280);

        expect(find.text(r'$84,420'), findsOneWidget);
        expect(find.text('Mon'), findsWidgets);
        expect(find.text('ORD-1048'), findsOneWidget);
        expect(find.text('Avery Stone'), findsOneWidget);
        expect(find.byType(LineChart), findsOneWidget);
        expect(
          find.byType(RemixDataTable<RegistryDashboardRecord>),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('overview uses caller-owned data', (tester) async {
        const data = RegistryDashboardSampleData(
          metrics: [
            RegistryDashboardMetric(
              label: 'Retained metric',
              value: '17',
              change: 'Edited locally',
            ),
          ],
          revenue: [RegistryDashboardPoint(label: 'Now', value: 17)],
          records: [
            RegistryDashboardRecord(
              id: 'LOCAL-1',
              customer: 'Local customer',
              status: 'Ready',
              amount: r'$17',
            ),
          ],
        );
        await _pumpOverview(tester, preset: preset, width: 760, data: data);

        expect(find.text('Retained metric'), findsOneWidget);
        expect(find.text('LOCAL-1'), findsOneWidget);
        expect(find.text('ORD-1048'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('narrow enlarged layout scrolls without overflow', (
        tester,
      ) async {
        await _pumpOverview(
          tester,
          preset: preset,
          width: 390,
          height: 520,
          textScaler: const TextScaler.linear(1.8),
        );

        expect(
          find.byKey(const ValueKey('dashboard-overview-scroll')),
          findsOneWidget,
        );
        expect(find.text('Revenue trend'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('compact demo chrome fits a 375 pixel viewport', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset, width: 375, height: 812);

        expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('full demo exposes and navigates all showcase destinations', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);

        for (final label in [
          'Overview',
          'Chat',
          'Customers',
          'Orders',
          'Settings',
          'Charts',
          'Actions',
          'Forms & Inputs',
          'Data Display',
          'Overlays',
          'Navigation',
          'Typography',
        ]) {
          expect(find.text(label), findsWidgets, reason: label);
        }

        await tester.tap(find.text('Chat').first);
        await tester.pump();

        expect(find.text('Agent chat'), findsOneWidget);
        expect(find.text('Ask the demo agent…'), findsOneWidget);
        expect(find.text('Acme starter'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('built-in chrome is functional and independently optional', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);
        expect(find.byKey(const ValueKey('dashboard-search')), findsWidgets);
        expect(
          find.byKey(const ValueKey('dashboard-appearance-toggle')),
          findsWidgets,
        );
        expect(find.text('Northstar workspace'), findsOneWidget);

        await tester.tap(
          find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
        );
        await tester.pump();
        expect(find.bySemanticsLabel('Use light appearance'), findsOneWidget);

        await tester.tap(find.bySemanticsLabel('Notifications').first);
        await tester.pump();
        expect(find.text('Order ORD-1047 requires review.'), findsOneWidget);
        await tester.tap(find.bySemanticsLabel('Notifications').first);
        await tester.pump();

        await _pumpDashboard(
          tester,
          preset: preset,
          builtInChrome: false,
          account: const Text('Caller account'),
        );
        expect(find.byKey(const ValueKey('dashboard-search')), findsNothing);
        expect(
          find.byKey(const ValueKey('dashboard-appearance-toggle')),
          findsNothing,
        );
        expect(find.text('Caller account'), findsOneWidget);
        expect(find.text('Northstar workspace'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('all twelve screens expose the shared section inventory', (
        tester,
      ) async {
        const expected = <RegistryDashboardDemoPage, List<String>>{
          RegistryDashboardDemoPage.overview: [
            'Revenue trend',
            'Recent activity',
            'Recent orders',
          ],
          RegistryDashboardDemoPage.chat: ['Agent chat', 'Interactive demo'],
          RegistryDashboardDemoPage.customers: [
            'Customers',
            'Search customers…',
            'Email',
          ],
          RegistryDashboardDemoPage.orders: ['Orders', 'Paid', 'ORD-1048'],
          RegistryDashboardDemoPage.settings: [
            'Profile',
            'Preferences',
            'Appearance',
            'Danger zone',
          ],
          RegistryDashboardDemoPage.charts: [
            'Revenue momentum',
            'Interactive product mix',
            'Safe empty state',
          ],
          RegistryDashboardDemoPage.actions: [
            'Button',
            'Icon button',
            'Toggle',
            'States',
          ],
          RegistryDashboardDemoPage.forms: [
            'Text field',
            'Text area',
            'Checkbox group',
            'Slider',
          ],
          RegistryDashboardDemoPage.dataDisplay: [
            'Avatar',
            'Data list',
            'Skeleton',
            'Divider',
          ],
          RegistryDashboardDemoPage.overlays: [
            'Dialog',
            'Popover',
            'Tooltip',
            'Menu',
          ],
          RegistryDashboardDemoPage.navigation: [
            'Sidebar',
            'Tabs',
            'Disclosure',
            'Accordion',
          ],
          RegistryDashboardDemoPage.typography: [
            'Text scale',
            'Heading level and size',
            'Keyboard keys',
            'Wrapping and truncation',
          ],
        };

        for (final entry in expected.entries) {
          await _pumpDashboard(tester, preset: preset, initialPage: entry.key);
          for (final label in entry.value) {
            expect(
              find.text(label),
              findsWidgets,
              reason: '${entry.key.name}: $label',
            );
          }
          expect(tester.takeException(), isNull, reason: entry.key.name);
        }
      });

      testWidgets('customer state survives navigation', (tester) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.customers,
        );
        await tester.enterText(
          find.byKey(const ValueKey('customer-search')),
          'Olivia',
        );
        await tester.pump();
        expect(find.text('Olivia Martin'), findsOneWidget);
        expect(find.text('Jackson Lee'), findsNothing);

        await tester.tap(find.text('Orders').first);
        await tester.pump();
        await tester.tap(find.text('Customers').first);
        await tester.pump();

        expect(find.text('Olivia Martin'), findsOneWidget);
        expect(find.text('Jackson Lee'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('tables expose full controlled interaction contracts', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.customers,
        );
        var customers = tester
            .widget<RemixDataTable<RegistryDashboardCustomer>>(
              find.byType(RemixDataTable<RegistryDashboardCustomer>),
            );
        expect(customers.columns.map((column) => column.id), [
          'name',
          'email',
          'plan',
          'status',
          'joined',
          'actions',
        ]);
        expect(customers.totalRows, 24);
        expect(customers.rows, hasLength(10));
        expect(customers.onSortChanged, isNotNull);
        expect(customers.onSelectionChanged, isNotNull);
        expect(customers.onPageChanged, isNotNull);
        expect(customers.onPageSizeChanged, isNotNull);

        customers.onSelectionChanged!({customers.rows.first.id});
        await tester.pump();
        expect(find.text('1 selected'), findsOneWidget);

        customers = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardCustomer>),
        );
        customers.onPageChanged!(1);
        await tester.pump();
        customers = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardCustomer>),
        );
        expect(customers.pageIndex, 1);
        expect(customers.rows, hasLength(10));

        await tester.tap(find.text('Orders').first);
        await tester.pump();
        var orders = tester.widget<RemixDataTable<RegistryDashboardOrder>>(
          find.byType(RemixDataTable<RegistryDashboardOrder>),
        );
        expect(orders.columns.map((column) => column.id), [
          'id',
          'customer',
          'date',
          'amount',
          'status',
          'actions',
        ]);
        expect(orders.totalRows, 30);
        orders.onSortChanged!(
          const RemixDataTableSort(
            columnId: 'amount',
            direction: RemixDataTableSortDirection.ascending,
          ),
        );
        await tester.pump();
        orders = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardOrder>),
        );
        expect(orders.sort?.columnId, 'amount');
        expect(
          orders.rows.first.amount,
          lessThanOrEqualTo(orders.rows.last.amount),
        );

        await tester.tap(find.text('Pending').last);
        await tester.pump();
        orders = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardOrder>),
        );
        expect(
          orders.rows,
          everyElement(
            isA<RegistryDashboardOrder>().having(
              (order) => order.status,
              'status',
              RegistryDashboardOrderStatus.pending,
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('Agent success, permission, stop, and retry are local', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.chat,
          chatStepDelay: const Duration(milliseconds: 10),
        );

        await tester.tap(find.text('Review checkout'));
        for (var frame = 0; frame < 5; frame++) {
          await tester.pump(const Duration(milliseconds: 11));
        }
        expect(find.textContaining('ready for review'), findsWidgets);
        expect(
          tester.widget<AgentAnswer>(find.byType(AgentAnswer)).onCopy,
          isNotNull,
        );

        await tester.tap(find.text('New chat'));
        await tester.pump();
        await tester.tap(find.text('Run terminal checks'));
        await tester.pump(const Duration(milliseconds: 12));
        final permission = tester.widget<AgentPermission>(
          find.byType(AgentPermission),
        );
        expect(permission.onAllowOnce, isNotNull);
        expect(permission.onAlwaysAllow, isNotNull);
        expect(permission.onDeny, isNotNull);
        permission.onAllowOnce!();
        await tester.pump(const Duration(milliseconds: 12));
        final composer = tester.widget<AgentComposer>(
          find.byType(AgentComposer),
        );
        expect(composer.running, isTrue);
        expect(composer.onStop, isNotNull);
        composer.onStop!();
        await tester.pump();
        expect(
          tester.widget<AgentComposer>(find.byType(AgentComposer)).running,
          isFalse,
        );
        expect(
          tester.widget<AgentAnswer>(find.byType(AgentAnswer)).onRetry,
          isNotNull,
        );
        expect(tester.takeException(), isNull);
      });
    });
  }

  test('dashboard_demo starter sources remain independent of Material', () {
    final lib = Directory('lib').existsSync() ? 'lib' : 'registry_source/lib';
    final paths = Directory('$lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              (file.path.contains('dashboard_demo') ||
                  file.path.contains('dashboard_overview')),
        )
        .map((file) => file.path)
        .toList();
    expect(paths, isNotEmpty);
    for (final path in paths) {
      expect(
        File(path).readAsStringSync(),
        isNot(contains('package:flutter/material.dart')),
        reason: path,
      );
    }
  });
}

Future<void> _pumpOverview(
  WidgetTester tester, {
  required _Preset preset,
  required double width,
  double height = 800,
  TextScaler textScaler = TextScaler.noScaling,
  RegistryDashboardSampleData data = registryDashboardSampleData,
}) async {
  final overview = switch (preset) {
    .defaultPreset => VanillaDashboardOverview(data: data),
    .fortal => FortalDashboardOverview(data: data),
  };
  await _pump(
    tester,
    preset: preset,
    width: width,
    height: height,
    textScaler: textScaler,
    child: overview,
  );
}

Future<void> _pumpDashboard(
  WidgetTester tester, {
  required _Preset preset,
  RegistryDashboardDemoPage initialPage = RegistryDashboardDemoPage.overview,
  Duration chatStepDelay = const Duration(milliseconds: 320),
  bool builtInChrome = true,
  Widget? account,
  double width = 1200,
  double height = 800,
}) => _pump(
  tester,
  preset: preset,
  width: width,
  height: height,
  child: switch (preset) {
    .defaultPreset => VanillaDashboardDemo(
      key: ValueKey(initialPage),
      brand: const Text('Acme starter'),
      initialPage: initialPage,
      chatStepDelay: chatStepDelay,
      builtInChrome: builtInChrome,
      account: account,
    ),
    .fortal => FortalDashboardDemo(
      key: ValueKey(initialPage),
      brand: const Text('Acme starter'),
      initialPage: initialPage,
      chatStepDelay: chatStepDelay,
      builtInChrome: builtInChrome,
      account: account,
    ),
  },
);

Future<void> _pump(
  WidgetTester tester, {
  required _Preset preset,
  required double width,
  required double height,
  required Widget child,
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final app = WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Directionality(textDirection: TextDirection.ltr, child: child!),
    ),
    home: SizedBox(width: width, height: height, child: child),
  );

  await tester.pumpWidget(switch (preset) {
    .defaultPreset => VanillaThemeScope(
      data: const VanillaThemeData.light(),
      child: app,
    ),
    .fortal => FortalScope(child: app),
  });
  await tester.pump();
}
