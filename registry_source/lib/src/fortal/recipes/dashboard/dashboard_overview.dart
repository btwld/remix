import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_charts.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';

/// The gap between cards, on every page.
const fortalDashboardGap = 16.0;

/// Two cards, the first twice as wide. One column under 900 wide.
final fortalLeadGrid = GridBoxStyler.columns(const [.fr(2), .fr(1)])
    .gap(fortalDashboardGap)
    .onConstraints(
      const .maxWidth(899),
      .equalColumns(1).gap(fortalDashboardGap),
    );

/// Three equal cards. One column under 900 wide.
final fortalThirdsGrid = GridBoxStyler.equalColumns(3)
    .gap(fortalDashboardGap)
    .onConstraints(
      const .maxWidth(899),
      .equalColumns(1).gap(fortalDashboardGap),
    );

/// Two equal cards. One column under 720 wide.
final fortalHalvesGrid = GridBoxStyler.equalColumns(2)
    .gap(fortalDashboardGap)
    .onConstraints(
      const .maxWidth(719),
      .equalColumns(1).gap(fortalDashboardGap),
    );

/// Four equal cards, two under 1000 wide and one under 520.
final fortalMetricsGrid = GridBoxStyler.equalColumns(4)
    .gap(fortalDashboardGap)
    .onConstraints(
      const .maxWidth(999),
      .equalColumns(2).gap(fortalDashboardGap),
    )
    .onConstraints(
      const .maxWidth(519),
      .equalColumns(1).gap(fortalDashboardGap),
    );

/// The Overview page: what the studio leads with, then the detail.
///
/// The page is a bento. Revenue takes the one inverse surface and the widest
/// cell; the featured edition beside it is a full-bleed cover; four metrics
/// follow at ordinary weight; goals sit on an accent wash; the calendar, the
/// team and the palettes recede on quiet surfaces.
class FortalDashboardOverview extends StatefulWidget {
  const FortalDashboardOverview({
    super.key,
    this.data,
    this.scrollController,
    this.onViewOrders,
    this.onViewCollection,
    this.onViewSchedule,
    this.onViewThemes,
  });

  /// The records the overview summarizes. Defaults to
  /// [fortalDashboardSampleData].
  final FortalDashboardData? data;

  /// Controls the page's scroll position.
  final ScrollController? scrollController;

  /// Called when the user asks to see all orders.
  final VoidCallback? onViewOrders;

  /// Called when the user asks to see the collection.
  final VoidCallback? onViewCollection;

  /// Called when the user asks to see the schedule.
  final VoidCallback? onViewSchedule;

  /// Called when the user asks to see the themes.
  final VoidCallback? onViewThemes;

  @override
  State<FortalDashboardOverview> createState() =>
      _FortalDashboardOverviewState();
}

class _FortalDashboardOverviewState extends State<FortalDashboardOverview> {
  Timer? _refresh;

  @override
  void dispose() {
    _refresh?.cancel();
    super.dispose();
  }

