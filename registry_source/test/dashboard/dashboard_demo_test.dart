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
import 'package:remix/src/utilities/remix_path_icon.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

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
            'Toast',
          ],
          RegistryDashboardDemoPage.navigation: [
            'App bar',
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

        final mixWarnings = <String>[];
        final originalDebugPrint = debugPrint;
        debugPrint = (String? message, {int? wrapWidth}) {
          if (message != null && message.contains('Mix: could not convert')) {
            mixWarnings.add(message);
          }
        };
        try {
          for (final entry in expected.entries) {
            await _pumpDashboard(
              tester,
              preset: preset,
              initialPage: entry.key,
            );
            for (final label in entry.value) {
              expect(
                find.text(label),
                findsWidgets,
                reason: '${entry.key.name}: $label',
              );
            }
            expect(tester.takeException(), isNull, reason: entry.key.name);
            expect(mixWarnings, isEmpty, reason: entry.key.name);
          }
        } finally {
          debugPrint = originalDebugPrint;
        }
      });

      testWidgets(
        'sidebar collapse and expand animate across 16ms frames without overflow or Mix warnings',
        (tester) async {
          final mixWarnings = <String>[];
          final originalDebugPrint = debugPrint;
          debugPrint = (String? message, {int? wrapWidth}) {
            if (message != null && message.contains('Mix: could not convert')) {
              mixWarnings.add(message);
            }
          };
          try {
            await _pumpDashboard(tester, preset: preset);
            expect(mixWarnings, isEmpty);

            await tester.tap(
              find.byKey(const ValueKey('dashboard-collapse')).first,
            );
            for (var frame = 0; frame < 16; frame++) {
              await tester.pump(const Duration(milliseconds: 16));
              expect(
                tester.takeException(),
                isNull,
                reason: 'collapse frame $frame',
              );
              expect(mixWarnings, isEmpty, reason: 'collapse frame $frame');
            }

            await tester.tap(
              find.byKey(const ValueKey('dashboard-collapse')).first,
            );
            for (var frame = 0; frame < 16; frame++) {
              await tester.pump(const Duration(milliseconds: 16));
              expect(
                tester.takeException(),
                isNull,
                reason: 'expand frame $frame',
              );
              expect(mixWarnings, isEmpty, reason: 'expand frame $frame');
            }
          } finally {
            debugPrint = originalDebugPrint;
          }
        },
      );

      // mix_chart draws each slice 80px wide whatever box it is given, so a
      // donut whose hole plus ring outgrows half its box is clipped.
      testWidgets('value axis end labels sit on their gridlines', (
        tester,
      ) async {
        await _pumpOverview(tester, preset: preset, width: 1280);

        // The revenue axis labels 0 to 100 in steps of 20. On their
        // gridlines they are evenly spaced; an end label pulled in off its
        // value shortens the gap beside it.
        final centers = [
          for (final label in const ['100', '80', '60', '40', '20', '0'])
            tester.getCenter(find.text(label).first).dy,
        ];
        final gaps = [
          for (var i = 1; i < centers.length; i++) centers[i] - centers[i - 1],
        ];
        for (final gap in gaps) {
          expect(gap, closeTo(gaps[2], 1), reason: 'gaps: $gaps');
        }
      });

      testWidgets('every pie fits inside its chart box', (tester) async {
        await _pumpOverview(tester, preset: preset, width: 1280);
        final overviewPies = _expectPiesFit(tester);

        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.charts,
          height: 4000,
        );
        final chartsPies = _expectPiesFit(tester);

        expect(overviewPies + chartsPies, 5);
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

      testWidgets('global search finds component galleries by section id', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);

        await tester.enterText(
          find.descendant(
            of: find.byKey(const ValueKey('dashboard-search')),
            matching: find.byType(EditableText),
          ),
          'toast',
        );
        await tester.pump();

        expect(find.text('Show toast'), findsOneWidget);
        expect(find.text('Show action toast'), findsOneWidget);
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

        await tester.tap(find.text('Pending').first);
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

      testWidgets(
        'Select, Checkbox, CheckboxGroup, and Disclosure work in Forms and Settings',
        (tester) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.forms,
            height: 3000,
          );

          final formsSelect = find
              .byKey(
                ValueKey(
                  preset == .defaultPreset
                      ? 'vanilla-gallery-select'
                      : 'select-surface-size2',
                ),
              )
              .first;
          expect(_isRotatedPi(tester, _selectIndicator(formsSelect)), isFalse);
          expect(
            find.descendant(of: formsSelect, matching: find.text('Apple')),
            findsOneWidget,
          );

          await tester.tap(formsSelect);
          await tester.pumpAndSettle();
          expect(_isRotatedPi(tester, _selectIndicator(formsSelect)), isTrue);
          expect(_pathGlyph(RemixPathGlyph.thickCheck), findsWidgets);

          await tester.tap(find.text('Orange').last);
          await tester.pumpAndSettle();
          expect(_isRotatedPi(tester, _selectIndicator(formsSelect)), isFalse);
          expect(
            find.descendant(of: formsSelect, matching: find.text('Orange')),
            findsOneWidget,
          );

          final firstCheckbox = find.byType(RemixCheckbox).first;
          expect(
            _glyphIn(firstCheckbox, RemixPathGlyph.thickCheck),
            findsOneWidget,
          );
          await tester.tap(firstCheckbox);
          await tester.pumpAndSettle();
          expect(
            _glyphIn(firstCheckbox, RemixPathGlyph.thickCheck),
            findsNothing,
          );

          final checkboxGroup = find.byType(RemixCheckboxGroup<String>);
          expect(
            _glyphIn(checkboxGroup, RemixPathGlyph.thickCheck),
            findsOneWidget,
          );
          await tester.tap(find.text('SMS'));
          await tester.pumpAndSettle();
          expect(
            _glyphIn(checkboxGroup, RemixPathGlyph.thickCheck),
            findsNWidgets(2),
          );

          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.settings,
            height: 2000,
          );

          final langSelect = find.byType(RemixSelect<String>).first;
          expect(_isRotatedPi(tester, _selectIndicator(langSelect)), isFalse);
          await tester.tap(langSelect);
          await tester.pumpAndSettle();
          expect(_isRotatedPi(tester, _selectIndicator(langSelect)), isTrue);
          await tester.tap(find.text('Spanish').last);
          await tester.pumpAndSettle();
          expect(
            find.descendant(of: langSelect, matching: find.text('Spanish')),
            findsOneWidget,
          );

          final digestCheckbox = find.byType(RemixCheckbox).first;
          expect(
            _glyphIn(digestCheckbox, RemixPathGlyph.thickCheck),
            findsNothing,
          );
          await tester.tap(digestCheckbox);
          await tester.pumpAndSettle();
          expect(
            _glyphIn(digestCheckbox, RemixPathGlyph.thickCheck),
            findsOneWidget,
          );

          final dangerZone = find.byKey(const ValueKey('settings-danger-zone'));
          final dangerChevron = find.descendant(
            of: dangerZone,
            matching: find.byIcon(RemixIcons.chevronDown),
          );
          expect(find.text('Delete workspace'), findsNothing);
          expect(_isRotatedPi(tester, dangerChevron), isFalse);

          await tester.tap(find.text('Danger zone'));
          await tester.pumpAndSettle();
          expect(find.text('Delete workspace'), findsOneWidget);
          expect(_isRotatedPi(tester, dangerChevron), isTrue);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'Disclosure, Accordion, and Menu interactions update icons and indicators',
        (tester) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.navigation,
            height: 2200,
          );

          final disclosure = find.byType(RemixDisclosure).first;
          final disclosureChevron = find.descendant(
            of: disclosure,
            matching: find.byIcon(RemixIcons.chevronDown),
          );
          expect(_isRotatedPi(tester, disclosureChevron), isTrue);
          await tester.tap(find.text('Shipping details').first);
          await tester.pumpAndSettle();
          expect(_isRotatedPi(tester, disclosureChevron), isFalse);
          await tester.tap(find.text('Shipping details').first);
          await tester.pumpAndSettle();
          expect(_isRotatedPi(tester, disclosureChevron), isTrue);

          final accordions = find.byType(RemixAccordion<String>);
          final itemA = accordions.at(0);
          final itemB = accordions.at(1);
          final chevronA = find.descendant(
            of: itemA,
            matching: find.byIcon(RemixIcons.chevronDown),
          );
          final chevronB = find.descendant(
            of: itemB,
            matching: find.byIcon(RemixIcons.chevronDown),
          );
          expect(_isRotatedPi(tester, chevronA), isTrue);
          expect(_isRotatedPi(tester, chevronB), isFalse);

          await tester.tap(find.text('Does it support tokens?').first);
          await tester.pumpAndSettle();
          expect(_isRotatedPi(tester, chevronA), isFalse);
          expect(_isRotatedPi(tester, chevronB), isTrue);

          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.overlays,
            height: 2200,
          );
          await tester.tap(find.text('Open menu').first);
          await tester.pumpAndSettle();

          expect(find.text('Show archived'), findsOneWidget);
          expect(find.text('Newest'), findsOneWidget);
          expect(find.text('Share'), findsOneWidget);
          expect(_pathGlyph(RemixPathGlyph.thickChevronRight), findsOneWidget);
          expect(_pathGlyph(RemixPathGlyph.thickCheck), findsWidgets);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'DataTable sort carets, tri-state selection checkboxes, and pager buttons work',
        (tester) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.customers,
            height: 1200,
          );

          final table = find.byType(RemixDataTable<RegistryDashboardCustomer>);
          expect(_glyphIn(table, RemixPathGlyph.caretDown), findsOneWidget);
          expect(_glyphIn(table, RemixPathGlyph.caretSort), findsOneWidget);

          await tester.tap(
            find.descendant(of: table, matching: find.text('Customer')),
          );
          await tester.pumpAndSettle();
          expect(_glyphIn(table, RemixPathGlyph.caretUp), findsOneWidget);
          expect(_glyphIn(table, RemixPathGlyph.caretSort), findsOneWidget);

          await tester.tap(
            find.descendant(of: table, matching: find.text('Customer')),
          );
          await tester.pumpAndSettle();
          expect(_glyphIn(table, RemixPathGlyph.caretDown), findsOneWidget);
          expect(_glyphIn(table, RemixPathGlyph.caretSort), findsOneWidget);

          final checkboxes = find.descendant(
            of: table,
            matching: find.byType(RemixCheckbox),
          );
          final headerCheckbox = checkboxes.first;
          final firstRowCheckbox = checkboxes.at(1);

          await tester.tap(firstRowCheckbox);
          await tester.pumpAndSettle();
          expect(find.text('1 selected'), findsOneWidget);
          expect(
            _glyphIn(headerCheckbox, RemixPathGlyph.thickDividerHorizontal),
            findsOneWidget,
          );

          await tester.tap(headerCheckbox);
          await tester.pumpAndSettle();
          expect(find.text('10 selected'), findsOneWidget);
          expect(
            _glyphIn(headerCheckbox, RemixPathGlyph.thickCheck),
            findsOneWidget,
          );

          expect(find.text('1–10 of 24'), findsOneWidget);
          await tester.tap(
            find.descendant(
              of: table,
              matching: _pathGlyph(RemixPathGlyph.chevronRight),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('11–20 of 24'), findsOneWidget);

          await tester.tap(
            find.descendant(
              of: table,
              matching: _pathGlyph(RemixPathGlyph.chevronLeft),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('1–10 of 24'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
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

/// Checks that the outermost edge of every pie on screen, with a selected
/// slice pulled out, stays inside the box the pie is laid out in, and returns
/// how many pies it checked.
int _expectPiesFit(WidgetTester tester) {
  // The adapter is private to mix_chart; it is where the resolved spec lands.
  final adapters = find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == 'FlPieChartAdapter',
  );

  for (final element in adapters.evaluate()) {
    final spec = (element.widget as dynamic).spec as PieChartSpec;
    final outer =
        (spec.centerRadius ?? 0) +
        (spec.slice?.spec.radius ?? 80) +
        (spec.selectedSliceRadiusOffset ?? 8);
    final box = (element.renderObject! as RenderBox).size;

    expect(
      outer,
      lessThanOrEqualTo(box.shortestSide / 2),
      reason: 'a pie reaching $outer px in a $box box',
    );
  }

  return adapters.evaluate().length;
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
    .defaultPreset => VanillaTheme(mode: VanillaThemeMode.light, child: app),
    .fortal => FortalTheme(child: app),
  });
  await tester.pump();
}

Finder _pathGlyph(RemixPathGlyph glyph) => find.byWidgetPredicate(
  (widget) => widget is RemixPathIcon && widget.glyph == glyph,
);

Finder _glyphIn(Finder ancestor, RemixPathGlyph glyph) =>
    find.descendant(of: ancestor, matching: _pathGlyph(glyph));

Finder _selectIndicator(Finder select) => find.descendant(
  of: select,
  matching: find.byKey(const ValueKey('remix-select-indicator')),
);

bool _isRotatedPi(WidgetTester tester, Finder target) {
  final transforms = tester.widgetList<Transform>(
    find.ancestor(of: target, matching: find.byType(Transform)),
  );
  return transforms.any((t) => (t.transform.storage[0] + 1.0).abs() < 0.01);
}
