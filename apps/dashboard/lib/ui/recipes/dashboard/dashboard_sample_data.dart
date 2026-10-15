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

  final String label;
  final String value;
  final String change;
  final String? delta;
  final bool positive;
  final double? progress;
}

/// One point in the overview's primary time series.
final class UiDashboardPoint {
  const UiDashboardPoint({required this.label, required this.value});

  final String label;
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

  final String id;
  final String customer;
  final String status;
  final String amount;
}

/// The category of an activity feed event.
enum UiDashboardActivityKind { customer, order, payment, alert }

/// One event in the overview activity feed.
final class UiDashboardActivity {
  const UiDashboardActivity({
    required this.title,
    required this.detail,
    required this.relativeTime,
    this.kind = UiDashboardActivityKind.customer,
  });

  final String title;
  final String detail;
  final String relativeTime;
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

  final List<UiDashboardMetric> metrics;
  final List<UiDashboardPoint> revenue;
  final List<UiDashboardRecord> records;
  final List<UiDashboardActivity> activities;
}

/// The editable data rendered by [UiDashboardOverview] by default.
const uiDashboardSampleData = UiDashboardSampleData(
  metrics: [
    UiDashboardMetric(
      label: 'Revenue',
      value: r'$84,420',
      change: '+12.4% this month',
      delta: '+12.4%',
    ),
    UiDashboardMetric(
      label: 'Active customers',
      value: '2,420',
      change: '+8.2% this month',
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
      change: '+4.1% this month',
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
      customer: 'Avery Stone',
      status: 'Paid',
      amount: r'$1,280',
    ),
    UiDashboardRecord(
      id: 'ORD-1047',
      customer: 'Mina Patel',
      status: 'Pending',
      amount: r'$860',
    ),
    UiDashboardRecord(
      id: 'ORD-1046',
      customer: 'Jordan Lee',
      status: 'Paid',
      amount: r'$2,140',
    ),
    UiDashboardRecord(
      id: 'ORD-1045',
      customer: 'Riley Chen',
      status: 'Refunded',
      amount: r'$640',
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