  /// Stands in for a fetch: the metrics show their loading state, then
  /// return.
  void _startRefresh() {
    _refresh?.cancel();
    setState(() {
      _refresh = Timer(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() => _refresh = null);
        fortalDashboardToast(context, 'Overview is up to date');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data ?? fortalDashboardSampleData;
    final refreshing = _refresh != null;
    return FortalPage(
      key: const ValueKey('dashboard-overview'),
      scrollController: widget.scrollController,
      title: 'Overview',
      description: 'How the studio is doing, as of a moment ago.',
      actions: [
        FortalTooltip(
          tooltipChild: const StyledText('Refresh'),
          child: FortalIconButton.soft(
            key: const ValueKey('overview-refresh'),
            icon: RemixIcons.refresh,
            semanticLabel: 'Refresh overview',
            loading: refreshing,
            onPressed: _startRefresh,
          ),
        ),
        FortalButton.soft(
          label: 'Export',
          leadingIcon: RemixIcons.download,
          onPressed: () =>
              fortalDashboardToast(context, 'Overview export prepared'),
        ),
        FortalButton(
          label: 'New order',
          leadingIcon: RemixIcons.plus,
          onPressed: () => fortalDashboardToast(context, 'Draft order started'),
        ),
      ],
      children: [
        GridBox(
          key: const ValueKey('overview-lead'),
          style: fortalLeadGrid,
          children: [
            FortalRevenueCard(data: data),
            if (data.editions.isNotEmpty)
              FortalFeaturedEditionCard(
                edition: data.editions.first,
                onPressed: widget.onViewCollection,
              ),
          ],
        ),
        GridBox(
          key: const ValueKey('dashboard-metrics'),
          style: fortalMetricsGrid,
          children: [
            for (final metric in data.metrics)
              FortalSkeleton(
                loading: refreshing,
                child: FortalStatCard(metric: metric),
              ),
          ],
        ),
        GridBox(
          key: const ValueKey('overview-breakdown'),
          style: fortalThirdsGrid,
          children: [
            FortalChannelsCard(
              channels: data.channels,
              total: data.revenueTotal(.week),
            ),
            FortalTopEditionsCard(
              editions: data.editions,
              onViewAll: widget.onViewCollection,
            ),
            FortalGoalsCard(goals: data.goals),
          ],
        ),
        GridBox(
          key: const ValueKey('overview-records'),
          style: fortalLeadGrid,
          children: [
            FortalRecentOrdersCard(
              orders: data.orders,
              onViewAll: widget.onViewOrders,
            ),
            FortalActivityCard(activities: data.activities),
          ],
        ),
        GridBox(
          key: const ValueKey('overview-studio'),
          style: fortalThirdsGrid,
          children: [
            FortalUpcomingCard(
              events: data.upcoming,
              onViewAll: widget.onViewSchedule,
            ),
            FortalTeamCard(team: data.team),
            FortalPalettesCard(onViewAll: widget.onViewThemes),
          ],
        ),
      ],
    );
  }
}

/// Revenue over a switchable window, against the window before it.
///
/// This is the page's lead, so it defaults to the inverse surface. The range
/// is the card's own state: switching it rebuilds this card and nothing else.
class FortalRevenueCard extends StatefulWidget {
  const FortalRevenueCard({
    super.key,
    required this.data,
    this.emphasis = .inverse,
    this.initialRange = .week,
  });

  /// The records the card plots.
  final FortalDashboardData data;

  /// How loudly the card speaks.
  final FortalSurfaceEmphasis emphasis;

  /// The window shown first.
  final FortalDashboardRange initialRange;

  @override
  State<FortalRevenueCard> createState() => _FortalRevenueCardState();
}

class _FortalRevenueCardState extends State<FortalRevenueCard> {
  late FortalDashboardRange _range = widget.initialRange;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final delta = data.revenueDelta(_range);
    return FortalSurface(
      key: const ValueKey('overview-revenue'),
      emphasis: widget.emphasis,
      size: .size3,
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space4()),
        children: [
          WrapBox(
            style: WrapBoxStyler()
                .wrapAlignment(.spaceBetween)
                .crossAxisAlignment(.start)
                .spacing(FortalTokens.space3())
                .runSpacing(FortalTokens.space3()),
            children: [
              ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start)
                    .spacing(FortalTokens.space1()),
                children: [
                  const FortalHeading(
                    'Revenue',
                    headingLevel: 2,
                    size: .size2,
                    weight: .medium,
                  ),
                  FortalText(
                    fortalDashboardCompactCurrency(data.revenueTotal(_range)),
                    key: const ValueKey('overview-revenue-total'),
                    size: .size8,
                    weight: .bold,
                  ),
                  RowBox(
                    style: FlexBoxStyler()
                        .mainAxisSize(.min)
                        .crossAxisAlignment(.center)
                        .spacing(FortalTokens.space2()),
                    children: [
                      FortalDeltaBadge(delta, positive: !delta.startsWith('-')),
                      Flexible(
                        child: StyledText(
                          _range.comparison,
                          style: dashboardTextLine(.size1, tone: .muted),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FortalSegmentedControl<FortalDashboardRange>(
                key: const ValueKey('overview-range'),
                size: .size1,
                semanticLabel: 'Revenue range',
                selectedValue: _range,
                items: [
                  for (final range in FortalDashboardRange.values)
                    RemixSegmentedControlItem(value: range, label: range.label),
                ],
                onChanged: (range) => setState(() => _range = range),
              ),
            ],
          ),
          FortalRevenueChart(
            points: data.revenue[_range]!,
            semanticLabel: 'Revenue, ${_range.description.toLowerCase()}',
          ),
          const _RevenueLegend(),
        ],
      ),
    );
  }
}

class _RevenueLegend extends StatelessWidget {
  const _RevenueLegend();

  @override
  Widget build(BuildContext context) => FortalDashboardChartLegend(
    semanticLabel: 'Revenue series',
    items: [
      FortalDashboardChartLegendItem(
        id: 'current',
        label: 'This period',
        color: resolveFortalChartPalette(context).first,
        pattern: .solid,
      ),
      FortalDashboardChartLegendItem(
        id: 'previous',
        label: 'Previous period',
        color: MixScope.tokenOf(FortalTokens.gray9, context),
        pattern: .dashed,
      ),
    ],
  );
}

/// An area chart of [points] over a dashed line for the period before.
///
/// The chart paints in its own layer, so a hover elsewhere on the page, or a
/// scroll, does not repaint it.
class FortalRevenueChart extends StatelessWidget {
  const FortalRevenueChart({
    super.key,
    required this.points,
    required this.semanticLabel,
    this.height = 240,
  });

  /// The series to plot, oldest first.
  final List<FortalDashboardPoint> points;

  /// The chart's accessible label.
  final String semanticLabel;

  /// The height of the plot, before theme scaling.
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = resolveFortalChartPalette(context).first;
    final previous = MixScope.tokenOf(FortalTokens.gray9, context);
    // Thirteen weekly labels do not fit under a narrow card; show every other.
    final labelEvery = points.length > 8 ? 2 : 1;

    return SizedBox(
      height: height * FortalTheme.of(context).scaling.factor,
      child: RepaintBoundary(
        child: FortalLineChart(
          key: const ValueKey('dashboard-revenue-chart'),
          // Series take the palette in order; the comparison paints first so
          // the current period sits on top of it.
          palette: [previous, accent],
          semanticsLabel: semanticLabel,
          dataTransition: MediaQuery.disableAnimationsOf(context)
              ? ChartDataTransition.none
              : const ChartDataTransition(
                  duration: Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                ),
          series: [
            LineSeries(
              id: 'previous',
              label: 'Previous period',
              points: [
                for (final (index, point) in points.indexed)
                  ChartPoint(id: index, x: index.toDouble(), y: point.previous),
              ],
              style: LineSeriesStyler().stroke(
                ChartStrokeStyler().width(1.5).dashArray([4, 4]),
              ),
            ),
            LineSeries(
              id: 'current',
              label: 'This period',
              points: [
                for (final (index, point) in points.indexed)
                  ChartPoint(id: index, x: index.toDouble(), y: point.value),
              ],
              style: LineSeriesStyler().belowArea(
                ChartAreaStyler()
                    .show(true)
                    // The axis runs half a step below zero; stop the fill at
                    // the zero line instead of the plot's edge.
                    .cutoffY(0)
                    .applyCutoff(true)
                    .gradient(
                      LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          accent.withValues(alpha: 0.24),
                          accent.withValues(alpha: 0),
                        ],
                      ),
                    ),
              ),
            ),
          ],
          xAxis: ChartAxis.numeric(
            min: -0.5,
            max: points.length > 1 ? points.length - 0.5 : 1.5,
            interval: 1,
            minIncluded: false,
            maxIncluded: false,
            labelFormatter: (value) {
              final index = value.round();
              return index >= 0 &&
                      index < points.length &&
                      index % labelEvery == 0
                  ? points[index].label
                  : '';
            },
          ),
          yAxis: registryDashboardDataAxis(
            points.expand((point) => [point.value, point.previous]),
            targetIntervals: 4,
          ),
          valueFormatter: (value) => '\$${_trim(value)}K',
          style: registryDashboardLineStyle(),
        ),
      ),
    );
  }
}

