import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_charts.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';

/// The gap between cards, on every page.
const uiDashboardGap = 16.0;

/// Two cards, the first twice as wide. One column under 900 wide.
final uiLeadGrid = GridBoxStyler.columns(const [.fr(2), .fr(1)])
    .gap(uiDashboardGap)
    .onConstraints(const .maxWidth(899), .equalColumns(1).gap(uiDashboardGap));

/// Three equal cards. One column under 900 wide.
final uiThirdsGrid = GridBoxStyler.equalColumns(3)
    .gap(uiDashboardGap)
    .onConstraints(const .maxWidth(899), .equalColumns(1).gap(uiDashboardGap));

/// Two equal cards. One column under 720 wide.
final uiHalvesGrid = GridBoxStyler.equalColumns(2)
    .gap(uiDashboardGap)
    .onConstraints(const .maxWidth(719), .equalColumns(1).gap(uiDashboardGap));

/// Four equal cards, two under 1000 wide and one under 520.
final uiMetricsGrid = GridBoxStyler.equalColumns(4)
    .gap(uiDashboardGap)
    .onConstraints(const .maxWidth(999), .equalColumns(2).gap(uiDashboardGap))
    .onConstraints(const .maxWidth(519), .equalColumns(1).gap(uiDashboardGap));

/// The Overview page: what the studio leads with, then the detail.
///
/// The page is a bento. Revenue takes the one inverse surface and the widest
/// cell; the featured edition beside it is a full-bleed cover; four metrics
/// follow at ordinary weight; goals sit on an accent wash; the calendar, the
/// team and the palettes recede on quiet surfaces.
class UiDashboardOverview extends StatefulWidget {
  const UiDashboardOverview({
    super.key,
    this.data,
    this.scrollController,
    this.onViewOrders,
    this.onViewCollection,
    this.onViewSchedule,
    this.onViewThemes,
  });

  /// The records the overview summarizes. Defaults to
  /// [uiDashboardSampleData].
  final UiDashboardData? data;

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
  State<UiDashboardOverview> createState() => _UiDashboardOverviewState();
}

