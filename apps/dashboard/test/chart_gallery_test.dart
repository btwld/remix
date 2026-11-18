import 'dart:math' as math;

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

    final chartBox = find.byKey(const ValueKey('overview-channel-chart'));
    expect(chartBox, findsOneWidget);
    final donutFinder = find.byWidgetPredicate(
      (widget) =>
          widget is PieChart &&
          widget.semanticsLabel == 'Revenue share by channel',
    );
    final donut = tester.widget<PieChart>(donutFinder);
    final donutRect = tester.getRect(donutFinder);

    // The chart fills the box it is given, so the safe space is the margin
    // between the donut's outer edge and the smaller side of that box.
    final donutSpec = donut.style.build(tester.element(chartBox)).spec;
    expect(donut.slices.every((slice) => slice.style == null), isTrue);
    expect(donutSpec.slice!.spec.radius, 22);
    final outerRadius = donutSpec.centerRadius! + donutSpec.slice!.spec.radius!;
    expect(outerRadius, 80);
    expect(
      outerRadius * 2,
      lessThanOrEqualTo(math.min(donutRect.width, donutRect.height) - 16),
    );

    // The revenue legend names both periods; the donut legend names every
    // channel with its share. Channel names also sit in the Recent orders
    // table, so scope them to the legend.
    for (final label in const ['This period', 'Previous period']) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
    final legend = find.byKey(const ValueKey('overview-channel-legend'));
    expect(legend, findsOneWidget);
    for (final label in const [
      'Studio store',
      'Galleries',
      'Marketplace',
      '46%',
      '31%',
      '23%',
    ]) {
      expect(
        find.descendant(of: legend, matching: find.text(label)),
        findsOneWidget,
        reason: label,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('overview chart cards collapse with their grids', (tester) async {
    Future<void> pumpAt(double width) async {
      tester.view.physicalSize = Size(width, 2400);
      tester.view.devicePixelRatio = 1;
      await tester.pumpWidget(
        UiTheme(
          child: WidgetsApp(
            color: const Color(0xFFFFFFFF),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
            home: const UiDashboardOverview(),
          ),
        ),
      );
    }

    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // The revenue line chart leads a two-thirds / one-third row, and the
    // channel donut sits first in a row of three. Both grids go to one
    // column when the content is under 900 wide (the page adds 48 of padding).
    Rect card(String title) => tester.getRect(
      find
          .ancestor(of: find.text(title), matching: find.byType(UiSurface))
          .first,
    );

    await pumpAt(1200);
    final revenue = card('Revenue');
    final channels = card('Sales by channel');
    final editions = card('Top editions');
    expect(tester.getRect(find.byType(UiLineChart)).width, greaterThan(300));
    expect(editions.top, closeTo(channels.top, 0.5));
    expect(editions.left, greaterThan(channels.right));
    expect(channels.top, greaterThan(revenue.bottom));
    expect(revenue.width, greaterThan(channels.width));

    // Exactly at the threshold: a 900 wide grid still has its columns.
    await pumpAt(948);
    expect(
      card('Top editions').top,
      closeTo(card('Sales by channel').top, 0.5),
    );

    await pumpAt(947);
    final narrowChannels = card('Sales by channel');
    final narrowEditions = card('Top editions');
    expect(narrowEditions.top, greaterThan(narrowChannels.bottom));
    expect(narrowEditions.left, closeTo(narrowChannels.left, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('analytics orders chart stacks one segment per channel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const DashboardApp());

    await tester.tap(
      find.byKey(const ValueKey(UiDashboardDemoPage.analytics)).first,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    final page = find.byKey(const ValueKey('dashboard-page-analytics'));
    final chart = find.descendant(of: page, matching: find.byType(UiBarChart));
    expect(chart, findsOneWidget);
    final bars = tester.widget<UiBarChart>(chart);
    expect(bars.semanticsLabel, 'Weekly orders by channel');
    expect(bars.groups, hasLength(6));
    for (final group in bars.groups) {
      expect(group.bars, hasLength(1), reason: group.label);
      final segments = group.bars.single.segments;
      expect(segments, hasLength(3), reason: group.label);
      // Each segment starts where the one before it ended.
      expect(segments.first.fromY, 0);
      for (var index = 1; index < segments.length; index++) {
        expect(segments[index].fromY, segments[index - 1].toY);
      }
      expect(group.bars.single.toY, segments.last.toY);
    }

    // The legend names the stacked channels.
    for (final channel in const ['Studio store', 'Galleries', 'Marketplace']) {
      expect(
        find.descendant(of: page, matching: find.text(channel)),
        findsWidgets,
        reason: channel,
      );
    }
    expect(tester.takeException(), isNull);
  });
}
