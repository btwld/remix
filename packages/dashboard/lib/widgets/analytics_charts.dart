import 'package:flutter/material.dart';
import 'package:remix/remix.dart';
import 'package:remix_chart/remix_chart.dart';

import 'page_header.dart';

class AnalyticsCharts extends StatelessWidget {
  const AnalyticsCharts({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1120
            ? 3
            : width >= 720
            ? 2
            : 1;
        final itemWidth = (width - (columns - 1) * 16) / columns;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: itemWidth,
              child: _AnalyticsCard(
                title: 'Revenue trend',
                description: 'Seven-day net revenue',
                child: FortalLineChart(
                  semanticsLabel: 'Seven-day net revenue',
                  showMarkers: true,
                  series: [_revenueSeries()],
                  xAxis: ChartAxis.numeric(
                    min: 0,
                    max: 6,
                    interval: 1,
                    labelFormatter: _dayLabel,
                  ),
                  yAxis: ChartAxis.numeric(
                    min: 0,
                    max: 100,
                    interval: 25,
                    labelFormatter: _currencyLabel,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _AnalyticsCard(
                title: 'Order volume',
                description: 'Actual versus plan',
                child: FortalBarChart(
                  semanticsLabel: 'Quarterly actual and planned orders',
                  groups: _orderGroups(),
                  xAxis: ChartAxis.numeric(
                    min: 0,
                    max: 3,
                    interval: 1,
                    labelFormatter: _quarterLabel,
                  ),
                  yAxis: ChartAxis.numeric(min: 0, max: 100, interval: 25),
                ),
              ),
            ),
            SizedBox(
              width: itemWidth,
              child: _AnalyticsCard(
                title: 'Channel mix',
                description: 'Revenue contribution',
                child: FortalPieChart(
                  semanticsLabel: 'Revenue contribution by channel',
                  centerRadius: 44,
                  slices: _channelSlices(),
                  valueFormatter: (value) => '${value.toInt()}%',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FortalCard(
      size: .size2,
      child: SizedBox(
        height: 292,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            SectionLabel(title),
            const SizedBox(height: 2),
            StyledText(
              description,
              style: TextStyler(
                style: FortalTokens.text1.mix(),
              ).color(FortalTokens.gray11()),
            ),
            const SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}

LineSeries _revenueSeries() => LineSeries(
  id: 'revenue',
  label: 'Revenue',
  points: [
    ChartPoint(id: 'mon', x: 0, y: 42),
    ChartPoint(id: 'tue', x: 1, y: 54),
    ChartPoint(id: 'wed', x: 2, y: 48),
    ChartPoint(id: 'thu', x: 3, y: 66),
    ChartPoint(id: 'fri', x: 4, y: 62),
    ChartPoint(id: 'sat', x: 5, y: 78),
    ChartPoint(id: 'sun', x: 6, y: 84),
  ],
);

List<BarGroup> _orderGroups() => [
  _orderGroup('q1', 'Q1', 52, 48),
  _orderGroup('q2', 'Q2', 68, 64),
  _orderGroup('q3', 'Q3', 74, 78),
  _orderGroup('q4', 'Q4', 88, 82),
];

BarGroup _orderGroup(String id, String label, double actual, double plan) =>
    BarGroup(
      id: id,
      label: label,
      bars: [
        BarValue(id: 'actual', label: 'Actual', toY: actual),
        BarValue(id: 'plan', label: 'Plan', toY: plan),
      ],
    );

List<PieSlice> _channelSlices() => [
  PieSlice(id: 'direct', label: 'Direct', value: 46),
  PieSlice(id: 'partners', label: 'Partners', value: 31),
  PieSlice(id: 'marketplace', label: 'Marketplace', value: 23),
];

String _dayLabel(double value) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final index = value.round();
  return index >= 0 && index < labels.length ? labels[index] : '';
}

String _quarterLabel(double value) {
  const labels = ['Q1', 'Q2', 'Q3', 'Q4'];
  final index = value.round();
  return index >= 0 && index < labels.length ? labels[index] : '';
}

String _currencyLabel(double value) => '\$${value.toInt()}k';
