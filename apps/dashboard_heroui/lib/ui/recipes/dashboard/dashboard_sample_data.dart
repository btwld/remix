/// One headline value shown by the dashboard overview.
final class UiDashboardMetric {
  const UiDashboardMetric({
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
final class UiDashboardPoint {
  const UiDashboardPoint({required this.label, required this.value});

  /// The x-axis label, such as a weekday.
  final String label;

  /// The y-axis value.
  final double value;
}

/// One row in the overview's recent-records table.
final class UiDashboardRecord {
  const UiDashboardRecord({
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
enum UiDashboardActivityKind {
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
final class UiDashboardActivity {
  const UiDashboardActivity({
    required this.title,
    required this.detail,
    required this.relativeTime,
    this.kind = UiDashboardActivityKind.customer,
  });

  /// A short headline.
  final String title;

  /// One line of supporting text.
  final String detail;

  /// When it happened, relative to now, such as `12 min ago`.
  final String relativeTime;

  /// The event's category.
  final UiDashboardActivityKind kind;
}

/// Local, deterministic starter content intended to be edited after install.
final class UiDashboardSampleData {
  const UiDashboardSampleData({
    required this.metrics,
    required this.revenue,
    required this.records,
    this.activities = const [],
  });

  /// The headline metric cards.
  final List<UiDashboardMetric> metrics;

  /// The primary time series.
  final List<UiDashboardPoint> revenue;

  /// The recent-records table rows.
  final List<UiDashboardRecord> records;

  /// The activity feed events, newest first.
  final List<UiDashboardActivity> activities;
}

/// The editable data rendered by [UiDashboardOverview] by default.
const uiDashboardSampleData = UiDashboardSampleData(
  metrics: [
    UiDashboardMetric(
      label: 'Revenue',
      value: r'$84,420',
      change: 'this month',
      delta: '+12.4%',
    ),
    UiDashboardMetric(
      label: 'Active customers',
      value: '2,420',
      change: 'this month',
      delta: '+8.2%',
    ),
    UiDashboardMetric(
      label: 'Open orders',
      value: '184',
      change: '12 awaiting review',
      delta: '-2.3%',
      positive: false,
    ),
    UiDashboardMetric(
      label: 'Fulfillment',
      value: '94.2%',
      change: 'this month',
      delta: '+4.1%',
      progress: 0.942,
    ),
  ],
  revenue: [
    UiDashboardPoint(label: 'Mon', value: 42),
    UiDashboardPoint(label: 'Tue', value: 54),
    UiDashboardPoint(label: 'Wed', value: 48),
    UiDashboardPoint(label: 'Thu', value: 66),
    UiDashboardPoint(label: 'Fri', value: 62),
    UiDashboardPoint(label: 'Sat', value: 78),
    UiDashboardPoint(label: 'Sun', value: 84),
  ],
  records: [
    UiDashboardRecord(
      id: 'ORD-1048',
      customer: 'Olivia Martin',
      status: 'Paid',
      amount: r'$1,249.00',
    ),
    UiDashboardRecord(
      id: 'ORD-1047',
      customer: 'Jackson Lee',
      status: 'Pending',
      amount: r'$349.00',
    ),
    UiDashboardRecord(
      id: 'ORD-1046',
      customer: 'Ava Wilson',
      status: 'Paid',
      amount: r'$2,780.00',
    ),
    UiDashboardRecord(
      id: 'ORD-1045',
      customer: 'Emma Davis',
      status: 'Refunded',
      amount: r'$189.00',
    ),
  ],
  activities: [
    UiDashboardActivity(
      title: 'New customer',
      detail: 'Camila joined the Business plan',
      relativeTime: '12 min ago',
      kind: .customer,
    ),
    UiDashboardActivity(
      title: 'Payment received',
      detail: r'ORD-1048 · $1,249.00',
      relativeTime: '38 min ago',
      kind: .payment,
    ),
    UiDashboardActivity(
      title: 'Inventory alert',
      detail: 'SKU-402 fell below the reorder threshold.',
      relativeTime: '1 hr ago',
      kind: .alert,
    ),
    UiDashboardActivity(
      title: 'Order fulfilled',
      detail: 'ORD-1046 shipped to Ava Wilson',
      relativeTime: '3 hrs ago',
      kind: .order,
    ),
    UiDashboardActivity(
      title: 'New customer',
      detail: 'Henry accepted his invitation',
      relativeTime: '5 hrs ago',
      kind: .customer,
    ),
    UiDashboardActivity(
      title: 'Refund processed',
      detail: r'ORD-1045 · $189.00',
      relativeTime: 'Yesterday',
      kind: .payment,
    ),
  ],
);
