import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
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
        await tester.pumpAndSettle();

        expect(find.text('Workspace assistant'), findsOneWidget);
        expect(find.text('Ask about this workspace…'), findsOneWidget);
        expect(find.text('Acme starter'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  }

  test('dashboard_demo starter sources remain independent of Material', () {
    final lib = Directory('lib').existsSync() ? 'lib' : 'registry_source/lib';
    for (final path in [
      '$lib/src/dashboard/dashboard_sample_data.dart',
      '$lib/src/dashboard/dashboard_overview_base.dart',
      '$lib/src/dashboard/dashboard_demo_base.dart',
      '$lib/src/dashboard/dashboard_demo_content.dart',
      '$lib/src/default/recipes/dashboard/dashboard_overview.dart',
      '$lib/src/default/recipes/dashboard/dashboard_demo.dart',
      '$lib/src/fortal/recipes/dashboard/dashboard_overview.dart',
      '$lib/src/fortal/recipes/dashboard/dashboard_demo.dart',
    ]) {
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

Future<void> _pumpDashboard(WidgetTester tester, {required _Preset preset}) =>
    _pump(
      tester,
      preset: preset,
      width: 1200,
      height: 800,
      child: switch (preset) {
        .defaultPreset => const VanillaDashboardDemo(
          brand: Text('Acme starter'),
        ),
        .fortal => const FortalDashboardDemo(brand: Text('Acme starter')),
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