/// [value] without a trailing `.0`.
String _trim(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

/// The featured edition as a full-bleed cover with its sales on a panel over
/// the picture. The whole card is one button when [onPressed] is set.
class FortalFeaturedEditionCard extends StatelessWidget {
  const FortalFeaturedEditionCard({
    super.key,
    required this.edition,
    this.onPressed,
  });

  /// The edition featured.
  final FortalDashboardEdition edition;

  /// Called when the card is activated. The card is not a button when null.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final inset = FortalTokens.space3.resolve(context);
    final content = Stack(
      children: [
        // The floor: the cover never gets shorter than this, and grows with
        // the row when a neighbour is taller.
        SizedBox(height: 320 * FortalTheme.of(context).scaling.factor),
        Positioned.fill(child: FortalEditionCover(edition)),
        PositionedDirectional(
          top: inset,
          start: inset,
          child: const FortalBadge.solid(size: .size2, label: 'Featured'),
        ),
        Positioned(
          left: inset,
          right: inset,
          bottom: inset,
          child: Box(
            style: BoxStyler()
                .color(FortalTokens.colorPanelSolid())
                .borderRadius(.all(FortalTokens.radius3()))
                .padding(.all(FortalTokens.space3())),
            child: ColumnBox(
              style: FlexBoxStyler()
                  .mainAxisSize(.min)
                  .crossAxisAlignment(.stretch)
                  .spacing(FortalTokens.space2()),
              children: [
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.center)
                      .spacing(FortalTokens.space2()),
                  children: [
                    Expanded(
                      child: ColumnBox(
                        style: FlexBoxStyler().crossAxisAlignment(.start),
                        children: [
                          FortalText(
                            edition.title,
                            size: .size3,
                            weight: .bold,
                            truncate: true,
                          ),
                          StyledText(
                            '${edition.artist} · ${edition.series}',
                            style: dashboardTextLine(.size1, tone: .muted),
                          ),
                        ],
                      ),
                    ),
                    FortalText(
                      fortalDashboardCurrency(edition.price, cents: false),
                      size: .size3,
                      weight: .medium,
                    ),
                  ],
                ),
                FortalProgress(
                  value: edition.soldFraction,
                  size: .size1,
                  semanticsLabel: '${edition.title} edition sold',
                ),
                StyledText(
                  '${edition.sold} of ${edition.editionSize} sold',
                  style: dashboardText(.size1, tone: .muted),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return switch (onPressed) {
      final onPressed? => FortalPressableSurface(
        key: const ValueKey('overview-featured'),
        onPressed: onPressed,
        semanticLabel:
            'Featured edition: ${edition.title} by ${edition.artist}, '
            '${edition.sold} of ${edition.editionSize} sold. Open collection',
        padded: false,
        child: content,
      ),
      null => FortalSurface(
        key: const ValueKey('overview-featured'),
        padded: false,
        child: content,
      ),
    };
  }
}

/// Revenue split by channel: a donut around the total, and the shares beside
/// their names.
class FortalChannelsCard extends StatelessWidget {
  const FortalChannelsCard({
    super.key,
    required this.channels,
    required this.total,
  });

  /// The channels compared.
  final List<FortalDashboardChannel> channels;

  /// Total revenue, in thousands of dollars, shown in the donut's hole.
  final double total;

  @override
  Widget build(BuildContext context) {
    final palette = resolveFortalChartPalette(context);
    return FortalSurface(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space4()),
        children: [
          const FortalCardHeader(
            title: 'Sales by channel',
            description: 'Share of revenue this week',
          ),
          SizedBox(
            key: const ValueKey('overview-channel-chart'),
            height: 184,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RepaintBoundary(
                  child: PieChart(
                    style: fortalPieChartStyle(
                      palette: palette,
                      centerRadius: 58,
                    ).slice(PieSliceStyler().radius(22)),
                    semanticsLabel: 'Revenue share by channel',
                    slices: [
                      for (final channel in channels)
                        PieSlice(
                          id: channel.id,
                          label: channel.label,
                          value: channel.share,
                        ),
                    ],
                    valueFormatter: (value) => '${value.toInt()}%',
                  ),
                ),
                IgnorePointer(
                  child: ExcludeSemantics(
                    child: ColumnBox(
                      style: FlexBoxStyler().mainAxisSize(.min),
                      children: [
                        FortalText(
                          fortalDashboardCompactCurrency(total),
                          size: .size4,
                          weight: .bold,
                        ),
                        StyledText(
                          'this week',
                          style: dashboardText(.size1, tone: .muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FortalDashboardChartLegend(
            key: const ValueKey('overview-channel-legend'),
            semanticLabel: 'Revenue share by channel',
            axis: Axis.vertical,
            items: [
              for (final (index, channel) in channels.indexed)
                FortalDashboardChartLegendItem(
                  id: channel.id,
                  label: channel.label,
                  value: '${channel.share.toInt()}%',
                  color: palette[index % palette.length],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The best-selling editions, each with its cover.
class FortalTopEditionsCard extends StatelessWidget {
  const FortalTopEditionsCard({
    super.key,
    required this.editions,
    this.onViewAll,
    this.count = 5,
  });

  /// The collection. The card ranks it by revenue.
  final List<FortalDashboardEdition> editions;

  /// Called when the user asks to see the collection.
  final VoidCallback? onViewAll;

  /// How many editions to list.
  final int count;

  @override
  Widget build(BuildContext context) {
    final ranked = [...editions]
      ..sort((a, b) => b.revenue.compareTo(a.revenue));
    return FortalSurface(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space3()),
        children: [
          FortalCardHeader(
            title: 'Top editions',
            description: 'By revenue, all time',
            trailing: FortalButton.ghost(
              key: const ValueKey('overview-view-collection'),
              size: .size1,
              label: 'View all',
              onPressed: onViewAll,
            ),
          ),
          for (final edition in ranked.take(count))
            RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(FortalTokens.space3()),
              children: [
                FortalEditionThumbnail(edition),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler().crossAxisAlignment(.start),
                    children: [
                      FortalText(
                        edition.title,
                        size: .size2,
                        weight: .medium,
                        truncate: true,
                      ),
                      StyledText(
                        '${edition.sold} sold · ${edition.series}',
                        style: dashboardTextLine(.size1, tone: .muted),
                      ),
                    ],
                  ),
                ),
                FortalText(
                  fortalDashboardCurrency(edition.revenue, cents: false),
                  size: .size2,
                  weight: .medium,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The studio's targets on an accent wash, one progress bar each.
class FortalGoalsCard extends StatelessWidget {
  const FortalGoalsCard({super.key, required this.goals});

  /// The targets tracked.
  final List<FortalDashboardGoal> goals;

  @override
  Widget build(BuildContext context) => FortalSurface(
    emphasis: .tinted,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(FortalTokens.space4()),
      children: [
        const FortalCardHeader(
          title: 'Studio goals',
          description: 'Third quarter, 18 days left',
        ),
        for (final goal in goals)
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(FortalTokens.space2()),
            children: [
              RowBox(
                style: FlexBoxStyler().spacing(FortalTokens.space2()),
                children: [
                  Expanded(
                    child: FortalText(
                      goal.label,
                      size: .size2,
                      weight: .medium,
                      truncate: true,
                    ),
                  ),
                  StyledText(
                    goal.detail,
                    style: dashboardText(.size1, tone: .muted),
                  ),
                ],
              ),
              FortalProgress(value: goal.value, semanticsLabel: goal.label),
            ],
          ),
        const FortalCallout(
          size: .size1,
          icon: RemixIcons.wand,
          text: 'At this pace revenue lands 6% over target.',
        ),
      ],
    ),
  );
}

/// The latest orders as a table that runs to the card's edges.
class FortalRecentOrdersCard extends StatelessWidget {
  const FortalRecentOrdersCard({
    super.key,
    required this.orders,
    this.onViewAll,
    this.count = 6,
  });

  static final _columns = <RemixDataTableColumn<FortalDashboardOrder>>[
    RemixDataTableColumn(
      id: 'id',
      label: 'Order',
      width: const FixedColumnWidth(104),
      cellBuilder: (_, order) =>
          FortalDataTableCellText(order.id, primary: true),
    ),
    RemixDataTableColumn(
      id: 'customer',
      label: 'Customer',
      width: const FlexColumnWidth(2),
      cellBuilder: (_, order) => FortalDataTableCellText(order.customer),
    ),
    RemixDataTableColumn(
      id: 'edition',
      label: 'Edition',
      width: const FlexColumnWidth(2),
      cellBuilder: (_, order) => FortalDataTableCellText(order.edition),
    ),
    RemixDataTableColumn(
      id: 'amount',
      label: 'Amount',
      width: const FixedColumnWidth(108),
      alignment: AlignmentDirectional.centerEnd,
      cellBuilder: (_, order) => FortalDataTableCellText(
        fortalDashboardCurrency(order.amount),
        primary: true,
      ),
    ),
    RemixDataTableColumn(
      id: 'status',
      label: 'Status',
      width: const FixedColumnWidth(108),
      cellBuilder: (_, order) => FortalStatusBadge.order(order.status),
    ),
  ];

  /// The orders, newest first.
  final List<FortalDashboardOrder> orders;

  /// Called when the user asks to see all orders.
  final VoidCallback? onViewAll;

  /// How many orders to list.
  final int count;

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
          child: FortalCardHeader(
            title: 'Recent orders',
            description: 'The last ${count.clamp(0, orders.length)} placed',
            trailing: FortalButton.ghost(
              key: const ValueKey('overview-view-orders'),
              size: .size1,
              label: 'View all',
              onPressed: onViewAll,
            ),
          ),
        ),
        FortalDataTable<FortalDashboardOrder>(
          key: const ValueKey('dashboard-records-table'),
          semanticLabel: 'Recent orders',
          rows: orders.take(count).toList(),
          minimumWidth: 560,
          columns: _columns,
        ),
      ],
    ),
  );
}

/// What just happened, newest first.
class FortalActivityCard extends StatelessWidget {
  const FortalActivityCard({super.key, required this.activities});

  /// The events, newest first.
  final List<FortalDashboardActivity> activities;

  @override
  Widget build(BuildContext context) => FortalSurface(
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(FortalTokens.space3()),
      children: [
        const FortalCardHeader(title: 'Activity', description: 'Today'),
        for (final event in activities)
          RowBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.center)
                .spacing(FortalTokens.space3()),
            children: [
              FortalActivityIcon(kind: event.kind),
              Expanded(
                child: ColumnBox(
                  style: FlexBoxStyler().crossAxisAlignment(.start),
                  children: [
                    FortalText(
                      event.title,
                      size: .size2,
                      weight: .medium,
                      truncate: true,
                    ),
                    StyledText(
                      event.detail,
                      style: dashboardTextLine(.size1, tone: .muted),
                    ),
                  ],
                ),
              ),
              StyledText(
                event.relativeTime,
                style: dashboardText(.size1, tone: .subtle),
              ),
            ],
          ),
      ],
    ),
  );
}

/// The icon of an activity, tinted by its kind.
class FortalActivityIcon extends StatelessWidget {
  const FortalActivityIcon({super.key, required this.kind});

  /// The event's category.
  final FortalDashboardActivityKind kind;

  @override
  Widget build(BuildContext context) {
    final (icon, accent) = switch (kind) {
      .customer => (RemixIcons.user, FortalAccentColor.ceu),
      .order => (RemixIcons.box, FortalAccentColor.duna),
      .payment => (RemixIcons.checkCircle, FortalAccentColor.mar),
      .alert => (RemixIcons.warning, FortalAccentColor.sol),
      .release => (RemixIcons.calendar, FortalAccentColor.caju),
    };

    return FortalAccentScope(
      accent: accent,
      child: FortalAvatar.soft(icon: icon, size: .size2),
    );
  }
}

/// What is next on the studio calendar, on a quiet surface.
class FortalUpcomingCard extends StatelessWidget {
  const FortalUpcomingCard({
    super.key,
    required this.events,
    this.onViewAll,
    this.count = 3,
  });

  /// The events, soonest first.
  final List<FortalDashboardEvent> events;

  /// Called when the user asks to see the schedule.
  final VoidCallback? onViewAll;

  /// How many events to list.
  final int count;

  @override
  Widget build(BuildContext context) => FortalSurface(
    emphasis: .quiet,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(FortalTokens.space3()),
      children: [
        FortalCardHeader(
          title: 'Upcoming',
          description: 'On the studio calendar',
          trailing: FortalButton.ghost(
            key: const ValueKey('overview-view-schedule'),
            size: .size1,
            label: 'Schedule',
            onPressed: onViewAll,
          ),
        ),
        for (final event in events.take(count)) FortalEventTile(event),
      ],
    ),
  );
}

/// The seven Fortal palettes, one button each, on a quiet surface. Picking
/// one restyles the whole dashboard.
///
/// The buttons need a [FortalDashboardThemeScope] above them to apply a
/// palette; without one they are disabled.
class FortalPalettesCard extends StatelessWidget {
  const FortalPalettesCard({super.key, this.onViewAll});

  /// Called when the user asks to see the themes.
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final scope = FortalDashboardThemeScope.maybeOf(context);
    final active =
        scope?.settings.accentColor ?? FortalTheme.of(context).accent;
    return FortalSurface(
      key: const ValueKey('overview-palettes'),
      emphasis: .quiet,
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space3()),
        children: [
          FortalCardHeader(
            title: 'Palettes',
            description: 'Seven themes, one tap each',
            trailing: FortalButton.ghost(
              key: const ValueKey('overview-view-themes'),
              size: .size1,
              label: 'Themes',
              onPressed: onViewAll,
            ),
          ),
          WrapBox(
            style: WrapBoxStyler()
                .spacing(FortalTokens.space2())
                .runSpacing(FortalTokens.space2()),
            children: [
              for (final accent in FortalAccentColor.values)
                FortalAccentScope(
                  accent: accent,
                  child: FortalButton(
                    key: ValueKey('overview-palette-${accent.name}'),
                    variant: accent == active ? .solid : .soft,
                    size: .size1,
                    label: enumLabel(accent),
                    semanticLabel:
                        '${enumLabel(accent)} palette'
                        '${accent == active ? ', in use' : ''}',
                    onPressed: scope == null
                        ? null
                        : () => scope.onChanged(
                            scope.settings.copyWith(accentColor: accent),
                          ),
                  ),
                ),
            ],
          ),
          StyledText(
            'Each palette pairs an accent with its own neutral, in light and '
            'dark.',
            style: dashboardText(.size1, tone: .muted),
          ),
        ],
      ),
    );
  }
}

/// Who is on the team and who is around, on a quiet surface.
class FortalTeamCard extends StatelessWidget {
  const FortalTeamCard({super.key, required this.team});

  /// The team, in display order.
  final List<FortalDashboardMember> team;

  @override
  Widget build(BuildContext context) {
    final online = team.where((member) => member.online).length;
    return FortalSurface(
      emphasis: .quiet,
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(FortalTokens.space3()),
        children: [
          FortalCardHeader(
            title: 'Team',
            description: '$online of ${team.length} online now',
            trailing: FortalAvatarStack(members: team),
          ),
          for (final member in team.take(3))
            RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(FortalTokens.space3()),
              children: [
                FortalAccentScope(
                  accent: member.accent,
                  child: FortalAvatar(
                    label: member.initials,
                    size: .size2,
                    fallbackLength: 2,
                  ),
                ),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler().crossAxisAlignment(.start),
                    children: [
                      FortalText(
                        member.name,
                        size: .size2,
                        weight: .medium,
                        truncate: true,
                      ),
                      StyledText(
                        member.role,
                        style: dashboardTextLine(.size1, tone: .muted),
                      ),
                    ],
                  ),
                ),
                if (member.online)
                  const FortalAccentScope(
                    accent: .mar,
                    child: FortalBadge(highContrast: true, label: 'Online'),
                  )
                else
                  const FortalBadge.outline(label: 'Away'),
              ],
            ),
        ],
      ),
    );
  }
}
