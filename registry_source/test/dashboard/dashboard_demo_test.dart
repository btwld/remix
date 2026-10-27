import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/src/agent/components/answer.dart';
import 'package:registry_source/src/agent/components/composer.dart';
import 'package:registry_source/src/agent/components/permission.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_base.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_records.dart';
import 'package:registry_source/src/dashboard/dashboard_sample_data.dart';
import 'package:registry_source/src/default/components/icon_button.dart';
import 'package:registry_source/src/default/components/menu.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/default/theme/theme_data.dart';
import 'package:registry_source/src/default/theme/theme_scope.dart';
import 'package:registry_source/src/default/theme/tokens.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

enum _Preset { defaultPreset, fortal }

void main() {
  test('shared parity contract matches the Fortal reference inventory', () {
    expect(RegistryDashboardDemoPage.values.map((page) => page.name), [
      'overview',
      'chat',
      'customers',
      'orders',
      'settings',
    ]);
    expect(
      registryDashboardDemoSectionIds.keys,
      RegistryDashboardDemoPage.values,
    );
    expect(registryDashboardDemoSectionIds.values, everyElement(isNotEmpty));
    expect(registryDashboardCustomers, hasLength(24));
    expect(registryDashboardOrders, hasLength(30));
  });

  testWidgets('alert notification uses the sample event title', (tester) async {
    await _pumpDashboard(tester, preset: .fortal);
    await tester.tap(find.bySemanticsLabel('Notifications').first);
    await tester.pump();

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('topbar-notifications-content')),
        matching: find.text('Inventory alert'),
      ),
      findsOneWidget,
    );
    expect(find.text('Order ORD-1047 requires review.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an order row opens its actions from a real icon button', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pumpDashboard(
      tester,
      preset: .defaultPreset,
      initialPage: RegistryDashboardDemoPage.orders,
    );
    const label = 'Actions for ORD-1048';
    final button = find.byWidgetPredicate(
      (widget) => widget is VanillaIconButton && widget.semanticLabel == label,
    );
    expect(button, findsOneWidget);
    final menu = find.ancestor(
      of: button,
      matching: find.byType(VanillaMenu<String>),
    );

    expect(find.semantics.byLabel(label), findsOne);
    expect(_focusStops(tester, menu), 1);
    expect(
      tester.getSemantics(button),
      isSemantics(
        label: label,
        isButton: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
        hasExpandedState: true,
        isExpanded: false,
      ),
    );

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Archive'), findsOneWidget);
    expect(
      tester.getSemantics(button),
      isSemantics(label: label, hasExpandedState: true, isExpanded: true),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Archive'), findsNothing);
    expect(
      tester.getSemantics(button),
      isSemantics(label: label, isFocused: true),
    );
    semantics.dispose();
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

      testWidgets('full demo exposes and navigates all real destinations', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);

        for (final label in [
          'Overview',
          'Chat',
          'Customers',
          'Orders',
          'Settings',
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
        expect(
          find.text(switch (preset) {
            .defaultPreset => 'Order ORD-1047 requires review.',
            .fortal => 'Inventory alert',
          }),
          findsWidgets,
        );
        if (preset == .fortal) {
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('topbar-notifications-content')),
              matching: find.text('Inventory alert'),
            ),
            findsOneWidget,
          );
          expect(find.text('Order ORD-1047 requires review.'), findsNothing);
        }
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

      testWidgets('all five screens expose the shared section inventory', (
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
        'sidebar collapse and expand animate across frames without overflow, jumps, or Mix warnings',
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

            final collapseButton = find
                .byKey(const ValueKey('dashboard-collapse'))
                .first;

            await tester.tap(collapseButton);
            await tester.pump();
            double previousButtonDx = tester.getCenter(collapseButton).dx;
            for (var frame = 0; frame < 24; frame++) {
              await tester.pump(const Duration(milliseconds: 10));
              expect(
                tester.takeException(),
                isNull,
                reason: 'collapse frame $frame',
              );
              expect(mixWarnings, isEmpty, reason: 'collapse frame $frame');
              final currentButtonDx = tester.getCenter(collapseButton).dx;
              final step = previousButtonDx - currentButtonDx;
              expect(
                currentButtonDx,
                lessThanOrEqualTo(previousButtonDx + 0.5),
                reason: 'collapse button should move monotonically left',
              );
              expect(
                step,
                lessThanOrEqualTo(frame >= 19 ? 4.0 : 20.0),
                reason: 'collapse frame $frame should not jump',
              );
              previousButtonDx = currentButtonDx;
            }

            await tester.tap(collapseButton);
            await tester.pump();
            previousButtonDx = tester.getCenter(collapseButton).dx;
            for (var frame = 0; frame < 24; frame++) {
              await tester.pump(const Duration(milliseconds: 10));
              expect(
                tester.takeException(),
                isNull,
                reason: 'expand frame $frame',
              );
              expect(mixWarnings, isEmpty, reason: 'expand frame $frame');
              final currentButtonDx = tester.getCenter(collapseButton).dx;
              final step = currentButtonDx - previousButtonDx;
              expect(
                currentButtonDx,
                greaterThanOrEqualTo(previousButtonDx - 0.5),
                reason: 'collapse button should move monotonically right',
              );
              expect(
                step,
                lessThanOrEqualTo(frame >= 19 ? 4.0 : 20.0),
                reason: 'expand frame $frame should not jump',
              );
              previousButtonDx = currentButtonDx;
            }
          } finally {
            debugPrint = originalDebugPrint;
          }
        },
      );

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

      // mix_chart draws each slice 80px wide whatever box it is given, so a
      // donut whose hole plus ring outgrows half its box is clipped.
      testWidgets('every pie fits inside its chart box', (tester) async {
        await _pumpOverview(tester, preset: preset, width: 1280);
        final overviewPies = _expectPiesFit(tester);

        expect(overviewPies, greaterThan(0));
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

      testWidgets('global search finds real screens by section id', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);

        await tester.enterText(
          find.descendant(
            of: find.byKey(const ValueKey('dashboard-search')),
            matching: find.byType(EditableText),
          ),
          'profile',
        );
        await tester.pump();

        expect(find.text('Settings'), findsWidgets);
        expect(find.text('Profile'), findsWidgets);
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

      testWidgets(
        'Settings Select, Checkbox, and Danger zone Disclosure work',
        (tester) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.settings,
          );

          final select = find.byType(RemixSelect<String>);
          expect(_glyphIn(select, RemixPathGlyph.chevronDown), findsOneWidget);
          expect(_transformAngleIn(tester, select), closeTo(0, 0.01));

          await tester.tap(select);
          await tester.pumpAndSettle();
          expect(_transformAngleIn(tester, select), closeTo(math.pi, 0.01));
          expect(_pathGlyph(RemixPathGlyph.thickCheck), findsOneWidget);

          await tester.tap(find.text('Spanish').last);
          await tester.pumpAndSettle();
          expect(
            find.descendant(of: select, matching: find.text('Spanish')),
            findsOneWidget,
          );
          expect(_transformAngleIn(tester, select), closeTo(0, 0.01));

          final checkbox = find.byType(RemixCheckbox);
          expect(_glyphIn(checkbox, RemixPathGlyph.thickCheck), findsNothing);
          await tester.ensureVisible(checkbox);
          await tester.tap(checkbox);
          await tester.pumpAndSettle();
          expect(_glyphIn(checkbox, RemixPathGlyph.thickCheck), findsOneWidget);

          final dangerZone = find
              .byKey(const ValueKey('settings-danger-zone'))
              .first;
          expect(find.text('Delete workspace'), findsNothing);
          expect(_transformAngleIn(tester, dangerZone), closeTo(0, 0.01));

          await tester.ensureVisible(dangerZone);
          await tester.tap(find.text('Danger zone'));
          await tester.pumpAndSettle();
          expect(find.text('Delete workspace'), findsOneWidget);
          expect(_transformAngleIn(tester, dangerZone), closeTo(math.pi, 0.01));
          expect(tester.takeException(), isNull);
        },
      );
    });
  }

  testWidgets('settings radius keeps a host\'s custom dark theme', (
    tester,
  ) async {
    const customBackground = Color(0xFF123456);
    await _pumpDashboard(
      tester,
      preset: .defaultPreset,
      initialPage: RegistryDashboardDemoPage.settings,
      darkTheme: const VanillaThemeData.dark().copyWith(
        background: customBackground,
      ),
    );

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pumpAndSettle();

    expect(
      MixScope.tokenOf(
        VanillaTokens.background,
        tester.element(find.textContaining('Control radius')),
      ),
      customBackground,
    );
  });

  testWidgets('settings radius slider changes the resolved radius', (
    tester,
  ) async {
    await _pumpDashboard(
      tester,
      preset: .defaultPreset,
      initialPage: RegistryDashboardDemoPage.settings,
    );

    Radius radiusOf(RadiusToken token) => MixScope.tokenOf(
      token,
      tester.element(find.textContaining('Control radius')),
    );

    final before = radiusOf(VanillaTokens.radiusLg);
    expect(before, const Radius.circular(10));
    expect(find.text('Control radius · 10px'), findsOneWidget);

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();

    final after = radiusOf(VanillaTokens.radiusLg);
    expect(after.x, greaterThan(before.x));
    expect(radiusOf(VanillaTokens.radiusMd).x, closeTo(after.x - 2, 0.001));
    expect(find.text('Control radius · 10px'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pumpAndSettle();
    expect(
      MixScope.tokenOf(
        VanillaTokens.background,
        tester.element(find.textContaining('Control radius')),
      ),
      const Color(0xFF0A0A0A),
    );
    expect(radiusOf(VanillaTokens.radiusLg), after);

    await tester.tap(find.bySemanticsLabel('Theme settings'));
    await tester.pumpAndSettle();
    expect(find.text('Theme settings'), findsOneWidget);
    expect(find.text('Accent color'), findsNothing);
    expect(find.text('Density'), findsNothing);
    expect(find.text('Comfortable'), findsNothing);
    expect(find.text('Neutral'), findsNothing);
    expect(find.text('Light'), findsWidgets);
    expect(find.text('Dark'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

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
  VanillaThemeData? darkTheme,
}) => _pump(
  tester,
  preset: preset,
  width: width,
  height: height,
  darkTheme: darkTheme,
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
  VanillaThemeData? darkTheme,
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
    .defaultPreset => VanillaTheme(
      mode: VanillaThemeMode.light,
      darkTheme: darkTheme,
      child: app,
    ),
    .fortal => FortalTheme(child: app),
  });
  await tester.pump();
}

Finder _pathGlyph(RemixPathGlyph glyph) => find.byWidgetPredicate(
  (widget) => widget is RemixPathIcon && widget.glyph == glyph,
);

Finder _glyphIn(Finder ancestor, RemixPathGlyph glyph) =>
    find.descendant(of: ancestor, matching: _pathGlyph(glyph));

double _transformAngleIn(WidgetTester tester, Finder ancestor) {
  final transform = tester.widget<Transform>(
    find.descendant(of: ancestor, matching: find.byType(Transform)).first,
  );
  return math
      .atan2(transform.transform.entry(1, 0), transform.transform.entry(0, 0))
      .abs();
}

/// How many focus stops sit inside [root].
int _focusStops(WidgetTester tester, Finder root) {
  final rootElement = tester.element(root);

  return FocusManager.instance.rootScope.traversalDescendants.where((node) {
    var inside = false;
    node.context?.visitAncestorElements((ancestor) {
      inside = identical(ancestor, rootElement);
      return !inside;
    });
    return inside;
  }).length;
}
