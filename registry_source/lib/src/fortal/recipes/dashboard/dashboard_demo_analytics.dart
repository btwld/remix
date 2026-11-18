import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_charts.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';

/// The Analytics page: where revenue comes from and how editions sell.
class FortalDashboardAnalyticsPage extends StatelessWidget {
  const FortalDashboardAnalyticsPage({super.key, this.data});

  /// The records the page analyzes. Defaults to [fortalDashboardSampleData].
  final FortalDashboardData? data;

  @override
  Widget build(BuildContext context) {
    final data = this.data ?? fortalDashboardSampleData;
    return FortalPage(
      key: const ValueKey('dashboard-analytics'),
      title: 'Analytics',
      description: 'Where revenue comes from and how each edition sells.',
      actions: [
        FortalButton.soft(
          label: 'Download report',
          leadingIcon: RemixIcons.download,
          onPressed: () => showRemixToast(
            context,
            const RemixToastData(
              title: 'Analytics report prepared',
              icon: RemixIcons.checkCircle,
            ),
          ),
        ),
      ],
      children: [
        FortalSummaryStrip(metrics: data.metrics),
        FortalRevenueCard(
          data: data,
          emphasis: .standard,
          initialRange: .month,
        ),
        GridBox(
          key: const ValueKey('analytics-breakdown'),
          style: fortalHalvesGrid,
          children: [
            FortalChannelOrdersCard(channels: data.channels, weeks: data.weeks),
            FortalSellThroughCard(editions: data.editions),
          ],
        ),
        GridBox(
          key: const ValueKey('analytics-channels'),
          style: fortalLeadGrid,
          children: [
            FortalChannelTableCard(channels: data.channels),
            const FortalInsightsCard(),
          ],
        ),
      ],
    );
  }
}

/// Headline figures in one surface, a divider apart: the compact alternative
/// to a row of stat cards.
class FortalSummaryStrip extends StatelessWidget {
  const FortalSummaryStrip({super.key, required this.metrics});

  // A one-pixel gap over a divider-coloured ground draws the rules between
  // cells, and none around the outside, at every column count.
  static final _grid = GridBoxStyler.equalColumns(4)
      .gap(1)
      .onConstraints(const .maxWidth(799), .equalColumns(2).gap(1))
      .onConstraints(const .maxWidth(419), .equalColumns(1).gap(1));

  /// The figures shown, in order.
  final List<FortalDashboardMetric> metrics;