class _UiDashboardOverviewState extends State<UiDashboardOverview> {
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
        uiDashboardToast(context, 'Overview is up to date');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data ?? uiDashboardSampleData;
    final refreshing = _refresh != null;
    return UiPage(
      key: const ValueKey('dashboard-overview'),
      scrollController: widget.scrollController,
      title: 'Overview',
      description: 'How the studio is doing, as of a moment ago.',
      actions: [
        UiTooltip(
          tooltipChild: const StyledText('Refresh'),
          child: UiIconButton.soft(
            key: const ValueKey('overview-refresh'),
            icon: RemixIcons.refresh,
            semanticLabel: 'Refresh overview',
            loading: refreshing,
            onPressed: _startRefresh,
          ),
        ),
        UiButton.soft(
          label: 'Export',
          leadingIcon: RemixIcons.download,
          onPressed: () =>
              uiDashboardToast(context, 'Overview export prepared'),
        ),
        UiButton(
          label: 'New order',
          leadingIcon: RemixIcons.plus,
          onPressed: () => uiDashboardToast(context, 'Draft order started'),
        ),
      ],
      children: [
        GridBox(
          key: const ValueKey('overview-lead'),
          style: uiLeadGrid,
          children: [
            UiRevenueCard(data: data),
            if (data.editions.isNotEmpty)
              UiFeaturedEditionCard(
                edition: data.editions.first,
                onPressed: widget.onViewCollection,
              ),
          ],
        ),
        GridBox(
          key: const ValueKey('dashboard-metrics'),
          style: uiMetricsGrid,
          children: [
            for (final metric in data.metrics)
              UiSkeleton(
                loading: refreshing,
                child: UiStatCard(metric: metric),
              ),
          ],
        ),
        GridBox(
          key: const ValueKey('overview-breakdown'),
          style: uiThirdsGrid,
          children: [
            UiChannelsCard(
              channels: data.channels,
              total: data.revenueTotal(.week),
            ),
            UiTopEditionsCard(
              editions: data.editions,
              onViewAll: widget.onViewCollection,
            ),
            UiGoalsCard(goals: data.goals),
          ],
        ),
        GridBox(
          key: const ValueKey('overview-records'),
          style: uiLeadGrid,
          children: [
            UiRecentOrdersCard(
              orders: data.orders,
              onViewAll: widget.onViewOrders,
            ),
            UiActivityCard(activities: data.activities),
          ],
        ),
        GridBox(
          key: const ValueKey('overview-studio'),
          style: uiThirdsGrid,
          children: [
            UiUpcomingCard(
              events: data.upcoming,
              onViewAll: widget.onViewSchedule,
            ),
            UiTeamCard(team: data.team),
            UiPalettesCard(onViewAll: widget.onViewThemes),
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
class UiRevenueCard extends StatefulWidget {
  const UiRevenueCard({
    super.key,
    required this.data,
    this.emphasis = .inverse,
    this.initialRange = .week,
  });

  /// The records the card plots.
  final UiDashboardData data;

  /// How loudly the card speaks.
  final UiSurfaceEmphasis emphasis;

  /// The window shown first.
  final UiDashboardRange initialRange;

  @override
  State<UiRevenueCard> createState() => _UiRevenueCardState();
}

class _UiRevenueCardState extends State<UiRevenueCard> {
  late UiDashboardRange _range = widget.initialRange;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final delta = data.revenueDelta(_range);
    return UiSurface(
      key: const ValueKey('overview-revenue'),
      emphasis: widget.emphasis,
      size: .size3,
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(UiTokens.space4()),
        children: [
          WrapBox(
            style: WrapBoxStyler()
                .wrapAlignment(.spaceBetween)
                .crossAxisAlignment(.start)
                .spacing(UiTokens.space3())
                .runSpacing(UiTokens.space3()),
            children: [
              ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start)
                    .spacing(UiTokens.space1()),
                children: [
                  const UiHeading(
                    'Revenue',
                    headingLevel: 2,
                    size: .size2,
                    weight: .medium,
                  ),
                  UiText(
                    uiDashboardCompactCurrency(data.revenueTotal(_range)),
                    key: const ValueKey('overview-revenue-total'),
                    size: .size8,
                    weight: .bold,
                  ),
                  RowBox(
                    style: FlexBoxStyler()
                        .mainAxisSize(.min)
                        .crossAxisAlignment(.center)
                        .spacing(UiTokens.space2()),
                    children: [
                      UiDeltaBadge(delta, positive: !delta.startsWith('-')),
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
              UiSegmentedControl<UiDashboardRange>(
                key: const ValueKey('overview-range'),
                size: .size1,
                semanticLabel: 'Revenue range',
                selectedValue: _range,
                items: [
                  for (final range in UiDashboardRange.values)
                    RemixSegmentedControlItem(value: range, label: range.label),
                ],
                onChanged: (range) => setState(() => _range = range),
              ),
            ],
          ),
          UiRevenueChart(
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
  Widget build(BuildContext context) => UiDashboardChartLegend(
    semanticLabel: 'Revenue series',
    items: [
      UiDashboardChartLegendItem(
        id: 'current',
        label: 'This period',
        color: resolveUiChartPalette(context).first,
        pattern: .solid,
      ),
      UiDashboardChartLegendItem(
        id: 'previous',
        label: 'Previous period',
        color: MixScope.tokenOf(UiTokens.gray9, context),
        pattern: .dashed,
      ),
    ],
  );
}

/// An area chart of [points] over a dashed line for the period before.
///
/// The chart paints in its own layer, so a hover elsewhere on the page, or a
/// scroll, does not repaint it.
class UiRevenueChart extends StatelessWidget {
  const UiRevenueChart({
    super.key,
    required this.points,
    required this.semanticLabel,
    this.height = 240,
  });

  /// The series to plot, oldest first.
  final List<UiDashboardPoint> points;

  /// The chart's accessible label.
  final String semanticLabel;

  /// The height of the plot, before theme scaling.
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = resolveUiChartPalette(context).first;
    final previous = MixScope.tokenOf(UiTokens.gray9, context);
    // Thirteen weekly labels do not fit under a narrow card; show every other.
    final labelEvery = points.length > 8 ? 2 : 1;

    return SizedBox(
      height: height * UiTheme.of(context).scaling.factor,
      child: RepaintBoundary(
        child: UiLineChart(
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
          yAxis: uiDashboardDataAxis(
            points.expand((point) => [point.value, point.previous]),
            targetIntervals: 4,
          ),
          valueFormatter: (value) => '\$${_trim(value)}K',
          style: uiDashboardLineStyle(),
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
class UiFeaturedEditionCard extends StatelessWidget {
  const UiFeaturedEditionCard({
    super.key,
    required this.edition,
    this.onPressed,
  });

  /// The edition featured.
  final UiDashboardEdition edition;

  /// Called when the card is activated. The card is not a button when null.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final inset = UiTokens.space3.resolve(context);
    final content = Stack(
      children: [
        // The floor: the cover never gets shorter than this, and grows with
        // the row when a neighbour is taller.
        SizedBox(height: 320 * UiTheme.of(context).scaling.factor),
        Positioned.fill(child: UiEditionCover(edition)),
        PositionedDirectional(
          top: inset,
          start: inset,
          child: const UiBadge.solid(size: .size2, label: 'Featured'),
        ),
        Positioned(
          left: inset,
          right: inset,
          bottom: inset,
          child: Box(
            style: BoxStyler()
                .color(UiTokens.colorPanelSolid())
                .borderRadius(.all(UiTokens.radius3()))
                .padding(.all(UiTokens.space3())),
            child: ColumnBox(
              style: FlexBoxStyler()
                  .mainAxisSize(.min)
                  .crossAxisAlignment(.stretch)
                  .spacing(UiTokens.space2()),
              children: [
                RowBox(
                  style: FlexBoxStyler()
                      .crossAxisAlignment(.center)
                      .spacing(UiTokens.space2()),
                  children: [
                    Expanded(
                      child: ColumnBox(
                        style: FlexBoxStyler().crossAxisAlignment(.start),
                        children: [
                          UiText(
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
                    UiText(
                      uiDashboardCurrency(edition.price, cents: false),
                      size: .size3,
                      weight: .medium,
                    ),
                  ],
                ),
                UiProgress(
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
      final onPressed? => UiPressableSurface(
        key: const ValueKey('overview-featured'),
        onPressed: onPressed,
        semanticLabel:
            'Featured edition: ${edition.title} by ${edition.artist}, '
            '${edition.sold} of ${edition.editionSize} sold. Open collection',
        padded: false,
        child: content,
      ),
      null => UiSurface(
        key: const ValueKey('overview-featured'),
        padded: false,
        child: content,
      ),
    };
  }
}

/// Revenue split by channel: a donut around the total, and the shares beside
/// their names.
class UiChannelsCard extends StatelessWidget {
  const UiChannelsCard({
    super.key,
    required this.channels,
    required this.total,
  });

  /// The channels compared.
  final List<UiDashboardChannel> channels;

  /// Total revenue, in thousands of dollars, shown in the donut's hole.
  final double total;

  @override
  Widget build(BuildContext context) {
    final palette = resolveUiChartPalette(context);
    return UiSurface(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(UiTokens.space4()),
        children: [
          const UiCardHeader(
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
                    style: uiPieChartStyle(
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
                        UiText(
                          uiDashboardCompactCurrency(total),
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
          UiDashboardChartLegend(
            key: const ValueKey('overview-channel-legend'),
            semanticLabel: 'Revenue share by channel',
            axis: Axis.vertical,
            items: [
              for (final (index, channel) in channels.indexed)
                UiDashboardChartLegendItem(
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
class UiTopEditionsCard extends StatelessWidget {
  const UiTopEditionsCard({
    super.key,
    required this.editions,
    this.onViewAll,
    this.count = 5,
  });

  /// The collection. The card ranks it by revenue.
  final List<UiDashboardEdition> editions;

  /// Called when the user asks to see the collection.
  final VoidCallback? onViewAll;

  /// How many editions to list.
  final int count;

  @override
  Widget build(BuildContext context) {
    final ranked = [...editions]
      ..sort((a, b) => b.revenue.compareTo(a.revenue));
    return UiSurface(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(UiTokens.space3()),
        children: [
          UiCardHeader(
            title: 'Top editions',
            description: 'By revenue, all time',
            trailing: UiButton.ghost(
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
                  .spacing(UiTokens.space3()),
              children: [
                UiEditionThumbnail(edition),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler().crossAxisAlignment(.start),
                    children: [
                      UiText(
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
                UiText(
                  uiDashboardCurrency(edition.revenue, cents: false),
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
class UiGoalsCard extends StatelessWidget {
  const UiGoalsCard({super.key, required this.goals});

  /// The targets tracked.
  final List<UiDashboardGoal> goals;

  @override
  Widget build(BuildContext context) => UiSurface(
    emphasis: .tinted,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space4()),
      children: [
        const UiCardHeader(
          title: 'Studio goals',
          description: 'Third quarter, 18 days left',
        ),
        for (final goal in goals)
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.stretch)
                .spacing(UiTokens.space2()),
            children: [
              RowBox(
                style: FlexBoxStyler().spacing(UiTokens.space2()),
                children: [
                  Expanded(
                    child: UiText(
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
              UiProgress(value: goal.value, semanticsLabel: goal.label),
            ],
          ),
        const UiCallout(
          size: .size1,
          icon: RemixIcons.wand,
          text: 'At this pace revenue lands 6% over target.',
        ),
      ],
    ),
  );
}

/// The latest orders as a table that runs to the card's edges.
class UiRecentOrdersCard extends StatelessWidget {
  const UiRecentOrdersCard({
    super.key,
    required this.orders,
    this.onViewAll,
    this.count = 6,
  });

  static final _columns = <RemixDataTableColumn<UiDashboardOrder>>[
    RemixDataTableColumn(
      id: 'id',
      label: 'Order',
      width: const FixedColumnWidth(104),
      cellBuilder: (_, order) => UiDataTableCellText(order.id, primary: true),
    ),
    RemixDataTableColumn(
      id: 'customer',
      label: 'Customer',
      width: const FlexColumnWidth(2),
      cellBuilder: (_, order) => UiDataTableCellText(order.customer),
    ),
    RemixDataTableColumn(
      id: 'edition',
      label: 'Edition',
      width: const FlexColumnWidth(2),
      cellBuilder: (_, order) => UiDataTableCellText(order.edition),
    ),
    RemixDataTableColumn(
      id: 'amount',
      label: 'Amount',
      width: const FixedColumnWidth(108),
      alignment: AlignmentDirectional.centerEnd,
      cellBuilder: (_, order) =>
          UiDataTableCellText(uiDashboardCurrency(order.amount), primary: true),
    ),
    RemixDataTableColumn(
      id: 'status',
      label: 'Status',
      width: const FixedColumnWidth(108),
      cellBuilder: (_, order) => UiStatusBadge.order(order.status),
    ),
  ];

  /// The orders, newest first.
  final List<UiDashboardOrder> orders;

  /// Called when the user asks to see all orders.
  final VoidCallback? onViewAll;

  /// How many orders to list.
  final int count;

  @override
  Widget build(BuildContext context) => UiSurface(
    padded: false,
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch),
      children: [
        Box(
          style: BoxStyler().padding(
            .symmetric(
              horizontal: UiTokens.space3(),
              vertical: UiTokens.space4(),
            ),
          ),
          child: UiCardHeader(
            title: 'Recent orders',
            description: 'The last ${count.clamp(0, orders.length)} placed',
            trailing: UiButton.ghost(
              key: const ValueKey('overview-view-orders'),
              size: .size1,
              label: 'View all',
              onPressed: onViewAll,
            ),
          ),
        ),
        UiDataTable<UiDashboardOrder>(
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
class UiActivityCard extends StatelessWidget {
  const UiActivityCard({super.key, required this.activities});

  /// The events, newest first.
  final List<UiDashboardActivity> activities;

  @override
  Widget build(BuildContext context) => UiSurface(
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space3()),
      children: [
        const UiCardHeader(title: 'Activity', description: 'Today'),
        for (final event in activities)
          RowBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.center)
                .spacing(UiTokens.space3()),
            children: [
              UiActivityIcon(kind: event.kind),
              Expanded(
                child: ColumnBox(
                  style: FlexBoxStyler().crossAxisAlignment(.start),
                  children: [
                    UiText(
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
class UiActivityIcon extends StatelessWidget {
  const UiActivityIcon({super.key, required this.kind});

  /// The event's category.
  final UiDashboardActivityKind kind;

  @override
  Widget build(BuildContext context) {
    final (icon, accent) = switch (kind) {
      .customer => (RemixIcons.user, UiAccentColor.ceu),
      .order => (RemixIcons.box, UiAccentColor.duna),
      .payment => (RemixIcons.checkCircle, UiAccentColor.mar),
      .alert => (RemixIcons.warning, UiAccentColor.sol),
      .release => (RemixIcons.calendar, UiAccentColor.caju),
    };

    return UiAccentScope(
      accent: accent,
      child: UiAvatar.soft(icon: icon, size: .size2),
    );
  }
}

/// What is next on the studio calendar, on a quiet surface.
class UiUpcomingCard extends StatelessWidget {
  const UiUpcomingCard({
    super.key,
    required this.events,
    this.onViewAll,
    this.count = 3,
  });

  /// The events, soonest first.
  final List<UiDashboardEvent> events;

  /// Called when the user asks to see the schedule.
  final VoidCallback? onViewAll;

  /// How many events to list.
  final int count;

  @override
  Widget build(BuildContext context) => UiSurface(
    emphasis: .quiet,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space3()),
      children: [
        UiCardHeader(
          title: 'Upcoming',
          description: 'On the studio calendar',
          trailing: UiButton.ghost(
            key: const ValueKey('overview-view-schedule'),
            size: .size1,
            label: 'Schedule',
            onPressed: onViewAll,
          ),
        ),
        for (final event in events.take(count)) UiEventTile(event),
      ],
    ),
  );
}

/// The seven Ui palettes, one button each, on a quiet surface. Picking
/// one restyles the whole dashboard.
///
/// The buttons need a [UiDashboardThemeScope] above them to apply a
/// palette; without one they are disabled.
class UiPalettesCard extends StatelessWidget {
  const UiPalettesCard({super.key, this.onViewAll});

  /// Called when the user asks to see the themes.
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final scope = UiDashboardThemeScope.maybeOf(context);
    final active = scope?.settings.accentColor ?? UiTheme.of(context).accent;
    return UiSurface(
      key: const ValueKey('overview-palettes'),
      emphasis: .quiet,
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(UiTokens.space3()),
        children: [
          UiCardHeader(
            title: 'Palettes',
            description: 'Seven themes, one tap each',
            trailing: UiButton.ghost(
              key: const ValueKey('overview-view-themes'),
              size: .size1,
              label: 'Themes',
              onPressed: onViewAll,
            ),
          ),
          WrapBox(
            style: WrapBoxStyler()
                .spacing(UiTokens.space2())
                .runSpacing(UiTokens.space2()),
            children: [
              for (final accent in UiAccentColor.values)
                UiAccentScope(
                  accent: accent,
                  child: UiButton(
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
class UiTeamCard extends StatelessWidget {
  const UiTeamCard({super.key, required this.team});

  /// The team, in display order.
  final List<UiDashboardMember> team;

  @override
  Widget build(BuildContext context) {
    final online = team.where((member) => member.online).length;
    return UiSurface(
      emphasis: .quiet,
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(UiTokens.space3()),
        children: [
          UiCardHeader(
            title: 'Team',
            description: '$online of ${team.length} online now',
            trailing: UiAvatarStack(members: team),
          ),
          for (final member in team.take(3))
            RowBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(UiTokens.space3()),
              children: [
                UiAccentScope(
                  accent: member.accent,
                  child: UiAvatar(
                    label: member.initials,
                    size: .size2,
                    fallbackLength: 2,
                  ),
                ),
                Expanded(
                  child: ColumnBox(
                    style: FlexBoxStyler().crossAxisAlignment(.start),
                    children: [
                      UiText(
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
                  const UiAccentScope(
                    accent: .mar,
                    child: UiBadge(highContrast: true, label: 'Online'),
                  )
                else
                  const UiBadge.outline(label: 'Away'),
              ],
            ),
        ],
      ),
    );
  }
}
