import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_base.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_charts.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/chart.dart';
import 'package:registry_source/src/heroui/components/chip.dart';
import 'package:registry_source/src/heroui/components/tabs.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the fulfillment legend names the colors the pie draws '
        'in $mode', (tester) async {
      await _pumpDemo(tester, host: _host(mode));

      final legend = tester.widget<RegistryChartLegend>(
        find.byType(RegistryChartLegend),
      );
      expect(legend.items.map((item) => item.color), heroUiChartSeries.take(3));
      final pie = find.byType(PieChart);
      final palette = resolveHeroUiChartPalette(tester.element(pie));
      expect(palette.take(3), [
        heroUiToken(HeroUiTokens.accent, mode),
        heroUiToken(HeroUiTokens.muted, mode),
        heroUiToken(HeroUiTokens.foreground, mode),
      ]);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('statuses are soft chips in their status color', (tester) async {
    await _pumpDemo(tester);

    HeroUiChip chip(String label) => tester.widget<HeroUiChip>(
      find.ancestor(
        of: find.text(label).first,
        matching: find.byType(HeroUiChip),
      ),
    );
    expect(chip('Paid').color, HeroUiColor.success);
    expect(chip('Pending').color, HeroUiColor.warning);
    expect(chip('Refunded').color, HeroUiColor.defaultColor);
    for (final label in ['Paid', 'Pending', 'Refunded']) {
      expect(chip(label).variant, HeroUiChipVariant.soft, reason: label);
    }
  });

  testWidgets('the order filter is the primary tabs pill', (tester) async {
    await _pumpDemo(tester, initialPage: RegistryDashboardDemoPage.orders);

    final bar = tester.widget<HeroUiTabBar>(find.byType(HeroUiTabBar));
    expect(bar.variant, HeroUiTabsVariant.primary);
    expect(find.byType(HeroUiTab), findsNWidgets(5));
    await tester.tap(find.text('Refunded'));
    await tester.pump();
    final orders = tester.widget<RemixDataTable<Object>>(
      find.byWidgetPredicate((widget) => widget is RemixDataTable),
    );
    expect(orders.rows, isNotEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the radius slider reaches both brightnesses and keeps a '
      "host's custom dark theme", (tester) async {
    const custom = Color(0xFF123456);
    await _pumpDemo(
      tester,
      initialPage: RegistryDashboardDemoPage.settings,
      host: (child) => HeroUiTheme(
        mode: HeroUiThemeMode.light,
        darkTheme: HeroUiThemeData.dark(
          colors: {HeroUiTokens.background: custom},
        ),
        child: child,
      ),
    );

    Radius radius(RadiusToken token) => MixScope.tokenOf(
      token,
      tester.element(find.textContaining('Control radius')),
    );
    expect(radius(HeroUiTokens.radiusLg), const Radius.circular(8));
    expect(find.text('Control radius · 8px'), findsOneWidget);

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    final after = radius(HeroUiTokens.radiusLg);
    expect(after.x, greaterThan(8));
    expect(radius(HeroUiTokens.radiusXl).x, closeTo(after.x * 1.5, 0.001));
    expect(
      find.text('Settings'),
      findsWidgets,
      reason: 'the page survives the new radius',
    );

    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pumpAndSettle();
    final element = tester.element(find.textContaining('Control radius'));
    expect(HeroUiTheme.of(element).brightness, Brightness.dark);
    expect(MixScope.tokenOf(HeroUiTokens.background, element), custom);
    expect(radius(HeroUiTokens.radiusLg), after);
  });

  testWidgets('the radius slider works without a host theme', (tester) async {
    await _pumpDemo(
      tester,
      initialPage: RegistryDashboardDemoPage.settings,
      host: (child) => child,
    );

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    expect(
      MixScope.tokenOf(
        HeroUiTokens.radiusLg,
        tester.element(find.textContaining('Control radius')),
      ).x,
      greaterThan(8),
    );
    expect(tester.takeException(), isNull);
  });

  for (final label in ['Open notifications', 'Open theme settings']) {
    testWidgets('$label toggles its popover from one button', (tester) async {
      await _pumpDemo(tester);
      final button = find.byWidgetPredicate(
        (widget) => widget is HeroUiIconButton && widget.semanticLabel == label,
      );
      expect(button, findsOneWidget);
      final panel = label == 'Open notifications'
          ? 'Payout batch #29 was settled.'
          : 'Theme settings';

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(panel), findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.text(panel), findsNothing);
    });
  }

  testWidgets('theme settings switch the demo to dark and back', (
    tester,
  ) async {
    await _pumpDemo(tester);
    Brightness brightness() =>
        HeroUiTheme.of(tester.element(find.text('Revenue trend'))).brightness;

    await tester.tap(find.bySemanticsLabel('Open theme settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.dark);
    // As in Vanilla, the popover closes as the appearance changes.
    await tester.tap(find.bySemanticsLabel('Open theme settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light').last);
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);
  });
}

typedef _Host = Widget Function(Widget child);

_Host _host(String mode) =>
    (child) =>
        HeroUiTheme(mode: HeroUiThemeMode.values.byName(mode), child: child);

Future<void> _pumpDemo(
  WidgetTester tester, {
  RegistryDashboardDemoPage initialPage = RegistryDashboardDemoPage.overview,
  _Host? host,
}) async {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(1280, 900);
  addTearDown(tester.view.reset);
  final app = WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    home: HeroUiDashboardDemo(
      initialPage: initialPage,
      chatStepDelay: const Duration(milliseconds: 10),
    ),
  );
  await tester.pumpWidget((host ?? _host('light'))(app));
  await tester.pump();
}