  @override
  Widget build(BuildContext context) => FortalSurface(
    key: const ValueKey('analytics-summary'),
    padded: false,
    child: Box(
      style: BoxStyler().color(FortalTokens.gray5()),
      child: GridBox(
        style: _grid,
        children: [
          for (final metric in metrics)
            Box(
              style: BoxStyler()
                  .padding(.all(FortalTokens.space4()))
                  .color(FortalTokens.colorPanelSolid()),
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.start)
                    .spacing(FortalTokens.space2()),
                children: [
                  StyledText(
                    metric.label,
                    style: dashboardTextLine(.size2, tone: .muted),
                  ),
                  RowBox(
                    style: FlexBoxStyler()
                        .mainAxisSize(.min)
                        .crossAxisAlignment(.center)
                        .spacing(FortalTokens.space2()),
                    children: [
                      Flexible(
                        child: FortalText(
                          metric.value,
                          size: .size6,
                          weight: .bold,
                          truncate: true,
                        ),
                      ),
                      FortalDeltaBadge(metric.delta, positive: metric.positive),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

/// Weekly orders as bars stacked by channel.
class FortalChannelOrdersCard extends StatelessWidget {
  const FortalChannelOrdersCard({
    super.key,
    required this.channels,
    required this.weeks,
  });

  /// The channels, in the order each week's counts follow.
  final List<FortalDashboardChannel> channels;

  /// The weeks plotted, oldest first.
  final List<FortalDashboardWeek> weeks;

  @override
  Widget build(BuildContext context) {
    final palette = resolveFortalChartPalette(context);
    Color colorOf(int channel) => palette[channel % palette.length];

    return FortalSurface(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space4()),
        children: [
          const FortalCardHeader(
            title: 'Orders by channel',
            description: 'Weekly orders, last six weeks',
          ),
          SizedBox(
            height: 240 * FortalTheme.of(context).scaling.factor,
            child: RepaintBoundary(
              child: FortalBarChart(
                key: const ValueKey('analytics-orders-chart'),
                palette: palette,
                semanticsLabel: 'Weekly orders by channel',
                groups: [
                  for (final week in weeks)
                    BarGroup(
                      id: week.label,
                      label: week.label,
                      bars: [_stack(week, colorOf)],
                    ),
                ],
                yAxis: registryDashboardDataAxis(
                  weeks.map(
                    (week) => week.orders.fold(0, (sum, count) => sum + count),
                  ),
                  targetIntervals: 4,
                ),
                style: registryDashboardBarStyle().bar(
                  BarStyler().width(FortalTokens.space5()),
                ),
              ),
            ),
          ),
          FortalDashboardChartLegend(
            semanticLabel: 'Channels',
            items: [
              for (final (index, channel) in channels.indexed)
                FortalDashboardChartLegendItem(
                  id: channel.id,
                  label: channel.label,
                  color: colorOf(index),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// One week's bar: a segment per channel, each starting where the last
  /// one ended.
  BarValue _stack(FortalDashboardWeek week, Color Function(int) colorOf) {
    var from = 0.0;
    final segments = <BarSegment>[];
    for (final (index, count) in week.orders.indexed) {
      segments.add(
        BarSegment(
          id: channels[index].id,
          label: channels[index].label,
          fromY: from,
          toY: from + count,
          style: BarSegmentStyler().color(colorOf(index)),
        ),
      );
      from += count;
    }

    return BarValue(
      id: 'orders',
      label: 'Orders',
      toY: from,
      segments: segments,
    );
  }
}

/// How much of each released edition has sold, with its cover.
class FortalSellThroughCard extends StatelessWidget {
  const FortalSellThroughCard({
    super.key,
    required this.editions,
    this.count = 6,
  });

  /// The collection. Drafts are left out.
  final List<FortalDashboardEdition> editions;

  /// How many editions to list.
  final int count;

  @override
  Widget build(BuildContext context) {
    final released =
        editions.where((edition) => edition.status != .draft).toList()
          ..sort((a, b) => b.soldFraction.compareTo(a.soldFraction));
    return FortalSurface(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space3()),
        children: [
          const FortalCardHeader(
            title: 'Sell-through',
            description: 'Share of each edition sold',
          ),
          for (final edition in released.take(count))
            RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(FortalTokens.space3()),
              children: [
                FortalEditionThumbnail(edition, extent: 36),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler()
                        .crossAxisAlignment(.stretch)
                        .spacing(FortalTokens.space1()),
                    children: [
                      RowBox(
                        style: FlexBoxStyler().spacing(FortalTokens.space2()),
                        children: [
                          Expanded(
                            child: FortalText(
                              edition.title,
                              size: .size2,
                              weight: .medium,
                              truncate: true,
                            ),
                          ),
                          StyledText(
                            '${(edition.soldFraction * 100).round()}%',
                            style: dashboardText(.size1, tone: .muted),
                          ),
                        ],
                      ),
                      FortalProgress(
                        value: edition.soldFraction,
                        size: .size1,
                        semanticsLabel: '${edition.title} sold',
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Each channel's revenue, share and change, as a table.
class FortalChannelTableCard extends StatelessWidget {
  const FortalChannelTableCard({super.key, required this.channels});

  static final _columns = <RemixDataTableColumn<FortalDashboardChannel>>[
    RemixDataTableColumn(
      id: 'channel',
      label: 'Channel',
      width: const FlexColumnWidth(2),
      cellBuilder: (_, channel) =>
          FortalDataTableCellText(channel.label, primary: true),
    ),
    RemixDataTableColumn(
      id: 'revenue',
      label: 'Revenue',
      width: const FixedColumnWidth(120),
      alignment: AlignmentDirectional.centerEnd,
      cellBuilder: (_, channel) => FortalDataTableCellText(
        fortalDashboardCurrency(channel.revenue, cents: false),
        primary: true,
      ),
    ),
    RemixDataTableColumn(
      id: 'share',
      label: 'Share',
      width: const FixedColumnWidth(88),
      alignment: AlignmentDirectional.centerEnd,
      cellBuilder: (_, channel) =>
          FortalDataTableCellText('${channel.share.toInt()}%'),
    ),
    RemixDataTableColumn(
      id: 'change',
      label: 'Change',
      width: const FixedColumnWidth(104),
      cellBuilder: (_, channel) => FortalDeltaBadge(
        channel.delta,
        positive: !channel.delta.startsWith('-'),
      ),
    ),
  ];

  /// The channels compared.
  final List<FortalDashboardChannel> channels;

  @override
  Widget build(BuildContext context) => FortalSurface(
    padded: false,
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch),
      children: [
        Box(
          style: BoxStyler().padding(
            .symmetric(
              horizontal: FortalTokens.space3(),
              vertical: FortalTokens.space4(),
            ),
          ),
          child: const FortalCardHeader(
            title: 'Channel performance',
            description: 'This week against last',
          ),
        ),
        FortalDataTable<FortalDashboardChannel>(
          key: const ValueKey('analytics-channel-table'),
          semanticLabel: 'Channel performance',
          rows: channels,
          minimumWidth: 440,
          columns: _columns,
        ),
      ],
    ),
  );
}

/// Three observations worth acting on, on an accent wash.
class FortalInsightsCard extends StatelessWidget {
  const FortalInsightsCard({super.key});

  static const _insights = [
    (
      RemixIcons.arrowUp,
      'Galleries are compounding',
      'Wholesale orders grew six weeks running.',
    ),
    (
      RemixIcons.warning,
      'Two editions are nearly gone',
      'Mar Aberto and Caju Maduro sell out this month.',
    ),
    (
      RemixIcons.calendar,
      'Fridays convert best',
      'Schedule the Jangada release for a Friday.',
    ),
  ];

  @override
  Widget build(BuildContext context) => FortalSurface(
    emphasis: .tinted,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(FortalTokens.space4()),
      children: [
        const FortalCardHeader(
          title: 'Insights',
          description: 'Worth acting on this week',
        ),
        for (final (icon, title, body) in _insights)
          RowBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(FortalTokens.space3()),
            children: [
              FortalAvatar.solid(icon: icon, size: .size2),
              Expanded(
                child: ColumnBox(
                  style: FlexBoxStyler().crossAxisAlignment(.start).spacing(2),
                  children: [
                    FortalText(title, size: .size2, weight: .medium),
                    StyledText(
                      body,
                      style: dashboardText(.size2, tone: .muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
