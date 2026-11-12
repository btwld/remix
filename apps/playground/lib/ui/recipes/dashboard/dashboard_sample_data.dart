/// One headline value shown by the dashboard overview.
final class PlaygroundDashboardMetric {
  const PlaygroundDashboardMetric({
    required this.label,
    required this.value,
    required this.change,
    this.delta,
    this.positive = true,
    this.progress,
  });

  /// What the metric measures.
  final String label;

  /// The headline figure.
  final String value;

  /// The period or context the [delta] refers to.
  final String change;

  /// The change since the previous period, such as `+12.4%`.
  final String? delta;

  /// Whether [delta] is good news, which decides its tone.
  final bool positive;

  /// Fraction from 0 to 1 shown as a progress bar; omitted when null.
  final double? progress;
}

/// One point in the overview's primary time series.
final class PlaygroundDashboardPoint {
  const PlaygroundDashboardPoint({required this.label, required this.value});

  /// The x-axis label, such as a weekday.
  final String label;

  /// The y-axis value.
  final double value;
}

/// One row in the overview's recent-records table.
final class PlaygroundDashboardRecord {
  const PlaygroundDashboardRecord({
    required this.id,
    required this.customer,
    required this.status,
    required this.amount,
  });

  /// The order identifier.
  final String id;

  /// The customer's name.
  final String customer;

  /// The order's status, such as `Paid`.
  final String status;

  /// The formatted amount.
  final String amount;
}

/// The category of an activity feed event.
enum PlaygroundDashboardActivityKind {
  /// A customer joined or changed.
  customer,

  /// An order was placed or fulfilled.
  order,

  /// A payment or refund.
  payment,

  /// Something needs attention.
  alert,
}

/// One event in the overview activity feed.
final class PlaygroundDashboardActivity {
  const PlaygroundDashboardActivity({
    required this.title,
    required this.detail,
    required this.relativeTime,
    this.kind = PlaygroundDashboardActivityKind.customer,
  });

  /// A short headline.
  final String title;

  /// One line of supporting text.
  final String detail;

  /// When it happened, relative to now, such as `12 min ago`.
  final String relativeTime;

  /// The event's category.
  final PlaygroundDashboardActivityKind kind;
}

/// Local, deterministic starter content intended to be edited after install.
final class PlaygroundDashboardSampleData {
  const PlaygroundDashboardSampleData({
    required this.metrics,
    required this.revenue,
    required this.records,
    this.activities = const [],
  });

  /// The headline metric cards.
  final List<PlaygroundDashboardMetric> metrics;

  /// The primary time series.
  final List<PlaygroundDashboardPoint> revenue;

  /// The recent-records table rows.
  final List<PlaygroundDashboardRecord> records;

  /// The activity feed events, newest first.
  final List<PlaygroundDashboardActivity> activities;
}

/// The editable data rendered by [PlaygroundDashboardOverview] by default.
const playgroundDashboardSampleData = PlaygroundDashboardSampleData(
  metrics: [
    PlaygroundDashboardMetric(
      label: 'Revenue',
      value: r'$84,420',
      change: 'this month',
      delta: '+12.4%',
    ),
    PlaygroundDashboardMetric(
      label: 'Active customers',
      value: '2,420',
      change: 'this month',
      delta: '+8.2%',
    ),
    PlaygroundDashboardMetric(
      label: 'Open orders',
      value: '184',
      change: '12 awaiting review',
      delta: '-2.3%',
      positive: false,
    ),
    PlaygroundDashboardMetric(
      label: 'Fulfillment',
      value: '94.2%',
      change: 'this month',
      delta: '+4.1%',
      progress: 0.942,
    ),
  ],
  revenue: [
    PlaygroundDashboardPoint(label: 'Mon', value: 42),
    PlaygroundDashboardPoint(label: 'Tue', value: 54),
    PlaygroundDashboardPoint(label: 'Wed', value: 48),
    PlaygroundDashboardPoint(label: 'Thu', value: 66),
    PlaygroundDashboardPoint(label: 'Fri', value: 62),
    PlaygroundDashboardPoint(label: 'Sat', value: 78),
    PlaygroundDashboardPoint(label: 'Sun', value: 84),
  ],
  records: [
    PlaygroundDashboardRecord(
      id: 'ORD-1048',
      customer: 'Olivia Martin',
      status: 'Paid',
      amount: r'$1,249.00',
    ),
    PlaygroundDashboardRecord(
      id: 'ORD-1047',
      customer: 'Jackson Lee',
      status: 'Pending',
      amount: r'$349.00',
    ),
    PlaygroundDashboardRecord(
      id: 'ORD-1046',
      customer: 'Ava Wilson',
      status: 'Paid',
      amount: r'$2,780.00',
    ),
    PlaygroundDashboardRecord(
      id: 'ORD-1045',
      customer: 'Emma Davis',
      status: 'Refunded',
      amount: r'$189.00',
    ),
  ],
  activities: [
    PlaygroundDashboardActivity(
      title: 'New customer',
      detail: 'Camila joined the Business plan',
      relativeTime: '12 min ago',
      kind: .customer,
    ),
    PlaygroundDashboardActivity(
      title: 'Payment received',
      detail: r'ORD-1048 · $1,249.00',
      relativeTime: '38 min ago',
      kind: .payment,
    ),
    PlaygroundDashboardActivity(
      title: 'Inventory alert',
      detail: 'SKU-402 fell below the reorder threshold.',
      relativeTime: '1 hr ago',
      kind: .alert,
    ),
    PlaygroundDashboardActivity(
      title: 'Order fulfilled',
      detail: 'ORD-1046 shipped to Ava Wilson',
      relativeTime: '3 hrs ago',
      kind: .order,
    ),
    PlaygroundDashboardActivity(
      title: 'New customer',
      detail: 'Henry accepted his invitation',
      relativeTime: '5 hrs ago',
      kind: .customer,
    ),
    PlaygroundDashboardActivity(
      title: 'Refund processed',
      detail: r'ORD-1045 · $189.00',
      relativeTime: 'Yesterday',
      kind: .payment,
    ),
  ],
);
