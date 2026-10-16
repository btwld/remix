import 'package:dashboard/main.dart';
import 'package:dashboard/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

void main() {
  testWidgets('overview donut has safe space and visible data legends', (
    tester,
  ) async {
    await tester.pumpWidget(const DashboardApp());

    final safeArea = find.byKey(
      const ValueKey('overview-channel-chart-safe-area'),
    );
    expect(safeArea, findsOneWidget);
    // The chart sits inside the safe area's padding, so its rect is inset
    // from the safe area's rect by that padding on every side.
    final donutRect = tester.getRect(
      find.byWidgetPredicate(
        (widget) =>
            widget is PieChart &&
            widget.semanticsLabel == 'Revenue contribution by channel',
      ),
    );
    final safeRect = tester.getRect(safeArea);
    expect(donutRect.top - safeRect.top, greaterThanOrEqualTo(8));
    expect(safeRect.bottom - donutRect.bottom, greaterThanOrEqualTo(8));

    final donut = tester.widget<PieChart>(
      find.byWidgetPredicate(
        (widget) =>
            widget is PieChart &&
            widget.semanticsLabel == 'Revenue contribution by channel',
      ),
    );
    final donutContext = tester.element(safeArea);
    final donutSpec = donut.style.build(donutContext).spec;
    expect(donut.slices.every((slice) => slice.style == null), isTrue);
    expect(donutSpec.slice!.spec.radius, 36);
    expect(
      donutSpec.centerRadius! + donutSpec.slice!.spec.radius!,
      lessThanOrEqualTo(80),
    );

    expect(find.byKey(const ValueKey('overview-order-legend')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('overview-channel-legend')),
      findsOneWidget,
    );
    for (final label in const [
      'Actual',
      'Plan',
      'Direct 46%',
      'Partners 31%',
      'Marketplace 23%',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('overview charts use a three two one responsive grid', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<List<Offset>> pumpAt(double width) async {
      await tester.pumpWidget(
        UiTheme(
          child: WidgetsApp(
            color: const Color(0xFFFFFFFF),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
            home: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: width, child: const UiAnalyticsCharts()),
            ),
          ),
        ),
      );
      expect(find.byKey(const ValueKey('overview-chart-grid')), findsOneWidget);
      return [
        tester.getCenter(find.text('Revenue trend')),
        tester.getCenter(find.text('Order volume')),
        tester.getCenter(find.text('Channel mix')),
      ];
    }

    final wide = await pumpAt(1200);
    expect(wide[1].dy, closeTo(wide[0].dy, 0.5));
    expect(wide[2].dy, closeTo(wide[0].dy, 0.5));

    final medium = await pumpAt(1000);
    expect(medium[1].dy, closeTo(medium[0].dy, 0.5));
    expect(medium[2].dy, greaterThan(medium[0].dy));

    final compact = await pumpAt(700);
    expect(compact[1].dy, greaterThan(compact[0].dy));
    expect(compact[2].dy, greaterThan(compact[1].dy));
    expect(tester.takeException(), isNull);
  });
}
