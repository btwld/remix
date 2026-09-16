/// One headline value shown by the dashboard overview.
final class RegistryDashboardMetric {
  const RegistryDashboardMetric({
    required this.label,
    required this.value,
    required this.change,
  });

  final String label;
  final String value;
  final String change;
}

/// One point in the overview's primary time series.
final class RegistryDashboardPoint {
  const RegistryDashboardPoint({required this.label, required this.value});

  final String label;
  final double value;
}

/// One row in the overview's recent-records table.
final class RegistryDashboardRecord {
  const RegistryDashboardRecord({
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

/// Local, deterministic starter content intended to be edited after install.
final class RegistryDashboardSampleData {
  const RegistryDashboardSampleData({
    required this.metrics,
    required this.revenue,
    required this.records,
  });

  final List<RegistryDashboardMetric> metrics;
  final List<RegistryDashboardPoint> revenue;
  final List<RegistryDashboardRecord> records;
}

/// The editable data rendered by [RegistryDashboardOverview] by default.
const registryDashboardSampleData = RegistryDashboardSampleData(
  metrics: [
    RegistryDashboardMetric(
      label: 'Revenue',
      value: r'$84,420',
      change: '+12.4% this month',
    ),
    RegistryDashboardMetric(
      label: 'Active customers',
      value: '2,420',
      change: '+8.2% this month',
    ),
    RegistryDashboardMetric(
      label: 'Open orders',
      value: '184',
      change: '12 awaiting review',
    ),
    RegistryDashboardMetric(
      label: 'Fulfillment',
      value: '94.2%',
      change: '+4.1% this month',
    ),
  ],
  revenue: [
    RegistryDashboardPoint(label: 'Mon', value: 42),
    RegistryDashboardPoint(label: 'Tue', value: 54),
    RegistryDashboardPoint(label: 'Wed', value: 48),
    RegistryDashboardPoint(label: 'Thu', value: 66),
    RegistryDashboardPoint(label: 'Fri', value: 62),
    RegistryDashboardPoint(label: 'Sat', value: 78),
    RegistryDashboardPoint(label: 'Sun', value: 84),
  ],
  records: [
    RegistryDashboardRecord(
      id: 'ORD-1048',
      customer: 'Avery Stone',
      status: 'Fulfilled',
      amount: r'$1,280',
    ),
    RegistryDashboardRecord(
      id: 'ORD-1047',
      customer: 'Mina Patel',
      status: 'Processing',
      amount: r'$860',
    ),
    RegistryDashboardRecord(
      id: 'ORD-1046',
      customer: 'Jordan Lee',
      status: 'Review',
      amount: r'$2,140',
    ),
    RegistryDashboardRecord(
      id: 'ORD-1045',
      customer: 'Riley Chen',
      status: 'Fulfilled',
      amount: r'$640',
    ),
  ],
);
