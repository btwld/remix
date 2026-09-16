/// One headline value shown by the dashboard overview.
final class PlaygroundDashboardMetric {
  const PlaygroundDashboardMetric({
    required this.label,
    required this.value,
    required this.change,
  });

  final String label;
  final String value;
  final String change;
}

/// One point in the overview's primary time series.
final class PlaygroundDashboardPoint {
  const PlaygroundDashboardPoint({required this.label, required this.value});

  final String label;
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

  final String id;
  final String customer;
  final String status;
  final String amount;
}

/// One event in the overview activity feed.
final class PlaygroundDashboardActivity {
  const PlaygroundDashboardActivity({
    required this.title,
    required this.detail,
    required this.relativeTime,
  });

  final String title;
  final String detail;
  final String relativeTime;
}

/// Local, deterministic starter content intended to be edited after install.
final class PlaygroundDashboardSampleData {
  const PlaygroundDashboardSampleData({
    required this.metrics,
    required this.revenue,
    required this.records,
    this.activities = const [],
  });

  final List<PlaygroundDashboardMetric> metrics;
  final List<PlaygroundDashboardPoint> revenue;
  final List<PlaygroundDashboardRecord> records;
  final List<PlaygroundDashboardActivity> activities;
}

/// The editable data rendered by [PlaygroundDashboardOverview] by default.
const playgroundDashboardSampleData = PlaygroundDashboardSampleData(
  metrics: [
    PlaygroundDashboardMetric(
      label: 'Revenue',
      value: r'$84,420',
      change: '+12.4% this month',
    ),
    PlaygroundDashboardMetric(
      label: 'Active customers',
      value: '2,420',
      change: '+8.2% this month',
    ),
    PlaygroundDashboardMetric(
      label: 'Open orders',
      value: '184',
      change: '12 awaiting review',
    ),
    PlaygroundDashboardMetric(
      label: 'Fulfillment',
      value: '94.2%',
      change: '+4.1% this month',
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
      customer: 'Avery Stone',
      status: 'Fulfilled',
      amount: r'$1,280',
    ),
    PlaygroundDashboardRecord(
      id: 'ORD-1047',
      customer: 'Mina Patel',
      status: 'Processing',
      amount: r'$860',
    ),
    PlaygroundDashboardRecord(
      id: 'ORD-1046',
      customer: 'Jordan Lee',
      status: 'Review',
      amount: r'$2,140',
    ),
    PlaygroundDashboardRecord(
      id: 'ORD-1045',
      customer: 'Riley Chen',
      status: 'Fulfilled',
      amount: r'$640',
    ),
  ],
  activities: [
    PlaygroundDashboardActivity(
      title: 'New customer',
      detail: 'Camila joined the Business plan',
      relativeTime: '12 min ago',
    ),
    PlaygroundDashboardActivity(
      title: 'Payment received',
      detail: r'ORD-1048 · $1,249.00',
      relativeTime: '38 min ago',
    ),
    PlaygroundDashboardActivity(
      title: 'Order requires review',
      detail: 'ORD-1047 is awaiting confirmation',
      relativeTime: '1 hr ago',
    ),
    PlaygroundDashboardActivity(
      title: 'Order fulfilled',
      detail: 'ORD-1046 shipped to Ava Wilson',
      relativeTime: '3 hrs ago',
    ),
    PlaygroundDashboardActivity(
      title: 'New customer',
      detail: 'Henry accepted his invitation',
      relativeTime: '5 hrs ago',
    ),
    PlaygroundDashboardActivity(
      title: 'Refund processed',
      detail: r'ORD-1045 · $189.00',
      relativeTime: 'Yesterday',
    ),
  ],
);
